###############################################################################
# Created by write_sdc
###############################################################################
current_design megabytebeat_macro
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 30517.5000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ena}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_n}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[0]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[1]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[2]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[3]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[4]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[5]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[6]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {ui_in[7]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[0]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[1]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[2]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[3]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[4]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[5]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[6]}]
set_input_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {uio_in[7]}]
set_output_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {vdd_bb_hi_s}]
set_output_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {vss_lo_e}]
set_output_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {vss_lo_s}]
set_output_delay 6103.5000 -clock [get_clocks {clk}] -add_delay [get_ports {vss_lo_w}]
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
