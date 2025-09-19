`timescale 1ns / 1ps

module k_register_array_tb;

    // Inputs
    reg clk;
    reg rst;
    reg ena_K_reg;

    // Outputs
    wire [31:0] K_out;

    // Instantiate the Unit Under Test (UUT)
    k_register_array uut (
        .clk(clk),
        .rst(rst),
        .ena_K_reg(ena_K_reg),
        .K_out(K_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        rst = 0;
        ena_K_reg = 0;

        // Apply reset
        #10 rst = 1; // Release reset

        // Test case 1: Enable K register
        #10 ena_K_reg = 1; // Enable the counter
        #640; // Wait for all 64 values to be output

        // Test case 2: Disable K register
        #10 ena_K_reg = 0; // Disable the counter
        #50; // Wait for some time to ensure K_out holds its last value

        // Test case 3: Re-enable K register
        #10 ena_K_reg = 1; // Re-enable the counter
        #320; // Check the outputs again for half the cycle

        // End simulation
        #50 $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | rst: %b | ena_K_reg: %b | K_out: %h", 
                 $time, rst, ena_K_reg, K_out);
    end

endmodule