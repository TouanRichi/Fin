# Timing Constraints for SHA256_Top FPGA implementation
# Target frequency: 100MHz (10ns period) - more conservative for reliability

# Primary clock constraint for 100MHz
create_clock -period 10.0 -name clk -waveform {0.000 5.0} [get_ports clk]

# Clock uncertainty and skew (typical for FPGA designs)
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delay constraints (conservative timing)
set_input_delay -clock clk -max 2.0 [get_ports {reset start_in}]
set_input_delay -clock clk -min 0.5 [get_ports {reset start_in}]

# Message input constraints
set_input_delay -clock clk -max 2.0 [get_ports {message_word0[*] message_word1[*] message_word2[*] message_word3[*]}]
set_input_delay -clock clk -min 0.5 [get_ports {message_word0[*] message_word1[*] message_word2[*] message_word3[*]}]

# Output delay constraints
set_output_delay -clock clk -max 2.0 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -min 0.5 [get_ports {sha256_result[*]}]
set_output_delay -clock clk -max 2.0 [get_ports {sha256_valid debug_counter[*] design_active}]
set_output_delay -clock clk -min 0.5 [get_ports {sha256_valid debug_counter[*] design_active}]

# False path constraints for reset (asynchronous reset)
set_false_path -from [get_ports reset]

# Maximum fanout constraint to improve timing
set_max_fanout 16 [current_design]

# Maximum transition time constraint
set_max_transition 1.0 [current_design]

# Keep important signals from being optimized away
set_property KEEP true [get_nets debug_counter*]
set_property KEEP true [get_nets design_active]
set_property KEEP true [get_nets sha256_valid]

# Critical path optimization
set_multicycle_path -setup 2 -to [get_pins {*reg*/D}]
set_multicycle_path -hold 1 -to [get_pins {*reg*/D}]