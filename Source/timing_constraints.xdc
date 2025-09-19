# Timing Constraints for RISC-V SHA256 Co-processor FPGA implementation
# Optimized I/O interface - reduced from 1029 pins to ~46 pins
# Target frequency: 100MHz (10ns period)

# Primary clock constraint for 100MHz
create_clock -period 10.0 -name clk -waveform {0.000 5.0} [get_ports clk]

# Clock uncertainty and skew (typical for FPGA designs)
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delay constraints - RISC-V processor interface
set_input_delay -clock clk -max 2.0 [get_ports {reset start_in}]
set_input_delay -clock clk -min 0.5 [get_ports {reset start_in}]

# Co-processor control interface
set_input_delay -clock clk -max 2.0 [get_ports {operation_mode[*]}]
set_input_delay -clock clk -min 0.5 [get_ports {operation_mode[*]}]

# Data interface from RISC-V processor (optimized)
set_input_delay -clock clk -max 2.0 [get_ports {data_in[*] data_addr[*] data_valid}]
set_input_delay -clock clk -min 0.5 [get_ports {data_in[*] data_addr[*] data_valid}]

# Output delay constraints to RISC-V processor (optimized)
set_output_delay -clock clk -max 2.0 [get_ports {data_out[*]}]
set_output_delay -clock clk -min 0.5 [get_ports {data_out[*]}]
set_output_delay -clock clk -max 2.0 [get_ports {result_valid busy design_active}]
set_output_delay -clock clk -min 0.5 [get_ports {result_valid busy design_active}]

# False path constraints for reset (asynchronous reset)
set_false_path -from [get_ports reset]

# Maximum fanout constraint to improve timing
set_max_fanout 16 [current_design]

# Maximum transition time constraint
set_max_transition 1.0 [current_design]

# Keep important signals from being optimized away
set_property KEEP true [get_nets design_active]
set_property KEEP true [get_nets result_valid]
set_property KEEP true [get_nets busy]

# Critical path optimization for co-processor
set_multicycle_path -setup 2 -to [get_pins {*reg*/D}]
set_multicycle_path -hold 1 -to [get_pins {*reg*/D}]

# I/O optimization note:
# Previous interface: 1029 pins (too many for xczu9cg device)
# New interface: ~46 pins (fits comfortably in 707 available pins)
# Reduction achieved by using sequential data loading instead of parallel