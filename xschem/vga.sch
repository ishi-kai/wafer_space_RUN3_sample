v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {VGA: All-MOS resistor-free gain-switched diff amp (~3.6/6.0/9.1/14.2 dB, +/-0.25 dB PVT)} 100 80 0 0 0.6 0.6 {}
T {AC coupling (M4 bottom plate on low-Z input) + 100k gate bias to PBV} 100 190 0 0 0.4 0.4 {layer=8}
T {diff pair + 0.8 mA tail (16 x 50 uA unit from NB)} 100 390 0 0 0.4 0.4 {layer=8}
T {PMOS Bank 0: 4 units always diode-connected (locks DC CM & sets max gain)} 100 590 0 0 0.4 0.4 {layer=8}
T {PMOS Bank A (4 units): GA=0 diode / GA=1 PBV current source (L=1u static inv -> ANT.16=0)} 100 790 0 0 0.4 0.4 {layer=8}
T {PMOS Bank B (8 units): GB=0 diode / GB=1 PBV current source (L=1u static inv -> ANT.16=0)} 100 1390 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=GA}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=GB}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=NB}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=PBV}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=OUTP}
C {devices/opin.sym} -100 510 0 0 {name=p7 lab=OUTN}
C {devices/iopin.sym} -100 540 0 0 {name=p8 lab=VDD}
C {devices/iopin.sym} -100 570 0 0 {name=p9 lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 300 0 0 {name=CC1 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 270 200 250 {lab=gp}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=gp}
N 200 330 200 350 {lab=INP}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=INP}
C {symbols/cap_mim_2f0fF.sym} 500 300 0 0 {name=CC2 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 500 270 500 250 {lab=gn}
C {devices/lab_pin.sym} 500 250 0 0 {name=l3 sig_type=std_logic lab=gn}
N 500 330 500 350 {lab=INN}
C {devices/lab_pin.sym} 500 350 0 0 {name=l4 sig_type=std_logic lab=INN}
C {symbols/ppolyf_u_1k.sym} 800 300 0 0 {name=RB1 W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 330 800 350 {lab=PBV}
C {devices/lab_pin.sym} 800 350 0 0 {name=l5 sig_type=std_logic lab=PBV}
N 800 270 800 250 {lab=gp}
C {devices/lab_pin.sym} 800 250 0 0 {name=l6 sig_type=std_logic lab=gp}
N 780 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 0 {name=l7 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 300 0 0 {name=RB2 W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 330 1100 350 {lab=PBV}
C {devices/lab_pin.sym} 1100 350 0 0 {name=l8 sig_type=std_logic lab=PBV}
N 1100 270 1100 250 {lab=gn}
C {devices/lab_pin.sym} 1100 250 0 0 {name=l9 sig_type=std_logic lab=gn}
N 1080 300 1060 300 {lab=VSS}
C {devices/lab_pin.sym} 1060 300 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=MT L=2u W=32u nf=4 m=8 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=t}
C {devices/lab_pin.sym} 220 450 0 0 {name=l11 sig_type=std_logic lab=t}
N 180 500 160 500 {lab=NB}
C {devices/lab_pin.sym} 160 500 0 0 {name=l12 sig_type=std_logic lab=NB}
N 220 530 220 550 {lab=VSS}
C {devices/lab_pin.sym} 220 550 0 0 {name=l13 sig_type=std_logic lab=VSS}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l14 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 500 0 0 {name=M1 L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 470 520 450 {lab=OUTN}
C {devices/lab_pin.sym} 520 450 0 0 {name=l15 sig_type=std_logic lab=OUTN}
N 480 500 460 500 {lab=gp}
C {devices/lab_pin.sym} 460 500 0 0 {name=l16 sig_type=std_logic lab=gp}
N 520 530 520 550 {lab=t}
C {devices/lab_pin.sym} 520 550 0 0 {name=l17 sig_type=std_logic lab=t}
N 520 500 540 500 {lab=VSS}
C {devices/lab_pin.sym} 540 500 0 1 {name=l18 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 800 500 0 0 {name=M2 L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 470 820 450 {lab=OUTP}
C {devices/lab_pin.sym} 820 450 0 0 {name=l19 sig_type=std_logic lab=OUTP}
N 780 500 760 500 {lab=gn}
C {devices/lab_pin.sym} 760 500 0 0 {name=l20 sig_type=std_logic lab=gn}
N 820 530 820 550 {lab=t}
C {devices/lab_pin.sym} 820 550 0 0 {name=l21 sig_type=std_logic lab=t}
N 820 500 840 500 {lab=VSS}
C {devices/lab_pin.sym} 840 500 0 1 {name=l22 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 700 0 0 {name=MP0N L=0.56u W=24u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 730 220 750 {lab=OUTN}
C {devices/lab_pin.sym} 220 750 0 0 {name=l23 sig_type=std_logic lab=OUTN}
N 180 700 160 700 {lab=OUTN}
C {devices/lab_pin.sym} 160 700 0 0 {name=l24 sig_type=std_logic lab=OUTN}
N 220 670 220 650 {lab=VDD}
C {devices/lab_pin.sym} 220 650 0 0 {name=l25 sig_type=std_logic lab=VDD}
N 220 700 240 700 {lab=VDD}
C {devices/lab_pin.sym} 240 700 0 1 {name=l26 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 500 700 0 0 {name=MP0P L=0.56u W=24u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 730 520 750 {lab=OUTP}
C {devices/lab_pin.sym} 520 750 0 0 {name=l27 sig_type=std_logic lab=OUTP}
N 480 700 460 700 {lab=OUTP}
C {devices/lab_pin.sym} 460 700 0 0 {name=l28 sig_type=std_logic lab=OUTP}
N 520 670 520 650 {lab=VDD}
C {devices/lab_pin.sym} 520 650 0 0 {name=l29 sig_type=std_logic lab=VDD}
N 520 700 540 700 {lab=VDD}
C {devices/lab_pin.sym} 540 700 0 1 {name=l30 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 900 0 0 {name=MGAN L=1u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 870 220 850 {lab=gab}
C {devices/lab_pin.sym} 220 850 0 0 {name=l31 sig_type=std_logic lab=gab}
N 180 900 160 900 {lab=GA}
C {devices/lab_pin.sym} 160 900 0 0 {name=l32 sig_type=std_logic lab=GA}
N 220 930 220 950 {lab=VSS}
C {devices/lab_pin.sym} 220 950 0 0 {name=l33 sig_type=std_logic lab=VSS}
N 220 900 240 900 {lab=VSS}
C {devices/lab_pin.sym} 240 900 0 1 {name=l34 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 900 0 0 {name=MGAP L=1u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 930 520 950 {lab=gab}
C {devices/lab_pin.sym} 520 950 0 0 {name=l35 sig_type=std_logic lab=gab}
N 480 900 460 900 {lab=GA}
C {devices/lab_pin.sym} 460 900 0 0 {name=l36 sig_type=std_logic lab=GA}
N 520 870 520 850 {lab=VDD}
C {devices/lab_pin.sym} 520 850 0 0 {name=l37 sig_type=std_logic lab=VDD}
N 520 900 540 900 {lab=VDD}
C {devices/lab_pin.sym} 540 900 0 1 {name=l38 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 900 0 0 {name=TGAN1 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 870 820 850 {lab=gan}
C {devices/lab_pin.sym} 820 850 0 0 {name=l39 sig_type=std_logic lab=gan}
N 780 900 760 900 {lab=gab}
C {devices/lab_pin.sym} 760 900 0 0 {name=l40 sig_type=std_logic lab=gab}
N 820 930 820 950 {lab=OUTN}
C {devices/lab_pin.sym} 820 950 0 0 {name=l41 sig_type=std_logic lab=OUTN}
N 820 900 840 900 {lab=VSS}
C {devices/lab_pin.sym} 840 900 0 1 {name=l42 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 900 0 0 {name=TGAP1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 930 1120 950 {lab=gan}
C {devices/lab_pin.sym} 1120 950 0 0 {name=l43 sig_type=std_logic lab=gan}
N 1080 900 1060 900 {lab=GA}
C {devices/lab_pin.sym} 1060 900 0 0 {name=l44 sig_type=std_logic lab=GA}
N 1120 870 1120 850 {lab=OUTN}
C {devices/lab_pin.sym} 1120 850 0 0 {name=l45 sig_type=std_logic lab=OUTN}
N 1120 900 1140 900 {lab=VDD}
C {devices/lab_pin.sym} 1140 900 0 1 {name=l46 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1100 0 0 {name=TGAN2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1070 220 1050 {lab=gan}
C {devices/lab_pin.sym} 220 1050 0 0 {name=l47 sig_type=std_logic lab=gan}
N 180 1100 160 1100 {lab=GA}
C {devices/lab_pin.sym} 160 1100 0 0 {name=l48 sig_type=std_logic lab=GA}
N 220 1130 220 1150 {lab=PBV}
C {devices/lab_pin.sym} 220 1150 0 0 {name=l49 sig_type=std_logic lab=PBV}
N 220 1100 240 1100 {lab=VSS}
C {devices/lab_pin.sym} 240 1100 0 1 {name=l50 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1100 0 0 {name=TGAP2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1130 520 1150 {lab=gan}
C {devices/lab_pin.sym} 520 1150 0 0 {name=l51 sig_type=std_logic lab=gan}
N 480 1100 460 1100 {lab=gab}
C {devices/lab_pin.sym} 460 1100 0 0 {name=l52 sig_type=std_logic lab=gab}
N 520 1070 520 1050 {lab=PBV}
C {devices/lab_pin.sym} 520 1050 0 0 {name=l53 sig_type=std_logic lab=PBV}
N 520 1100 540 1100 {lab=VDD}
C {devices/lab_pin.sym} 540 1100 0 1 {name=l54 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 1100 0 0 {name=TGBN1 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1070 820 1050 {lab=gap}
C {devices/lab_pin.sym} 820 1050 0 0 {name=l55 sig_type=std_logic lab=gap}
N 780 1100 760 1100 {lab=gab}
C {devices/lab_pin.sym} 760 1100 0 0 {name=l56 sig_type=std_logic lab=gab}
N 820 1130 820 1150 {lab=OUTP}
C {devices/lab_pin.sym} 820 1150 0 0 {name=l57 sig_type=std_logic lab=OUTP}
N 820 1100 840 1100 {lab=VSS}
C {devices/lab_pin.sym} 840 1100 0 1 {name=l58 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 1100 0 0 {name=TGBP1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1130 1120 1150 {lab=gap}
C {devices/lab_pin.sym} 1120 1150 0 0 {name=l59 sig_type=std_logic lab=gap}
N 1080 1100 1060 1100 {lab=GA}
C {devices/lab_pin.sym} 1060 1100 0 0 {name=l60 sig_type=std_logic lab=GA}
N 1120 1070 1120 1050 {lab=OUTP}
C {devices/lab_pin.sym} 1120 1050 0 0 {name=l61 sig_type=std_logic lab=OUTP}
N 1120 1100 1140 1100 {lab=VDD}
C {devices/lab_pin.sym} 1140 1100 0 1 {name=l62 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1300 0 0 {name=TGBN2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1270 220 1250 {lab=gap}
C {devices/lab_pin.sym} 220 1250 0 0 {name=l63 sig_type=std_logic lab=gap}
N 180 1300 160 1300 {lab=GA}
C {devices/lab_pin.sym} 160 1300 0 0 {name=l64 sig_type=std_logic lab=GA}
N 220 1330 220 1350 {lab=PBV}
C {devices/lab_pin.sym} 220 1350 0 0 {name=l65 sig_type=std_logic lab=PBV}
N 220 1300 240 1300 {lab=VSS}
C {devices/lab_pin.sym} 240 1300 0 1 {name=l66 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1300 0 0 {name=TGBP2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1330 520 1350 {lab=gap}
C {devices/lab_pin.sym} 520 1350 0 0 {name=l67 sig_type=std_logic lab=gap}
N 480 1300 460 1300 {lab=gab}
C {devices/lab_pin.sym} 460 1300 0 0 {name=l68 sig_type=std_logic lab=gab}
N 520 1270 520 1250 {lab=PBV}
C {devices/lab_pin.sym} 520 1250 0 0 {name=l69 sig_type=std_logic lab=PBV}
N 520 1300 540 1300 {lab=VDD}
C {devices/lab_pin.sym} 540 1300 0 1 {name=l70 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 1300 0 0 {name=MPAN L=0.56u W=24u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 1330 820 1350 {lab=OUTN}
C {devices/lab_pin.sym} 820 1350 0 0 {name=l71 sig_type=std_logic lab=OUTN}
N 780 1300 760 1300 {lab=gan}
C {devices/lab_pin.sym} 760 1300 0 0 {name=l72 sig_type=std_logic lab=gan}
N 820 1270 820 1250 {lab=VDD}
C {devices/lab_pin.sym} 820 1250 0 0 {name=l73 sig_type=std_logic lab=VDD}
N 820 1300 840 1300 {lab=VDD}
C {devices/lab_pin.sym} 840 1300 0 1 {name=l74 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 1300 0 0 {name=MPAP L=0.56u W=24u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1330 1120 1350 {lab=OUTP}
C {devices/lab_pin.sym} 1120 1350 0 0 {name=l75 sig_type=std_logic lab=OUTP}
N 1080 1300 1060 1300 {lab=gap}
C {devices/lab_pin.sym} 1060 1300 0 0 {name=l76 sig_type=std_logic lab=gap}
N 1120 1270 1120 1250 {lab=VDD}
C {devices/lab_pin.sym} 1120 1250 0 0 {name=l77 sig_type=std_logic lab=VDD}
N 1120 1300 1140 1300 {lab=VDD}
C {devices/lab_pin.sym} 1140 1300 0 1 {name=l78 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1500 0 0 {name=MGBN L=1u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1470 220 1450 {lab=gbb}
C {devices/lab_pin.sym} 220 1450 0 0 {name=l79 sig_type=std_logic lab=gbb}
N 180 1500 160 1500 {lab=GB}
C {devices/lab_pin.sym} 160 1500 0 0 {name=l80 sig_type=std_logic lab=GB}
N 220 1530 220 1550 {lab=VSS}
C {devices/lab_pin.sym} 220 1550 0 0 {name=l81 sig_type=std_logic lab=VSS}
N 220 1500 240 1500 {lab=VSS}
C {devices/lab_pin.sym} 240 1500 0 1 {name=l82 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1500 0 0 {name=MGBP L=1u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1530 520 1550 {lab=gbb}
C {devices/lab_pin.sym} 520 1550 0 0 {name=l83 sig_type=std_logic lab=gbb}
N 480 1500 460 1500 {lab=GB}
C {devices/lab_pin.sym} 460 1500 0 0 {name=l84 sig_type=std_logic lab=GB}
N 520 1470 520 1450 {lab=VDD}
C {devices/lab_pin.sym} 520 1450 0 0 {name=l85 sig_type=std_logic lab=VDD}
N 520 1500 540 1500 {lab=VDD}
C {devices/lab_pin.sym} 540 1500 0 1 {name=l86 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 1500 0 0 {name=TGCN1 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1470 820 1450 {lab=gbn}
C {devices/lab_pin.sym} 820 1450 0 0 {name=l87 sig_type=std_logic lab=gbn}
N 780 1500 760 1500 {lab=gbb}
C {devices/lab_pin.sym} 760 1500 0 0 {name=l88 sig_type=std_logic lab=gbb}
N 820 1530 820 1550 {lab=OUTN}
C {devices/lab_pin.sym} 820 1550 0 0 {name=l89 sig_type=std_logic lab=OUTN}
N 820 1500 840 1500 {lab=VSS}
C {devices/lab_pin.sym} 840 1500 0 1 {name=l90 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 1500 0 0 {name=TGCP1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1530 1120 1550 {lab=gbn}
C {devices/lab_pin.sym} 1120 1550 0 0 {name=l91 sig_type=std_logic lab=gbn}
N 1080 1500 1060 1500 {lab=GB}
C {devices/lab_pin.sym} 1060 1500 0 0 {name=l92 sig_type=std_logic lab=GB}
N 1120 1470 1120 1450 {lab=OUTN}
C {devices/lab_pin.sym} 1120 1450 0 0 {name=l93 sig_type=std_logic lab=OUTN}
N 1120 1500 1140 1500 {lab=VDD}
C {devices/lab_pin.sym} 1140 1500 0 1 {name=l94 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1700 0 0 {name=TGCN2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1670 220 1650 {lab=gbn}
C {devices/lab_pin.sym} 220 1650 0 0 {name=l95 sig_type=std_logic lab=gbn}
N 180 1700 160 1700 {lab=GB}
C {devices/lab_pin.sym} 160 1700 0 0 {name=l96 sig_type=std_logic lab=GB}
N 220 1730 220 1750 {lab=PBV}
C {devices/lab_pin.sym} 220 1750 0 0 {name=l97 sig_type=std_logic lab=PBV}
N 220 1700 240 1700 {lab=VSS}
C {devices/lab_pin.sym} 240 1700 0 1 {name=l98 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1700 0 0 {name=TGCP2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1730 520 1750 {lab=gbn}
C {devices/lab_pin.sym} 520 1750 0 0 {name=l99 sig_type=std_logic lab=gbn}
N 480 1700 460 1700 {lab=gbb}
C {devices/lab_pin.sym} 460 1700 0 0 {name=l100 sig_type=std_logic lab=gbb}
N 520 1670 520 1650 {lab=PBV}
C {devices/lab_pin.sym} 520 1650 0 0 {name=l101 sig_type=std_logic lab=PBV}
N 520 1700 540 1700 {lab=VDD}
C {devices/lab_pin.sym} 540 1700 0 1 {name=l102 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 1700 0 0 {name=TGDN1 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1670 820 1650 {lab=gbp}
C {devices/lab_pin.sym} 820 1650 0 0 {name=l103 sig_type=std_logic lab=gbp}
N 780 1700 760 1700 {lab=gbb}
C {devices/lab_pin.sym} 760 1700 0 0 {name=l104 sig_type=std_logic lab=gbb}
N 820 1730 820 1750 {lab=OUTP}
C {devices/lab_pin.sym} 820 1750 0 0 {name=l105 sig_type=std_logic lab=OUTP}
N 820 1700 840 1700 {lab=VSS}
C {devices/lab_pin.sym} 840 1700 0 1 {name=l106 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 1700 0 0 {name=TGDP1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1730 1120 1750 {lab=gbp}
C {devices/lab_pin.sym} 1120 1750 0 0 {name=l107 sig_type=std_logic lab=gbp}
N 1080 1700 1060 1700 {lab=GB}
C {devices/lab_pin.sym} 1060 1700 0 0 {name=l108 sig_type=std_logic lab=GB}
N 1120 1670 1120 1650 {lab=OUTP}
C {devices/lab_pin.sym} 1120 1650 0 0 {name=l109 sig_type=std_logic lab=OUTP}
N 1120 1700 1140 1700 {lab=VDD}
C {devices/lab_pin.sym} 1140 1700 0 1 {name=l110 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1900 0 0 {name=TGDN2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1870 220 1850 {lab=gbp}
C {devices/lab_pin.sym} 220 1850 0 0 {name=l111 sig_type=std_logic lab=gbp}
N 180 1900 160 1900 {lab=GB}
C {devices/lab_pin.sym} 160 1900 0 0 {name=l112 sig_type=std_logic lab=GB}
N 220 1930 220 1950 {lab=PBV}
C {devices/lab_pin.sym} 220 1950 0 0 {name=l113 sig_type=std_logic lab=PBV}
N 220 1900 240 1900 {lab=VSS}
C {devices/lab_pin.sym} 240 1900 0 1 {name=l114 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1900 0 0 {name=TGDP2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1930 520 1950 {lab=gbp}
C {devices/lab_pin.sym} 520 1950 0 0 {name=l115 sig_type=std_logic lab=gbp}
N 480 1900 460 1900 {lab=gbb}
C {devices/lab_pin.sym} 460 1900 0 0 {name=l116 sig_type=std_logic lab=gbb}
N 520 1870 520 1850 {lab=PBV}
C {devices/lab_pin.sym} 520 1850 0 0 {name=l117 sig_type=std_logic lab=PBV}
N 520 1900 540 1900 {lab=VDD}
C {devices/lab_pin.sym} 540 1900 0 1 {name=l118 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 1900 0 0 {name=MPBN L=0.56u W=48u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 1930 820 1950 {lab=OUTN}
C {devices/lab_pin.sym} 820 1950 0 0 {name=l119 sig_type=std_logic lab=OUTN}
N 780 1900 760 1900 {lab=gbn}
C {devices/lab_pin.sym} 760 1900 0 0 {name=l120 sig_type=std_logic lab=gbn}
N 820 1870 820 1850 {lab=VDD}
C {devices/lab_pin.sym} 820 1850 0 0 {name=l121 sig_type=std_logic lab=VDD}
N 820 1900 840 1900 {lab=VDD}
C {devices/lab_pin.sym} 840 1900 0 1 {name=l122 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 1900 0 0 {name=MPBP L=0.56u W=48u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1930 1120 1950 {lab=OUTP}
C {devices/lab_pin.sym} 1120 1950 0 0 {name=l123 sig_type=std_logic lab=OUTP}
N 1080 1900 1060 1900 {lab=gbp}
C {devices/lab_pin.sym} 1060 1900 0 0 {name=l124 sig_type=std_logic lab=gbp}
N 1120 1870 1120 1850 {lab=VDD}
C {devices/lab_pin.sym} 1120 1850 0 0 {name=l125 sig_type=std_logic lab=VDD}
N 1120 1900 1140 1900 {lab=VDD}
C {devices/lab_pin.sym} 1140 1900 0 1 {name=l126 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 2400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
