`timescale 1ns / 1ps

module RISC_Sha_tb;

    // Inputs
    reg clk;
    reg rst;
    reg start_sha;
    reg [31:0] A_i_r;
    reg [31:0] B_i_r;
    reg [31:0] C_i_r;
    reg [31:0] D_i_r;
    reg [31:0] E_i_r;
    reg [31:0] F_i_r;
    reg [31:0] G_i_r;
    reg [31:0] H_i_r;

    // Test vectors for multiple test inputs
    reg [31:0] test_vectors_sha256 [0:2][0:7]; // 3 test cases, 8 values each (A-H)
    
    // W input test vectors (using simple test patterns)
    reg [31:0] w_sha256 [0:15];
    
    integer test_case;
    integer i;  // Loop variable for Verilog-2001 compatibility

    // Outputs from UUT
    wire [255:0] sha256_result;
    wire sha256_valid;

    // Instantiate the Unit Under Test (UUT)
    RISC_SHA uut (
        .clk(clk),
        .reset(rst),
        .start_in(start_sha),
        .A_i(A_i_r),
        .B_i(B_i_r),
        .C_i(C_i_r),
        .D_i(D_i_r),
        .E_i(E_i_r),
        .F_i(F_i_r),
        .G_i(G_i_r),
        .H_i(H_i_r),
        // W inputs for SHA256
        .w0_sha256(w_sha256[0]),
        .w1_sha256(w_sha256[1]),
        .w2_sha256(w_sha256[2]),
        .w3_sha256(w_sha256[3]),
        .w4_sha256(w_sha256[4]),
        .w5_sha256(w_sha256[5]),
        .w6_sha256(w_sha256[6]),
        .w7_sha256(w_sha256[7]),
        .w8_sha256(w_sha256[8]),
        .w9_sha256(w_sha256[9]),
        .w10_sha256(w_sha256[10]),
        .w11_sha256(w_sha256[11]),
        .w12_sha256(w_sha256[12]),
        .w13_sha256(w_sha256[13]),
        .w14_sha256(w_sha256[14]),
        .w15_sha256(w_sha256[15]),
        // Outputs
        .sha256_result(sha256_result),
        .sha256_valid(sha256_valid)
    );

    // Clock generation
    initial begin
        $dumpfile("RISC_Sha_tb.vcd");
        $dumpvars(0, RISC_Sha_tb);

        // Initialize test vectors for SHA256
        // Test case 0: Standard SHA256 initial values
        test_vectors_sha256[0][0] = 32'h6A09E667; // A
        test_vectors_sha256[0][1] = 32'hBB67AE85; // B
        test_vectors_sha256[0][2] = 32'h3C6EF372; // C
        test_vectors_sha256[0][3] = 32'hA54FF53A; // D
        test_vectors_sha256[0][4] = 32'h510E527F; // E
        test_vectors_sha256[0][5] = 32'h9B05688C; // F
        test_vectors_sha256[0][6] = 32'h1F83D9AB; // G
        test_vectors_sha256[0][7] = 32'h5BE0CD19; // H

        // Test case 1: Modified values for additional testing
        test_vectors_sha256[1][0] = 32'h12345678;
        test_vectors_sha256[1][1] = 32'h9ABCDEF0;
        test_vectors_sha256[1][2] = 32'hFEDCBA98;
        test_vectors_sha256[1][3] = 32'h76543210;
        test_vectors_sha256[1][4] = 32'h11111111;
        test_vectors_sha256[1][5] = 32'h22222222;
        test_vectors_sha256[1][6] = 32'h33333333;
        test_vectors_sha256[1][7] = 32'h44444444;

        // Test case 2: Another set of test values
        test_vectors_sha256[2][0] = 32'hAAAAAAAA;
        test_vectors_sha256[2][1] = 32'hBBBBBBBB;
        test_vectors_sha256[2][2] = 32'hCCCCCCCC;
        test_vectors_sha256[2][3] = 32'hDDDDDDDD;
        test_vectors_sha256[2][4] = 32'hEEEEEEEE;
        test_vectors_sha256[2][5] = 32'hFFFFFFFF;
        test_vectors_sha256[2][6] = 32'h00000000;
        test_vectors_sha256[2][7] = 32'h12345678;
        
        // Initialize W vectors with simple test patterns
        // For SHA256 (32-bit values)
        w_sha256[0] = 32'h61626380;  // "abc" message first word (padded)
        w_sha256[1] = 32'h00000000;
        w_sha256[2] = 32'h00000000;
        w_sha256[3] = 32'h00000000;
        w_sha256[4] = 32'h00000000;
        w_sha256[5] = 32'h00000000;
        w_sha256[6] = 32'h00000000;
        w_sha256[7] = 32'h00000000;
        w_sha256[8] = 32'h00000000;
        w_sha256[9] = 32'h00000000;
        w_sha256[10] = 32'h00000000;
        w_sha256[11] = 32'h00000000;
        w_sha256[12] = 32'h00000000;
        w_sha256[13] = 32'h00000000;
        w_sha256[14] = 32'h00000000;
        w_sha256[15] = 32'h00000018; // Length = 24 bits for "abc"
        
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic with multiple test cases
    initial begin
        // Initialize inputs
        start_sha = 0;
        test_case = 0;

        // Apply reset
        rst = 0; // Active-low reset
        #10 rst = 1; // Release reset

        // Run multiple test cases
        for (test_case = 0; test_case < 3; test_case = test_case + 1) begin
            $display("========================================");
            $display("Starting Test Case %0d", test_case);
            $display("========================================");
            
            // Load test vectors for current test case
            A_i_r = test_vectors_sha256[test_case][0];
            B_i_r = test_vectors_sha256[test_case][1];
            C_i_r = test_vectors_sha256[test_case][2];
            D_i_r = test_vectors_sha256[test_case][3];
            E_i_r = test_vectors_sha256[test_case][4];
            F_i_r = test_vectors_sha256[test_case][5];
            G_i_r = test_vectors_sha256[test_case][6];
            H_i_r = test_vectors_sha256[test_case][7];

            $display("SHA256 Input Values:");
            $display("A=%h, B=%h, C=%h, D=%h", A_i_r, B_i_r, C_i_r, D_i_r);
            $display("E=%h, F=%h, G=%h, H=%h", E_i_r, F_i_r, G_i_r, H_i_r);

            // Wait a few cycles before starting
            #20;
            
            // Start the FSM
            start_sha = 1;
            #10;
            start_sha = 0;

            // Wait for test to complete (need more time for SHA256 computation)
            // Check result periodically during computation
            for (i = 0; i < 200; i = i + 1) begin
                #10;
                if (sha256_valid) begin
                    $display("SHA256 computation completed at time %0t", $time);
                    $display("SHA256 Result: %h", sha256_result);
                    i = 200; // Break out of loop
                end
            end
            
            // Final check
            if (!sha256_valid) begin
                $display("SHA256 computation not completed, checking final result anyway");
                $display("SHA256 Result: %h (may not be valid)", sha256_result);
            end
            
            $display("Test Case %0d completed", test_case);
            if (sha256_valid) begin
                $display("SHA256 Result: %h", sha256_result);
            end else begin
                $display("SHA256 Result: Not valid yet");
            end
            $display("----------------------------------------");
            
            // Reset for next test case if not the last one
            if (test_case < 2) begin
                rst = 0;
                #10;
                rst = 1;
                #10;
            end
        end

        $display("All test cases completed");
        $finish;
    end

    // Monitor outputs for all test cases
    initial begin
        $monitor("Time: %0t | Test Case: %0d | rst: %b | start_sha: %b | A_i: %h | B_i: %h", 
                 $time, test_case, rst, start_sha, A_i_r, B_i_r);
    end

    // Additional monitoring for debug
    initial begin
        forever begin
            #10;
            if (start_sha) begin
                $display("FSM Debug: Time: %0t | start_sha: %b | sha256_valid: %b", 
                         $time, start_sha, sha256_valid);
            end
        end
    end

endmodule