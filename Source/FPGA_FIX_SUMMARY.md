# SHA256 FPGA Design Fix Summary

## Problem Analysis
The original FPGA design had the following critical issues:
1. **[Place 30-494] The design is empty** - during placement
2. **[Common 17-69] Command failed: Placer could not place all instances**
3. **No ports matched** warnings in timing constraints

## Root Cause
The main issue was that **the testbench (`RISC_Sha_tb`) was being synthesized as the top-level module instead of the actual hardware design (`RISC_SHA`)**. 

Testbenches are simulation constructs with no real hardware logic, causing the "design is empty" error during placement.

## Solutions Implemented

### 1. Created Proper Top-Level Module (`SHA256_Top.v`)
```verilog
module SHA256_Top (
    input clk,
    input reset,
    input start_in,
    input [31:0] A_i, B_i, C_i, D_i, E_i, F_i, G_i, H_i,
    input [31:0] w0_sha256, w1_sha256, ..., w15_sha256,
    output [255:0] sha256_result,
    output sha256_valid
);
    // Instantiates RISC_SHA with proper port connections
    RISC_SHA risc_sha_inst (...);
endmodule
```

### 2. Updated Timing Constraints
- Removed non-existent memory interface ports (`DMAD_*`, `DMAI_*`)
- Ensured all constraint ports match the actual `SHA256_Top` module ports
- Fixed clock constraints to target the correct design hierarchy

### 3. Created Simple Test Vector Testbench (`SHA256_simple_tb.v`)
- Tests SHA256 computation with "abc" input
- Expected result: `ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad`
- Separate from synthesis (simulation only)

### 4. Synthesis Test Script (`synthesis_test.sh`)
- Proper Vivado synthesis script using `SHA256_Top` as top-level
- Includes all necessary design files (excluding testbenches)
- Uses updated timing constraints

## Files Modified/Created

### New Files:
- `SHA256_Top.v` - Synthesizable top-level wrapper
- `SHA256_simple_tb.v` - Simple testbench for "abc" test vector
- `synthesis_test.sh` - Synthesis test script

### Modified Files:
- `timing_constraints.xdc` - Removed non-existent port constraints
- `timing_constraints.sdc` - Removed non-existent port constraints

## Expected Results

### Before Fix:
```
ERROR: [Place 30-494] The design is empty
Resolution: Check if opt_design has removed all the leaf cells of your design.
ERROR: [Common 17-69] Command failed: Placer could not place all instances
```

### After Fix:
- Synthesis should complete successfully with `SHA256_Top` as top-level
- No "design is empty" errors
- Placement and routing should proceed normally
- Design contains actual SHA256 hardware logic

## How to Test

1. **Synthesis Test:**
   ```bash
   cd Source
   vivado -mode batch -source synthesis_test.tcl
   ```

2. **Simulation Test:**
   ```bash
   cd Source
   iverilog -o sha256_sim SHA256_simple_tb.v [design_files...]
   ./sha256_sim
   ```

## Key Principle
**Always use a proper hardware design module as the top-level for synthesis, never a testbench.**

The testbench (`RISC_Sha_tb`) should only be used for simulation to verify the design functionality, while `SHA256_Top` should be used for synthesis and FPGA implementation.