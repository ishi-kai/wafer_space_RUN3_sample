v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {gmc_lpf2: 2nd-order Gm-C biquad, half-cap sides 19.9 / 25.9 um} 100 80 0 0 0.6 0.6 {}
T {integrator 2 + damping} 100 390 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=VTN}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=OUTP}
C {devices/opin.sym} -100 420 0 0 {name=p4 lab=OUTN}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VDD}
C {devices/iopin.sym} -100 480 0 0 {name=p6 lab=VSS}
C {gm_unit.sym} 200 300 0 0 {name=XG1 }
N 100 270 80 270 {lab=INP}
C {devices/lab_pin.sym} 80 270 0 0 {name=l1 sig_type=std_logic lab=INP}
N 100 290 80 290 {lab=INN}
C {devices/lab_pin.sym} 80 290 0 0 {name=l2 sig_type=std_logic lab=INN}
N 300 270 320 270 {lab=xp}
C {devices/lab_pin.sym} 320 270 0 1 {name=l3 sig_type=std_logic lab=xp}
N 300 290 320 290 {lab=xn}
C {devices/lab_pin.sym} 320 290 0 1 {name=l4 sig_type=std_logic lab=xn}
N 100 310 80 310 {lab=VTN}
C {devices/lab_pin.sym} 80 310 0 0 {name=l5 sig_type=std_logic lab=VTN}
N 300 310 320 310 {lab=VDD}
C {devices/lab_pin.sym} 320 310 0 1 {name=l6 sig_type=std_logic lab=VDD}
N 300 330 320 330 {lab=VSS}
C {devices/lab_pin.sym} 320 330 0 1 {name=l7 sig_type=std_logic lab=VSS}
C {gm_unit.sym} 520 300 0 0 {name=XG2 }
N 420 270 400 270 {lab=OUTN}
C {devices/lab_pin.sym} 400 270 0 0 {name=l8 sig_type=std_logic lab=OUTN}
N 420 290 400 290 {lab=OUTP}
C {devices/lab_pin.sym} 400 290 0 0 {name=l9 sig_type=std_logic lab=OUTP}
N 620 270 640 270 {lab=xp}
C {devices/lab_pin.sym} 640 270 0 1 {name=l10 sig_type=std_logic lab=xp}
N 620 290 640 290 {lab=xn}
C {devices/lab_pin.sym} 640 290 0 1 {name=l11 sig_type=std_logic lab=xn}
N 420 310 400 310 {lab=VTN}
C {devices/lab_pin.sym} 400 310 0 0 {name=l12 sig_type=std_logic lab=VTN}
N 620 310 640 310 {lab=VDD}
C {devices/lab_pin.sym} 640 310 0 1 {name=l13 sig_type=std_logic lab=VDD}
N 620 330 640 330 {lab=VSS}
C {devices/lab_pin.sym} 640 330 0 1 {name=l14 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 840 300 0 0 {name=C1A W=19.9e-6 L=19.9e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 840 270 840 250 {lab=xp}
C {devices/lab_pin.sym} 840 250 0 0 {name=l15 sig_type=std_logic lab=xp}
N 840 330 840 350 {lab=xn}
C {devices/lab_pin.sym} 840 350 0 0 {name=l16 sig_type=std_logic lab=xn}
C {symbols/cap_mim_2f0fF.sym} 1160 300 0 0 {name=C1B W=19.9e-6 L=19.9e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1160 270 1160 250 {lab=xn}
C {devices/lab_pin.sym} 1160 250 0 0 {name=l17 sig_type=std_logic lab=xn}
N 1160 330 1160 350 {lab=xp}
C {devices/lab_pin.sym} 1160 350 0 0 {name=l18 sig_type=std_logic lab=xp}
C {gm_unit.sym} 200 500 0 0 {name=XG3 }
N 100 470 80 470 {lab=xp}
C {devices/lab_pin.sym} 80 470 0 0 {name=l19 sig_type=std_logic lab=xp}
N 100 490 80 490 {lab=xn}
C {devices/lab_pin.sym} 80 490 0 0 {name=l20 sig_type=std_logic lab=xn}
N 300 470 320 470 {lab=OUTP}
C {devices/lab_pin.sym} 320 470 0 1 {name=l21 sig_type=std_logic lab=OUTP}
N 300 490 320 490 {lab=OUTN}
C {devices/lab_pin.sym} 320 490 0 1 {name=l22 sig_type=std_logic lab=OUTN}
N 100 510 80 510 {lab=VTN}
C {devices/lab_pin.sym} 80 510 0 0 {name=l23 sig_type=std_logic lab=VTN}
N 300 510 320 510 {lab=VDD}
C {devices/lab_pin.sym} 320 510 0 1 {name=l24 sig_type=std_logic lab=VDD}
N 300 530 320 530 {lab=VSS}
C {devices/lab_pin.sym} 320 530 0 1 {name=l25 sig_type=std_logic lab=VSS}
C {gm_unit.sym} 520 500 0 0 {name=XG4 }
N 420 470 400 470 {lab=OUTN}
C {devices/lab_pin.sym} 400 470 0 0 {name=l26 sig_type=std_logic lab=OUTN}
N 420 490 400 490 {lab=OUTP}
C {devices/lab_pin.sym} 400 490 0 0 {name=l27 sig_type=std_logic lab=OUTP}
N 620 470 640 470 {lab=OUTP}
C {devices/lab_pin.sym} 640 470 0 1 {name=l28 sig_type=std_logic lab=OUTP}
N 620 490 640 490 {lab=OUTN}
C {devices/lab_pin.sym} 640 490 0 1 {name=l29 sig_type=std_logic lab=OUTN}
N 420 510 400 510 {lab=VTN}
C {devices/lab_pin.sym} 400 510 0 0 {name=l30 sig_type=std_logic lab=VTN}
N 620 510 640 510 {lab=VDD}
C {devices/lab_pin.sym} 640 510 0 1 {name=l31 sig_type=std_logic lab=VDD}
N 620 530 640 530 {lab=VSS}
C {devices/lab_pin.sym} 640 530 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 840 500 0 0 {name=C2A W=25.9e-6 L=25.9e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 840 470 840 450 {lab=OUTP}
C {devices/lab_pin.sym} 840 450 0 0 {name=l33 sig_type=std_logic lab=OUTP}
N 840 530 840 550 {lab=OUTN}
C {devices/lab_pin.sym} 840 550 0 0 {name=l34 sig_type=std_logic lab=OUTN}
C {symbols/cap_mim_2f0fF.sym} 1160 500 0 0 {name=C2B W=25.9e-6 L=25.9e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1160 470 1160 450 {lab=OUTN}
C {devices/lab_pin.sym} 1160 450 0 0 {name=l35 sig_type=std_logic lab=OUTN}
N 1160 530 1160 550 {lab=OUTP}
C {devices/lab_pin.sym} 1160 550 0 0 {name=l36 sig_type=std_logic lab=OUTP}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
