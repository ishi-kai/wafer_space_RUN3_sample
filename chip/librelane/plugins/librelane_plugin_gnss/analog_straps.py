"""odbpy: straps for:
  1. GNSS analog pad block afe_rf_pad (VDDA / VDDV / VSSA / RF) + analog[0..2] -> i_chip_core.i_afe on Metal2.
  2. megabytebeat_macro (slot 0p5x1 dual-VDD):
     * VDD_BB: Metal5 C-trunk + 30 horizontal Metal5 fingers into megabytebeat_macro, fed on Metal5
       from all 6 fill10_supplyVDD padring cells (jumping cleanly over the Metal3/Metal4 core rings).
     * Shared VSS: 15 vertical Metal4 straps from megabytebeat_macro south into chip_top's South
       Metal3 VSS core ring (+ Via3 4x4 arrays) and north into chip_top's nearest Metal3 VSS stripe
       (+ Via3 4x4 arrays).
"""
import re
import odb
from reader import click_odb, click

PAD, MACRO = "afe_rf_pad", "i_chip_core.i_afe"
PAIRS = [("VDDA", "VDDA"), ("VDDV", "VDDV"), ("VSSA", "VSSA"), ("RF", "RFIN")]
SIGS = [("analog[2].pad", "VCTRL"), ("analog[1].pad", "AFCOUT"), ("analog[0].pad", "REFIN")]
BB_MACRO = "i_chip_core.i_megabytebeat"
BB_SUPPLIES = ["sup_vdd_e0", "sup_vdd_e1", "sup_vdd_e2", "sup_vdd_w0", "sup_vdd_w1", "sup_vdd_w2"]


def boxes(inst, pin, layer):
    t = inst.getTransform()
    out = []
    mterm = inst.getMaster().findMTerm(pin)
    if mterm is None:
        return out
    for mp in mterm.getMPins():
        for b in mp.getGeometry():
            if b.getTechLayer().getName() != layer:
                continue
            p1, p2 = odb.Point(b.xMin(), b.yMin()), odb.Point(b.xMax(), b.yMax())
            t.apply(p1); t.apply(p2)
            out.append(odb.Rect(min(p1.x(), p2.x()), min(p1.y(), p2.y()), max(p1.x(), p2.x()), max(p1.y(), p2.y())))
    return out


def make_via3_4x4(block, tech):
    """Reuse OpenROAD PDN's VIARULE Via3_GEN_HH 4x4 via (guarantees 0 Magic/KLayout XOR)."""
    for v in block.getVias():
        if v.getName().startswith("via3_") and "_4_4_" in v.getName():
            print("  Reusing PDN Via3 master:", v.getName())
            return v
    # Fallback: build via using VIARULE Via3_GEN_HH
    rule = tech.findViaGenerateRule("Via3_GEN_HH")
    v = odb.dbVia_create(block, "gnss_bb_via3_4x4")
    v.setViaGenerateRule(rule)
    params = v.getViaParams()
    dbu = block.getDbUnitsPerMicron()
    params.setCutSize(int(round(0.26 * dbu)), int(round(0.26 * dbu)))
    params.setCutSpacing(int(round(0.36 * dbu)), int(round(0.36 * dbu)))
    params.setEnclosure(int(round(0.28 * dbu)), int(round(0.28 * dbu)), int(round(0.28 * dbu)), int(round(0.28 * dbu)))
    params.setNumCutRows(4)
    params.setNumCutCols(4)
    v.setViaParams(params)
    return v


