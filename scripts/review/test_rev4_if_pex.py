"""Full Post-Layout PEX Verification of rev.4 Auto-Tuned IF Chain:
Runs BOTH extracted gm_master.pex.spice AND extracted if_chain.pex.spice across
TT 27C 3.3V, SS 85C 3.135V, FF -20C 3.465V, and BWK/BWN trim modes!"""
import os, re, subprocess, tempfile, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "layout"))
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import lvs, pexsim, run

PDK_ROOT = os.path.expanduser("~/pdk")
MODELS = os.path.join(PDK_ROOT, "gf180mcuD/libs.tech/ngspice")

# Extract gm_master and if_chain if not already extracted
if not os.path.exists(os.path.join(pexsim.MAG, "gm_master.pex.spice")):
    lvs.pex("gm_master", pexsim.MAG)
if not os.path.exists(os.path.join(pexsim.MAG, "if_chain.pex.spice")):
    lvs.pex("if_chain", pexsim.MAG)

# Get bias_gen schematic subckt
net_txt = open(run.netlist("tb_ifadc")).read()
bg_m = re.search(r"(?ms)^\.subckt bias_gen\b.*?^\.ends[^\n]*", net_txt)
bg_sub = bg_m.group(0)

# Build pex subcircuit wrappers using pexsim.swap on minimal shells
def get_pex_wrapper(cell, ports):
    shell = f".subckt {cell} {' '.join(ports)}\n.ends\n.end\n"
    sw = pexsim.swap(shell, cell)
    return sw[:sw.rindex(".end")]

gm_pex = get_pex_wrapper("gm_master", ["REFCK", "NB", "PB", "BWK", "BWN", "VTN", "VDD", "VSS"])
if_pex = get_pex_wrapper("if_chain", ["INP", "INN", "G1A", "G1B", "G2A", "G2B", "G3A", "G3B", "NB", "VTN", "OUTP", "OUTN", "VDD", "VSS"])

def run_ng(cir):
    with tempfile.NamedTemporaryFile("w", suffix=".cir", delete=False) as f:
        f.write(cir); p = f.name
    try:
        r = subprocess.run(["ngspice", "-b", p], capture_output=True, text=True, timeout=300)
        return r.stdout + "\n" + r.stderr
    finally:
        os.unlink(p)

def hdr(corner, temp, vdd, sub):
    return f""".include {MODELS}/design.ngspice
.lib {MODELS}/sm141064.ngspice {corner}
.lib {MODELS}/sm141064.ngspice res_{corner}
.lib {MODELS}/sm141064.ngspice mimcap_{corner}
.temp {temp}
VDD vdd 0 {vdd}
{bg_sub}
{sub}
"""

def test_pex(label, corner, temp, vdd, bwk, bwn):
    lock_cir = hdr(corner, temp, vdd, gm_pex) + f"""
XBG nb pb vdd 0 bias_gen
VCLK refck 0 pulse(0 {vdd} 0 0.2n 0.2n 30.35n 61.095n)
VBWK bwk 0 {vdd if bwk else 0}
VBWN bwn 0 {vdd if bwn else 0}
XGM refck nb pb bwk bwn vtn vdd 0 gm_master
.ic v(vtn)=0.9
.option method=gear reltol=2e-3
.control
set num_threads=1
tran 10n 35u uic
let n = length(v(vtn))
let vmax = vecmax(v(vtn)[n-150, n-1])
let vmin = vecmin(v(vtn)[n-150, n-1])
let vtn_avg = (vmax + vmin)/2
let rip_mv = (vmax - vmin)*1000
echo LOCK vtn=$&vtn_avg rip_mv=$&rip_mv
.endc
.end
"""
    out = run_ng(lock_cir)
    m = re.search(r"LOCK vtn=(\S+) rip_mv=(\S+)", out)
    if not m:
        print(f"  {label:24s} PEX LOCK FAIL: {out[-250:]}")
        return
    vtn, rip = float(m.group(1)), float(m.group(2))

    ac_cir = hdr(corner, temp, vdd, if_pex) + f"""
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
ac dec 40 1e4 1e8
let g = db(mag(v(outp)-v(outn)))
meas ac g4 find g at=4.092e6
meas ac g16 find g at=16.368e6
meas ac gmax max g
let gm3 = gmax - 3
meas ac fl when g=gm3 rise=1
meas ac fh when g=gm3 fall=last
let rej16 = g4 - g16
echo IFAC idd=$&op1.idd_if g4=$&ac1.g4 fl=$&ac1.fl fh=$&ac1.fh rej16=$&rej16
.endc
.end
"""
    out2 = run_ng(ac_cir)
    m2 = re.search(r"IFAC idd=(\S+) g4=(\S+) fl=(\S+) fh=(\S+) rej16=(\S+)", out2)
    if not m2:
        print(f"  {label:24s} VTN={vtn:.4f}V rip={rip:.2f}mV | PEX AC FAIL: {out2[-250:]}")
        return
    idd, g4, fl, fh, rej = [float(x) for x in m2.groups()]
    print(f"  {label:24s} | PEX VTN={vtn:.4f}V rip={rip:.2f}mV | I_if={idd:.2f}mA G4={g4:5.2f}dB fl={fl/1e3:4.0f}k fh={fh/1e6:5.2f}MHz rej16={rej:4.1f}dB")

print("=== Rev.4 FULL POST-LAYOUT PEX: gm_master PEX + if_chain PEX (code 10) ===")
test_pex("TT 27C 3.3V nom",    "typical", 27, 3.3,   1, 0)
test_pex("SS 85C 3.135V nom",  "ss",      85, 3.135, 1, 0)
test_pex("FF -20C 3.465V nom", "ff",     -20, 3.465, 1, 0)
test_pex("TT wider  (BWK=0)",  "typical", 27, 3.3,   0, 0)
test_pex("TT narrow (BWN=1)",  "typical", 27, 3.3,   1, 1)
