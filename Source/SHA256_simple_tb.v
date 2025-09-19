`timescale 1ns / 1ps

// Simple testbench for SHA256 hardware with "abc" test vector
module SHA256_simple_tb;

    // Clock and reset
    reg clk;
    reg reset;
    reg start_in;
    
    // SHA256 initial hash values (standard SHA256 constants)
    reg [31:0] A_i, B_i, C_i, D_i, E_i, F_i, G_i, H_i;
    
    // W inputs for SHA256 message schedule (for "abc" + padding)
    reg [31:0] w0_sha256, w1_sha256, w2_sha256, w3_sha256;
    reg [31:0] w4_sha256, w5_sha256, w6_sha256, w7_sha256;
    reg [31:0] w8_sha256, w9_sha256, w10_sha256, w11_sha256;
    reg [31:0] w12_sha256, w13_sha256, w14_sha256, w15_sha256;
    
    // Outputs
    wire [255:0] sha256_result;
    wire sha256_valid;
    
    // Expected SHA256("abc") result: ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
    localparam [255:0] EXPECTED_ABC_SHA256 = 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad;

    // Instantiate the DUT
    SHA256_Top dut (
        .clk(clk),
        .reset(reset),
        .start_in(start_in),
        .A_i(A_i), .B_i(B_i), .C_i(C_i), .D_i(D_i),
        .E_i(E_i), .F_i(F_i), .G_i(G_i), .H_i(H_i),
        .w0_sha256(w0_sha256),   .w1_sha256(w1_sha256),
        .w2_sha256(w2_sha256),   .w3_sha256(w3_sha256),
        .w4_sha256(w4_sha256),   .w5_sha256(w5_sha256),
        .w6_sha256(w6_sha256),   .w7_sha256(w7_sha256),
        .w8_sha256(w8_sha256),   .w9_sha256(w9_sha256),
        .w10_sha256(w10_sha256), .w11_sha256(w11_sha256),
        .w12_sha256(w12_sha256), .w13_sha256(w13_sha256),
        .w14_sha256(w14_sha256), .w15_sha256(w15_sha256),
        .sha256_result(sha256_result),
        .sha256_valid(sha256_valid)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns period)
    end

    // Test sequence
    initial begin
        $dumpfile("SHA256_simple_tb.vcd");
        $dumpvars(0, SHA256_simple_tb);
        
        // Initialize signals
        reset = 0;
        start_in = 0;
        
        // Standard SHA256 initial hash values
        A_i = 32'h6a09e667;  B_i = 32'hbb67ae85;  C_i = 32'h3c6ef372;  D_i = 32'ha54ff53a;
        E_i = 32'h510e527f;  F_i = 32'h9b05688c;  G_i = 32'h1f83d9ab;  H_i = 32'h5be0cd19;
        
        // Message schedule for "abc" (padded to 512 bits)
        // "abc" = 0x616263, padded with 1 bit, then zeros, then length = 24 bits
        w0_sha256  = 32'h61626380; // "abc" + padding bit
        w1_sha256  = 32'h00000000;
        w2_sha256  = 32'h00000000;
        w3_sha256  = 32'h00000000;
        w4_sha256  = 32'h00000000;
        w5_sha256  = 32'h00000000;
        w6_sha256  = 32'h00000000;
        w7_sha256  = 32'h00000000;
        w8_sha256  = 32'h00000000;
        w9_sha256  = 32'h00000000;
        w10_sha256 = 32'h00000000;
        w11_sha256 = 32'h00000000;
        w12_sha256 = 32'h00000000;
        w13_sha256 = 32'h00000000;
        w14_sha256 = 32'h00000000;
        w15_sha256 = 32'h00000018; // Length = 24 bits
        
        // Apply reset
        #10 reset = 1;
        #20 reset = 0;
        
        // Wait a few cycles
        #30;
        
        // Start SHA256 computation
        $display("Starting SHA256 computation for 'abc'");
        $display("Expected result: %h", EXPECTED_ABC_SHA256);
        start_in = 1;
        #10 start_in = 0;
        
        // Wait for completion or timeout
        fork
            begin
                wait(sha256_valid);
                #10;
                
                $display("SHA256 computation completed");
                $display("Result:   %h", sha256_result);
                $display("Expected: %h", EXPECTED_ABC_SHA256);
                
                if (sha256_result == EXPECTED_ABC_SHA256) begin
                    $display("✓ TEST PASSED: SHA256('abc') result matches expected value");
                end else begin
                    $display("✗ TEST FAILED: SHA256('abc') result mismatch");
                end
            end
            begin
                #10000; // 10µs timeout
                $display("✗ TEST TIMEOUT: SHA256 computation did not complete in time");
            end
        join_any
        
        #100;
        $finish;
    end
    
    // Monitor
    always @(posedge sha256_valid) begin
        $display("@%0t: SHA256 result ready: %h", $time, sha256_result);
    end

endmodule