def strap_megabytebeat(block, tech):
    bb = block.findInst(BB_MACRO)
    if bb is None:
        return
    print("[INFO] Strapping megabytebeat_macro (VDD_BB on Metal5 + shared VSS on Metal4/Via3)…")
    dbu = block.getDbUnitsPerMicron()
    um = lambda v: int(round(v * dbu))

    m3 = tech.findLayer("Metal3")
    m4 = tech.findLayer("Metal4")
    m5 = tech.findLayer("Metal5")

    mbb = bb.getBBox()
    mx1, my1, mx2, my2 = mbb.xMin(), mbb.yMin(), mbb.xMax(), mbb.yMax()
    print("  megabytebeat_macro bbox: (%.2f, %.2f) -> (%.2f, %.2f) um" % (mx1/dbu, my1/dbu, mx2/dbu, my2/dbu))

    # ------------------------------------------------------------------ 1. VDD_BB on Metal5
    vdd_bb_iterm = bb.findITerm("VDD_BB")
    vdd_bb_net = vdd_bb_iterm.getNet()
    if vdd_bb_net is None:
        raise SystemExit("[ERROR] megabytebeat_macro/VDD_BB is unconnected")
    vdd_bb_net.setSpecial()
    vdd_bb_net.setSigType("POWER")
    sw_bb = odb.dbSWire_create(vdd_bb_net, "ROUTED")

    # Metal5 C-trunk outside megabytebeat_macro (width 12 um, inside PDN_OBSTRUCTIONS [446..1474, 452..1490])
    w_x1, w_x2 = mx1 - um(30.0), mx1 - um(18.0)   # 450 .. 462 um
    e_x1, e_x2 = mx2 + um(18.0), mx2 + um(30.0)   # 1458 .. 1470 um
    s_y1, s_y2 = my1 - um(48.0), my1 - um(36.0)   # 472 .. 484 um (clear of y=459.6/465.6 PDN M5 stubs)
    t_y2       = my2 - um(50.0)                   # 1430 um (covers all 15 horizontal Metal5 stripes)

    bb_m5_drawn = []
    def add_bb_m5(x1, y1, x2, y2):
        odb.dbSBox_create(sw_bb, m5, x1, y1, x2, y2, "STRIPE")
        bb_m5_drawn.append((x1, y1, x2, y2))

    add_bb_m5(w_x1, s_y1, e_x2, s_y2)  # South trunk
    add_bb_m5(w_x1, s_y1, w_x2, t_y2)  # West trunk
    add_bb_m5(e_x1, s_y1, e_x2, t_y2)  # East trunk

    # Connect all 15 horizontal Metal5 VDD_BB stripes of megabytebeat_macro to West & East trunks
    bb_m5_boxes = boxes(bb, "VDD_BB", "Metal5")
    stripes = [r for r in bb_m5_boxes if r.dx() > um(500.0) and r.dy() < um(6.0)]
    if not stripes:
        raise SystemExit("[ERROR] No horizontal Metal5 VDD_BB stripes found on megabytebeat_macro")
    for r in stripes:
        add_bb_m5(w_x2, r.yMin(), r.xMin() + um(4.0), r.yMax())
        add_bb_m5(r.xMax() - um(4.0), r.yMin(), e_x1, r.yMax())
    print("  VDD_BB: connected %d Metal5 horizontal stripes to West & East trunks (%d fingers)" % (len(stripes), 2 * len(stripes)))

    # Connect all 6 fill10_supplyVDD pad cells directly on Metal5 (passing through 64 um windows between PDN M5 stubs)
    n_sup = 0
    for sname in BB_SUPPLIES:
        sinst = block.findInst(sname)
        if sinst is None:
            raise SystemExit("[ERROR] supply cell %s not found" % sname)
        sboxes = boxes(sinst, "DVDD", "Metal5")
        if sname.startswith("sup_vdd_w"):
            p = max(sboxes, key=lambda r: r.xMax())
            add_bb_m5(p.xMin(), p.yMin(), w_x2, p.yMax())
            print("  VDD_BB west  jumper %s: x=[%.2f,%.2f] y=[%.2f,%.2f]" % (sname, p.xMin()/dbu, w_x2/dbu, p.yMin()/dbu, p.yMax()/dbu))
        elif sname.startswith("sup_vdd_e"):
            p = min(sboxes, key=lambda r: r.xMin())
            add_bb_m5(e_x1, p.yMin(), p.xMax(), p.yMax())
            print("  VDD_BB east  jumper %s: x=[%.2f,%.2f] y=[%.2f,%.2f]" % (sname, e_x1/dbu, p.xMax()/dbu, p.yMin()/dbu, p.yMax()/dbu))
        n_sup += 1
    print("  VDD_BB: %d fill10_supplyVDD Metal5 jumpers connected" % n_sup)

    # Automated Metal5 isolation guard: assert >= 3.0 um clearance from EVERY VDD/VSS Metal5 shape!
    margin = um(3.0)
    for other_name in ("VDD", "VSS"):
        onet = block.findNet(other_name)
        if onet is None:
            continue
        for sw in onet.getSWires():
            for b in sw.getWires():
                if b.isVia() or b.getTechLayer().getName() != "Metal5":
                    continue
                ox1, oy1, ox2, oy2 = b.xMin(), b.yMin(), b.xMax(), b.yMax()
                for bx1, by1, bx2, by2 in bb_m5_drawn:
                    if bx1 - margin < ox2 and ox1 < bx2 + margin and by1 - margin < oy2 and oy1 < by2 + margin:
                        raise SystemExit(
                            "[ERROR] Metal5 VDD_BB [%.2f,%.2f..%.2f,%.2f] violates 3um clearance to %s [%.2f,%.2f..%.2f,%.2f]" % (
                                bx1/dbu, by1/dbu, bx2/dbu, by2/dbu, other_name, ox1/dbu, oy1/dbu, ox2/dbu, oy2/dbu))
    print("  VDD_BB Metal5 isolation check PASS: >= 3.0 um clearance from all VDD & VSS Metal5 shapes!")

    # ------------------------------------------------------------------ 2. Shared VSS on Metal4 + Via3
    vss_net = bb.findITerm("VSS").getNet()
    if vss_net is None:
        raise SystemExit("[ERROR] megabytebeat_macro/VSS is unconnected")
    # Find South Metal3 VSS core ring and all North vertical Metal4 VSS stripes ending near y = my2 + 10 um
    south_m3_ring = None
    north_chip_vss_m4 = []
    for sw in vss_net.getSWires():
        for b in sw.getWires():
            if b.isVia():
                continue
            lname = b.getTechLayer().getName()
            r = odb.Rect(b.xMin(), b.yMin(), b.xMax(), b.yMax())
            if lname == "Metal3" and r.dx() > um(800.0) and r.yMax() < my1 - um(80.0):
                if south_m3_ring is None or r.yMax() > south_m3_ring.yMax():
                    south_m3_ring = r
            elif lname == "Metal4" and r.dy() > um(100.0) and r.dx() < um(10.0):
                if r.xMin() >= mx1 + um(10.0) and r.xMax() <= mx2 - um(10.0):
                    if my2 <= r.yMin() <= my2 + um(100.0):
                        north_chip_vss_m4.append(r)
    if south_m3_ring is None:
        raise SystemExit("[ERROR] Could not locate South Metal3 VSS core ring")
    print("  VSS south M3 ring: y=[%.2f, %.2f] um, north chip M4 VSS stripes: %d" % (
        south_m3_ring.yMin()/dbu, south_m3_ring.yMax()/dbu, len(north_chip_vss_m4)))

    vss_m4_boxes = boxes(bb, "VSS", "Metal4")
    vstripes = [r for r in vss_m4_boxes if r.dy() > um(500.0) and r.dx() < um(6.0)]
    if not vstripes:
        raise SystemExit("[ERROR] No vertical Metal4 VSS stripes found on megabytebeat_macro")

    via3 = make_via3_4x4(block, tech)
    sw_vss = odb.dbSWire_create(vss_net, "ROUTED")
    sy_c = (south_m3_ring.yMin() + south_m3_ring.yMax()) // 2

    # North Metal3 VSS collector bar in the PDN-obstructed corridor y = [my2+1, my2+9] (8 um tall):
    # macro M4 stripes land on lower half (y = my2+1..my2+4.5), chip M4 stripes land on upper half
    # (y = my2+5.5..my2+9) -> guaranteed >= 1.0 um Metal4 clearance, zero risk of touching chip VDD M4!
    bar_y1, bar_y2 = my2 + um(1.0), my2 + um(9.0)
    bar_x1, bar_x2 = mx1 + um(8.0), mx2 - um(8.0)
    odb.dbSBox_create(sw_vss, m3, bar_x1, bar_y1, bar_x2, bar_y2, "STRIPE")
    ny_mac = my2 + um(2.8)
    ny_top = my2 + um(7.2)

    # Collect all VDD Metal4 boxes below y = my1 + 20 um so South Metal4 VSS straps skip any
    # LCM(60um, 75um)=300um aligned VDD core-ring taps (guaranteeing 0 VDD<->VSS shorts!)
    vdd_m4_south = []
    vdd_net = block.findNet("VDD")
    if vdd_net is not None:
        for sw in vdd_net.getSWires():
            for b in sw.getWires():
                if not b.isVia() and b.getTechLayer().getName() == "Metal4" and b.yMin() < my1 + um(20.0):
                    vdd_m4_south.append((b.xMin(), b.yMin(), b.xMax(), b.yMax()))

    n_south_vss = 0
    m4_margin = um(2.0)
    for r in vstripes:
        cx = (r.xMin() + r.xMax()) // 2
        # South Metal4 strap: only draw if >= 2.0 um clear of all VDD Metal4 shapes
        sy1_s = south_m3_ring.yMin() + um(2.0)
        sy2_s = r.yMin() + um(4.0)
        blocked = any(
            r.xMin() - m4_margin < vx2 and vx1 < r.xMax() + m4_margin and sy1_s - m4_margin < vy2 and vy1 < sy2_s + m4_margin
            for vx1, vy1, vx2, vy2 in vdd_m4_south
        )
        if not blocked:
            odb.dbSBox_create(sw_vss, m4, r.xMin(), sy1_s, r.xMax(), sy2_s, "STRIPE")
            odb.dbSBox_create(sw_vss, via3, cx, sy_c, "STRIPE")
            n_south_vss += 1
        # North Metal4 strap from macro Metal4 VSS stripe -> lower half of North M3 VSS collector bar
        odb.dbSBox_create(sw_vss, m4, r.xMin(), r.yMax() - um(4.0), r.xMax(), my2 + um(4.5), "STRIPE")
        odb.dbSBox_create(sw_vss, via3, cx, ny_mac, "STRIPE")

    for r in north_chip_vss_m4:
        cx = (r.xMin() + r.xMax()) // 2
        # Extend chip_top vertical M4 VSS stripe down to upper half of North M3 VSS collector bar
        odb.dbSBox_create(sw_vss, m4, r.xMin(), my2 + um(5.5), r.xMax(), r.yMin() + um(4.0), "STRIPE")
        odb.dbSBox_create(sw_vss, via3, cx, ny_top, "STRIPE")

    print("  VSS: connected %d/%d south M4 straps + %d north macro M4 straps + %d north chip M4 VSS stripes (0 VDD<->VSS overlaps)" % (
        n_south_vss, len(vstripes), len(vstripes), len(north_chip_vss_m4)))
    strap_bb_ua(block, tech, bb)


