v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Crystal-locked SC master tuning loop (locks Gm = 4*fREF*Cref, resistor-free)} 100 80 0 0 0.6 0.6 {}
T {non-overlapping 2-phase clock generator (from 16.368 MHz REFCK)} 100 190 0 0 0.4 0.4 {layer=8}
T {small-signal bias I0 ~ 1.56 uA (1:32 MOS ratio from NB, zero resistors) + Vcm replica} 100 790 0 0 0.4 0.4 {layer=8}
T {Branch 1: diode-connected replica gm_unit driven by 4*I0} 100 1190 0 0 0.4 0.4 {layer=8}
T {Branch 2: SC resistor (C_ref = 3.2 + 0.8*~BWN + 0.8*~BWK pF) driven by I0} 100 1390 0 0 0.4 0.4 {layer=8}
T {PMOS-input differential-difference error OTA (12.5 uA tail from PB) -> VTN} 100 2990 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=REFCK}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=NB}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=PB}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=BWK}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=BWN}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=VTN}
C {devices/iopin.sym} -100 480 0 0 {name=p6 lab=VDD}
C {devices/iopin.sym} -100 510 0 0 {name=p7 lab=VSS}
C {inv_dig.sym} 200 300 0 0 {name=XC0 }
N 100 280 80 280 {lab=REFCK}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=REFCK}
N 300 280 320 280 {lab=ckb}
C {devices/lab_pin.sym} 320 280 0 1 {name=l2 sig_type=std_logic lab=ckb}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {nor2.sym} 520 300 0 0 {name=XNA }
N 420 280 400 280 {lab=REFCK}
C {devices/lab_pin.sym} 400 280 0 0 {name=l5 sig_type=std_logic lab=REFCK}
N 420 300 400 300 {lab=p2b}
C {devices/lab_pin.sym} 400 300 0 0 {name=l6 sig_type=std_logic lab=p2b}
N 620 280 640 280 {lab=a1}
C {devices/lab_pin.sym} 640 280 0 1 {name=l7 sig_type=std_logic lab=a1}
N 620 300 640 300 {lab=VDD}
C {devices/lab_pin.sym} 640 300 0 1 {name=l8 sig_type=std_logic lab=VDD}
N 620 320 640 320 {lab=VSS}
C {devices/lab_pin.sym} 640 320 0 1 {name=l9 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 840 300 0 0 {name=XA1 }
N 740 280 720 280 {lab=a1}
C {devices/lab_pin.sym} 720 280 0 0 {name=l10 sig_type=std_logic lab=a1}
N 940 280 960 280 {lab=a2}
C {devices/lab_pin.sym} 960 280 0 1 {name=l11 sig_type=std_logic lab=a2}
N 940 300 960 300 {lab=VDD}
C {devices/lab_pin.sym} 960 300 0 1 {name=l12 sig_type=std_logic lab=VDD}
N 940 320 960 320 {lab=VSS}
C {devices/lab_pin.sym} 960 320 0 1 {name=l13 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1160 300 0 0 {name=XA2 }
N 1060 280 1040 280 {lab=a2}
C {devices/lab_pin.sym} 1040 280 0 0 {name=l14 sig_type=std_logic lab=a2}
N 1260 280 1280 280 {lab=p1b}
C {devices/lab_pin.sym} 1280 280 0 1 {name=l15 sig_type=std_logic lab=p1b}
N 1260 300 1280 300 {lab=VDD}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l16 sig_type=std_logic lab=VDD}
N 1260 320 1280 320 {lab=VSS}
C {devices/lab_pin.sym} 1280 320 0 1 {name=l17 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 500 0 0 {name=XA3 }
N 100 480 80 480 {lab=p1b}
C {devices/lab_pin.sym} 80 480 0 0 {name=l18 sig_type=std_logic lab=p1b}
N 300 480 320 480 {lab=p1}
C {devices/lab_pin.sym} 320 480 0 1 {name=l19 sig_type=std_logic lab=p1}
N 300 500 320 500 {lab=VDD}
C {devices/lab_pin.sym} 320 500 0 1 {name=l20 sig_type=std_logic lab=VDD}
N 300 520 320 520 {lab=VSS}
C {devices/lab_pin.sym} 320 520 0 1 {name=l21 sig_type=std_logic lab=VSS}
C {nor2.sym} 520 500 0 0 {name=XNB }
N 420 480 400 480 {lab=ckb}
C {devices/lab_pin.sym} 400 480 0 0 {name=l22 sig_type=std_logic lab=ckb}
N 420 500 400 500 {lab=p1b}
C {devices/lab_pin.sym} 400 500 0 0 {name=l23 sig_type=std_logic lab=p1b}
N 620 480 640 480 {lab=b1}
C {devices/lab_pin.sym} 640 480 0 1 {name=l24 sig_type=std_logic lab=b1}
N 620 500 640 500 {lab=VDD}
C {devices/lab_pin.sym} 640 500 0 1 {name=l25 sig_type=std_logic lab=VDD}
N 620 520 640 520 {lab=VSS}
C {devices/lab_pin.sym} 640 520 0 1 {name=l26 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 840 500 0 0 {name=XB1 }
N 740 480 720 480 {lab=b1}
C {devices/lab_pin.sym} 720 480 0 0 {name=l27 sig_type=std_logic lab=b1}
N 940 480 960 480 {lab=b2}
C {devices/lab_pin.sym} 960 480 0 1 {name=l28 sig_type=std_logic lab=b2}
N 940 500 960 500 {lab=VDD}
C {devices/lab_pin.sym} 960 500 0 1 {name=l29 sig_type=std_logic lab=VDD}
N 940 520 960 520 {lab=VSS}
C {devices/lab_pin.sym} 960 520 0 1 {name=l30 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1160 500 0 0 {name=XB2 }
N 1060 480 1040 480 {lab=b2}
C {devices/lab_pin.sym} 1040 480 0 0 {name=l31 sig_type=std_logic lab=b2}
N 1260 480 1280 480 {lab=p2b}
C {devices/lab_pin.sym} 1280 480 0 1 {name=l32 sig_type=std_logic lab=p2b}
N 1260 500 1280 500 {lab=VDD}
C {devices/lab_pin.sym} 1280 500 0 1 {name=l33 sig_type=std_logic lab=VDD}
N 1260 520 1280 520 {lab=VSS}
C {devices/lab_pin.sym} 1280 520 0 1 {name=l34 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 700 0 0 {name=XB3 }
N 100 680 80 680 {lab=p2b}
C {devices/lab_pin.sym} 80 680 0 0 {name=l35 sig_type=std_logic lab=p2b}
N 300 680 320 680 {lab=p2}
C {devices/lab_pin.sym} 320 680 0 1 {name=l36 sig_type=std_logic lab=p2}
N 300 700 320 700 {lab=VDD}
C {devices/lab_pin.sym} 320 700 0 1 {name=l37 sig_type=std_logic lab=VDD}
N 300 720 320 720 {lab=VSS}
C {devices/lab_pin.sym} 320 720 0 1 {name=l38 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 900 0 0 {name=MNB0 L=4u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 870 220 850 {lab=pb0}
C {devices/lab_pin.sym} 220 850 0 0 {name=l39 sig_type=std_logic lab=pb0}
N 180 900 160 900 {lab=NB}
C {devices/lab_pin.sym} 160 900 0 0 {name=l40 sig_type=std_logic lab=NB}
N 220 930 220 950 {lab=VSS}
C {devices/lab_pin.sym} 220 950 0 0 {name=l41 sig_type=std_logic lab=VSS}
N 220 900 240 900 {lab=VSS}
C {devices/lab_pin.sym} 240 900 0 1 {name=l42 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 520 900 0 0 {name=MPB0 L=2u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 540 930 540 950 {lab=pb0}
C {devices/lab_pin.sym} 540 950 0 0 {name=l43 sig_type=std_logic lab=pb0}
N 500 900 480 900 {lab=pb0}
C {devices/lab_pin.sym} 480 900 0 0 {name=l44 sig_type=std_logic lab=pb0}
N 540 870 540 850 {lab=VDD}
C {devices/lab_pin.sym} 540 850 0 0 {name=l45 sig_type=std_logic lab=VDD}
N 540 900 560 900 {lab=VDD}
C {devices/lab_pin.sym} 560 900 0 1 {name=l46 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 840 900 0 0 {name=MPB1 L=2u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 860 930 860 950 {lab=nb0}
C {devices/lab_pin.sym} 860 950 0 0 {name=l47 sig_type=std_logic lab=nb0}
N 820 900 800 900 {lab=pb0}
C {devices/lab_pin.sym} 800 900 0 0 {name=l48 sig_type=std_logic lab=pb0}
N 860 870 860 850 {lab=VDD}
C {devices/lab_pin.sym} 860 850 0 0 {name=l49 sig_type=std_logic lab=VDD}
N 860 900 880 900 {lab=VDD}
C {devices/lab_pin.sym} 880 900 0 1 {name=l50 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 1160 900 0 0 {name=MND0 L=2u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1180 870 1180 850 {lab=nb0}
C {devices/lab_pin.sym} 1180 850 0 0 {name=l51 sig_type=std_logic lab=nb0}
N 1140 900 1120 900 {lab=nb0}
C {devices/lab_pin.sym} 1120 900 0 0 {name=l52 sig_type=std_logic lab=nb0}
N 1180 930 1180 950 {lab=VSS}
C {devices/lab_pin.sym} 1180 950 0 0 {name=l53 sig_type=std_logic lab=VSS}
N 1180 900 1200 900 {lab=VSS}
C {devices/lab_pin.sym} 1200 900 0 1 {name=l54 sig_type=std_logic lab=VSS}
C {gm_unit.sym} 200 1100 0 0 {name=XGMCM }
N 100 1070 80 1070 {lab=vcm}
C {devices/lab_pin.sym} 80 1070 0 0 {name=l55 sig_type=std_logic lab=vcm}
N 100 1090 80 1090 {lab=vcm}
C {devices/lab_pin.sym} 80 1090 0 0 {name=l56 sig_type=std_logic lab=vcm}
N 300 1070 320 1070 {lab=vcm}
C {devices/lab_pin.sym} 320 1070 0 1 {name=l57 sig_type=std_logic lab=vcm}
N 300 1090 320 1090 {lab=vcm}
C {devices/lab_pin.sym} 320 1090 0 1 {name=l58 sig_type=std_logic lab=vcm}
N 100 1110 80 1110 {lab=VTN}
C {devices/lab_pin.sym} 80 1110 0 0 {name=l59 sig_type=std_logic lab=VTN}
N 300 1110 320 1110 {lab=VDD}
C {devices/lab_pin.sym} 320 1110 0 1 {name=l60 sig_type=std_logic lab=VDD}
N 300 1130 320 1130 {lab=VSS}
C {devices/lab_pin.sym} 320 1130 0 1 {name=l61 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 520 1100 0 0 {name=CCM W=30e-6 L=30e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 520 1070 520 1050 {lab=vcm}
C {devices/lab_pin.sym} 520 1050 0 0 {name=l62 sig_type=std_logic lab=vcm}
N 520 1130 520 1150 {lab=VSS}
C {devices/lab_pin.sym} 520 1150 0 0 {name=l63 sig_type=std_logic lab=VSS}
C {gm_unit.sym} 200 1300 0 0 {name=XGMREP }
N 100 1270 80 1270 {lab=gn}
C {devices/lab_pin.sym} 80 1270 0 0 {name=l64 sig_type=std_logic lab=gn}
N 100 1290 80 1290 {lab=gp}
C {devices/lab_pin.sym} 80 1290 0 0 {name=l65 sig_type=std_logic lab=gp}
N 300 1270 320 1270 {lab=gp}
C {devices/lab_pin.sym} 320 1270 0 1 {name=l66 sig_type=std_logic lab=gp}
N 300 1290 320 1290 {lab=gn}
C {devices/lab_pin.sym} 320 1290 0 1 {name=l67 sig_type=std_logic lab=gn}
N 100 1310 80 1310 {lab=VTN}
C {devices/lab_pin.sym} 80 1310 0 0 {name=l68 sig_type=std_logic lab=VTN}
N 300 1310 320 1310 {lab=VDD}
C {devices/lab_pin.sym} 320 1310 0 1 {name=l69 sig_type=std_logic lab=VDD}
N 300 1330 320 1330 {lab=VSS}
C {devices/lab_pin.sym} 320 1330 0 1 {name=l70 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 520 1300 0 0 {name=MPGM L=2u W=16u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 540 1330 540 1350 {lab=gp}
C {devices/lab_pin.sym} 540 1350 0 0 {name=l71 sig_type=std_logic lab=gp}
N 500 1300 480 1300 {lab=pb0}
C {devices/lab_pin.sym} 480 1300 0 0 {name=l72 sig_type=std_logic lab=pb0}
N 540 1270 540 1250 {lab=VDD}
C {devices/lab_pin.sym} 540 1250 0 0 {name=l73 sig_type=std_logic lab=VDD}
N 540 1300 560 1300 {lab=VDD}
C {devices/lab_pin.sym} 560 1300 0 1 {name=l74 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 840 1300 0 0 {name=MNGM L=2u W=8u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 860 1270 860 1250 {lab=gn}
C {devices/lab_pin.sym} 860 1250 0 0 {name=l75 sig_type=std_logic lab=gn}
N 820 1300 800 1300 {lab=nb0}
C {devices/lab_pin.sym} 800 1300 0 0 {name=l76 sig_type=std_logic lab=nb0}
N 860 1330 860 1350 {lab=VSS}
C {devices/lab_pin.sym} 860 1350 0 0 {name=l77 sig_type=std_logic lab=VSS}
N 860 1300 880 1300 {lab=VSS}
C {devices/lab_pin.sym} 880 1300 0 1 {name=l78 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1500 0 0 {name=MATX L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1470 220 1450 {lab=atx}
C {devices/lab_pin.sym} 220 1450 0 0 {name=l79 sig_type=std_logic lab=atx}
N 180 1500 160 1500 {lab=atx}
C {devices/lab_pin.sym} 160 1500 0 0 {name=l80 sig_type=std_logic lab=atx}
N 220 1530 220 1550 {lab=VSS}
C {devices/lab_pin.sym} 220 1550 0 0 {name=l81 sig_type=std_logic lab=VSS}
N 220 1500 240 1500 {lab=VSS}
C {devices/lab_pin.sym} 240 1500 0 1 {name=l82 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 520 1500 0 0 {name=MATHI L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 540 1530 540 1550 {lab=athi}
C {devices/lab_pin.sym} 540 1550 0 0 {name=l83 sig_type=std_logic lab=athi}
N 500 1500 480 1500 {lab=atx}
C {devices/lab_pin.sym} 480 1500 0 0 {name=l84 sig_type=std_logic lab=atx}
N 540 1470 540 1450 {lab=VDD}
C {devices/lab_pin.sym} 540 1450 0 0 {name=l85 sig_type=std_logic lab=VDD}
N 540 1500 560 1500 {lab=VDD}
C {devices/lab_pin.sym} 560 1500 0 1 {name=l86 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 840 1500 0 0 {name=MATLO L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 860 1470 860 1450 {lab=atlo}
C {devices/lab_pin.sym} 860 1450 0 0 {name=l87 sig_type=std_logic lab=atlo}
N 820 1500 800 1500 {lab=athi}
C {devices/lab_pin.sym} 800 1500 0 0 {name=l88 sig_type=std_logic lab=athi}
N 860 1530 860 1550 {lab=VSS}
C {devices/lab_pin.sym} 860 1550 0 0 {name=l89 sig_type=std_logic lab=VSS}
N 860 1500 880 1500 {lab=VSS}
C {devices/lab_pin.sym} 880 1500 0 1 {name=l90 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1160 1500 0 0 {name=MABWK L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1180 1470 1180 1450 {lab=BWK}
C {devices/lab_pin.sym} 1180 1450 0 0 {name=l91 sig_type=std_logic lab=BWK}
N 1140 1500 1120 1500 {lab=atlo}
C {devices/lab_pin.sym} 1120 1500 0 0 {name=l92 sig_type=std_logic lab=atlo}
N 1180 1530 1180 1550 {lab=VSS}
C {devices/lab_pin.sym} 1180 1550 0 0 {name=l93 sig_type=std_logic lab=VSS}
N 1180 1500 1200 1500 {lab=VSS}
C {devices/lab_pin.sym} 1200 1500 0 1 {name=l94 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1700 0 0 {name=MABWN L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1670 220 1650 {lab=BWN}
C {devices/lab_pin.sym} 220 1650 0 0 {name=l95 sig_type=std_logic lab=BWN}
N 180 1700 160 1700 {lab=atlo}
C {devices/lab_pin.sym} 160 1700 0 0 {name=l96 sig_type=std_logic lab=atlo}
N 220 1730 220 1750 {lab=VSS}
C {devices/lab_pin.sym} 220 1750 0 0 {name=l97 sig_type=std_logic lab=VSS}
N 220 1700 240 1700 {lab=VSS}
C {devices/lab_pin.sym} 240 1700 0 1 {name=l98 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 520 1700 0 0 {name=XIBWK }
N 420 1680 400 1680 {lab=BWK}
C {devices/lab_pin.sym} 400 1680 0 0 {name=l99 sig_type=std_logic lab=BWK}
N 620 1680 640 1680 {lab=bww}
C {devices/lab_pin.sym} 640 1680 0 1 {name=l100 sig_type=std_logic lab=bww}
N 620 1700 640 1700 {lab=VDD}
C {devices/lab_pin.sym} 640 1700 0 1 {name=l101 sig_type=std_logic lab=VDD}
N 620 1720 640 1720 {lab=VSS}
C {devices/lab_pin.sym} 640 1720 0 1 {name=l102 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 840 1700 0 0 {name=XIBWN }
N 740 1680 720 1680 {lab=BWN}
C {devices/lab_pin.sym} 720 1680 0 0 {name=l103 sig_type=std_logic lab=BWN}
N 940 1680 960 1680 {lab=bwnb}
C {devices/lab_pin.sym} 960 1680 0 1 {name=l104 sig_type=std_logic lab=bwnb}
N 940 1700 960 1700 {lab=VDD}
C {devices/lab_pin.sym} 960 1700 0 1 {name=l105 sig_type=std_logic lab=VDD}
N 940 1720 960 1720 {lab=VSS}
C {devices/lab_pin.sym} 960 1720 0 1 {name=l106 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1160 1700 0 0 {name=MPSC L=2u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1180 1730 1180 1750 {lab=sp}
C {devices/lab_pin.sym} 1180 1750 0 0 {name=l107 sig_type=std_logic lab=sp}
N 1140 1700 1120 1700 {lab=pb0}
C {devices/lab_pin.sym} 1120 1700 0 0 {name=l108 sig_type=std_logic lab=pb0}
N 1180 1670 1180 1650 {lab=VDD}
C {devices/lab_pin.sym} 1180 1650 0 0 {name=l109 sig_type=std_logic lab=VDD}
N 1180 1700 1200 1700 {lab=VDD}
C {devices/lab_pin.sym} 1200 1700 0 1 {name=l110 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1900 0 0 {name=MNSC L=2u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1870 220 1850 {lab=sn}
C {devices/lab_pin.sym} 220 1850 0 0 {name=l111 sig_type=std_logic lab=sn}
N 180 1900 160 1900 {lab=nb0}
C {devices/lab_pin.sym} 160 1900 0 0 {name=l112 sig_type=std_logic lab=nb0}
N 220 1930 220 1950 {lab=VSS}
C {devices/lab_pin.sym} 220 1950 0 0 {name=l113 sig_type=std_logic lab=VSS}
N 220 1900 240 1900 {lab=VSS}
C {devices/lab_pin.sym} 240 1900 0 1 {name=l114 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 520 1900 0 0 {name=CSP W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 520 1870 520 1850 {lab=sp}
C {devices/lab_pin.sym} 520 1850 0 0 {name=l115 sig_type=std_logic lab=sp}
N 520 1930 520 1950 {lab=vcm}
C {devices/lab_pin.sym} 520 1950 0 0 {name=l116 sig_type=std_logic lab=vcm}
C {symbols/cap_mim_2f0fF.sym} 840 1900 0 0 {name=CSN W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 840 1870 840 1850 {lab=sn}
C {devices/lab_pin.sym} 840 1850 0 0 {name=l117 sig_type=std_logic lab=sn}
N 840 1930 840 1950 {lab=vcm}
C {devices/lab_pin.sym} 840 1950 0 0 {name=l118 sig_type=std_logic lab=vcm}
C {symbols/nfet_03v3.sym} 1160 1900 0 0 {name=SW1PN L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1180 1870 1180 1850 {lab=sp}
C {devices/lab_pin.sym} 1180 1850 0 0 {name=l119 sig_type=std_logic lab=sp}
N 1140 1900 1120 1900 {lab=p1}
C {devices/lab_pin.sym} 1120 1900 0 0 {name=l120 sig_type=std_logic lab=p1}
N 1180 1930 1180 1950 {lab=cp1}
C {devices/lab_pin.sym} 1180 1950 0 0 {name=l121 sig_type=std_logic lab=cp1}
N 1180 1900 1200 1900 {lab=VSS}
C {devices/lab_pin.sym} 1200 1900 0 1 {name=l122 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 2100 0 0 {name=SW1PP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 2130 220 2150 {lab=sp}
C {devices/lab_pin.sym} 220 2150 0 0 {name=l123 sig_type=std_logic lab=sp}
N 180 2100 160 2100 {lab=p1b}
C {devices/lab_pin.sym} 160 2100 0 0 {name=l124 sig_type=std_logic lab=p1b}
N 220 2070 220 2050 {lab=cp1}
C {devices/lab_pin.sym} 220 2050 0 0 {name=l125 sig_type=std_logic lab=cp1}
N 220 2100 240 2100 {lab=VDD}
C {devices/lab_pin.sym} 240 2100 0 1 {name=l126 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 520 2100 0 0 {name=SW2PN L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 540 2070 540 2050 {lab=cp1}
C {devices/lab_pin.sym} 540 2050 0 0 {name=l127 sig_type=std_logic lab=cp1}
N 500 2100 480 2100 {lab=p2}
C {devices/lab_pin.sym} 480 2100 0 0 {name=l128 sig_type=std_logic lab=p2}
N 540 2130 540 2150 {lab=vcm}
C {devices/lab_pin.sym} 540 2150 0 0 {name=l129 sig_type=std_logic lab=vcm}
N 540 2100 560 2100 {lab=VSS}
C {devices/lab_pin.sym} 560 2100 0 1 {name=l130 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 840 2100 0 0 {name=SW2PP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 860 2130 860 2150 {lab=cp1}
C {devices/lab_pin.sym} 860 2150 0 0 {name=l131 sig_type=std_logic lab=cp1}
N 820 2100 800 2100 {lab=p2b}
C {devices/lab_pin.sym} 800 2100 0 0 {name=l132 sig_type=std_logic lab=p2b}
N 860 2070 860 2050 {lab=vcm}
C {devices/lab_pin.sym} 860 2050 0 0 {name=l133 sig_type=std_logic lab=vcm}
N 860 2100 880 2100 {lab=VDD}
C {devices/lab_pin.sym} 880 2100 0 1 {name=l134 sig_type=std_logic lab=VDD}
C {symbols/cap_mim_2f0fF.sym} 1160 2100 0 0 {name=CREFP W=40e-6 L=40e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1160 2070 1160 2050 {lab=cp1}
C {devices/lab_pin.sym} 1160 2050 0 0 {name=l135 sig_type=std_logic lab=cp1}
N 1160 2130 1160 2150 {lab=VSS}
C {devices/lab_pin.sym} 1160 2150 0 0 {name=l136 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 2300 0 0 {name=CRNP W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 2270 200 2250 {lab=cp1}
C {devices/lab_pin.sym} 200 2250 0 0 {name=l137 sig_type=std_logic lab=cp1}
N 200 2330 200 2350 {lab=cnp}
C {devices/lab_pin.sym} 200 2350 0 0 {name=l138 sig_type=std_logic lab=cnp}
C {symbols/nfet_03v3.sym} 520 2300 0 0 {name=MSNP L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 540 2270 540 2250 {lab=cnp}
C {devices/lab_pin.sym} 540 2250 0 0 {name=l139 sig_type=std_logic lab=cnp}
N 500 2300 480 2300 {lab=bwnb}
C {devices/lab_pin.sym} 480 2300 0 0 {name=l140 sig_type=std_logic lab=bwnb}
N 540 2330 540 2350 {lab=VSS}
C {devices/lab_pin.sym} 540 2350 0 0 {name=l141 sig_type=std_logic lab=VSS}
N 540 2300 560 2300 {lab=VSS}
C {devices/lab_pin.sym} 560 2300 0 1 {name=l142 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 840 2300 0 0 {name=CRWP W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 840 2270 840 2250 {lab=cp1}
C {devices/lab_pin.sym} 840 2250 0 0 {name=l143 sig_type=std_logic lab=cp1}
N 840 2330 840 2350 {lab=cwp}
C {devices/lab_pin.sym} 840 2350 0 0 {name=l144 sig_type=std_logic lab=cwp}
C {symbols/nfet_03v3.sym} 1160 2300 0 0 {name=MSWP L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1180 2270 1180 2250 {lab=cwp}
C {devices/lab_pin.sym} 1180 2250 0 0 {name=l145 sig_type=std_logic lab=cwp}
N 1140 2300 1120 2300 {lab=bww}
C {devices/lab_pin.sym} 1120 2300 0 0 {name=l146 sig_type=std_logic lab=bww}
N 1180 2330 1180 2350 {lab=VSS}
C {devices/lab_pin.sym} 1180 2350 0 0 {name=l147 sig_type=std_logic lab=VSS}
N 1180 2300 1200 2300 {lab=VSS}
C {devices/lab_pin.sym} 1200 2300 0 1 {name=l148 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 2500 0 0 {name=SW1NN L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2470 220 2450 {lab=sn}
C {devices/lab_pin.sym} 220 2450 0 0 {name=l149 sig_type=std_logic lab=sn}
N 180 2500 160 2500 {lab=p1}
C {devices/lab_pin.sym} 160 2500 0 0 {name=l150 sig_type=std_logic lab=p1}
N 220 2530 220 2550 {lab=cn1}
C {devices/lab_pin.sym} 220 2550 0 0 {name=l151 sig_type=std_logic lab=cn1}
N 220 2500 240 2500 {lab=VSS}
C {devices/lab_pin.sym} 240 2500 0 1 {name=l152 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 520 2500 0 0 {name=SW1NP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 540 2530 540 2550 {lab=sn}
C {devices/lab_pin.sym} 540 2550 0 0 {name=l153 sig_type=std_logic lab=sn}
N 500 2500 480 2500 {lab=p1b}
C {devices/lab_pin.sym} 480 2500 0 0 {name=l154 sig_type=std_logic lab=p1b}
N 540 2470 540 2450 {lab=cn1}
C {devices/lab_pin.sym} 540 2450 0 0 {name=l155 sig_type=std_logic lab=cn1}
N 540 2500 560 2500 {lab=VDD}
C {devices/lab_pin.sym} 560 2500 0 1 {name=l156 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 840 2500 0 0 {name=SW2NN L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 860 2470 860 2450 {lab=cn1}
C {devices/lab_pin.sym} 860 2450 0 0 {name=l157 sig_type=std_logic lab=cn1}
N 820 2500 800 2500 {lab=p2}
C {devices/lab_pin.sym} 800 2500 0 0 {name=l158 sig_type=std_logic lab=p2}
N 860 2530 860 2550 {lab=vcm}
C {devices/lab_pin.sym} 860 2550 0 0 {name=l159 sig_type=std_logic lab=vcm}
N 860 2500 880 2500 {lab=VSS}
C {devices/lab_pin.sym} 880 2500 0 1 {name=l160 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1160 2500 0 0 {name=SW2NP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1180 2530 1180 2550 {lab=cn1}
C {devices/lab_pin.sym} 1180 2550 0 0 {name=l161 sig_type=std_logic lab=cn1}
N 1140 2500 1120 2500 {lab=p2b}
C {devices/lab_pin.sym} 1120 2500 0 0 {name=l162 sig_type=std_logic lab=p2b}
N 1180 2470 1180 2450 {lab=vcm}
C {devices/lab_pin.sym} 1180 2450 0 0 {name=l163 sig_type=std_logic lab=vcm}
N 1180 2500 1200 2500 {lab=VDD}
C {devices/lab_pin.sym} 1200 2500 0 1 {name=l164 sig_type=std_logic lab=VDD}
C {symbols/cap_mim_2f0fF.sym} 200 2700 0 0 {name=CREFN W=40e-6 L=40e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 2670 200 2650 {lab=cn1}
C {devices/lab_pin.sym} 200 2650 0 0 {name=l165 sig_type=std_logic lab=cn1}
N 200 2730 200 2750 {lab=VSS}
C {devices/lab_pin.sym} 200 2750 0 0 {name=l166 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 520 2700 0 0 {name=CRNN W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 520 2670 520 2650 {lab=cn1}
C {devices/lab_pin.sym} 520 2650 0 0 {name=l167 sig_type=std_logic lab=cn1}
N 520 2730 520 2750 {lab=cnn}
C {devices/lab_pin.sym} 520 2750 0 0 {name=l168 sig_type=std_logic lab=cnn}
C {symbols/nfet_03v3.sym} 840 2700 0 0 {name=MSNN L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 860 2670 860 2650 {lab=cnn}
C {devices/lab_pin.sym} 860 2650 0 0 {name=l169 sig_type=std_logic lab=cnn}
N 820 2700 800 2700 {lab=bwnb}
C {devices/lab_pin.sym} 800 2700 0 0 {name=l170 sig_type=std_logic lab=bwnb}
N 860 2730 860 2750 {lab=VSS}
C {devices/lab_pin.sym} 860 2750 0 0 {name=l171 sig_type=std_logic lab=VSS}
N 860 2700 880 2700 {lab=VSS}
C {devices/lab_pin.sym} 880 2700 0 1 {name=l172 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1160 2700 0 0 {name=CRWN W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1160 2670 1160 2650 {lab=cn1}
C {devices/lab_pin.sym} 1160 2650 0 0 {name=l173 sig_type=std_logic lab=cn1}
N 1160 2730 1160 2750 {lab=cwn}
C {devices/lab_pin.sym} 1160 2750 0 0 {name=l174 sig_type=std_logic lab=cwn}
C {symbols/nfet_03v3.sym} 200 2900 0 0 {name=MSWN L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2870 220 2850 {lab=cwn}
C {devices/lab_pin.sym} 220 2850 0 0 {name=l175 sig_type=std_logic lab=cwn}
N 180 2900 160 2900 {lab=bww}
C {devices/lab_pin.sym} 160 2900 0 0 {name=l176 sig_type=std_logic lab=bww}
N 220 2930 220 2950 {lab=VSS}
C {devices/lab_pin.sym} 220 2950 0 0 {name=l177 sig_type=std_logic lab=VSS}
N 220 2900 240 2900 {lab=VSS}
C {devices/lab_pin.sym} 240 2900 0 1 {name=l178 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 3100 0 0 {name=MEOT L=2u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 3130 220 3150 {lab=eot}
C {devices/lab_pin.sym} 220 3150 0 0 {name=l179 sig_type=std_logic lab=eot}
N 180 3100 160 3100 {lab=PB}
C {devices/lab_pin.sym} 160 3100 0 0 {name=l180 sig_type=std_logic lab=PB}
N 220 3070 220 3050 {lab=VDD}
C {devices/lab_pin.sym} 220 3050 0 0 {name=l181 sig_type=std_logic lab=VDD}
N 220 3100 240 3100 {lab=VDD}
C {devices/lab_pin.sym} 240 3100 0 1 {name=l182 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 520 3100 0 0 {name=MEM1 L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 540 3130 540 3150 {lab=eo1}
C {devices/lab_pin.sym} 540 3150 0 0 {name=l183 sig_type=std_logic lab=eo1}
N 500 3100 480 3100 {lab=gp}
C {devices/lab_pin.sym} 480 3100 0 0 {name=l184 sig_type=std_logic lab=gp}
N 540 3070 540 3050 {lab=eot}
C {devices/lab_pin.sym} 540 3050 0 0 {name=l185 sig_type=std_logic lab=eot}
N 540 3100 560 3100 {lab=VDD}
C {devices/lab_pin.sym} 560 3100 0 1 {name=l186 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 840 3100 0 0 {name=MEM2 L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 860 3130 860 3150 {lab=VTN}
C {devices/lab_pin.sym} 860 3150 0 0 {name=l187 sig_type=std_logic lab=VTN}
N 820 3100 800 3100 {lab=sp}
C {devices/lab_pin.sym} 800 3100 0 0 {name=l188 sig_type=std_logic lab=sp}
N 860 3070 860 3050 {lab=eot}
C {devices/lab_pin.sym} 860 3050 0 0 {name=l189 sig_type=std_logic lab=eot}
N 860 3100 880 3100 {lab=VDD}
C {devices/lab_pin.sym} 880 3100 0 1 {name=l190 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1160 3100 0 0 {name=MEM3 L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1180 3130 1180 3150 {lab=eo1}
C {devices/lab_pin.sym} 1180 3150 0 0 {name=l191 sig_type=std_logic lab=eo1}
N 1140 3100 1120 3100 {lab=sn}
C {devices/lab_pin.sym} 1120 3100 0 0 {name=l192 sig_type=std_logic lab=sn}
N 1180 3070 1180 3050 {lab=eot}
C {devices/lab_pin.sym} 1180 3050 0 0 {name=l193 sig_type=std_logic lab=eot}
N 1180 3100 1200 3100 {lab=VDD}
C {devices/lab_pin.sym} 1200 3100 0 1 {name=l194 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 200 3300 0 0 {name=MEM4 L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 3330 220 3350 {lab=VTN}
C {devices/lab_pin.sym} 220 3350 0 0 {name=l195 sig_type=std_logic lab=VTN}
N 180 3300 160 3300 {lab=gn}
C {devices/lab_pin.sym} 160 3300 0 0 {name=l196 sig_type=std_logic lab=gn}
N 220 3270 220 3250 {lab=eot}
C {devices/lab_pin.sym} 220 3250 0 0 {name=l197 sig_type=std_logic lab=eot}
N 220 3300 240 3300 {lab=VDD}
C {devices/lab_pin.sym} 240 3300 0 1 {name=l198 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 520 3300 0 0 {name=MEL1 L=2u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 540 3270 540 3250 {lab=eo1}
C {devices/lab_pin.sym} 540 3250 0 0 {name=l199 sig_type=std_logic lab=eo1}
N 500 3300 480 3300 {lab=eo1}
C {devices/lab_pin.sym} 480 3300 0 0 {name=l200 sig_type=std_logic lab=eo1}
N 540 3330 540 3350 {lab=VSS}
C {devices/lab_pin.sym} 540 3350 0 0 {name=l201 sig_type=std_logic lab=VSS}
N 540 3300 560 3300 {lab=VSS}
C {devices/lab_pin.sym} 560 3300 0 1 {name=l202 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 840 3300 0 0 {name=MEL2 L=2u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 860 3270 860 3250 {lab=VTN}
C {devices/lab_pin.sym} 860 3250 0 0 {name=l203 sig_type=std_logic lab=VTN}
N 820 3300 800 3300 {lab=eo1}
C {devices/lab_pin.sym} 800 3300 0 0 {name=l204 sig_type=std_logic lab=eo1}
N 860 3330 860 3350 {lab=VSS}
C {devices/lab_pin.sym} 860 3350 0 0 {name=l205 sig_type=std_logic lab=VSS}
N 860 3300 880 3300 {lab=VSS}
C {devices/lab_pin.sym} 880 3300 0 1 {name=l206 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1160 3300 0 0 {name=CINT W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=2}
N 1160 3270 1160 3250 {lab=VTN}
C {devices/lab_pin.sym} 1160 3250 0 0 {name=l207 sig_type=std_logic lab=VTN}
N 1160 3330 1160 3350 {lab=VSS}
C {devices/lab_pin.sym} 1160 3350 0 0 {name=l208 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 3800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
