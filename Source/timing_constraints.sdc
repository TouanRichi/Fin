# SDC Timing Constraints for SHA256 RISC-V Implementation
# Target frequency: 350MHz (2.857ns period)
# Compatible with Synopsys, Cadence, and other EDA tools

# Primary clock definition for 350MHz
create_clock -name clk -period 2.857 [get_ports clk]

# Clock uncertainty (jitter and skew)
set_clock_uncertainty 0.1 [get_clocks clk]

# Input delay constraints
# Setup time constraints (assuming 50% of clock period)
set_input_delay -clock clk -max 1.4 [get_ports {reset start_in}]
set_input_delay -clock clk -min 0.2 [get_ports {reset start_in}]

# SHA256 data input constraints
set_input_delay -clock clk -max 1.4 [get_ports {A_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {A_i[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {B_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {B_i[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {C_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {C_i[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {D_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {D_i[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {E_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {E_i[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {F_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {F_i[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {G_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {G_i[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {H_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {H_i[*]}]

# W input constraints for SHA256 (w0 to w15)
set_input_delay -clock clk -max 1.4 [get_ports {w0_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w0_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w1_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w1_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w2_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w2_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w3_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w3_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w4_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w4_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w5_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w5_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w6_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w6_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w7_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w7_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w8_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w8_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w9_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w9_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w10_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w10_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w11_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w11_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w12_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w12_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w13_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w13_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w14_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w14_sha256[*]}]
set_input_delay -clock clk -max 1.4 [get_ports {w15_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w15_sha256[*]}]

# No memory interface constraints needed for SHA256_Top module

# Output delay constraints
set_output_delay -clock clk -max 1.4 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -min 0.2 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -max 1.4 [get_ports {sha256_valid}]
set_output_delay -clock clk -min 0.2 [get_ports {sha256_valid}]

# False path for asynchronous reset
set_false_path -from [get_ports reset]

# Design rule constraints for optimization
set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]
set_max_capacitance 0.5 [current_design]

# Multicycle path constraints for relaxed timing on specific paths
set_multicycle_path -setup 2 -through [get_pins -hierarchical *reg*/Q]
set_multicycle_path -hold 1 -through [get_pins -hierarchical *reg*/Q]

# Group related logic for better placement
group_path -name "SHA_DATAPATH" -from [get_ports {A_i[*] B_i[*] C_i[*] D_i[*] E_i[*] F_i[*] G_i[*] H_i[*]}] -to [get_ports {sha256_result[*] sha256_valid}]
group_path -name "W_INPUTS" -from [get_ports {w*_sha256[*]}] -to [get_ports {sha256_result[*] sha256_valid}]

# Case analysis for optimization (reset inactive during normal operation)
set_case_analysis 1 [get_ports reset]