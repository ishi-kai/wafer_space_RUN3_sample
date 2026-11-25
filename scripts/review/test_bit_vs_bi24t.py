"""Compare gf180mcu_fd_io__bi_t (4 mA, PDRV0=0, PDRV1=0, SL=1) vs bi_24t (24 mA, SL=1)
on (1) SDO readback delay at 3.3V/3.0V SS and (2) DVSS ground bounce & RF band switching current."""
import os, re, subprocess, tempfile
import numpy as np

PDK = os.path.expanduser("~/pdk/gf180mcuD")
IO = open(PDK + "/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice").read()
IO = re.sub(r"(ppolyf_u[^\n]*?) m=1\.0 r=\S+", r"\1", IO)

def run_ng(cir):
    with tempfile.NamedTemporaryFile("w", suffix=".cir", delete=False) as f:
        f.write(cir); p = f.name
    try:
        r = subprocess.run(["ngspice", "-b", p], capture_output=True, text=True, timeout=120)
        return r.stdout + "\n" + r.stderr
    finally:
        os.unlink(p)

# 1. SDO pad delay comparison (pad-only + 1.5nH bondwire + Cload, driven by buf_4)
print("=== 1. Pad Delay Comparison (buf_4 -> pad -> 1.5nH -> Cload) ===")
for cell in ("gf180mcu_fd_io__bi_24t", "gf180mcu_fd_io__bi_t"):
    for cname, lib, temp, vdd in [("tt_27_3v3", "typical", 27, 3.3), ("ss_85_3v135", "ss", 85, 3.135), ("ss_125_3v0", "ss", 125, 3.0)]:
        for cl_pf in (5, 15, 30):
            # Port order:
            # bi_24t: A CS DVDD DVSS IE OE PAD PD PU SL VDD VSS Y
            # bi_t:   A CS DVDD DVSS IE OE PAD PD PDRV0 PDRV1 PU SL VDD VSS Y
            if cell.endswith("bi_24t"):
                inst = f"XP a 0 vdd 0 0 vdd pad vdd 0 vdd vdd 0 y {cell}"
            else:
                inst = f"XP a 0 vdd 0 0 vdd pad vdd 0 0 0 vdd vdd 0 y {cell}"
            cir = f"""* pad delay
.include {PDK}/libs.tech/ngspice/design.ngspice
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice {lib}
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice res_typical
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice moscap_typical
{IO}
.temp {temp}
VD vdd 0 {vdd}
VA a 0 pulse(0 {vdd} 20n 1n 1n 80n 160n)
{inst}
LB pad pb1 1.5n
RB pb1 out 0.15
RPB pad pb1 300
CL out 0 {cl_pf}p
.option method=gear reltol=1e-3
.control
set num_threads=1
tran 50p 180n
meas tran tr70 trig v(a) val={0.5*vdd} rise=1 targ v(out) val={0.7*vdd} rise=1
meas tran tf30 trig v(a) val={0.5*vdd} fall=1 targ v(out) val={0.3*vdd} fall=1
meas tran tr1090 trig v(out) val={0.1*vdd} rise=1 targ v(out) val={0.9*vdd} rise=1
meas tran tf9010 trig v(out) val={0.9*vdd} fall=1 targ v(out) val={0.1*vdd} fall=1
echo DEL tr70=$&tr70 tf30=$&tf30 tr1090=$&tr1090 tf9010=$&tf9010
.endc
.end
"""
            out = run_ng(cir)
            m = re.search(r"DEL tr70=(\S+) tf30=(\S+) tr1090=(\S+) tf9010=(\S+)", out)
            if m:
                vals = [float(x)*1e9 for x in m.groups()]
                print(f"  {cell[-6:]:6s} {cname:11s} {cl_pf:2d}pF | t_r70={vals[0]:5.2f}ns t_f30={vals[1]:5.2f}ns | slew r={vals[2]:5.2f}ns f={vals[3]:5.2f}ns")
            else:
                print(f"  {cell[-6:]:6s} {cname:11s} {cl_pf:2d}pF FAIL")

# 2. Ground bounce (DVSS peak-to-peak & peak di/dt) with 5 pF load, 0 ohm vs 330 ohm
print("\n=== 2. DVSS Ground Bounce Comparison (TT 27C 3.3V, 5pF load, 0.5nH DVDD/DVSS wires) ===")
for cell in ("gf180mcu_fd_io__bi_24t", "gf180mcu_fd_io__bi_t"):
    for rs in (0, 330):
        if cell.endswith("bi_24t"):
            inst = f"XP a dvss dvdd dvss dvss dvdd pad dvss dvss dvdd dvdd dvss y {cell}"
        else:
            inst = f"XP a dvss dvdd dvss dvss dvdd pad dvss dvss dvss dvss dvdd dvdd dvss y {cell}"
        rser = f"RSER pin out {rs}" if rs else "VSER pin out 0"
        cir = f"""* bounce
.include {PDK}/libs.tech/ngspice/design.ngspice
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice typical
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice res_typical
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib {PDK}/libs.tech/ngspice/sm141064.ngspice moscap_typical
{IO}
.temp 27
VD dvp 0 3.3
LD dvp dv1 0.5n
RD dv1 dvdd 0.1
RPD dvp dv1 150
LS dvss ds1 0.5n
RS ds1 0 0.1
RPS dvss ds1 150
CDEC dvdd dvss 100p
VA a 0 pulse(0 3.3 20n 0.2n 0.2n 30n 61n)
{inst}
LB pad pb1 1.5n
RB pb1 pin 0.15
RPB pad pb1 300
CPIN pin 0 0.3p
{rser}
CL out 0 5p
.option method=gear reltol=1e-3
.control
set num_threads=1
tran 20p 90n
let dvss_pp = (vecmax(v(dvss)) - vecmin(v(dvss))) * 1000
let ipk = vecmax(abs(i(LB))) * 1000
echo BNC dvss_pp_mV=$&dvss_pp ipk_mA=$&ipk
.endc
.end
"""
        out = run_ng(cir)
        m = re.search(r"BNC dvss_pp_mV=(\S+) ipk_mA=(\S+)", out)
        if m:
            print(f"  {cell[-6:]:6s} Rser={rs:3d}ohm | DVSS_pp={float(m.group(1)):6.2f} mV | I_pad_pk={float(m.group(2)):5.2f} mA")
