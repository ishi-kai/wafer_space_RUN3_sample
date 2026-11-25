"""Build every analog module bottom-up with DRC + LVS; log to layout/build_all.log"""
import os, sys, time, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import auto, lvs, build
ORDER = ["inv_dig", "inv_lo1", "inv_lo2", "nand2", "nand3", "nor2", "dff_st", "div2", "div3", "div48",
         "dff_r", "pfd", "cp", "loop_filter", "refbuf", "divbuf", "pll_core",
         "vco_ring4", "vmon_buf", "decap", "decap_vco", "sa_comp", "adc2b", "afc_dac", "bias_gen", "bias_if",
         "vga", "vga_fix", "gm_unit", "gmc_lpf1", "gmc_lpf2", "gm_master",
         "if_chain", "lna_nc", "mixer_iq"]
only = sys.argv[1:] or ORDER
log = open(os.path.join(lvs.PROJ, "layout", "build_all.log"), "a")
res = {}
for c in only:
    t = time.time()
    try:
        m = auto._built.get(c) or (build.build(c, check=False) if c in build.cells.BUILD else auto.build(c))
        m.write(build.OUT); m.flattened().write(build.OUT)
        n, errs = lvs.drc(c, build.OUT)
        ok, last, rpt = lvs.lvs(c, build.OUT)
        b = m.outline
        line = "%-12s route=%s DRC=%d LVS=%s size=%.0fx%.0fum %.0fs %s" % (
            c, getattr(m, "route_ok", "?"), n, "OK" if ok else "FAIL", (b[2]-b[0])/1e3, (b[3]-b[1])/1e3,
            time.time() - t, "" if ok else last[-1:])
    except Exception as e:
        import traceback; traceback.print_exc()
        line = "%-12s ERROR %s" % (c, repr(e)[:200])
    print(line, flush=True); log.write(line + "\n"); log.flush()
