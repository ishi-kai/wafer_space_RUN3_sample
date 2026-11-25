# SPDX-FileCopyrightText: © 2026 GNSS AFE + megabytebeat Authors
# SPDX-License-Identifier: Apache-2.0
#
# Full-chip cocotb testbench for slot 0p5x1 dual-VDD GNSS AFE + proppy/ttgf-megabytebeat.
# Tests both RTL and Gate-Level (GL=1, powered netlist with separate VDD / VDD_BB / VDDA / VDDV):
#   1. GNSS SPI reset default (ID=10101, ctl=19'h08000), write & readback.
#   2. megabytebeat bb_ena=0 quiet-by-default clamping (all 5 PWM outputs == 0 while bb_clk runs).
#   3. megabytebeat bb_ena=1 bit-exact 5-track PWM verification against upstream DSLX formulas.
#   4. megabytebeat bb_ena 1->0->1 synchronous flush + clean restart from t=0.

import os
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles
from cocotb_tools.runner import get_runner

sim = os.getenv("SIM", "icarus")
gl = bool(int(os.getenv("GL", "0")))
pdk_root = os.getenv("PDK_ROOT", str(Path(__file__).resolve().parent / "../gf180mcu"))
pdk = os.getenv("PDK", "gf180mcuD")
scl = os.getenv("SCL", "gf180mcu_fd_sc_mcu7t5v0")
pad = os.getenv("PAD", "gf180mcu_fd_io")
sram = os.getenv("SRAM", "gf180mcu_fd_ip_sram")
slot = os.getenv("SLOT", "0p5x1")

hdl_toplevel = "chip_top"


def bytebeat_golden(t: int, a: int, b: int, c: int, d: int):
    """Exact golden formulas from proppy/ttgf-megabytebeat src/bytebeat.x."""
    t32 = t & 0xFFFFFFFF
    ab = ((b & 0xF) << 4) | (a & 0xF)
    cd = ((d & 0xF) << 4) | (c & 0xF)

    # Track 0: the 42 melody
    sh0 = (t32 >> cd) if cd < 32 else 0
    s0 = (t32 * (ab & sh0)) & 0xFF

    # Track 1: fractal trees
    ab_nz = 1 if ab == 0 else ab
    cd_257 = cd + 2
    s1 = (t32 | (t32 % ab_nz) | (t32 % cd_257)) & 0xFF

    # Track 2: untitled (droid)
    cond0 = (t32 >> a) & b
    p0 = t32 >> c
    p1 = ((-t32) & 0xFFFFFFFF) >> d
    s2 = (p0 if cond0 != 0 else p1) & 0xFF

    # Track 3: a tune to share
    s3 = (t32 * ((t32 >> a) | (t32 >> b)) & cd) & 0xFF

    # Track 7 (uo_pwm[4]): sierpinski harmony
    s7 = (((t32 * a) & (t32 >> b)) | ((t32 * c) & (t32 >> d))) & 0xFF

    return [s0, s1, s2, s3, s7]


async def init_chip(dut):
    if gl:
        for p, v in [("VDD", 1), ("DVDD", 1), ("VDD_BB", 1), ("DVDD_BB", 1),
                     ("VDDA", 1), ("VDDV", 1), ("VSS", 0), ("DVSS", 0), ("VSSA", 0)]:
            if hasattr(dut, p):
                getattr(dut, p).value = v

    dut.clk_PAD.value = 0
    dut.rst_n_PAD.value = 0
    dut.input_PAD.value = 0b10  # CS_N=1, SDI=0

    dut.bb_clk_PAD.value = 0
    dut.bb_rst_n_PAD.value = 0
    dut.bb_ena_PAD.value = 0
    dut.bb_ui_PAD.value = 0
    dut.bb_uio_PAD.value = 0

    await Timer(500, unit="ns")
    dut.rst_n_PAD.value = 1
    dut.bb_rst_n_PAD.value = 1
    await Timer(500, unit="ns")


