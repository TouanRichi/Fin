# Timing Constraints for SHA256 RISC-V Implementation
# Target frequency: 350MHz (2.857ns period)

# Primary clock constraint for 350MHz
create_clock -period 2.857 -name clk -waveform {0.000 1.4285} [get_ports clk]

# Clock uncertainty and skew (typical for FPGA designs)
set_clock_uncertainty 0.1 [get_clocks clk]

# Input delay constraints (assuming 50% of clock period for setup)
set_input_delay -clock clk -max 1.4 [get_ports {reset start_in}]
set_input_delay -clock clk -min 0.2 [get_ports {reset start_in}]

# SHA256 input data constraints
set_input_delay -clock clk -max 1.4 [get_ports {A_i[*] B_i[*] C_i[*] D_i[*] E_i[*] F_i[*] G_i[*] H_i[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {A_i[*] B_i[*] C_i[*] D_i[*] E_i[*] F_i[*] G_i[*] H_i[*]}]

# W input constraints for SHA256
set_input_delay -clock clk -max 1.4 [get_ports {w*_sha256[*]}]
set_input_delay -clock clk -min 0.2 [get_ports {w*_sha256[*]}]

# No memory interface constraints needed for SHA256_Top module

# Output delay constraints (assuming 50% of clock period for hold)
set_output_delay -clock clk -max 1.4 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -min 0.2 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -max 1.4 [get_ports {sha256_valid}]
set_output_delay -clock clk -min 0.2 [get_ports {sha256_valid}]

# False path constraints for reset (asynchronous reset)
set_false_path -from [get_ports reset]

# Maximum fanout constraint to improve timing
set_max_fanout 20 [current_design]

# Maximum transition time constraint
set_max_transition 0.5 [current_design]

# Critical path optimization - focus on register-to-register paths
set_multicycle_path -setup 2 -to [get_pins {*reg*/D}]
set_multicycle_path -hold 1 -to [get_pins {*reg*/D}]

# Case analysis for better optimization (assuming reset is not active during normal operation)
set_case_analysis 1 [get_ports reset]

# High effort place and route directives
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]