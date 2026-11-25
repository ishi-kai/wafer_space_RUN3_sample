v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {GNSS AFE (GPS L1 C/A + Galileo E1) for GF180MCU - analog hard macro (SPI registers in the digital core)} 100 80 0 0 0.6 0.6 {}
T {bias + LO generation} 100 190 0 0 0.4 0.4 {layer=8}
T {RF (single-ended 50 ohm) -> noise-cancelling LNA -> I/Q mixers} 100 970 0 0 0.4 0.4 {layer=8}
T {2-bit ADCs (sampled at fLO/96 = 16.368 MHz), clock out, AFC DAC} 100 1490 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=RFIN}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=REFIN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=IG1A}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=IG1B}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=IG2A}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=IG2B}
C {devices/ipin.sym} -100 480 0 0 {name=p6 lab=IG3A}
C {devices/ipin.sym} -100 510 0 0 {name=p7 lab=IG3B}
C {devices/ipin.sym} -100 540 0 0 {name=p8 lab=B0}
C {devices/ipin.sym} -100 570 0 0 {name=p9 lab=B1}
C {devices/ipin.sym} -100 600 0 0 {name=p10 lab=AFC0}
C {devices/ipin.sym} -100 630 0 0 {name=p11 lab=AFC1}
C {devices/ipin.sym} -100 660 0 0 {name=p12 lab=AFC2}
C {devices/ipin.sym} -100 690 0 0 {name=p13 lab=AFC3}
C {devices/ipin.sym} -100 720 0 0 {name=p14 lab=AFC4}
C {devices/ipin.sym} -100 750 0 0 {name=p15 lab=AFC5}
C {devices/ipin.sym} -100 780 0 0 {name=p16 lab=AFC6}
C {devices/ipin.sym} -100 810 0 0 {name=p17 lab=AFC7}
C {devices/ipin.sym} -100 840 0 0 {name=p18 lab=ICP2}
C {devices/ipin.sym} -100 870 0 0 {name=p19 lab=BWK}
C {devices/ipin.sym} -100 900 0 0 {name=p20 lab=BWN}
C {devices/opin.sym} -100 930 0 0 {name=p21 lab=I_SIGN}
C {devices/opin.sym} -100 960 0 0 {name=p22 lab=I_MAG}
C {devices/opin.sym} -100 990 0 0 {name=p23 lab=Q_SIGN}
C {devices/opin.sym} -100 1020 0 0 {name=p24 lab=Q_MAG}
C {devices/opin.sym} -100 1050 0 0 {name=p25 lab=CLKOUT}
C {devices/opin.sym} -100 1080 0 0 {name=p26 lab=AFCOUT}
C {devices/opin.sym} -100 1110 0 0 {name=p27 lab=VCTRL}
C {devices/iopin.sym} -100 1140 0 0 {name=p28 lab=VDDV}
C {devices/iopin.sym} -100 1170 0 0 {name=p29 lab=VDD}
C {devices/iopin.sym} -100 1200 0 0 {name=p30 lab=VSS}
C {bias_gen.sym} 200 300 0 0 {name=XBIAS }
N 300 270 320 270 {lab=nb}
C {devices/lab_pin.sym} 320 270 0 1 {name=l1 sig_type=std_logic lab=nb}
N 300 290 320 290 {lab=pb}
C {devices/lab_pin.sym} 320 290 0 1 {name=l2 sig_type=std_logic lab=pb}
N 300 310 320 310 {lab=VDD}
C {devices/lab_pin.sym} 320 310 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 330 320 330 {lab=VSS}
C {devices/lab_pin.sym} 320 330 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {vmon_buf.sym} 620 300 0 0 {name=XMON }
N 520 280 500 280 {lab=vctrl}
C {devices/lab_pin.sym} 500 280 0 0 {name=l5 sig_type=std_logic lab=vctrl}
N 520 300 500 300 {lab=nb}
C {devices/lab_pin.sym} 500 300 0 0 {name=l6 sig_type=std_logic lab=nb}
N 720 280 740 280 {lab=vmon}
C {devices/lab_pin.sym} 740 280 0 1 {name=l7 sig_type=std_logic lab=vmon}
N 720 300 740 300 {lab=VDDV}
C {devices/lab_pin.sym} 740 300 0 1 {name=l8 sig_type=std_logic lab=VDDV}
N 720 320 740 320 {lab=VSS}
C {devices/lab_pin.sym} 740 320 0 1 {name=l9 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1040 300 0 0 {name=RMON W=1u L=10u model=ppolyf_u_1k spiceprefix=X m=1}
N 1040 330 1040 350 {lab=vmon}
C {devices/lab_pin.sym} 1040 350 0 0 {name=l10 sig_type=std_logic lab=vmon}
N 1040 270 1040 250 {lab=VCTRL}
C {devices/lab_pin.sym} 1040 250 0 0 {name=l11 sig_type=std_logic lab=VCTRL}
N 1020 300 1000 300 {lab=VSS}
C {devices/lab_pin.sym} 1000 300 0 0 {name=l12 sig_type=std_logic lab=VSS}
C {vco_ring4.sym} 200 560 0 0 {name=XVCO }
N 100 450 80 450 {lab=vctrl}
C {devices/lab_pin.sym} 80 450 0 0 {name=l13 sig_type=std_logic lab=vctrl}
N 100 470 80 470 {lab=B0}
C {devices/lab_pin.sym} 80 470 0 0 {name=l14 sig_type=std_logic lab=B0}
N 100 490 80 490 {lab=B1}
C {devices/lab_pin.sym} 80 490 0 0 {name=l15 sig_type=std_logic lab=B1}
N 100 510 80 510 {lab=nb}
C {devices/lab_pin.sym} 80 510 0 0 {name=l16 sig_type=std_logic lab=nb}
N 300 450 320 450 {lab=l1p}
C {devices/lab_pin.sym} 320 450 0 1 {name=l17 sig_type=std_logic lab=l1p}
N 300 470 320 470 {lab=l1n}
C {devices/lab_pin.sym} 320 470 0 1 {name=l18 sig_type=std_logic lab=l1n}
N 300 490 320 490 {lab=l2p}
C {devices/lab_pin.sym} 320 490 0 1 {name=l19 sig_type=std_logic lab=l2p}
N 300 510 320 510 {lab=l2n}
C {devices/lab_pin.sym} 320 510 0 1 {name=l20 sig_type=std_logic lab=l2n}
N 300 530 320 530 {lab=l3p}
C {devices/lab_pin.sym} 320 530 0 1 {name=l21 sig_type=std_logic lab=l3p}
N 300 550 320 550 {lab=l3n}
C {devices/lab_pin.sym} 320 550 0 1 {name=l22 sig_type=std_logic lab=l3n}
N 300 570 320 570 {lab=l4p}
C {devices/lab_pin.sym} 320 570 0 1 {name=l23 sig_type=std_logic lab=l4p}
N 300 590 320 590 {lab=l4n}
C {devices/lab_pin.sym} 320 590 0 1 {name=l24 sig_type=std_logic lab=l4n}
N 300 610 320 610 {lab=ckr}
C {devices/lab_pin.sym} 320 610 0 1 {name=l25 sig_type=std_logic lab=ckr}
N 300 630 320 630 {lab=vr}
C {devices/lab_pin.sym} 320 630 0 1 {name=l26 sig_type=std_logic lab=vr}
N 300 650 320 650 {lab=VDDV}
C {devices/lab_pin.sym} 320 650 0 1 {name=l27 sig_type=std_logic lab=VDDV}
N 300 670 320 670 {lab=VSS}
C {devices/lab_pin.sym} 320 670 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {refbuf.sym} 620 560 0 0 {name=XRB }
N 520 540 500 540 {lab=REFIN}
C {devices/lab_pin.sym} 500 540 0 0 {name=l29 sig_type=std_logic lab=REFIN}
N 720 540 740 540 {lab=refck}
C {devices/lab_pin.sym} 740 540 0 1 {name=l30 sig_type=std_logic lab=refck}
N 720 560 740 560 {lab=VDDV}
C {devices/lab_pin.sym} 740 560 0 1 {name=l31 sig_type=std_logic lab=VDDV}
N 720 580 740 580 {lab=VSS}
C {devices/lab_pin.sym} 740 580 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {decap_vco.sym} 1040 560 0 0 {name=XDECV }
N 1140 550 1160 550 {lab=VDDV}
C {devices/lab_pin.sym} 1160 550 0 1 {name=l33 sig_type=std_logic lab=VDDV}
N 1140 570 1160 570 {lab=VSS}
C {devices/lab_pin.sym} 1160 570 0 1 {name=l34 sig_type=std_logic lab=VSS}
C {pll_core.sym} 200 820 0 0 {name=XPLL }
N 100 770 80 770 {lab=refck}
C {devices/lab_pin.sym} 80 770 0 0 {name=l35 sig_type=std_logic lab=refck}
N 100 790 80 790 {lab=ckr}
C {devices/lab_pin.sym} 80 790 0 0 {name=l36 sig_type=std_logic lab=ckr}
N 100 810 80 810 {lab=nb}
C {devices/lab_pin.sym} 80 810 0 0 {name=l37 sig_type=std_logic lab=nb}
N 100 830 80 830 {lab=pb}
C {devices/lab_pin.sym} 80 830 0 0 {name=l38 sig_type=std_logic lab=pb}
N 100 850 80 850 {lab=ICP2}
C {devices/lab_pin.sym} 80 850 0 0 {name=l39 sig_type=std_logic lab=ICP2}
N 300 770 320 770 {lab=vctrl}
C {devices/lab_pin.sym} 320 770 0 1 {name=l40 sig_type=std_logic lab=vctrl}
N 300 790 320 790 {lab=fs}
C {devices/lab_pin.sym} 320 790 0 1 {name=l41 sig_type=std_logic lab=fs}
N 300 810 320 810 {lab=fb}
C {devices/lab_pin.sym} 320 810 0 1 {name=l42 sig_type=std_logic lab=fb}
N 300 830 320 830 {lab=refck_a}
C {devices/lab_pin.sym} 320 830 0 1 {name=l43 sig_type=std_logic lab=refck_a}
N 300 850 320 850 {lab=VDD}
C {devices/lab_pin.sym} 320 850 0 1 {name=l44 sig_type=std_logic lab=VDD}
N 300 870 320 870 {lab=VSS}
C {devices/lab_pin.sym} 320 870 0 1 {name=l45 sig_type=std_logic lab=VSS}
C {gm_master.sym} 620 820 0 0 {name=XGM }
N 520 780 500 780 {lab=refck_a}
C {devices/lab_pin.sym} 500 780 0 0 {name=l46 sig_type=std_logic lab=refck_a}
N 520 800 500 800 {lab=nb}
C {devices/lab_pin.sym} 500 800 0 0 {name=l47 sig_type=std_logic lab=nb}
N 520 820 500 820 {lab=pb}
C {devices/lab_pin.sym} 500 820 0 0 {name=l48 sig_type=std_logic lab=pb}
N 520 840 500 840 {lab=BWK}
C {devices/lab_pin.sym} 500 840 0 0 {name=l49 sig_type=std_logic lab=BWK}
N 520 860 500 860 {lab=BWN}
C {devices/lab_pin.sym} 500 860 0 0 {name=l50 sig_type=std_logic lab=BWN}
N 720 780 740 780 {lab=vtn}
C {devices/lab_pin.sym} 740 780 0 1 {name=l51 sig_type=std_logic lab=vtn}
N 720 800 740 800 {lab=VDD}
C {devices/lab_pin.sym} 740 800 0 1 {name=l52 sig_type=std_logic lab=VDD}
N 720 820 740 820 {lab=VSS}
C {devices/lab_pin.sym} 740 820 0 1 {name=l53 sig_type=std_logic lab=VSS}
C {lna_nc.sym} 200 1080 0 0 {name=XLNA }
N 100 1050 80 1050 {lab=RFIN}
C {devices/lab_pin.sym} 80 1050 0 0 {name=l54 sig_type=std_logic lab=RFIN}
N 100 1070 80 1070 {lab=pb}
C {devices/lab_pin.sym} 80 1070 0 0 {name=l55 sig_type=std_logic lab=pb}
N 300 1050 320 1050 {lab=rfp}
C {devices/lab_pin.sym} 320 1050 0 1 {name=l56 sig_type=std_logic lab=rfp}
N 300 1070 320 1070 {lab=rfn}
C {devices/lab_pin.sym} 320 1070 0 1 {name=l57 sig_type=std_logic lab=rfn}
N 300 1090 320 1090 {lab=VDD}
C {devices/lab_pin.sym} 320 1090 0 1 {name=l58 sig_type=std_logic lab=VDD}
N 300 1110 320 1110 {lab=VSS}
C {devices/lab_pin.sym} 320 1110 0 1 {name=l59 sig_type=std_logic lab=VSS}
C {mixer_iq.sym} 620 1080 0 0 {name=XMIX }
N 520 980 500 980 {lab=rfp}
C {devices/lab_pin.sym} 500 980 0 0 {name=l60 sig_type=std_logic lab=rfp}
N 520 1000 500 1000 {lab=rfn}
C {devices/lab_pin.sym} 500 1000 0 0 {name=l61 sig_type=std_logic lab=rfn}
N 520 1020 500 1020 {lab=l1p}
C {devices/lab_pin.sym} 500 1020 0 0 {name=l62 sig_type=std_logic lab=l1p}
N 520 1040 500 1040 {lab=l1n}
C {devices/lab_pin.sym} 500 1040 0 0 {name=l63 sig_type=std_logic lab=l1n}
N 520 1060 500 1060 {lab=l2p}
C {devices/lab_pin.sym} 500 1060 0 0 {name=l64 sig_type=std_logic lab=l2p}
N 520 1080 500 1080 {lab=l2n}
C {devices/lab_pin.sym} 500 1080 0 0 {name=l65 sig_type=std_logic lab=l2n}
N 520 1100 500 1100 {lab=l3p}
C {devices/lab_pin.sym} 500 1100 0 0 {name=l66 sig_type=std_logic lab=l3p}
N 520 1120 500 1120 {lab=l3n}
C {devices/lab_pin.sym} 500 1120 0 0 {name=l67 sig_type=std_logic lab=l3n}
N 520 1140 500 1140 {lab=l4p}
C {devices/lab_pin.sym} 500 1140 0 0 {name=l68 sig_type=std_logic lab=l4p}
N 520 1160 500 1160 {lab=l4n}
C {devices/lab_pin.sym} 500 1160 0 0 {name=l69 sig_type=std_logic lab=l4n}
N 520 1180 500 1180 {lab=nb}
C {devices/lab_pin.sym} 500 1180 0 0 {name=l70 sig_type=std_logic lab=nb}
N 720 980 740 980 {lab=mip}
C {devices/lab_pin.sym} 740 980 0 1 {name=l71 sig_type=std_logic lab=mip}
N 720 1000 740 1000 {lab=min}
C {devices/lab_pin.sym} 740 1000 0 1 {name=l72 sig_type=std_logic lab=min}
N 720 1020 740 1020 {lab=mqp}
C {devices/lab_pin.sym} 740 1020 0 1 {name=l73 sig_type=std_logic lab=mqp}
N 720 1040 740 1040 {lab=mqn}
C {devices/lab_pin.sym} 740 1040 0 1 {name=l74 sig_type=std_logic lab=mqn}
N 720 1060 740 1060 {lab=VDD}
C {devices/lab_pin.sym} 740 1060 0 1 {name=l75 sig_type=std_logic lab=VDD}
N 720 1080 740 1080 {lab=VSS}
C {devices/lab_pin.sym} 740 1080 0 1 {name=l76 sig_type=std_logic lab=VSS}
C {if_chain.sym} 1040 1080 0 0 {name=XIFI }
N 940 990 920 990 {lab=mip}
C {devices/lab_pin.sym} 920 990 0 0 {name=l77 sig_type=std_logic lab=mip}
N 940 1010 920 1010 {lab=min}
C {devices/lab_pin.sym} 920 1010 0 0 {name=l78 sig_type=std_logic lab=min}
N 940 1030 920 1030 {lab=IG1A}
C {devices/lab_pin.sym} 920 1030 0 0 {name=l79 sig_type=std_logic lab=IG1A}
N 940 1050 920 1050 {lab=IG1B}
C {devices/lab_pin.sym} 920 1050 0 0 {name=l80 sig_type=std_logic lab=IG1B}
N 940 1070 920 1070 {lab=IG2A}
C {devices/lab_pin.sym} 920 1070 0 0 {name=l81 sig_type=std_logic lab=IG2A}
N 940 1090 920 1090 {lab=IG2B}
C {devices/lab_pin.sym} 920 1090 0 0 {name=l82 sig_type=std_logic lab=IG2B}
N 940 1110 920 1110 {lab=IG3A}
C {devices/lab_pin.sym} 920 1110 0 0 {name=l83 sig_type=std_logic lab=IG3A}
N 940 1130 920 1130 {lab=IG3B}
C {devices/lab_pin.sym} 920 1130 0 0 {name=l84 sig_type=std_logic lab=IG3B}
N 940 1150 920 1150 {lab=nb}
C {devices/lab_pin.sym} 920 1150 0 0 {name=l85 sig_type=std_logic lab=nb}
N 940 1170 920 1170 {lab=vtn}
C {devices/lab_pin.sym} 920 1170 0 0 {name=l86 sig_type=std_logic lab=vtn}
N 1140 990 1160 990 {lab=aip}
C {devices/lab_pin.sym} 1160 990 0 1 {name=l87 sig_type=std_logic lab=aip}
N 1140 1010 1160 1010 {lab=ain}
C {devices/lab_pin.sym} 1160 1010 0 1 {name=l88 sig_type=std_logic lab=ain}
N 1140 1030 1160 1030 {lab=VDD}
C {devices/lab_pin.sym} 1160 1030 0 1 {name=l89 sig_type=std_logic lab=VDD}
N 1140 1050 1160 1050 {lab=VSS}
C {devices/lab_pin.sym} 1160 1050 0 1 {name=l90 sig_type=std_logic lab=VSS}
C {if_chain.sym} 200 1350 0 0 {name=XIFQ }
N 100 1260 80 1260 {lab=mqp}
C {devices/lab_pin.sym} 80 1260 0 0 {name=l91 sig_type=std_logic lab=mqp}
N 100 1280 80 1280 {lab=mqn}
C {devices/lab_pin.sym} 80 1280 0 0 {name=l92 sig_type=std_logic lab=mqn}
N 100 1300 80 1300 {lab=IG1A}
C {devices/lab_pin.sym} 80 1300 0 0 {name=l93 sig_type=std_logic lab=IG1A}
N 100 1320 80 1320 {lab=IG1B}
C {devices/lab_pin.sym} 80 1320 0 0 {name=l94 sig_type=std_logic lab=IG1B}
N 100 1340 80 1340 {lab=IG2A}
C {devices/lab_pin.sym} 80 1340 0 0 {name=l95 sig_type=std_logic lab=IG2A}
N 100 1360 80 1360 {lab=IG2B}
C {devices/lab_pin.sym} 80 1360 0 0 {name=l96 sig_type=std_logic lab=IG2B}
N 100 1380 80 1380 {lab=IG3A}
C {devices/lab_pin.sym} 80 1380 0 0 {name=l97 sig_type=std_logic lab=IG3A}
N 100 1400 80 1400 {lab=IG3B}
C {devices/lab_pin.sym} 80 1400 0 0 {name=l98 sig_type=std_logic lab=IG3B}
N 100 1420 80 1420 {lab=nb}
C {devices/lab_pin.sym} 80 1420 0 0 {name=l99 sig_type=std_logic lab=nb}
N 100 1440 80 1440 {lab=vtn}
C {devices/lab_pin.sym} 80 1440 0 0 {name=l100 sig_type=std_logic lab=vtn}
N 300 1260 320 1260 {lab=aqp}
C {devices/lab_pin.sym} 320 1260 0 1 {name=l101 sig_type=std_logic lab=aqp}
N 300 1280 320 1280 {lab=aqn}
C {devices/lab_pin.sym} 320 1280 0 1 {name=l102 sig_type=std_logic lab=aqn}
N 300 1300 320 1300 {lab=VDD}
C {devices/lab_pin.sym} 320 1300 0 1 {name=l103 sig_type=std_logic lab=VDD}
N 300 1320 320 1320 {lab=VSS}
C {devices/lab_pin.sym} 320 1320 0 1 {name=l104 sig_type=std_logic lab=VSS}
C {adc2b.sym} 200 1600 0 0 {name=XADI }
N 100 1570 80 1570 {lab=aip}
C {devices/lab_pin.sym} 80 1570 0 0 {name=l105 sig_type=std_logic lab=aip}
N 100 1590 80 1590 {lab=ain}
C {devices/lab_pin.sym} 80 1590 0 0 {name=l106 sig_type=std_logic lab=ain}
N 100 1610 80 1610 {lab=fs}
C {devices/lab_pin.sym} 80 1610 0 0 {name=l107 sig_type=std_logic lab=fs}
N 300 1570 320 1570 {lab=I_SIGN}
C {devices/lab_pin.sym} 320 1570 0 1 {name=l108 sig_type=std_logic lab=I_SIGN}
N 300 1590 320 1590 {lab=I_MAG}
C {devices/lab_pin.sym} 320 1590 0 1 {name=l109 sig_type=std_logic lab=I_MAG}
N 300 1610 320 1610 {lab=VDD}
C {devices/lab_pin.sym} 320 1610 0 1 {name=l110 sig_type=std_logic lab=VDD}
N 300 1630 320 1630 {lab=VSS}
C {devices/lab_pin.sym} 320 1630 0 1 {name=l111 sig_type=std_logic lab=VSS}
C {adc2b.sym} 620 1600 0 0 {name=XADQ }
N 520 1570 500 1570 {lab=aqp}
C {devices/lab_pin.sym} 500 1570 0 0 {name=l112 sig_type=std_logic lab=aqp}
N 520 1590 500 1590 {lab=aqn}
C {devices/lab_pin.sym} 500 1590 0 0 {name=l113 sig_type=std_logic lab=aqn}
N 520 1610 500 1610 {lab=fs}
C {devices/lab_pin.sym} 500 1610 0 0 {name=l114 sig_type=std_logic lab=fs}
N 720 1570 740 1570 {lab=Q_SIGN}
C {devices/lab_pin.sym} 740 1570 0 1 {name=l115 sig_type=std_logic lab=Q_SIGN}
N 720 1590 740 1590 {lab=Q_MAG}
C {devices/lab_pin.sym} 740 1590 0 1 {name=l116 sig_type=std_logic lab=Q_MAG}
N 720 1610 740 1610 {lab=VDD}
C {devices/lab_pin.sym} 740 1610 0 1 {name=l117 sig_type=std_logic lab=VDD}
N 720 1630 740 1630 {lab=VSS}
C {devices/lab_pin.sym} 740 1630 0 1 {name=l118 sig_type=std_logic lab=VSS}
C {inv_lo2.sym} 1040 1600 0 0 {name=XCKO1 }
N 940 1580 920 1580 {lab=fs}
C {devices/lab_pin.sym} 920 1580 0 0 {name=l119 sig_type=std_logic lab=fs}
N 1140 1580 1160 1580 {lab=fsb}
C {devices/lab_pin.sym} 1160 1580 0 1 {name=l120 sig_type=std_logic lab=fsb}
N 1140 1600 1160 1600 {lab=VDD}
C {devices/lab_pin.sym} 1160 1600 0 1 {name=l121 sig_type=std_logic lab=VDD}
N 1140 1620 1160 1620 {lab=VSS}
C {devices/lab_pin.sym} 1160 1620 0 1 {name=l122 sig_type=std_logic lab=VSS}
C {inv_lo2.sym} 200 1860 0 0 {name=XCKO2 }
N 100 1840 80 1840 {lab=fsb}
C {devices/lab_pin.sym} 80 1840 0 0 {name=l123 sig_type=std_logic lab=fsb}
N 300 1840 320 1840 {lab=CLKOUT}
C {devices/lab_pin.sym} 320 1840 0 1 {name=l124 sig_type=std_logic lab=CLKOUT}
N 300 1860 320 1860 {lab=VDD}
C {devices/lab_pin.sym} 320 1860 0 1 {name=l125 sig_type=std_logic lab=VDD}
N 300 1880 320 1880 {lab=VSS}
C {devices/lab_pin.sym} 320 1880 0 1 {name=l126 sig_type=std_logic lab=VSS}
C {afc_dac.sym} 620 1860 0 0 {name=XAFC }
N 520 1790 500 1790 {lab=AFC0}
C {devices/lab_pin.sym} 500 1790 0 0 {name=l127 sig_type=std_logic lab=AFC0}
N 520 1810 500 1810 {lab=AFC1}
C {devices/lab_pin.sym} 500 1810 0 0 {name=l128 sig_type=std_logic lab=AFC1}
N 520 1830 500 1830 {lab=AFC2}
C {devices/lab_pin.sym} 500 1830 0 0 {name=l129 sig_type=std_logic lab=AFC2}
N 520 1850 500 1850 {lab=AFC3}
C {devices/lab_pin.sym} 500 1850 0 0 {name=l130 sig_type=std_logic lab=AFC3}
N 520 1870 500 1870 {lab=AFC4}
C {devices/lab_pin.sym} 500 1870 0 0 {name=l131 sig_type=std_logic lab=AFC4}
N 520 1890 500 1890 {lab=AFC5}
C {devices/lab_pin.sym} 500 1890 0 0 {name=l132 sig_type=std_logic lab=AFC5}
N 520 1910 500 1910 {lab=AFC6}
C {devices/lab_pin.sym} 500 1910 0 0 {name=l133 sig_type=std_logic lab=AFC6}
N 520 1930 500 1930 {lab=AFC7}
C {devices/lab_pin.sym} 500 1930 0 0 {name=l134 sig_type=std_logic lab=AFC7}
N 720 1790 740 1790 {lab=AFCOUT}
C {devices/lab_pin.sym} 740 1790 0 1 {name=l135 sig_type=std_logic lab=AFCOUT}
N 720 1810 740 1810 {lab=VDD}
C {devices/lab_pin.sym} 740 1810 0 1 {name=l136 sig_type=std_logic lab=VDD}
N 720 1830 740 1830 {lab=VSS}
C {devices/lab_pin.sym} 740 1830 0 1 {name=l137 sig_type=std_logic lab=VSS}
C {decap.sym} 1040 1860 0 0 {name=XDEC }
N 1140 1850 1160 1850 {lab=VDD}
C {devices/lab_pin.sym} 1160 1850 0 1 {name=l138 sig_type=std_logic lab=VDD}
N 1140 1870 1160 1870 {lab=VSS}
C {devices/lab_pin.sym} 1160 1870 0 1 {name=l139 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 2560 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