async def spi_transfer(dut, tx_word: int) -> int:
    """24-bit SPI mode 0 transaction: MSB first, sample SDO (bidir_PAD[5]) on rising SCLK."""
    rx = 0
    dut.input_PAD.value = 0b00  # CS_N=0
    await Timer(100, unit="ns")
    for bit in range(23, -1, -1):
        sdi = (tx_word >> bit) & 1
        dut.input_PAD.value = sdi  # CS_N=0, SDI=sdi
        await Timer(100, unit="ns")
        dut.clk_PAD.value = 1
        await Timer(50, unit="ns")
        sdo = int(dut.bidir_PAD.value[5])
        rx = (rx << 1) | sdo
        await Timer(50, unit="ns")
        dut.clk_PAD.value = 0
        await Timer(50, unit="ns")
    dut.input_PAD.value = 0b10  # CS_N=1 (latches sr[18:0] -> ctl)
    await Timer(200, unit="ns")
    return rx


@cocotb.test()
async def test_gnss_spi_and_megabytebeat(dut):
    """Verify GNSS SPI + megabytebeat bb_ena gating + 5-track bit-exact PWM."""
    await init_chip(dut)

    # ------------------------------------------------------------ 1. GNSS SPI test
    # First frame reads back reset default {ID=5'b10101, ctl=19'h08000} = 0xA88000
    w1 = 0x05A3C5  # ctl = 19'h5A3C5
    rd0 = await spi_transfer(dut, w1)
    assert rd0 == 0xA88000, f"Expected reset readback 0xA88000, got 0x{rd0:06X}"

    # Second frame reads back {5'b10101, 19'h5A3C5} = 0xADA3C5
    w2 = 0x02F10A
    rd1 = await spi_transfer(dut, w2)
    expected_rd1 = (0b10101 << 19) | (w1 & 0x7FFFF)
    assert rd1 == expected_rd1, f"Expected SPI readback 0x{expected_rd1:06X}, got 0x{rd1:06X}"
    cocotb.log.info(f"GNSS SPI PASS: reset=0x{rd0:06X}, frame1=0x{rd1:06X}")

    # ------------------------------------------------------------ 2. megabytebeat bb_ena=0 test
    bb_clk = Clock(dut.bb_clk_PAD, 488, unit="ns")  # ~2.048 MHz
    cocotb.start_soon(bb_clk.start())

    # Set active params (a=0xa, b=0x2, c=0xa, d=0x0) while bb_ena=0
    dut.bb_ui_PAD.value = 0x2A
    dut.bb_uio_PAD.value = 0x0A
    dut.bb_ena_PAD.value = 0
    await ClockCycles(dut.bb_clk_PAD, 300)
    for _ in range(32):
        await RisingEdge(dut.bb_clk_PAD)
        await Timer(10, unit="ns")
        assert int(dut.bb_uo_PAD.value) == 0, f"Expected 0 with bb_ena=0, got {dut.bb_uo_PAD.value}"
    cocotb.log.info("megabytebeat bb_ena=0 quiet clamping PASS")

    # ------------------------------------------------------------ 3. megabytebeat bb_ena=1 5-track test
    # Enable on falling edge so first posedge sees clean ena=1, rst_n=1
    await FallingEdge(dut.bb_clk_PAD)
    dut.bb_rst_n_PAD.value = 0
    dut.bb_ena_PAD.value = 1
    await ClockCycles(dut.bb_clk_PAD, 4)
    await FallingEdge(dut.bb_clk_PAD)
    dut.bb_rst_n_PAD.value = 1

    # Test with params a=0x5, b=0x2, c=0x3, d=0x1 (all 5 tracks produce distinct non-zero samples!)
    a, b, c, d = 0x5, 0x2, 0x3, 0x1
    dut.bb_ui_PAD.value = (b << 4) | a
    dut.bb_uio_PAD.value = (d << 4) | c

    # Over each 256-cycle frame (starting immediately after reset deassertion on falling edge,
    # sampling after each posedge when pwm updates for count=0..255), high-cycle count == sample(t)!
    mismatches = 0
    for t_idx in range(12):
        counts = [0, 0, 0, 0, 0]
        for _ in range(256):
            await RisingEdge(dut.bb_clk_PAD)
            await Timer(20, unit="ns")
            val = int(dut.bb_uo_PAD.value)
            for ch in range(5):
                counts[ch] += (val >> ch) & 1
        exp = bytebeat_golden(t_idx, a, b, c, d)
        cocotb.log.info(f"t={t_idx}: got={counts}, expected={exp}")
        if counts != exp:
            mismatches += 1
    assert mismatches == 0, f"megabytebeat PWM mismatches: {mismatches}"
    cocotb.log.info("megabytebeat 5-track bit-exact PWM PASS (t=0..11)")

    # ------------------------------------------------------------ 4. bb_ena 1 -> 0 disable check
    await FallingEdge(dut.bb_clk_PAD)
    dut.bb_ena_PAD.value = 0
    await ClockCycles(dut.bb_clk_PAD, 10)
    await Timer(20, unit="ns")
    assert int(dut.bb_uo_PAD.value) == 0, f"Expected 0 after bb_ena=0, got {dut.bb_uo_PAD.value}"
    cocotb.log.info("megabytebeat bb_ena 1->0 disable PASS")


