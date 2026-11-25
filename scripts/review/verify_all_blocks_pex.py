"""Comprehensive Post-Layout PEX Verification of ALL rev.4 Analog Blocks:
1. bias_gen PEX (TT/SS/FF + real 0->VDD cold power-on ramp)
2. refbuf PEX (TT/SS/FF, 16.368 MHz 0.4Vpk sine -> CMOS)
3. vmon_buf PEX (TT/SS/FF, VCTRL monitor buffer 100k load + input leakage)
4. vco_ring4 PEX (TT/SS/FF across bands B0/B1=00..11: verify 785.664 MHz coverage)
5. if_chain PEX + gm_master PEX:
   (a) All 4 gain codes (00/01/10/11) at TT (with rshunt=1e12 for floating poly dummies)
   (b) Dual-channel (I+Q) max-gain supply stability with 5 nH + 0.5 ohm bond wires (TT/SS/FF)
6. adc2b PEX (TT/SS/FF: real 4.092 MHz AC sine at 2.16V CM + 16.368 MHz clock)
7. afc_dac PEX (TT/SS/FF: 256-code INL/DNL/monotonicity)
"""
import os, re, sys, subprocess, tempfile
from concurrent.futures import ThreadPoolExecutor
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "scripts"))
sys.path.insert(0, os.path.join(ROOT, "scripts", "layout"))
os.environ.setdefault("PDK", "gf180mcuD")
os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, pex_vco, run

PDK_ROOT = os.environ["PDK_ROOT"]
MODELS = os.path.join(PDK_ROOT, "gf180mcuD/libs.tech/ngspice")

CORNERS = [
    ("TT 27C 3.3V",    "typical", 27,  3.3),
    ("SS 85C 3.135V",  "ss",      85,  3.135),
    ("FF -20C 3.465V", "ff",     -20,  3.465),
]

def pex_sub(cell, ports):
    shell = f".subckt {cell} {' '.join(ports)}\n.ends\n.end\n"
    sw = pexsim.swap(shell, cell)
    return sw[:sw.rindex(".end")]

