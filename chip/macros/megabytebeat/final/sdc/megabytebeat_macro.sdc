###############################################################################
# Created by write_sdc
###############################################################################
current_design megabytebeat_macro
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 488.0000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ena}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_n}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[0]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[1]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[2]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[3]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[4]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[5]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[6]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[7]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[0]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[1]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[2]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[3]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[4]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[5]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[6]}]
set_input_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[7]}]
set_output_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uo_pwm[0]}]
set_output_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uo_pwm[1]}]
set_output_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {uo_pwm[2]}]
set_output_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {vdd_bb_hi_s}]
set_output_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {vss_lo_e}]
set_output_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {vss_lo_s}]
set_output_delay 97.6000 -clock [get_clocks {clk}] -add_delay [get_ports {vss_lo_w}]
set_multicycle_path -hold\
    -from [list [get_ports {ui_in[0]}]\
           [get_ports {ui_in[1]}]\
           [get_ports {ui_in[2]}]\
           [get_ports {ui_in[3]}]\
           [get_ports {ui_in[4]}]\
           [get_ports {ui_in[5]}]\
           [get_ports {ui_in[6]}]\
           [get_ports {ui_in[7]}]\
           [get_ports {uio_in[0]}]\
           [get_ports {uio_in[1]}]\
           [get_ports {uio_in[2]}]\
           [get_ports {uio_in[3]}]\
           [get_ports {uio_in[4]}]\
           [get_ports {uio_in[5]}]\
           [get_ports {uio_in[6]}]\
           [get_ports {uio_in[7]}]\
           [get_cells {_18846_}]\
           [get_cells {_18847_}]\
           [get_cells {_18848_}]\
           [get_cells {_18849_}]\
           [get_cells {_18850_}]\
           [get_cells {_18851_}]\
           [get_cells {_18852_}]\
           [get_cells {_18853_}]\
           [get_cells {_18854_}]\
           [get_cells {_18855_}]\
           [get_cells {_18856_}]\
           [get_cells {_18857_}]\
           [get_cells {_18858_}]\
           [get_cells {_18859_}]\
           [get_cells {_18860_}]\
           [get_cells {_18861_}]\
           [get_cells {_18862_}]\
           [get_cells {_18863_}]\
           [get_cells {_18864_}]\
           [get_cells {_18865_}]\
           [get_cells {_18866_}]\
           [get_cells {_18867_}]\
           [get_cells {_18868_}]\
           [get_cells {_18869_}]\
           [get_cells {_18870_}]\
           [get_cells {_18871_}]\
           [get_cells {_18872_}]\
           [get_cells {_18873_}]\
           [get_cells {_18874_}]\
           [get_cells {_18875_}]\
           [get_cells {_18876_}]\
           [get_cells {_18877_}]\
           [get_cells {_18880_}]\
           [get_cells {_18881_}]\
           [get_cells {_18882_}]\
           [get_cells {_18883_}]\
           [get_cells {_18884_}]\
           [get_cells {_18885_}]\
           [get_cells {_18886_}]\
           [get_cells {_18887_}]\
           [get_cells {_18888_}]\
           [get_cells {_18889_}]\
           [get_cells {_18890_}]\
           [get_cells {_18891_}]\
           [get_cells {_18892_}]\
           [get_cells {_18893_}]\
           [get_cells {_18894_}]\
           [get_cells {_18895_}]\
           [get_cells {_18896_}]\
           [get_cells {_18897_}]\
           [get_cells {_18898_}]\
           [get_cells {_18899_}]\
           [get_cells {_18900_}]\
           [get_cells {_18901_}]\
           [get_cells {_18902_}]\
           [get_cells {_18903_}]\
           [get_cells {_18904_}]\
           [get_cells {_18905_}]\
           [get_cells {_18906_}]\
           [get_cells {_18907_}]\
           [get_cells {_18908_}]\
           [get_cells {_18909_}]\
           [get_cells {_18910_}]\
           [get_cells {_18911_}]\
           [get_cells {_18912_}]\
           [get_cells {_18913_}]\
           [get_cells {_18914_}]\
           [get_cells {_18915_}]\
           [get_cells {_18916_}]\
           [get_cells {_18917_}]\
           [get_cells {_18918_}]\
           [get_cells {_18919_}]]\
    -to [list [get_cells {_18846_}]\
           [get_cells {_18847_}]\
           [get_cells {_18848_}]\
           [get_cells {_18849_}]\
           [get_cells {_18850_}]\
           [get_cells {_18851_}]\
           [get_cells {_18852_}]\
           [get_cells {_18853_}]\
           [get_cells {_18854_}]\
           [get_cells {_18855_}]\
           [get_cells {_18856_}]\
           [get_cells {_18857_}]\
           [get_cells {_18858_}]\
           [get_cells {_18859_}]\
           [get_cells {_18860_}]\
           [get_cells {_18861_}]\
           [get_cells {_18862_}]\
           [get_cells {_18863_}]\
           [get_cells {_18864_}]\
           [get_cells {_18865_}]\
           [get_cells {_18866_}]\
           [get_cells {_18867_}]\
           [get_cells {_18868_}]\
           [get_cells {_18869_}]\
           [get_cells {_18870_}]\
           [get_cells {_18871_}]\
           [get_cells {_18872_}]\
           [get_cells {_18873_}]\
           [get_cells {_18874_}]\
           [get_cells {_18875_}]\
           [get_cells {_18876_}]\
           [get_cells {_18877_}]\
           [get_cells {_18880_}]\
           [get_cells {_18881_}]\
           [get_cells {_18882_}]\
           [get_cells {_18883_}]\
           [get_cells {_18884_}]\
           [get_cells {_18885_}]\
           [get_cells {_18886_}]\
           [get_cells {_18887_}]\
           [get_cells {_18888_}]\
           [get_cells {_18889_}]\
           [get_cells {_18890_}]\
           [get_cells {_18891_}]\
           [get_cells {_18892_}]\
           [get_cells {_18893_}]\
           [get_cells {_18894_}]\
           [get_cells {_18895_}]\
           [get_cells {_18896_}]\
           [get_cells {_18897_}]\
           [get_cells {_18898_}]\
           [get_cells {_18899_}]\
           [get_cells {_18900_}]\
           [get_cells {_18901_}]\
           [get_cells {_18902_}]\
           [get_cells {_18903_}]\
           [get_cells {_18904_}]\
           [get_cells {_18905_}]\
           [get_cells {_18906_}]\
           [get_cells {_18907_}]\
           [get_cells {_18908_}]\
           [get_cells {_18909_}]\
           [get_cells {_18910_}]\
           [get_cells {_18911_}]\
           [get_cells {_18912_}]\
           [get_cells {_18913_}]\
           [get_cells {_18914_}]\
           [get_cells {_18915_}]\
           [get_cells {_18916_}]\
           [get_cells {_18917_}]\
           [get_cells {_18918_}]\
           [get_cells {_18919_}]] 255
