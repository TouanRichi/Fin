# Before vs After: FPGA Design Fix

## BEFORE (BROKEN - caused "design is empty" error)

### Wrong Top-Level Module:
```tcl
# ❌ WRONG: Synthesizing testbench
synth_design -top RISC_Sha_tb -part xczu9eg-ffvc900-3-e
```

### Constraint Errors:
```
WARNING: [Vivado 12-584] No ports matched 'clk'
WARNING: [Vivado 12-584] No ports matched 'reset' 
WARNING: [Vivado 12-584] No ports matched 'A_i[*]'
CRITICAL WARNING: [Vivado 12-4739] create_clock:No valid object(s) found
```

### Placement Error:
```
ERROR: [Place 30-494] The design is empty
Resolution: Check if opt_design has removed all the leaf cells of your design
ERROR: [Common 17-69] Command failed: Placer could not place all instances
```

---

## AFTER (FIXED - proper hardware synthesis)

### Correct Top-Level Module:
```tcl
# ✅ CORRECT: Synthesizing actual hardware design
synth_design -top SHA256_Top -part xczu9eg-ffvc900-3-e
```

### SHA256_Top Module Structure:
```verilog
module SHA256_Top (
    input clk,                    // ✅ Actual clock port
    input reset,                  // ✅ Actual reset port  
    input start_in,               // ✅ Actual control port
    input [31:0] A_i, B_i, ...,  // ✅ Actual data ports
    input [31:0] w0_sha256, ...,  // ✅ Actual message ports
    output [255:0] sha256_result, // ✅ Actual output ports
    output sha256_valid           // ✅ Actual valid signal
);
    // ✅ Instantiates real hardware design
    RISC_SHA risc_sha_inst (...);
endmodule
```

### Fixed Constraints:
```tcl
# ✅ Ports exist and match design
create_clock -period 2.857 -name clk [get_ports clk]
set_input_delay -clock clk -max 1.4 [get_ports {reset start_in}]
set_input_delay -clock clk -max 1.4 [get_ports {A_i[*] B_i[*] ...}]
set_output_delay -clock clk -max 1.4 [get_ports {sha256_result[*]}]
```

### Expected Result:
```
SUCCESS: SHA256_Top synthesis completed without 'design is empty' error!
Top-level module: SHA256_Top (not testbench)
Design contains actual hardware logic for FPGA implementation.
```

---

## Key Principle Learned:

**🏗️ HARDWARE DESIGN vs 🧪 TESTBENCH**

- **Hardware Design** (`SHA256_Top`, `RISC_SHA`): Contains actual logic gates, registers, and hardware components → **USE FOR SYNTHESIS**
- **Testbench** (`RISC_Sha_tb`, `SHA256_simple_tb`): Contains simulation controls and test vectors → **USE FOR SIMULATION ONLY**

**Rule: Never synthesize a testbench - always use the actual hardware design module as top-level.**