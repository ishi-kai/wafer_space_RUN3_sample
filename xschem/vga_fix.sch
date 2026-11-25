v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {VGA_FIX: All-MOS resistor-free fixed-gain diff amp (~14.2 dB)} 100 80 0 0 0.6 0.6 {}
T {AC coupling (M4 bottom plate on low-Z input) + 100k gate bias to PBV} 100 190 0 0 0.4 0.4 {layer=8}
T {diff pair + 0.8 mA tail + 4-unit diode / 12-unit PBV PMOS load} 100 390 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=NB}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=PBV}
C {devices/opin.sym} -100 420 0 0 {name=p4 lab=OUTP}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=OUTN}
C {devices/iopin.sym} -100 480 0 0 {name=p6 lab=VDD}
C {devices/iopin.sym} -100 510 0 0 {name=p7 lab=VSS}
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
C {symbols/pfet_03v3.sym} 1100 500 0 0 {name=MPDN L=0.56u W=24u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 530 1120 550 {lab=OUTN}
C {devices/lab_pin.sym} 1120 550 0 0 {name=l23 sig_type=std_logic lab=OUTN}
N 1080 500 1060 500 {lab=OUTN}
C {devices/lab_pin.sym} 1060 500 0 0 {name=l24 sig_type=std_logic lab=OUTN}
N 1120 470 1120 450 {lab=VDD}
C {devices/lab_pin.sym} 1120 450 0 0 {name=l25 sig_type=std_logic lab=VDD}
N 1120 500 1140 500 {lab=VDD}
C {devices/lab_pin.sym} 1140 500 0 1 {name=l26 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 200 700 0 0 {name=MPDP L=0.56u W=24u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 730 220 750 {lab=OUTP}
C {devices/lab_pin.sym} 220 750 0 0 {name=l27 sig_type=std_logic lab=OUTP}
N 180 700 160 700 {lab=OUTP}
C {devices/lab_pin.sym} 160 700 0 0 {name=l28 sig_type=std_logic lab=OUTP}
N 220 670 220 650 {lab=VDD}
C {devices/lab_pin.sym} 220 650 0 0 {name=l29 sig_type=std_logic lab=VDD}
N 220 700 240 700 {lab=VDD}
C {devices/lab_pin.sym} 240 700 0 1 {name=l30 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 500 700 0 0 {name=MPCN L=0.56u W=72u nf=12 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 730 520 750 {lab=OUTN}
C {devices/lab_pin.sym} 520 750 0 0 {name=l31 sig_type=std_logic lab=OUTN}
N 480 700 460 700 {lab=PBV}
C {devices/lab_pin.sym} 460 700 0 0 {name=l32 sig_type=std_logic lab=PBV}
N 520 670 520 650 {lab=VDD}
C {devices/lab_pin.sym} 520 650 0 0 {name=l33 sig_type=std_logic lab=VDD}
N 520 700 540 700 {lab=VDD}
C {devices/lab_pin.sym} 540 700 0 1 {name=l34 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 700 0 0 {name=MPCP L=0.56u W=72u nf=12 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 730 820 750 {lab=OUTP}
C {devices/lab_pin.sym} 820 750 0 0 {name=l35 sig_type=std_logic lab=OUTP}
N 780 700 760 700 {lab=PBV}
C {devices/lab_pin.sym} 760 700 0 0 {name=l36 sig_type=std_logic lab=PBV}
N 820 670 820 650 {lab=VDD}
C {devices/lab_pin.sym} 820 650 0 0 {name=l37 sig_type=std_logic lab=VDD}
N 820 700 840 700 {lab=VDD}
C {devices/lab_pin.sym} 840 700 0 1 {name=l38 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 1200 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