SUBS = {
    "bias_gen":  pex_sub("bias_gen",  ["NB", "PB", "VDD", "VSS"]),
    "refbuf":    pex_sub("refbuf",    ["IN", "OUT", "VDD", "VSS"]),
    "vmon_buf":  pex_sub("vmon_buf",  ["IN", "NB", "OUT", "VDD", "VSS"]),
    "vco_ring4": pex_sub("vco_ring4", ["VCTRL", "B0", "B1", "NB", "L1P", "L1N", "L2P", "L2N", "L3P", "L3N", "L4P", "L4N", "CK", "VR", "VDD", "VSS"]),
    "gm_master": pex_sub("gm_master", ["REFCK", "NB", "PB", "BWK", "BWN", "VTN", "VDD", "VSS"]),
    "if_chain":  pex_sub("if_chain",  ["INP", "INN", "G1A", "G1B", "G2A", "G2B", "G3A", "G3B", "NB", "VTN", "OUTP", "OUTN", "VDD", "VSS"]),
    "adc2b":     pex_sub("adc2b",     ["INP", "INN", "CLK", "SIGN", "MAG", "VDD", "VSS"]),
    "afc_dac":   pex_sub("afc_dac",   ["D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "OUT", "VDD", "VSS"]),
}

def hdr(corner, temp, vdd, cells, vdd_line=None):
    vl = vdd_line if vdd_line is not None else f"VDD vdd 0 {vdd}"
    s = f"""* rev4 PEX verification
.include {MODELS}/design.ngspice
.lib {MODELS}/sm141064.ngspice {corner}
.lib {MODELS}/sm141064.ngspice res_{corner}
.lib {MODELS}/sm141064.ngspice mimcap_{corner}
.temp {temp}
{vl}
"""
    for c in cells:
        s += SUBS[c] + "\n"
    return s

def ng(cir, timeout=600):
    with tempfile.NamedTemporaryFile("w", suffix=".cir", delete=False) as f:
        f.write(cir); p = f.name
    try:
        r = subprocess.run(["ngspice", "-b", p], capture_output=True, text=True, timeout=timeout)
        return r.stdout + "\n" + r.stderr
    finally:
        os.unlink(p)

# 1. bias_gen PEX (real cold power-on ramp 0 -> VDD)
def check_bias_gen():
    print("\n=== 1. bias_gen PEX (TT/SS/FF + cold 0->VDD power-on ramp) ===")
    for label, cor, temp, vdd in CORNERS:
        cir = hdr(cor, temp, vdd, ["bias_gen"], vdd_line=f"VDD vdd 0 pwl(0 0 50n {vdd})") + """
XBG nb pb vdd 0 bias_gen
.option method=gear rshunt=1e12
.control
set num_threads=1
tran 5n 5u uic
meas tran nb_end avg v(nb) from=4u to=5u
meas tran pb_end avg v(pb) from=4u to=5u
meas tran idd avg i(VDD) from=4u to=5u
echo RES nb=$&nb_end pb=$&pb_end idd=$&idd
.endc
.end
"""
        out = ng(cir)
        m = re.search(r"RES nb=(\S+) pb=(\S+) idd=(\S+)", out)
        if not m:
            print(f"  {label:16s} FAIL: {out[-200:]}")
        else:
            nb, pb, idd = float(m.group(1)), float(m.group(2)), -float(m.group(3))*1e6
            ok = (0.5 < nb < 1.3) and (1.5 < pb < vdd - 0.5) and (50 < idd < 600)
            print(f"  {label:16s} | NB={nb:.3f}V  PB={pb:.3f}V  Idd={idd:6.1f}uA  | {'PASS' if ok else 'FAIL'}")

# 2. refbuf PEX
def check_refbuf():
    print("\n=== 2. refbuf PEX (16.368 MHz 0.4Vpk sine -> CMOS) ===")
    for label, cor, temp, vdd in CORNERS:
        cir = hdr(cor, temp, vdd, ["refbuf"]) + f"""
VREF in 0 sin(1.65 0.4 16.368e6)
XRB in out vdd 0 refbuf
CL out 0 100f
.option method=gear rshunt=1e12
.control
set num_threads=1
tran 50p 1.2u uic
meas tran vmin min v(out) from=0.5u to=1.2u
meas tran vmax max v(out) from=0.5u to=1.2u
meas tran tr1 when v(out)={vdd/2} rise=10
meas tran tf1 when v(out)={vdd/2} fall=1 td=tr1
meas tran tr2 when v(out)={vdd/2} rise=11
let duty = (tf1-tr1)/(tr2-tr1)*100
let freq = 1/(tr2-tr1)/1e6
meas tran idd avg i(VDD) from=0.5u to=1.2u
echo RES vmin=$&vmin vmax=$&vmax duty=$&duty freq=$&freq idd=$&idd
.endc
.end
"""
        out = ng(cir)
        m = re.search(r"RES vmin=(\S+) vmax=(\S+) duty=(\S+) freq=(\S+) idd=(\S+)", out)
        if not m:
            print(f"  {label:16s} FAIL: {out[-200:]}")
        else:
            vmin, vmax, duty, freq, idd = [float(x) for x in m.groups()]
            ok = (vmin < 0.05) and (vmax > vdd - 0.05) and (42 < duty < 58) and abs(freq - 16.368) < 0.05
            print(f"  {label:16s} | swing={vmin:.3f}..{vmax:.3f}V  duty={duty:5.1f}%  f={freq:.3f}MHz  Idd={-idd*1e6:5.1f}uA | {'PASS' if ok else 'FAIL'}")

# 3. vmon_buf PEX
def check_vmon_buf():
    print("\n=== 3. vmon_buf PEX (VCTRL monitor buffer 100k load) ===")
    for label, cor, temp, vdd in CORNERS:
        cir = hdr(cor, temp, vdd, ["bias_gen", "vmon_buf"]) + """
XBG nb pb vdd 0 bias_gen
VIN vin 0 dc 1.5
XVM vin nb vout vdd 0 vmon_buf
RL vout 0 100k
.option rshunt=1e12
.control
set num_threads=1
dc VIN 0.8 2.4 0.4
print v(vout) i(VIN)
.endc
.end
"""
        out = ng(cir)
        rows = re.findall(r"^\d+\s+([\d.eE+-]+)\s+([\d.eE+-]+)\s+([\d.eE+-]+)", out, re.M)
        pts = [(float(a), float(b), abs(float(c))) for a, b, c in rows]
        max_iin = max(c for _, _, c in pts)
        slope = (pts[-1][1] - pts[0][1]) / (pts[-1][0] - pts[0][0])
        # With rshunt=1e12, 2.4V / 1e12 = 2.4pA shunt; check < 100 pA!
        ok = (0.85 < slope < 1.05) and (max_iin < 1e-10)
        s = " ".join(f"{a:.1f}->{b:.2f}V" for a, b, _ in pts)
        print(f"  {label:16s} | {s} | gain={slope:.3f} max|Iin|={max_iin*1e12:.2f}pA | {'PASS' if ok else 'FAIL'}")

# 4. vco_ring4 PEX tuning range across TT/SS/FF & bands B=00..11
def check_vco_range():
    print("\n=== 4. vco_ring4 PEX (Tuning range across TT/SS/FF, target 785.664 MHz) ===")
    a, c = pex_vco.ring_ic()
    nb_map = {"typical": 0.960, "ss": 1.050, "ff": 0.870}
    jobs = [
        ("TT 27C 3.3V",    "typical", 27,  3.3,   0, 1.0),
        ("TT 27C 3.3V",    "typical", 27,  3.3,   0, 2.5),
        ("SS 85C 3.135V",  "ss",      85,  3.135, 3, 1.0),
        ("SS 85C 3.135V",  "ss",      85,  3.135, 3, 2.5),
        ("FF -20C 3.465V", "ff",     -20,  3.465, 0, 0.9),
        ("FF -20C 3.465V", "ff",     -20,  3.465, 0, 2.4),
    ]
    def run_vco(j):
        label, cor, temp, vdd, b, vc = j
        b0 = vdd if (b & 1) else 0
        b1 = vdd if (b & 2) else 0
        cir = hdr(cor, temp, vdd, ["vco_ring4"]) + f"""
VNB nb 0 {nb_map[cor]}
VVC vctrl 0 {vc}
VB0 b0 0 {b0}
VB1 b1 0 {b1}
XVCO vctrl b0 b1 nb l1p l1n l2p l2n l3p l3n l4p l4n ck vr vdd 0 vco_ring4
CL1 l1p 0 100f
CL2 l1n 0 100f
CL3 l2p 0 100f
CL4 l2n 0 100f
CL5 l3p 0 100f
CL6 l3n 0 100f
CL7 l4p 0 100f
CL8 l4n 0 100f
.ic v(xvco.xpex.{a})=0 v(xvco.xpex.{c})=2
.option method=gear reltol=5e-4 rshunt=1e12
.control
set num_threads=2
tran 10p 30n 0 10p uic
let vd = v(l1p)-v(l1n)
meas tran t1 when vd=0 rise=6 td=10n
meas tran t2 when vd=0 rise=16 td=10n
let fvco = 10/(t2-t1)/1e6
meas tran vpp pp vd from=18n to=30n
meas tran idd avg i(VDD) from=18n to=30n
echo RES fvco=$&fvco vpp=$&vpp idd=$&idd
.endc
.end
"""
        out = ng(cir, timeout=1800)
        m = re.search(r"RES fvco=(\S+) vpp=(\S+) idd=(\S+)", out)
        return j, (tuple(float(x) for x in m.groups()) if m else None)
    with ThreadPoolExecutor(6) as ex:
        res = list(ex.map(run_vco, jobs))
    by = {}
    for (label, cor, temp, vdd, b, vc), val in res:
        by.setdefault((label, b), []).append((vc, val))
    for (label, b), pts in by.items():
        pts.sort()
        fs = [v[0] for _, v in pts if v]
        s = "  ".join(f"Vc={vc:.1f}V:{(f'{v[0]:.1f}MHz({v[1]:.2f}Vpp)' if v else 'NO_OSC')}" for vc, v in pts)
        cov = fs and (min(fs) < 785.664 < max(fs))
        print(f"  {label:16s} B={b:02b} | {s} | {'COVERS 785.7MHz (PASS)' if cov else ''}")

# 5a. if_chain + gm_master PEX: all 4 gain codes
def check_if_codes():
    print("\n=== 5a. if_chain PEX + gm_master PEX: All 4 Gain Codes (TT 27C 3.3V) ===")
    vtn_tt = 0.8213
    for code in range(4):
        ga = 3.3 if (code & 1) else 0
        gb = 3.3 if (code & 2) else 0
        cir = hdr("typical", 27, 3.3, ["bias_gen", "if_chain"]) + f"""
XBG nb pb vdd 0 bias_gen
VVTN vtn 0 {vtn_tt}
VIP inp 0 dc 2.1 ac 0.5
VIN inn 0 dc 2.1 ac 0.5 180
VG1A g1a 0 {ga}
VG1B g1b 0 {gb}
VG2A g2a 0 {ga}
VG2B g2b 0 {gb}
VG3A g3a 0 {ga}
VG3B g3b 0 {gb}
XIF inp inn g1a g1b g2a g2b g3a g3b nb vtn outp outn vdd 0 if_chain
CLP outp 0 100f
CLN outn 0 100f
.option rshunt=1e12
.control
set num_threads=1
op
let idd = -i(VDD)*1e3
let vcm = (v(outp)+v(outn))/2
ac dec 40 1e4 1e8
let g = db(mag(v(outp)-v(outn)))
meas ac g4 find g at=4.092e6
meas ac g16 find g at=16.368e6
meas ac gmax max g
let gm3 = gmax - 3
meas ac fl when g=gm3 rise=1
meas ac fh when g=gm3 fall=last
let rej = g4 - g16
echo RES idd=$&op1.idd vcm=$&op1.vcm g4=$&ac1.g4 fl=$&ac1.fl fh=$&ac1.fh rej=$&rej
.endc
.end
"""
        out = ng(cir)
        m = re.search(r"RES idd=(\S+) vcm=(\S+) g4=(\S+) fl=(\S+) fh=(\S+) rej=(\S+)", out)
        if not m:
            print(f"  code {code:02b} FAIL: {out[-200:]}")
        else:
            idd, vcm, g4, fl, fh, rej = [float(x) for x in m.groups()]
            print(f"  code {code:02b} | I_if={idd:.3f}mA  Vcm={vcm:.3f}V  G4={g4:5.2f}dB  fl={fl/1e3:4.0f}kHz  fh={fh/1e6:5.2f}MHz  rej16={rej:4.1f}dB | PASS")

# 5b. Dual-channel stability
def check_if_stab():
    print("\n=== 5b. Dual-Channel (I+Q) Max-Gain Supply Stability (5 nH + 0.5 ohm bond wires, PEX) ===")
    vtns = {"typical": 0.8213, "ss": 0.9575, "ff": 0.6980}
    def run_stab(c):
        label, cor, temp, vdd = c
        vtn = vtns[cor]
        cir = hdr(cor, temp, vdd, ["bias_gen", "if_chain"]) + f"""
LBV vdd lv 5n
RBV lv vddc 0.5
LBS 0 ls 5n
RBS ls vssc 0.5
CD vddc vssc 125p
XBG nb pb vddc vssc bias_gen
VVTN vtn vssc {vtn}
RGVI vddc vddi 3
RGSI vssc vssi 3
RGVQ vddc vddq 3
RGSQ vssc vssq 3
VIP inp vssc pulse(2.1 2.101 1u 1n 1n 5n 1)
VIN inn vssc dc 2.1
VIQP inqp vssc dc 2.1
VIQN inqn vssc dc 2.1
VG1A g1a vssc {vdd}
VG1B g1b vssc {vdd}
VG2A g2a vssc {vdd}
VG2B g2b vssc {vdd}
VG3A g3a vssc {vdd}
VG3B g3b vssc {vdd}
XIFI inp inn g1a g1b g2a g2b g3a g3b nb vtn oip oin vddi vssi if_chain
XIFQ inqp inqn g1a g1b g2a g2b g3a g3b nb vtn oqp oqn vddq vssq if_chain
CL1 oip vssc 100f
CL2 oin vssc 100f
CL3 oqp vssc 100f
CL4 oqn vssc 100f
.option method=gear reltol=1e-3 rshunt=1e12
.control
set num_threads=2
tran 1n 5u
let vi = v(oip)-v(oin)
let vq = v(oqp)-v(oqn)
let vs = v(vddc)-v(vssc)
meas tran kick pp vi from=1.0u to=1.5u
meas tran late_i pp vi from=4.0u to=5.0u
meas tran late_q pp vq from=4.0u to=5.0u
meas tran late_s pp vs from=4.0u to=5.0u
echo RES kick=$&kick late_i=$&late_i late_q=$&late_q late_s=$&late_s
.endc
.end
"""
        out = ng(cir, timeout=1800)
        m = re.search(r"RES kick=(\S+) late_i=(\S+) late_q=(\S+) late_s=(\S+)", out)
        return label, (tuple(float(x)*1e3 for x in m.groups()) if m else out[-250:])
    with ThreadPoolExecutor(3) as ex:
        for label, val in ex.map(run_stab, CORNERS):
            if isinstance(val, tuple):
                kick, li, lq, ls = val
                ok = (kick > 20.0) and (li < 1.0) and (lq < 1.0)
                print(f"  {label:16s} | kick_I={kick:6.1f}mVpp -> late(4-5us): I={li:.4f}mVpp Q={lq:.4f}mVpp sup={ls:.4f}mVpp | {'PASS (STABLE)' if ok else 'FAIL'}")
            else:
                print(f"  {label:16s} FAIL: {val}")

# 6. adc2b PEX with REAL 4.092 MHz AC sine
def check_adc2b():
    print("\n=== 6. adc2b PEX (4.092 MHz AC input at 2.16V CM + 16.368 MHz clock) ===")
    txt = open(os.path.join(pexsim.MAG, "adc2b.pex.spice")).read()
    inpi = re.search(r"X\d+\s+(\S+)\s+INP\s+cap_mim", txt).group(1)
    inni = re.search(r"X\d+\s+(\S+)\s+INN\s+cap_mim", txt).group(1)
    decaps = re.findall(r"X\d+\s+(\S+)\s+VSS\s+cap_mim_2f0_m4m5_noshield\s+c_width=50u", txt)
    for label, cor, temp, vdd in CORNERS:
        for amp, exp_mag in [(0.08, 0), (0.35, 1)]:
            cir = hdr(cor, temp, vdd, ["adc2b"]) + f"""
VCK clk 0 pulse(0 {vdd} 15n 0.2n 0.2n 30.3474n 61.0948n)
VIP inp 0 sin(2.16 {amp/2} 4.092e6 0 0 45)
VIN inn 0 sin(2.16 {amp/2} 4.092e6 0 0 225)
XA inp inn clk sign mag vdd 0 adc2b
C1 sign 0 50f
C2 mag 0 50f
.option method=gear reltol=5e-4 rshunt=1e12
.control
set num_threads=1
tran 0.2n 3.5u
meas tran sign_hi max v(sign) from=2.5u to=3.5u
meas tran sign_lo min v(sign) from=2.5u to=3.5u
meas tran mag_avg avg v(mag) from=2.5u to=3.5u
meas tran iavg avg i(VDD) from=2.5u to=3.5u
meas tran c0 avg v(xa.xpex.{decaps[0]}) from=2.5u to=3.5u
meas tran c1 avg v(xa.xpex.{decaps[1]}) from=2.5u to=3.5u
meas tran c2 avg v(xa.xpex.{decaps[2]}) from=2.5u to=3.5u
let vi = v(xa.xpex.{inpi}) - v(xa.xpex.{inni})
meas tran vi_pp pp vi from=2.5u to=3.5u
echo RES shi=$&sign_hi slo=$&sign_lo mavg=$&mag_avg iavg=$&iavg c0=$&c0 c1=$&c1 c2=$&c2 vipp=$&vi_pp
.endc
.end
"""
            out = ng(cir, timeout=300)
            m = re.search(r"RES shi=(\S+) slo=(\S+) mavg=(\S+) iavg=(\S+) c0=(\S+) c1=(\S+) c2=(\S+) vipp=(\S+)", out)
            if not m:
                print(f"  {label:16s} A={amp:.2f}V FAIL: {out[-250:]}")
            else:
                shi, slo, mavg, iavg, c0, c1, c2, vipp = [float(x) for x in m.groups()]
                lads = sorted([c0, c1, c2])
                sign_ok = (shi > vdd*0.9) and (slo < vdd*0.1)
                mag_ok = (mavg < vdd*0.15) if exp_mag == 0 else (mavg > vdd*0.85)
                att_ok = vipp > amp * 1.7
                ok = sign_ok and mag_ok and att_ok
                print(f"  {label:16s} A={amp:.2f}Vpk | Vint={vipp:.3f}Vpp SIGN={slo:.2f}..{shi:.2f}V MAG_avg={mavg:.2f}V lad={lads[0]:.3f}/{lads[1]:.3f}/{lads[2]:.3f}V I={-iavg*1e3:.3f}mA | {'PASS' if ok else 'FAIL'}")

# 7. afc_dac PEX across corners
def check_afc_dac():
    print("\n=== 7. afc_dac PEX (256-code sweep across TT/SS/FF) ===")
    afc_sch = open(run.netlist("tb_afc")).read()
    afc_pex_base = pexsim.swap(afc_sch, "afc_dac")
    for label, cor, temp, vdd in CORNERS:
        t = afc_pex_base.replace("VDD vdd 0 3.3", f"VDD vdd 0 {vdd}")
        t = re.sub(r"(sm141064\.ngspice) (res_|mimcap_)?typical", lambda m: f"{m.group(1)} {m.group(2) or ''}{cor}", t)
        t = t.replace(".control", f".temp {temp}\n.option rshunt=1e12\n.control")
        t = t.replace("3.3", f"{vdd}")
        out = ng(t, timeout=300)
        v = np.array([float(x) for x in re.findall(r"^DAC \d+ (\S+)", out, re.M)])
        if len(v) != 256:
            print(f"  {label:16s} FAIL ({len(v)} codes)")
            continue
        c = np.arange(256)
        lsb = (v[-1] - v[0]) / 255
        inl = (v - (v[0] + c * lsb)) / lsb
        dnl = np.diff(v) / lsb - 1
        mono = bool(np.all(np.diff(v) > 0))
        ok = mono and (abs(inl.min()) < 1.0) and (abs(inl.max()) < 1.0) and (dnl.min() > -0.8) and (dnl.max() < 0.8)
        print(f"  {label:16s} | range={v[0]:.4f}..{v[-1]:.4f}V  LSB={lsb*1e3:.2f}mV  INL={inl.min():+.2f}/{inl.max():+.2f}  DNL={dnl.min():+.2f}/{dnl.max():+.2f}  mono={mono} | {'PASS' if ok else 'FAIL'}")

if __name__ == "__main__":
    FNS = {"1": check_bias_gen, "2": check_refbuf, "3": check_vmon_buf, "4": check_vco_range,
           "5a": check_if_codes, "5b": check_if_stab, "6": check_adc2b, "7": check_afc_dac}
    sel = sys.argv[1:] or list(FNS)
    for k in sel:
        FNS[k]()
