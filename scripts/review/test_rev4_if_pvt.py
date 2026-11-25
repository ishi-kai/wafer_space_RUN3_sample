"""Verify rev.4 xschem gm_master + if_chain across 5 extreme PVT corners,
cold startup from VTN=0V (uic), and BWK/BWN trim modes."""
import os, re, subprocess, tempfile, sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import run

PDK_ROOT = os.path.expanduser("~/pdk")
MODELS = os.path.join(PDK_ROOT, "gf180mcuD/libs.tech/ngspice")

# Netlist gnss_afe_top (or tb_ifadc) to get the exact generated xschem subckts!
net_path = run.netlist("tb_ifadc")
txt = open(net_path).read()

# Extract all .subckt ... .ends blocks from tb_ifadc.spice
subckts = "\n".join(re.findall(r"(?ms)^\.subckt\b.*?^\.ends[^\n]*", txt))

def run_ng(cir):
    with tempfile.NamedTemporaryFile("w", suffix=".cir", delete=False) as f:
        f.write(cir); p = f.name
    try:
        r = subprocess.run(["ngspice", "-b", p], capture_output=True, text=True, timeout=240)
        return r.stdout + "\n" + r.stderr
    finally:
        os.unlink(p)

def hdr(corner, temp, vdd):
    return f""".include {MODELS}/design.ngspice
.lib {MODELS}/sm141064.ngspice {corner}
.lib {MODELS}/sm141064.ngspice res_{corner}
.lib {MODELS}/sm141064.ngspice mimcap_{corner}
.temp {temp}
VDD vdd 0 {vdd}
{subckts}
"""

def test_case(label, corner, temp, vdd, bwk, bwn, cold=False):
    ic = "" if cold else ".ic v(vtn)=0.9"
    tend = "50u" if cold else "35u"
    lock_cir = hdr(corner, temp, vdd) + f"""
XBG nb pb vdd 0 bias_gen
VCLK refck 0 pulse(0 {vdd} 0 0.2n 0.2n 30.35n 61.095n)
VBWK bwk 0 {vdd if bwk else 0}
VBWN bwn 0 {vdd if bwn else 0}
XGM refck nb pb bwk bwn vtn vdd 0 gm_master
{ic}
.option method=gear reltol=1e-3
.control
set num_threads=1
tran 5n {tend} uic
let n = length(v(vtn))
let vmax = vecmax(v(vtn)[n-200, n-1])
let vmin = vecmin(v(vtn)[n-200, n-1])
let vtn_avg = (vmax + vmin)/2
let rip_mv = (vmax - vmin)*1000
let itot_gm = -mean(i(VDD)[n-200, n-1])*1000
echo LOCK vtn=$&vtn_avg rip_mv=$&rip_mv itot_gm=$&itot_gm
.endc
.end
"""
    out = run_ng(lock_cir)
    m = re.search(r"LOCK vtn=(\S+) rip_mv=(\S+) itot_gm=(\S+)", out)
    if not m:
        print(f"  {label:28s} LOCK FAIL: {out[-250:]}")
        return
    vtn, rip, igm = float(m.group(1)), float(m.group(2)), float(m.group(3))

    ac_cir = hdr(corner, temp, vdd) + f"""
XBG nb pb vdd 0 bias_gen
VVTN vtn 0 {vtn}
VIP inp 0 dc 2.1 ac 0.5
VIN inn 0 dc 2.1 ac 0.5 180
VG1A g1a 0 0
VG1B g1b 0 {vdd}
VG2A g2a 0 0
VG2B g2b 0 {vdd}
VG3A g3a 0 0
VG3B g3b 0 {vdd}
XIF inp inn g1a g1b g2a g2b g3a g3b nb vtn outp outn vdd 0 if_chain
CLP outp 0 100f
CLN outn 0 100f
.control
set num_threads=1
op
let idd_if = -i(VDD)*1000
let vcm_o = (v(outp)+v(outn))/2
ac dec 40 1e4 1e8
let g = db(mag(v(outp)-v(outn)))
meas ac g4 find g at=4.092e6
meas ac g16 find g at=16.368e6
meas ac gmax max g
let gm3 = gmax - 3
meas ac fl when g=gm3 rise=1
meas ac fh when g=gm3 fall=last
noise v(outp,outn) VIP dec 10 1e6 1e7
setplot noise1
let nin = inoise_spectrum[6]
let rej16 = ac1.g4 - ac1.g16
echo IFAC idd=$&op1.idd_if vcm=$&op1.vcm_o g4=$&ac1.g4 gmax=$&ac1.gmax fl=$&ac1.fl fh=$&ac1.fh rej16=$&rej16 nin=$&nin
.endc
.end
"""
    out2 = run_ng(ac_cir)
    m2 = re.search(r"IFAC idd=(\S+) vcm=(\S+) g4=(\S+) gmax=(\S+) fl=(\S+) fh=(\S+) rej16=(\S+) nin=(\S+)", out2)
    if not m2:
        print(f"  {label:28s} VTN={vtn:.4f}V rip={rip:.2f}mV | AC FAIL: {out2[-250:]}")
        return
    idd, vcm, g4, gmax, fl, fh, rej, nin = [float(x) for x in m2.groups()]
    print(f"  {label:28s} | VTN={vtn:.4f}V rip={rip:.2f}mV I_gm={igm:.2f}mA | I_if={idd:.2f}mA Vcm={vcm:.2f}V | G4={g4:5.2f}dB fl={fl/1e3:4.0f}k fh={fh/1e6:5.2f}MHz rej16={rej:4.1f}dB nin={nin*1e9:4.1f}nV/rtHz")

print("=== Rev.4 Auto-Tuned IF Chain + gm_master Verification (gain code 10) ===")
test_case("TT 27C 3.3V nom (cold uic)", "typical", 27, 3.3,   1, 0, cold=True)
test_case("SS 85C 3.135V nom",          "ss",      85, 3.135, 1, 0)
test_case("SS -20C 3.135V nom",         "ss",     -20, 3.135, 1, 0)
test_case("FF -20C 3.465V nom",         "ff",     -20, 3.465, 1, 0)
test_case("FF 85C 3.465V nom",          "ff",      85, 3.465, 1, 0)
print("--- BWK/BWN Trim Modes (TT 27C 3.3V) ---")
test_case("TT wider  (BWK=0, BWN=0)",   "typical", 27, 3.3,   0, 0)
test_case("TT narrow (BWK=1, BWN=1)",   "typical", 27, 3.3,   1, 1)
