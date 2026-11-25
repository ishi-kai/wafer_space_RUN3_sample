v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {IF chain (rev.4): All-MOS VGAs + Crystal-Locked 4th-order Gm-C LPF (BW ~0.4-7.0 MHz, auto-tuned)} 100 80 0 0 0.6 0.6 {}
T {fixed gain stages (All-MOS resistor-free, ~14.2 dB/stage)} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=G1A}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=G1B}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=G2A}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=G2B}
C {devices/ipin.sym} -100 480 0 0 {name=p6 lab=G3A}
C {devices/ipin.sym} -100 510 0 0 {name=p7 lab=G3B}
C {devices/ipin.sym} -100 540 0 0 {name=p8 lab=NB}
C {devices/ipin.sym} -100 570 0 0 {name=p9 lab=VTN}
C {devices/opin.sym} -100 600 0 0 {name=p10 lab=OUTP}
C {devices/opin.sym} -100 630 0 0 {name=p11 lab=OUTN}
C {devices/iopin.sym} -100 660 0 0 {name=p12 lab=VDD}
C {devices/iopin.sym} -100 690 0 0 {name=p13 lab=VSS}
C {bias_if.sym} 200 300 0 0 {name=XBIF }
N 100 280 80 280 {lab=NB}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=NB}
N 300 280 320 280 {lab=pbv}
C {devices/lab_pin.sym} 320 280 0 1 {name=l2 sig_type=std_logic lab=pbv}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {vga.sym} 600 300 0 0 {name=XV1 }
N 500 250 480 250 {lab=INP}
C {devices/lab_pin.sym} 480 250 0 0 {name=l5 sig_type=std_logic lab=INP}
N 500 270 480 270 {lab=INN}
C {devices/lab_pin.sym} 480 270 0 0 {name=l6 sig_type=std_logic lab=INN}
N 500 290 480 290 {lab=G1A}
C {devices/lab_pin.sym} 480 290 0 0 {name=l7 sig_type=std_logic lab=G1A}
N 500 310 480 310 {lab=G1B}
C {devices/lab_pin.sym} 480 310 0 0 {name=l8 sig_type=std_logic lab=G1B}
N 500 330 480 330 {lab=NB}
C {devices/lab_pin.sym} 480 330 0 0 {name=l9 sig_type=std_logic lab=NB}
N 500 350 480 350 {lab=pbv}
C {devices/lab_pin.sym} 480 350 0 0 {name=l10 sig_type=std_logic lab=pbv}
N 700 250 720 250 {lab=a1p}
C {devices/lab_pin.sym} 720 250 0 1 {name=l11 sig_type=std_logic lab=a1p}
N 700 270 720 270 {lab=a1n}
C {devices/lab_pin.sym} 720 270 0 1 {name=l12 sig_type=std_logic lab=a1n}
N 700 290 720 290 {lab=VDD}
C {devices/lab_pin.sym} 720 290 0 1 {name=l13 sig_type=std_logic lab=VDD}
N 700 310 720 310 {lab=VSS}
C {devices/lab_pin.sym} 720 310 0 1 {name=l14 sig_type=std_logic lab=VSS}
C {gmc_lpf1.sym} 1000 300 0 0 {name=XF1 }
N 900 270 880 270 {lab=a1p}
C {devices/lab_pin.sym} 880 270 0 0 {name=l15 sig_type=std_logic lab=a1p}
N 900 290 880 290 {lab=a1n}
C {devices/lab_pin.sym} 880 290 0 0 {name=l16 sig_type=std_logic lab=a1n}
N 900 310 880 310 {lab=VTN}
C {devices/lab_pin.sym} 880 310 0 0 {name=l17 sig_type=std_logic lab=VTN}
N 1100 270 1120 270 {lab=f1p}
C {devices/lab_pin.sym} 1120 270 0 1 {name=l18 sig_type=std_logic lab=f1p}
N 1100 290 1120 290 {lab=f1n}
C {devices/lab_pin.sym} 1120 290 0 1 {name=l19 sig_type=std_logic lab=f1n}
N 1100 310 1120 310 {lab=VDD}
C {devices/lab_pin.sym} 1120 310 0 1 {name=l20 sig_type=std_logic lab=VDD}
N 1100 330 1120 330 {lab=VSS}
C {devices/lab_pin.sym} 1120 330 0 1 {name=l21 sig_type=std_logic lab=VSS}
C {vga.sym} 200 500 0 0 {name=XV2 }
N 100 450 80 450 {lab=f1p}
C {devices/lab_pin.sym} 80 450 0 0 {name=l22 sig_type=std_logic lab=f1p}
N 100 470 80 470 {lab=f1n}
C {devices/lab_pin.sym} 80 470 0 0 {name=l23 sig_type=std_logic lab=f1n}
N 100 490 80 490 {lab=G2A}
C {devices/lab_pin.sym} 80 490 0 0 {name=l24 sig_type=std_logic lab=G2A}
N 100 510 80 510 {lab=G2B}
C {devices/lab_pin.sym} 80 510 0 0 {name=l25 sig_type=std_logic lab=G2B}
N 100 530 80 530 {lab=NB}
C {devices/lab_pin.sym} 80 530 0 0 {name=l26 sig_type=std_logic lab=NB}
N 100 550 80 550 {lab=pbv}
C {devices/lab_pin.sym} 80 550 0 0 {name=l27 sig_type=std_logic lab=pbv}
N 300 450 320 450 {lab=a2p}
C {devices/lab_pin.sym} 320 450 0 1 {name=l28 sig_type=std_logic lab=a2p}
N 300 470 320 470 {lab=a2n}
C {devices/lab_pin.sym} 320 470 0 1 {name=l29 sig_type=std_logic lab=a2n}
N 300 490 320 490 {lab=VDD}
C {devices/lab_pin.sym} 320 490 0 1 {name=l30 sig_type=std_logic lab=VDD}
N 300 510 320 510 {lab=VSS}
C {devices/lab_pin.sym} 320 510 0 1 {name=l31 sig_type=std_logic lab=VSS}
C {gmc_lpf2.sym} 200 700 0 0 {name=XF2 }
N 100 670 80 670 {lab=a2p}
C {devices/lab_pin.sym} 80 670 0 0 {name=l32 sig_type=std_logic lab=a2p}
N 100 690 80 690 {lab=a2n}
C {devices/lab_pin.sym} 80 690 0 0 {name=l33 sig_type=std_logic lab=a2n}
N 100 710 80 710 {lab=VTN}
C {devices/lab_pin.sym} 80 710 0 0 {name=l34 sig_type=std_logic lab=VTN}
N 300 670 320 670 {lab=f2p}
C {devices/lab_pin.sym} 320 670 0 1 {name=l35 sig_type=std_logic lab=f2p}
N 300 690 320 690 {lab=f2n}
C {devices/lab_pin.sym} 320 690 0 1 {name=l36 sig_type=std_logic lab=f2n}
N 300 710 320 710 {lab=VDD}
C {devices/lab_pin.sym} 320 710 0 1 {name=l37 sig_type=std_logic lab=VDD}
N 300 730 320 730 {lab=VSS}
C {devices/lab_pin.sym} 320 730 0 1 {name=l38 sig_type=std_logic lab=VSS}
C {vga.sym} 600 700 0 0 {name=XV3 }
N 500 650 480 650 {lab=f2p}
C {devices/lab_pin.sym} 480 650 0 0 {name=l39 sig_type=std_logic lab=f2p}
N 500 670 480 670 {lab=f2n}
C {devices/lab_pin.sym} 480 670 0 0 {name=l40 sig_type=std_logic lab=f2n}
N 500 690 480 690 {lab=G3A}
C {devices/lab_pin.sym} 480 690 0 0 {name=l41 sig_type=std_logic lab=G3A}
N 500 710 480 710 {lab=G3B}
C {devices/lab_pin.sym} 480 710 0 0 {name=l42 sig_type=std_logic lab=G3B}
N 500 730 480 730 {lab=NB}
C {devices/lab_pin.sym} 480 730 0 0 {name=l43 sig_type=std_logic lab=NB}
N 500 750 480 750 {lab=pbv}
C {devices/lab_pin.sym} 480 750 0 0 {name=l44 sig_type=std_logic lab=pbv}
N 700 650 720 650 {lab=a3p}
C {devices/lab_pin.sym} 720 650 0 1 {name=l45 sig_type=std_logic lab=a3p}
N 700 670 720 670 {lab=a3n}
C {devices/lab_pin.sym} 720 670 0 1 {name=l46 sig_type=std_logic lab=a3n}
N 700 690 720 690 {lab=VDD}
C {devices/lab_pin.sym} 720 690 0 1 {name=l47 sig_type=std_logic lab=VDD}
N 700 710 720 710 {lab=VSS}
C {devices/lab_pin.sym} 720 710 0 1 {name=l48 sig_type=std_logic lab=VSS}
C {vga_fix.sym} 200 900 0 0 {name=XV4 }
N 100 870 80 870 {lab=a3p}
C {devices/lab_pin.sym} 80 870 0 0 {name=l49 sig_type=std_logic lab=a3p}
N 100 890 80 890 {lab=a3n}
C {devices/lab_pin.sym} 80 890 0 0 {name=l50 sig_type=std_logic lab=a3n}
N 100 910 80 910 {lab=NB}
C {devices/lab_pin.sym} 80 910 0 0 {name=l51 sig_type=std_logic lab=NB}
N 100 930 80 930 {lab=pbv}
C {devices/lab_pin.sym} 80 930 0 0 {name=l52 sig_type=std_logic lab=pbv}
N 300 870 320 870 {lab=a4p}
C {devices/lab_pin.sym} 320 870 0 1 {name=l53 sig_type=std_logic lab=a4p}
N 300 890 320 890 {lab=a4n}
C {devices/lab_pin.sym} 320 890 0 1 {name=l54 sig_type=std_logic lab=a4n}
N 300 910 320 910 {lab=VDD}
C {devices/lab_pin.sym} 320 910 0 1 {name=l55 sig_type=std_logic lab=VDD}
N 300 930 320 930 {lab=VSS}
C {devices/lab_pin.sym} 320 930 0 1 {name=l56 sig_type=std_logic lab=VSS}
C {vga_fix.sym} 600 900 0 0 {name=XV5 }
N 500 870 480 870 {lab=a4p}
C {devices/lab_pin.sym} 480 870 0 0 {name=l57 sig_type=std_logic lab=a4p}
N 500 890 480 890 {lab=a4n}
C {devices/lab_pin.sym} 480 890 0 0 {name=l58 sig_type=std_logic lab=a4n}
N 500 910 480 910 {lab=NB}
C {devices/lab_pin.sym} 480 910 0 0 {name=l59 sig_type=std_logic lab=NB}
N 500 930 480 930 {lab=pbv}
C {devices/lab_pin.sym} 480 930 0 0 {name=l60 sig_type=std_logic lab=pbv}
N 700 870 720 870 {lab=OUTP}
C {devices/lab_pin.sym} 720 870 0 1 {name=l61 sig_type=std_logic lab=OUTP}
N 700 890 720 890 {lab=OUTN}
C {devices/lab_pin.sym} 720 890 0 1 {name=l62 sig_type=std_logic lab=OUTN}
N 700 910 720 910 {lab=VDD}
C {devices/lab_pin.sym} 720 910 0 1 {name=l63 sig_type=std_logic lab=VDD}
N 700 930 720 930 {lab=VSS}
C {devices/lab_pin.sym} 720 930 0 1 {name=l64 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
