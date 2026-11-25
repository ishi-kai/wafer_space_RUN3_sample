v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Gm-C unit OTA (high-Vov 6u/1u pair + self-CMFB split PMOS load)} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=OUTP}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=OUTN}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=VTN}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VDD}
C {devices/iopin.sym} -100 480 0 0 {name=p6 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MT L=2u W=32u nf=4 m=2 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=t}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=t}
N 180 300 160 300 {lab=VTN}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=VTN}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 300 0 0 {name=M1 L=1u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 270 520 250 {lab=OUTN}
C {devices/lab_pin.sym} 520 250 0 0 {name=l5 sig_type=std_logic lab=OUTN}
N 480 300 460 300 {lab=INP}
C {devices/lab_pin.sym} 460 300 0 0 {name=l6 sig_type=std_logic lab=INP}
N 520 330 520 350 {lab=t}
C {devices/lab_pin.sym} 520 350 0 0 {name=l7 sig_type=std_logic lab=t}
N 520 300 540 300 {lab=VSS}
C {devices/lab_pin.sym} 540 300 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 800 300 0 0 {name=M2 L=1u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 270 820 250 {lab=OUTP}
C {devices/lab_pin.sym} 820 250 0 0 {name=l9 sig_type=std_logic lab=OUTP}
N 780 300 760 300 {lab=INN}
C {devices/lab_pin.sym} 760 300 0 0 {name=l10 sig_type=std_logic lab=INN}
N 820 330 820 350 {lab=t}
C {devices/lab_pin.sym} 820 350 0 0 {name=l11 sig_type=std_logic lab=t}
N 820 300 840 300 {lab=VSS}
C {devices/lab_pin.sym} 840 300 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 300 0 0 {name=MP1A L=2u W=16u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 330 1120 350 {lab=OUTN}
C {devices/lab_pin.sym} 1120 350 0 0 {name=l13 sig_type=std_logic lab=OUTN}
N 1080 300 1060 300 {lab=OUTN}
C {devices/lab_pin.sym} 1060 300 0 0 {name=l14 sig_type=std_logic lab=OUTN}
N 1120 270 1120 250 {lab=VDD}
C {devices/lab_pin.sym} 1120 250 0 0 {name=l15 sig_type=std_logic lab=VDD}
N 1120 300 1140 300 {lab=VDD}
C {devices/lab_pin.sym} 1140 300 0 1 {name=l16 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 200 500 0 0 {name=MP1B L=2u W=16u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 530 220 550 {lab=OUTN}
C {devices/lab_pin.sym} 220 550 0 0 {name=l17 sig_type=std_logic lab=OUTN}
N 180 500 160 500 {lab=OUTP}
C {devices/lab_pin.sym} 160 500 0 0 {name=l18 sig_type=std_logic lab=OUTP}
N 220 470 220 450 {lab=VDD}
C {devices/lab_pin.sym} 220 450 0 0 {name=l19 sig_type=std_logic lab=VDD}
N 220 500 240 500 {lab=VDD}
C {devices/lab_pin.sym} 240 500 0 1 {name=l20 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 500 500 0 0 {name=MP2A L=2u W=16u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 530 520 550 {lab=OUTP}
C {devices/lab_pin.sym} 520 550 0 0 {name=l21 sig_type=std_logic lab=OUTP}
N 480 500 460 500 {lab=OUTP}
C {devices/lab_pin.sym} 460 500 0 0 {name=l22 sig_type=std_logic lab=OUTP}
N 520 470 520 450 {lab=VDD}
C {devices/lab_pin.sym} 520 450 0 0 {name=l23 sig_type=std_logic lab=VDD}
N 520 500 540 500 {lab=VDD}
C {devices/lab_pin.sym} 540 500 0 1 {name=l24 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 500 0 0 {name=MP2B L=2u W=16u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 530 820 550 {lab=OUTP}
C {devices/lab_pin.sym} 820 550 0 0 {name=l25 sig_type=std_logic lab=OUTP}
N 780 500 760 500 {lab=OUTN}
C {devices/lab_pin.sym} 760 500 0 0 {name=l26 sig_type=std_logic lab=OUTN}
N 820 470 820 450 {lab=VDD}
C {devices/lab_pin.sym} 820 450 0 0 {name=l27 sig_type=std_logic lab=VDD}
N 820 500 840 500 {lab=VDD}
C {devices/lab_pin.sym} 840 500 0 1 {name=l28 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
