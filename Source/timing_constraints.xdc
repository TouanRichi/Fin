# Timing Constraints for RISC-V SHA256 Co-processor FPGA implementation
# Target frequency: 100MHz (10ns period)

# Primary clock constraint for 100MHz
create_clock -period 10.0 -name clk -waveform {0.000 5.0} [get_ports clk]

# Clock uncertainty and skew (typical for FPGA designs)
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delay constraints - RISC-V processor interface
set_input_delay -clock clk -max 2.0 [get_ports {reset start_in}]
set_input_delay -clock clk -min 0.5 [get_ports {reset start_in}]

# SHA256 initial hash values from RISC-V processor
set_input_delay -clock clk -max 2.0 [get_ports {A_i[*] B_i[*] C_i[*] D_i[*] E_i[*] F_i[*] G_i[*] H_i[*]}]
set_input_delay -clock clk -min 0.5 [get_ports {A_i[*] B_i[*] C_i[*] D_i[*] E_i[*] F_i[*] G_i[*] H_i[*]}]

# W input constraints for SHA256 message schedule from RISC-V processor
set_input_delay -clock clk -max 2.0 [get_ports {w*_sha256[*]}]
set_input_delay -clock clk -min 0.5 [get_ports {w*_sha256[*]}]

# Output delay constraints to RISC-V processor
set_output_delay -clock clk -max 2.0 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -min 0.5 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -max 2.0 [get_ports {sha256_valid design_active}]
set_output_delay -clock clk -min 0.5 [get_ports {sha256_valid design_active}]

# False path constraints for reset (asynchronous reset)
set_false_path -from [get_ports reset]

# Maximum fanout constraint to improve timing
set_max_fanout 16 [current_design]

# Maximum transition time constraint
set_max_transition 1.0 [current_design]

# Keep important signals from being optimized away
set_property KEEP true [get_nets design_active]
set_property KEEP true [get_nets sha256_valid]

# Critical path optimization for co-processor
set_multicycle_path -setup 2 -to [get_pins {*reg*/D}]
set_multicycle_path -hold 1 -to [get_pins {*reg*/D}]