`timescale 1ns / 1ps

// SHA256 Top-level module for FPGA implementation
// This is the synthesizable top-level module, not the testbench
module SHA256_Top (
    input clk,
    input reset,
    input start_in,
    
    // SHA256 initial hash values input
    input [31:0] A_i,
    input [31:0] B_i,
    input [31:0] C_i,
    input [31:0] D_i,
    input [31:0] E_i,
    input [31:0] F_i,
    input [31:0] G_i,
    input [31:0] H_i,

    // W inputs for SHA256 (message schedule)
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
    
    // SHA256 result outputs
    output [255:0] sha256_result,
    output sha256_valid
);

    // Instantiate the main SHA256 design
    RISC_SHA risc_sha_inst (
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
        .sha256_result(sha256_result),
        .sha256_valid(sha256_valid)
    );

endmodule