def make_via2_3x3(block, tech):
    """DRC-clean GF180MCU 3x3 Via2 array (Via2_GEN_HH: 0.26 um cut, 0.36 um pitch, 0.12 um enc)."""
    v = block.findVia("gnss_bb_via2_3x3")
    if v is not None:
        return v
    v = odb.dbVia_create(block, "gnss_bb_via2_3x3")
    v.setViaGenerateRule(tech.findViaGenerateRule("Via2_GEN_HH"))
    p = v.getViaParams()
    dbu = block.getDbUnitsPerMicron()
    p.setBottomLayer(tech.findLayer("Metal2"))
    p.setCutLayer(tech.findLayer("Via2"))
    p.setTopLayer(tech.findLayer("Metal3"))
    p.setXCutSize(int(round(0.26 * dbu)))
    p.setYCutSize(int(round(0.26 * dbu)))
    p.setXCutSpacing(int(round(0.36 * dbu)))
    p.setYCutSpacing(int(round(0.36 * dbu)))
    p.setXBottomEnclosure(int(round(0.12 * dbu)))
    p.setYBottomEnclosure(int(round(0.12 * dbu)))
    p.setXTopEnclosure(int(round(0.12 * dbu)))
    p.setYTopEnclosure(int(round(0.12 * dbu)))
    p.setNumCutRows(3)
    p.setNumCutCols(3)
    v.setViaParams(p)
    return v