set_multicycle_path -setup\
    -from [list [get_ports {ui_in[0]}]\
           [get_ports {ui_in[1]}]\
           [get_ports {ui_in[2]}]\
           [get_ports {ui_in[3]}]\
           [get_ports {ui_in[4]}]\
           [get_ports {ui_in[5]}]\
           [get_ports {ui_in[6]}]\
           [get_ports {ui_in[7]}]\
           [get_ports {uio_in[0]}]\
           [get_ports {uio_in[1]}]\
           [get_ports {uio_in[2]}]\
           [get_ports {uio_in[3]}]\
           [get_ports {uio_in[4]}]\
           [get_ports {uio_in[5]}]\
           [get_ports {uio_in[6]}]\
           [get_ports {uio_in[7]}]\
           [get_cells {_18846_}]\
           [get_cells {_18847_}]\
           [get_cells {_18848_}]\
           [get_cells {_18849_}]\
           [get_cells {_18850_}]\
           [get_cells {_18851_}]\
           [get_cells {_18852_}]\
           [get_cells {_18853_}]\
           [get_cells {_18854_}]\
           [get_cells {_18855_}]\
           [get_cells {_18856_}]\
           [get_cells {_18857_}]\
           [get_cells {_18858_}]\
           [get_cells {_18859_}]\
           [get_cells {_18860_}]\
           [get_cells {_18861_}]\
           [get_cells {_18862_}]\
           [get_cells {_18863_}]\
           [get_cells {_18864_}]\
           [get_cells {_18865_}]\
           [get_cells {_18866_}]\
           [get_cells {_18867_}]\
           [get_cells {_18868_}]\
           [get_cells {_18869_}]\
           [get_cells {_18870_}]\
           [get_cells {_18871_}]\
           [get_cells {_18872_}]\
           [get_cells {_18873_}]\
           [get_cells {_18874_}]\
           [get_cells {_18875_}]\
           [get_cells {_18876_}]\
           [get_cells {_18877_}]\
           [get_cells {_18880_}]\
           [get_cells {_18881_}]\
           [get_cells {_18882_}]\
           [get_cells {_18883_}]\
           [get_cells {_18884_}]\
           [get_cells {_18885_}]\
           [get_cells {_18886_}]\
           [get_cells {_18887_}]\
           [get_cells {_18888_}]\
           [get_cells {_18889_}]\
           [get_cells {_18890_}]\
           [get_cells {_18891_}]\
           [get_cells {_18892_}]\
           [get_cells {_18893_}]\
           [get_cells {_18894_}]\
           [get_cells {_18895_}]\
           [get_cells {_18896_}]\
           [get_cells {_18897_}]\
           [get_cells {_18898_}]\
           [get_cells {_18899_}]\
           [get_cells {_18900_}]\
           [get_cells {_18901_}]\
           [get_cells {_18902_}]\
           [get_cells {_18903_}]\
           [get_cells {_18904_}]\
           [get_cells {_18905_}]\
           [get_cells {_18906_}]\
           [get_cells {_18907_}]\
           [get_cells {_18908_}]\
           [get_cells {_18909_}]\
           [get_cells {_18910_}]\
           [get_cells {_18911_}]\
           [get_cells {_18912_}]\
           [get_cells {_18913_}]\
           [get_cells {_18914_}]\
           [get_cells {_18915_}]\
           [get_cells {_18916_}]\
           [get_cells {_18917_}]\
           [get_cells {_18918_}]\
           [get_cells {_18919_}]]\
    -to [list [get_cells {_18846_}]\
           [get_cells {_18847_}]\
           [get_cells {_18848_}]\
           [get_cells {_18849_}]\
           [get_cells {_18850_}]\
           [get_cells {_18851_}]\
           [get_cells {_18852_}]\
           [get_cells {_18853_}]\
           [get_cells {_18854_}]\
           [get_cells {_18855_}]\
           [get_cells {_18856_}]\
           [get_cells {_18857_}]\
           [get_cells {_18858_}]\
           [get_cells {_18859_}]\
           [get_cells {_18860_}]\
           [get_cells {_18861_}]\
           [get_cells {_18862_}]\
           [get_cells {_18863_}]\
           [get_cells {_18864_}]\
           [get_cells {_18865_}]\
           [get_cells {_18866_}]\
           [get_cells {_18867_}]\
           [get_cells {_18868_}]\
           [get_cells {_18869_}]\
           [get_cells {_18870_}]\
           [get_cells {_18871_}]\
           [get_cells {_18872_}]\
           [get_cells {_18873_}]\
           [get_cells {_18874_}]\
           [get_cells {_18875_}]\
           [get_cells {_18876_}]\
           [get_cells {_18877_}]\
           [get_cells {_18880_}]\
           [get_cells {_18881_}]\
           [get_cells {_18882_}]\
           [get_cells {_18883_}]\
           [get_cells {_18884_}]\
           [get_cells {_18885_}]\
           [get_cells {_18886_}]\
           [get_cells {_18887_}]\
           [get_cells {_18888_}]\
           [get_cells {_18889_}]\
           [get_cells {_18890_}]\
           [get_cells {_18891_}]\
           [get_cells {_18892_}]\
           [get_cells {_18893_}]\
           [get_cells {_18894_}]\
           [get_cells {_18895_}]\
           [get_cells {_18896_}]\
           [get_cells {_18897_}]\
           [get_cells {_18898_}]\
           [get_cells {_18899_}]\
           [get_cells {_18900_}]\
           [get_cells {_18901_}]\
           [get_cells {_18902_}]\
           [get_cells {_18903_}]\
           [get_cells {_18904_}]\
           [get_cells {_18905_}]\
           [get_cells {_18906_}]\
           [get_cells {_18907_}]\
           [get_cells {_18908_}]\
           [get_cells {_18909_}]\
           [get_cells {_18910_}]\
           [get_cells {_18911_}]\
           [get_cells {_18912_}]\
           [get_cells {_18913_}]\
           [get_cells {_18914_}]\
           [get_cells {_18915_}]\
           [get_cells {_18916_}]\
           [get_cells {_18917_}]\
           [get_cells {_18918_}]\
           [get_cells {_18919_}]] 256
