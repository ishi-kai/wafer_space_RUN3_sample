v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {2-bit sign/magnitude ADC (MAX2769 compatible format), AC-coupled input -> thm (1.20 V), threshold +-0.15 V diff} 100 80 0 0 0.6 0.6 {}
T {AC coupling + level shift from IF output CM (~2.16 V) to thm (1.20 V); removes VGA5 DC offset} 100 190 0 0 0.4 0.4 {layer=8}
T {threshold ladder (VCM = 0.363 VDD = 1.20 V)} 100 390 0 0 0.4 0.4 {layer=8}
T {comparators} 100 790 0 0 0.4 0.4 {layer=8}
T {MAG = (v > +Vth) OR (v < -Vth)} 100 990 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=CLK}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=SIGN}
C {devices/opin.sym} -100 420 0 0 {name=p4 lab=MAG}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VDD}
C {devices/iopin.sym} -100 480 0 0 {name=p6 lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 300 0 0 {name=CC1 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 270 200 250 {lab=inp_i}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=inp_i}
N 200 330 200 350 {lab=INP}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=INP}
C {symbols/cap_mim_2f0fF.sym} 520 300 0 0 {name=CC2 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 520 270 520 250 {lab=inn_i}
C {devices/lab_pin.sym} 520 250 0 0 {name=l3 sig_type=std_logic lab=inn_i}
N 520 330 520 350 {lab=INN}
C {devices/lab_pin.sym} 520 350 0 0 {name=l4 sig_type=std_logic lab=INN}
C {symbols/ppolyf_u_1k.sym} 840 300 0 0 {name=RB1 W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 840 330 840 350 {lab=thm}
C {devices/lab_pin.sym} 840 350 0 0 {name=l5 sig_type=std_logic lab=thm}
N 840 270 840 250 {lab=inp_i}
C {devices/lab_pin.sym} 840 250 0 0 {name=l6 sig_type=std_logic lab=inp_i}
N 820 300 800 300 {lab=VSS}
C {devices/lab_pin.sym} 800 300 0 0 {name=l7 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1160 300 0 0 {name=RB2 W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 1160 330 1160 350 {lab=thm}
C {devices/lab_pin.sym} 1160 350 0 0 {name=l8 sig_type=std_logic lab=thm}
N 1160 270 1160 250 {lab=inn_i}
C {devices/lab_pin.sym} 1160 250 0 0 {name=l9 sig_type=std_logic lab=inn_i}
N 1140 300 1120 300 {lab=VSS}
C {devices/lab_pin.sym} 1120 300 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 500 0 0 {name=RL0 W=10u L=40.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 530 200 550 {lab=thp}
C {devices/lab_pin.sym} 200 550 0 0 {name=l11 sig_type=std_logic lab=thp}
N 200 470 200 450 {lab=VDD}
C {devices/lab_pin.sym} 200 450 0 0 {name=l12 sig_type=std_logic lab=VDD}
N 180 500 160 500 {lab=VSS}
C {devices/lab_pin.sym} 160 500 0 0 {name=l13 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 520 500 0 0 {name=RL1 W=10u L=1.4u model=ppolyf_u_1k spiceprefix=X m=1}
N 520 530 520 550 {lab=thm}
C {devices/lab_pin.sym} 520 550 0 0 {name=l14 sig_type=std_logic lab=thm}
N 520 470 520 450 {lab=thp}
C {devices/lab_pin.sym} 520 450 0 0 {name=l15 sig_type=std_logic lab=thp}
N 500 500 480 500 {lab=VSS}
C {devices/lab_pin.sym} 480 500 0 0 {name=l16 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 840 500 0 0 {name=RL2 W=10u L=1.4u model=ppolyf_u_1k spiceprefix=X m=1}
N 840 530 840 550 {lab=thn}
C {devices/lab_pin.sym} 840 550 0 0 {name=l17 sig_type=std_logic lab=thn}
N 840 470 840 450 {lab=thm}
C {devices/lab_pin.sym} 840 450 0 0 {name=l18 sig_type=std_logic lab=thm}
N 820 500 800 500 {lab=VSS}
C {devices/lab_pin.sym} 800 500 0 0 {name=l19 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1160 500 0 0 {name=RL3 W=10u L=22.3u model=ppolyf_u_1k spiceprefix=X m=1}
N 1160 530 1160 550 {lab=VSS}
C {devices/lab_pin.sym} 1160 550 0 0 {name=l20 sig_type=std_logic lab=VSS}
N 1160 470 1160 450 {lab=thn}
C {devices/lab_pin.sym} 1160 450 0 0 {name=l21 sig_type=std_logic lab=thn}
N 1140 500 1120 500 {lab=VSS}
C {devices/lab_pin.sym} 1120 500 0 0 {name=l22 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 700 0 0 {name=CT1 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 670 200 650 {lab=thp}
C {devices/lab_pin.sym} 200 650 0 0 {name=l23 sig_type=std_logic lab=thp}
N 200 730 200 750 {lab=VSS}
C {devices/lab_pin.sym} 200 750 0 0 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 520 700 0 0 {name=CT2 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 520 670 520 650 {lab=thm}
C {devices/lab_pin.sym} 520 650 0 0 {name=l25 sig_type=std_logic lab=thm}
N 520 730 520 750 {lab=VSS}
C {devices/lab_pin.sym} 520 750 0 0 {name=l26 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 840 700 0 0 {name=CT3 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 840 670 840 650 {lab=thn}
C {devices/lab_pin.sym} 840 650 0 0 {name=l27 sig_type=std_logic lab=thn}
N 840 730 840 750 {lab=VSS}
C {devices/lab_pin.sym} 840 750 0 0 {name=l28 sig_type=std_logic lab=VSS}
C {sa_comp.sym} 200 900 0 0 {name=XCS }
N 100 860 80 860 {lab=inp_i}
C {devices/lab_pin.sym} 80 860 0 0 {name=l29 sig_type=std_logic lab=inp_i}
N 100 880 80 880 {lab=inn_i}
C {devices/lab_pin.sym} 80 880 0 0 {name=l30 sig_type=std_logic lab=inn_i}
N 100 900 80 900 {lab=thm}
C {devices/lab_pin.sym} 80 900 0 0 {name=l31 sig_type=std_logic lab=thm}
N 100 920 80 920 {lab=thm}
C {devices/lab_pin.sym} 80 920 0 0 {name=l32 sig_type=std_logic lab=thm}
N 100 940 80 940 {lab=CLK}
C {devices/lab_pin.sym} 80 940 0 0 {name=l33 sig_type=std_logic lab=CLK}
N 300 860 320 860 {lab=SIGN}
C {devices/lab_pin.sym} 320 860 0 1 {name=l34 sig_type=std_logic lab=SIGN}
N 300 880 320 880 {lab=sb}
C {devices/lab_pin.sym} 320 880 0 1 {name=l35 sig_type=std_logic lab=sb}
N 300 900 320 900 {lab=VDD}
C {devices/lab_pin.sym} 320 900 0 1 {name=l36 sig_type=std_logic lab=VDD}
N 300 920 320 920 {lab=VSS}
C {devices/lab_pin.sym} 320 920 0 1 {name=l37 sig_type=std_logic lab=VSS}
C {sa_comp.sym} 520 900 0 0 {name=XCH }
N 420 860 400 860 {lab=inp_i}
C {devices/lab_pin.sym} 400 860 0 0 {name=l38 sig_type=std_logic lab=inp_i}
N 420 880 400 880 {lab=inn_i}
C {devices/lab_pin.sym} 400 880 0 0 {name=l39 sig_type=std_logic lab=inn_i}
N 420 900 400 900 {lab=thp}
C {devices/lab_pin.sym} 400 900 0 0 {name=l40 sig_type=std_logic lab=thp}
N 420 920 400 920 {lab=thn}
C {devices/lab_pin.sym} 400 920 0 0 {name=l41 sig_type=std_logic lab=thn}
N 420 940 400 940 {lab=CLK}
C {devices/lab_pin.sym} 400 940 0 0 {name=l42 sig_type=std_logic lab=CLK}
N 620 860 640 860 {lab=qh}
C {devices/lab_pin.sym} 640 860 0 1 {name=l43 sig_type=std_logic lab=qh}
N 620 880 640 880 {lab=qhb}
C {devices/lab_pin.sym} 640 880 0 1 {name=l44 sig_type=std_logic lab=qhb}
N 620 900 640 900 {lab=VDD}
C {devices/lab_pin.sym} 640 900 0 1 {name=l45 sig_type=std_logic lab=VDD}
N 620 920 640 920 {lab=VSS}
C {devices/lab_pin.sym} 640 920 0 1 {name=l46 sig_type=std_logic lab=VSS}
C {sa_comp.sym} 840 900 0 0 {name=XCL }
N 740 860 720 860 {lab=inp_i}
C {devices/lab_pin.sym} 720 860 0 0 {name=l47 sig_type=std_logic lab=inp_i}
N 740 880 720 880 {lab=inn_i}
C {devices/lab_pin.sym} 720 880 0 0 {name=l48 sig_type=std_logic lab=inn_i}
N 740 900 720 900 {lab=thn}
C {devices/lab_pin.sym} 720 900 0 0 {name=l49 sig_type=std_logic lab=thn}
N 740 920 720 920 {lab=thp}
C {devices/lab_pin.sym} 720 920 0 0 {name=l50 sig_type=std_logic lab=thp}
N 740 940 720 940 {lab=CLK}
C {devices/lab_pin.sym} 720 940 0 0 {name=l51 sig_type=std_logic lab=CLK}
N 940 860 960 860 {lab=ql}
C {devices/lab_pin.sym} 960 860 0 1 {name=l52 sig_type=std_logic lab=ql}
N 940 880 960 880 {lab=qlb}
C {devices/lab_pin.sym} 960 880 0 1 {name=l53 sig_type=std_logic lab=qlb}
N 940 900 960 900 {lab=VDD}
C {devices/lab_pin.sym} 960 900 0 1 {name=l54 sig_type=std_logic lab=VDD}
N 940 920 960 920 {lab=VSS}
C {devices/lab_pin.sym} 960 920 0 1 {name=l55 sig_type=std_logic lab=VSS}
C {nand2.sym} 200 1100 0 0 {name=XM }
N 100 1080 80 1080 {lab=qhb}
C {devices/lab_pin.sym} 80 1080 0 0 {name=l56 sig_type=std_logic lab=qhb}
N 100 1100 80 1100 {lab=ql}
C {devices/lab_pin.sym} 80 1100 0 0 {name=l57 sig_type=std_logic lab=ql}
N 300 1080 320 1080 {lab=MAG}
C {devices/lab_pin.sym} 320 1080 0 1 {name=l58 sig_type=std_logic lab=MAG}
N 300 1100 320 1100 {lab=VDD}
C {devices/lab_pin.sym} 320 1100 0 1 {name=l59 sig_type=std_logic lab=VDD}
N 300 1120 320 1120 {lab=VSS}
C {devices/lab_pin.sym} 320 1120 0 1 {name=l60 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1580 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
