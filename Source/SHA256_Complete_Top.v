`timescale 1ns / 1ps

// Complete SHA256 Top-level module for FPGA implementation
// This version includes both simplified logic AND the original RISC_SHA design
module SHA256_Complete_Top (
    input clk,
    input reset,
    input start_in,
    
    // Simplified interface
    input [31:0] message_word0,
    input [31:0] message_word1, 
    input [31:0] message_word2,
    input [31:0] message_word3,
    
    // Full interface for original design
    input [31:0] A_i,
    input [31:0] B_i,
    input [31:0] C_i,
    input [31:0] D_i,
    input [31:0] E_i,
    input [31:0] F_i,
    input [31:0] G_i,
    input [31:0] H_i,
    input [31:0] w0_sha256,
    input [31:0] w1_sha256,
    input [31:0] w2_sha256,
    input [31:0] w3_sha256,
    input [31:0] w4_sha256,
    input [31:0] w5_sha256,
    input [31:0] w6_sha256,
    input [31:0] w7_sha256,
    input [31:0] w8_sha256,
    input [31:0] w9_sha256,
    input [31:0] w10_sha256,
    input [31:0] w11_sha256,
    input [31:0] w12_sha256,
    input [31:0] w13_sha256,
    input [31:0] w14_sha256,
    input [31:0] w15_sha256,
    
    // Control input to select which design to use
    input use_original_design,
    
    // SHA256 result outputs
    output reg [255:0] sha256_result,
    output reg sha256_valid,
    
    // Additional debug outputs
    output [31:0] debug_counter,
    output design_active
);

    // Simplified design outputs
    wire [255:0] simple_sha256_result;
    wire simple_sha256_valid;
    
    // Original design outputs  
    wire [255:0] original_sha256_result;
    wire original_sha256_valid;

    // Instantiate simplified design
    SHA256_Top simple_design (
        .clk(clk),
        .reset(reset),
        .start_in(start_in),
        .message_word0(message_word0),
        .message_word1(message_word1),
        .message_word2(message_word2),
        .message_word3(message_word3),
        .sha256_result(simple_sha256_result),
        .sha256_valid(simple_sha256_valid),
        .debug_counter(debug_counter),
        .design_active(design_active)
    );
    
    // Instantiate original design
    RISC_SHA original_design (
        .clk(clk),
        .reset(reset),
        .start_in(start_in),
        .A_i(A_i),
        .B_i(B_i),
        .C_i(C_i),
        .D_i(D_i),
        .E_i(E_i),
        .F_i(F_i),
        .G_i(G_i),
        .H_i(H_i),
        .w0_sha256(w0_sha256),
        .w1_sha256(w1_sha256),
        .w2_sha256(w2_sha256),
        .w3_sha256(w3_sha256),
        .w4_sha256(w4_sha256),
        .w5_sha256(w5_sha256),
        .w6_sha256(w6_sha256),
        .w7_sha256(w7_sha256),
        .w8_sha256(w8_sha256),
        .w9_sha256(w9_sha256),
        .w10_sha256(w10_sha256),
        .w11_sha256(w11_sha256),
        .w12_sha256(w12_sha256),
        .w13_sha256(w13_sha256),
        .w14_sha256(w14_sha256),
        .w15_sha256(w15_sha256),
        .sha256_result(original_sha256_result),
        .sha256_valid(original_sha256_valid)
    );
    
    // Output multiplexer
    always @(*) begin
        if (use_original_design) begin
            sha256_result = original_sha256_result;
            sha256_valid = original_sha256_valid;
        end else begin
            sha256_result = simple_sha256_result;
            sha256_valid = simple_sha256_valid;
        end
    end

endmodule