set_false_path\
    -from [list [get_ports {ua[0]}]\
           [get_ports {ua[1]}]\
           [get_ports {ua[2]}]\
           [get_ports {ua[3]}]\
           [get_ports {ua[4]}]]
set_false_path\
    -to [list [get_ports {ua[0]}]\
           [get_ports {ua[1]}]\
           [get_ports {ua[2]}]\
           [get_ports {ua[3]}]\
           [get_ports {ua[4]}]]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0729 [get_ports {vdd_bb_hi_s}]
set_load -pin_load 0.0729 [get_ports {vss_lo_e}]
set_load -pin_load 0.0729 [get_ports {vss_lo_s}]
set_load -pin_load 0.0729 [get_ports {vss_lo_w}]
set_load -pin_load 0.0729 [get_ports {uo_pwm[2]}]
set_load -pin_load 0.0729 [get_ports {uo_pwm[1]}]
set_load -pin_load 0.0729 [get_ports {uo_pwm[0]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_4 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ena}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst_n}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[7]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[6]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[5]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[4]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[3]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[2]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[1]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {ui_in[0]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[7]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[6]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[5]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[4]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[3]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[2]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[1]}]
set_driving_cell -lib_cell gf180mcu_fd_sc_mcu7t5v0__inv_1 -pin {ZN} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {uio_in[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_capacitance 0.2000 [current_design]
set_max_fanout 10.0000 [current_design]