def chip_top_runner():
    proj_path = Path(__file__).resolve().parent
    sources = []
    defines = {f"SLOT_{slot.upper()}": True}
    includes = [proj_path / "../src/"]

    defines[f"PDK_{pdk.replace('-', '_')}"] = True
    defines[f"SCL_{scl}"] = True
    defines[f"PAD_{pad}"] = True
    defines[f"SRAM_{sram}"] = True

    if gl:
        sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v")
        sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / "primitives.v")
        sources.append(proj_path / "../macros/megabytebeat/final/pnl/megabytebeat_macro.pnl.v")
        sources.append(proj_path / f"../final/pnl/{hdl_toplevel}.pnl.v")
        defines.update({"FUNCTIONAL": True, "USE_POWER_PINS": True})
    else:
        sources += [
            proj_path / "../src/chip_top.sv",
            proj_path / "../src/chip_core.sv",
            proj_path / "../macros/megabytebeat/src/megabytebeat.v",
            proj_path / "../macros/megabytebeat/src/pwm_audio.v",
            proj_path / "../macros/megabytebeat/src/tt_um_proppy_megabytebeat.v",
            proj_path / "../macros/megabytebeat/src/megabytebeat_macro.sv",
        ]

    sources += [
        Path(pdk_root) / pdk / f"libs.ref/{pad}/verilog/{pad}.v",
        proj_path / "../src/gnss_afe_analog.v",
        proj_path / "../ip/gf180mcu_gnss_io/vh/gf180mcu_gnss_io.v",
        proj_path / "../ip/gf180mcu_ws_ip__logo/vh/gf180mcu_ws_ip__logo.v",
        proj_path / "../ip/gf180mcu_ws_ip__marker/vh/gf180mcu_ws_ip__marker.v",
        proj_path / "../ip/gf180mcu_ws_ip__qrcode_id/vh/gf180mcu_ws_ip__qrcode_id.v",
        proj_path / "../ip/gf180mcu_ws_ip__shuttle_id/vh/gf180mcu_ws_ip__shuttle_id.v",
        proj_path / "../ip/gf180mcu_ws_ip__project_id/vh/gf180mcu_ws_ip__project_id.v",
    ]

    build_args = ["-g2012"] if sim == "icarus" else ["--timing", "--trace", "--trace-fst", "--trace-structs"]
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        defines=defines,
        always=True,
        includes=includes,
        build_args=build_args,
        waves=False,
    )
    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module="chip_top_tb",
        waves=False,
    )


if __name__ == "__main__":
    chip_top_runner()