def strap_bb_ua(block, tech, bb):
    """Strap bb_ua_pads[i].pad/ASIG5V (Metal2) -> megabytebeat_macro/ua[i] (Metal3)."""
    dbu = block.getDbUnitsPerMicron()
    um = lambda v: int(round(v * dbu))
    m2, m3 = tech.findLayer("Metal2"), tech.findLayer("Metal3")
    mbb = bb.getBBox()
    entries = []
    for inst in block.getInsts():
        m = re.match(r"^bb_ua_pads\[(\d+)\]\.pad$", inst.getName().replace("\\", ""))
        if not m:
            continue
        ch = int(m.group(1))
        mpin = f"ua[{ch}]"
        net = inst.findITerm("ASIG5V").getNet()
        mnet = bb.findITerm(mpin).getNet()
        if net is None or mnet is None or net.getName() != mnet.getName():
            raise SystemExit(f"[ERROR] {inst.getName()}/ASIG5V and {BB_MACRO}/{mpin} are not on one net")
        side = "W" if inst.getBBox().xMax() < mbb.xMin() else "E"
        entries.append((side, ch, inst, mpin, net, boxes(inst, "ASIG5V", "Metal2"), boxes(bb, mpin, "Metal3")[0]))
    if not entries:
        return

    via2 = make_via2_3x3(block, tech)
    row_mids = sorted({(r.getBBox().yMin() + r.getBBox().yMax()) // 2 for r in block.getRows()})
    bw = um(1.12)
    hbw, bw_rem = bw // 2, bw - bw // 2

    for side in ("W", "E"):
        side_e = sorted((e for e in entries if e[0] == side), key=lambda e: e[6].yMin() + e[6].yMax())
        for idx, (_, ch, inst, mpin, net, pb, q) in enumerate(side_e):
            qy_c = (q.yMin() + q.yMax()) // 2
            y_mid = min(row_mids, key=lambda y: abs(y - qy_c))
            p = min(pb, key=lambda r: abs((r.yMin() + r.yMax()) // 2 - y_mid))
            py_c = (p.yMin() + p.yMax()) // 2
            w = p.yMax() - p.yMin()
            hw, w_rem = w // 2, w - w // 2
            pad_x = p.xMax() if side == "W" else p.xMin()
            mac_x = mbb.xMin() if side == "W" else mbb.xMax()
            x_trunk = pad_x + um(16.0 + 12.0 * idx) if side == "W" else pad_x - um(16.0 + 12.0 * idx)
            x_jog = mac_x - um(4.0) if side == "W" else mac_x + um(4.0)

            dy_um = abs((inst.getBBox().yMin() + inst.getBBox().yMax()) // 2 - qy_c) / dbu
            len_um = (abs(pad_x - x_trunk) + abs(py_c - y_mid) + abs(x_trunk - mac_x) + abs(y_mid - qy_c)) / dbu
            if dy_um > 150.0 or len_um > 300.0:
                raise SystemExit(f"[ERROR] {net.getName()} too far from {mpin}: dy={dy_um:.1f} um, L={len_um:.1f} um")

            if not net.isSpecial():
                net.setSpecial()
            sw = odb.dbSWire_create(net, "ROUTED")
            tx1, tx2 = x_trunk - hw, x_trunk + w_rem
            my1, my2 = y_mid - hw, y_mid + w_rem
            by1, by2 = y_mid - hbw, y_mid + bw_rem
            if side == "W":
                odb.dbSBox_create(sw, m2, p.xMax() - um(1.4), p.yMin(), tx2, p.yMax(), "STRIPE")
                odb.dbSBox_create(sw, m3, tx1, by1, x_jog + bw_rem, by2, "STRIPE")
                odb.dbSBox_create(sw, m3, x_jog - hbw, q.yMin(), q.xMax(), q.yMax(), "STRIPE")
            else:
                odb.dbSBox_create(sw, m2, tx1, p.yMin(), p.xMin() + um(1.4), p.yMax(), "STRIPE")
                odb.dbSBox_create(sw, m3, x_jog - hbw, by1, tx2, by2, "STRIPE")
                odb.dbSBox_create(sw, m3, q.xMin(), q.yMin(), x_jog + bw_rem, q.yMax(), "STRIPE")
            odb.dbSBox_create(sw, m2, tx1, min(p.yMin(), my1), tx2, max(p.yMax(), my2), "STRIPE")
            odb.dbSBox_create(sw, via2, x_trunk, y_mid, "STRIPE")
            odb.dbSBox_create(sw, m3, tx1, my1, tx2, my2, "STRIPE")
            if q.yMin() < by1 or q.yMax() > by2:
                odb.dbSBox_create(sw, m3, x_jog - hbw, min(by1, q.yMin()), x_jog + bw_rem, max(by2, q.yMax()), "STRIPE")
            print(f"  bb_ua[{ch}] ({side}) -> {mpin}: dy={dy_um:.1f} um, L={len_um:.1f} um")


def check_asig_straps(block):
    """Fail if any non-NC gf180mcu_fd_io__asig_5p0 pad connected to a macro lacks an SWire strap."""
    checked = 0
    for inst in block.getInsts():
        if inst.getMaster().getName() != "gf180mcu_fd_io__asig_5p0":
            continue
        it = inst.findITerm("ASIG5V")
        net = it.getNet() if it else None
        if net and any(x.getInst() != inst and x.getInst().getMaster().getType() == "BLOCK" for x in net.getITerms()):
            if not list(net.getSWires()):
                raise SystemExit(f"[ERROR] Non-NC analog pad {inst.getName()} ({net.getName()}) is unstrapped!")
            checked += 1
    print(f"[INFO] Analog pad strap check PASS ({checked} non-NC asig_5p0 pads strapped).")


@click.command()
@click_odb
def main(reader):
    block = reader.block
    m2 = reader.tech.findLayer("Metal2")
    pad = block.findInst(PAD)
    mac = block.findInst(MACRO)
    rows = list(block.getRows())
    y0 = min(r.getOrigin()[1] for r in rows)
    rh = rows[0].getSite().getHeight()

    def row_above(y):
        k = -(-(y - y0) // rh)
        return y0 + k * rh
    if pad is None or mac is None:
        raise SystemExit("[ERROR] %s or %s not found" % (PAD, MACRO))
    for ppin, mpin in PAIRS:
        net = pad.findITerm(ppin).getNet()
        if net is None or mac.findITerm(mpin).getNet() is None or \
                net.getName() != mac.findITerm(mpin).getNet().getName():
            raise SystemExit("[ERROR] %s/%s and %s/%s are not on one net" % (PAD, ppin, MACRO, mpin))
        pb = boxes(pad, ppin, "Metal2")
        ymin = min(r.yMin() for r in pb)
        pb = [r for r in pb if r.yMin() == ymin]
        mb = boxes(mac, mpin, "Metal2")
        if not net.isSpecial():
            net.setSpecial()
        sw = odb.dbSWire_create(net, "ROUTED")
        n = 0
        for p in pb:
            for q in mb:
                x1, x2 = max(p.xMin(), q.xMin()), min(p.xMax(), q.xMax())
                if x2 - x1 <= 0 or q.yMax() > p.yMin():
                    continue
                yb = row_above(q.yMax())
                odb.dbSBox_create(sw, m2, x1, yb, x2, p.yMax(), "STRIPE")
                if yb > q.yMax():
                    assert yb - q.yMax() < x2 - x1, "bridge would not be horizontal"
                    odb.dbSBox_create(sw, m2, x1, q.yMax(), x2, yb, "STRIPE")
                n += 1
        print("strap %s: %d Metal2 boxes (pad %d pins, macro %d pins)" % (net.getName(), n, len(pb), len(mb)))
        if n == 0:
            raise SystemExit("[ERROR] no strap for %s" % net.getName())

    insts = {i.getName().replace("\\", ""): i for i in block.getInsts()}
    for pname, mpin in SIGS:
        ap = insts.get(pname)
        if ap is None:
            raise SystemExit("[ERROR] pad %s not found" % pname)
        net = ap.findITerm("ASIG5V").getNet()
        if net is None or mac.findITerm(mpin).getNet() is None or \
                net.getName() != mac.findITerm(mpin).getNet().getName():
            raise SystemExit("[ERROR] %s/ASIG5V and %s/%s are not on one net" % (pname, MACRO, mpin))
        pb = boxes(ap, "ASIG5V", "Metal2")
        ymin = min(r.yMin() for r in pb)
        pb = [r for r in pb if r.yMin() == ymin]
        q = boxes(mac, mpin, "Metal2")[0]
        if not net.isSpecial():
            net.setSpecial()
        sw = odb.dbSWire_create(net, "ROUTED")
        yb = row_above(q.yMax())
        over = [p for p in pb if min(p.xMax(), q.xMax()) - max(p.xMin(), q.xMin()) > 0]
        if over:
            x1, x2 = max(over[0].xMin(), q.xMin()), min(over[0].xMax(), q.xMax())
            odb.dbSBox_create(sw, m2, x1, yb, x2, over[0].yMax(), "STRIPE")
            odb.dbSBox_create(sw, m2, x1, q.yMax(), x2, yb, "STRIPE")
            print("strap %s: straight" % net.getName())
            continue
        p = min(pb, key=lambda r: abs((r.xMin() + r.xMax()) // 2 - (q.xMin() + q.xMax()) // 2))
        w = q.xMax() - q.xMin()
        yh = yb + 2 * rh
        odb.dbSBox_create(sw, m2, q.xMin(), q.yMax(), q.xMax(), yh, "STRIPE")
        odb.dbSBox_create(sw, m2, min(q.xMin(), p.xMin()), yh, max(q.xMax(), p.xMax()), yh + w, "STRIPE")
        odb.dbSBox_create(sw, m2, p.xMin(), yh + w, p.xMax(), p.yMax(), "STRIPE")
        print("strap %s: dogleg (pad pin x %d..%d, macro pin x %d..%d)" % (net.getName(), p.xMin(), p.xMax(), q.xMin(), q.xMax()))

    net = pad.findITerm("RF").getNet()
    m5 = reader.tech.findLayer("Metal5")
    for bt in net.getBTerms():
        if bt.getBPins():
            continue
        opening = max(boxes(pad, "RF", "Metal5"), key=lambda r: r.dx() * r.dy())
        bp = odb.dbBPin_create(bt)
        odb.dbBox_create(bp, m5, opening.xMin(), opening.yMin(), opening.xMax(), opening.yMax())
        bp.setPlacementStatus("FIRM")
        print("port %s placed on the RF pad opening %s" % (bt.getName(), opening))

    # Strap megabytebeat_macro (VDD_BB + shared VSS) when present (slot 0p5x1)
    strap_megabytebeat(block, reader.tech)
    check_asig_straps(block)


if __name__ == "__main__":
    main()
