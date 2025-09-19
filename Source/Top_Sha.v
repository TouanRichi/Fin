module RISC_SHA (
    input clk,
    input reset,
    input start_in,
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
    
    // SHA256 result outputs
    output [255:0] sha256_result,
    output sha256_valid
);

// FSM Signals
    wire start_sha_o_w;
    wire sel_mux_w;
    wire ena_K_reg_w;
    wire sel_parise_mux_w;
    wire [31:0] reg16_out_w;
    wire [31:0] A_o_w;
    wire [31:0] B_o_w;
    wire [31:0] C_o_w;
    wire [31:0] D_o_w;
    wire [31:0] E_o_w;
    wire [31:0] F_o_w;
    wire [31:0] G_o_w;
    wire [31:0] H_o_w;

// Mux Signals
    wire [31:0] data_o_mux_w;

// Reg0 Signals
    wire [31:0] data_o_reg0_w;
    wire [31:0] data_o2_reg0_w;
    wire [31:0] data_regH_o_w;
    wire sel_mux_o_w;

// Reg1 Signals
    wire [31:0] data_o_reg1_w;

// Reg2 Signals
    wire [31:0] data_o_reg2_w;

// Reg3 Signals
    wire [31:0] data_o_reg3_w;

// Reg4 Signals
    wire [31:0] data_o_reg4_w;

// Reg5 Signals
    wire [31:0] data_o_reg5_w;

// Reg6 Signals
    wire [31:0] data_o_reg6_w;

// Reg7 Signals
    wire [31:0] data_o_reg7_w;

// Reg8 Signals
    wire [31:0] data_o_reg8_w;

// Reg9 Signals
    wire [31:0] data_o_reg9_w;

// Reg10 Signals
    wire [31:0] data_o_reg10_w;

// Reg11 Signals
    wire [31:0] data_o_reg11_w;

// Reg12 Signals
    wire [31:0] data_o_reg12_w;

// Reg13 Signals
    wire [31:0] data_o_reg13_w;

// Reg14 Signals
    wire [31:0] data_o_reg14_w;

// Reg15 Signals
    wire [31:0] data_o_reg15_w;

// Delta signals
    wire [31:0] delta0_out_w;

// Delta1 Signals
    wire [31:0] delta1_out_w;

// Adder Signals
    wire [31:0] data_o_adder_w;

// K_register Signals
    wire [31:0] k_reg_o_w;    

// Adder1 Signals
    wire [31:0] data_o_adder1_w;

wire sel_res256_w;
wire sel_res512_w = 1'b0;  // Always 0 since we only use SHA256

// SHA512 signals tied to inactive values since we only use SHA256
wire sel_mux_w2 = 1'b0;
wire ena_K_reg_w2 = 1'b0;
wire sel_parise_mux_w2 = 1'b0;
wire [63:0] reg16_out_w2 = 64'h0;
wire [63:0] A_o_w2 = 64'h0;
wire [63:0] B_o_w2 = 64'h0;
wire [63:0] C_o_w2 = 64'h0;
wire [63:0] D_o_w2 = 64'h0;
wire [63:0] E_o_w2 = 64'h0;
wire [63:0] F_o_w2 = 64'h0;
wire [63:0] G_o_w2 = 64'h0;
wire [63:0] H_o_w2 = 64'h0;

// Additional SHA512 signals needed by the pipeline
wire [63:0] data_o_mux_w2;
wire [63:0] data_o_reg0_w2, data_o2_reg0_w2, data_regH_o_w2;
wire sel_mux_o_w2;
wire [63:0] data_o_reg1_w2, data_o_reg2_w2, data_o_reg3_w2, data_o_reg4_w2;
wire [63:0] data_o_reg5_w2, data_o_reg6_w2, data_o_reg7_w2, data_o_reg8_w2;
wire [63:0] data_o_reg9_w2, data_o_reg10_w2, data_o_reg11_w2, data_o_reg12_w2;
wire [63:0] data_o_reg13_w2, data_o_reg14_w2, data_o_reg15_w2;
wire [63:0] delta0_out_w2, delta1_out_w2, data_o_adder_w2;
wire [63:0] k_reg_o_w2, data_o_adder1_w2;

fsm_controller fsm_controller (
    .clk(clk),
    .rst(reset),
    .start_sha(start_in),

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

    .A_i(A_i),
    .B_i(B_i),
    .C_i(C_i),
    .D_i(D_i),
    .E_i(E_i),
    .F_i(F_i),
    .G_i(G_i),
    .H_i(H_i),
    
    .start_sha_o(start_sha_o_w),

    .sel_mux(sel_mux_w),

    .sel_res256(sel_res256_w),

    .ena_K_reg(ena_K_reg_w),

    .sel_parise_mux(sel_parise_mux_w),
    
    .reg16_out(reg16_out_w),
    
    .A_o(A_o_w),
    .B_o(B_o_w),
    .C_o(C_o_w),
    .D_o(D_o_w),
    .E_o(E_o_w),
    .F_o(F_o_w),
    .G_o(G_o_w),
    .H_o(H_o_w)
    
);

mux32_2to1 mux32_2to1 (
    .data0_i(reg16_out_w),
    .data1_i(data_o_adder_w), // 
    .sel_i(sel_mux_w),
    .data_o(data_o_mux_w)
);


register0_32bit Reg0(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .sel_mux(sel_parise_mux_w),
    .data_i(data_o_mux_w),
    .data_i2(k_reg_o_w),
    .data_regH_i(reg_H_o_w),
    .sel_mux_o(sel_mux_o_w),
    .data_o(data_o_reg0_w),
    .data_o2(data_o2_reg0_w),
    .data_regH_o(data_regH_o_w)  
);

register1_32bit Reg1(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg0_w),
    .data_o(data_o_reg1_w) 
);

register2_32bit Reg2(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg1_w),
    .data_o(data_o_reg2_w) 
);

register3_32bit Reg3(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg2_w),
    .data_o(data_o_reg3_w) 
);

register4_32bit Reg4(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg3_w),
    .data_o(data_o_reg4_w) 
);

register5_32bit Reg5(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg4_w),
    .data_o(data_o_reg5_w) 
);

register6_32bit Reg6(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg5_w),
    .data_o(data_o_reg6_w) 
);

register7_32bit Reg7(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg6_w),
    .data_o(data_o_reg7_w) 
);

register8_32bit Reg8(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg7_w),
    .data_o(data_o_reg8_w) 
);

register9_32bit Reg9(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg8_w),
    .data_o(data_o_reg9_w) 
);

register10_32bit Reg10(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg9_w),
    .data_o(data_o_reg10_w) 
);

register11_32bit Reg11(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg10_w),
    .data_o(data_o_reg11_w) 
);

register12_32bit Reg12(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg11_w),
    .data_o(data_o_reg12_w) 
);

register13_32bit Reg13(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg12_w),
    .data_o(data_o_reg13_w) 
);

register14_32bit Reg14(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg13_w),
    .data_o(data_o_reg14_w) 
);

register15_32bit Reg15(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg14_w),
    .data_o(data_o_reg15_w) 
);

delta0 delta0 (
    .w1(data_o_reg14_w),
    .delta0(delta0_out_w)
);

delta1 delta1 (
    .w14(data_o_reg1_w),
    .delta1(delta1_out_w)
);

Adder_Sha Adder (
    .in1(delta1_out_w),
    .in2(data_o_reg6_w),
    .in3(delta0_out_w),
    .in4(data_o_reg15_w),
    .sum(data_o_adder_w)
);

K_register K_register (
    .clk(clk),
    .rst(reset),
    .ena_K_reg(ena_K_reg_w),
    .K_out(k_reg_o_w)
);

Adder1 Adder1 (
    .in1(data_o_reg0_w),
    .in2(data_o2_reg0_w),
    // .in3(data_regH_o_w),reg_H_o_w
    .in3(reg_H_o_w),
    .sum(data_o_adder1_w)
);

// pairwise_mux
wire [31:0] pairwise_mux_a_out_w;
wire [31:0] pairwise_mux_b_out_w;
wire [31:0] pairwise_mux_c_out_w;
wire [31:0] pairwise_mux_d_out_w;
wire [31:0] pairwise_mux_e_out_w;
wire [31:0] pairwise_mux_f_out_w;
wire [31:0] pairwise_mux_g_out_w;
wire [31:0] pairwise_mux_h_out_w;

pairwise_mux pairwise_mux (
    // .sel(sel_mux_o_w),
    // .sel_A(data_o_reg32_w), // tín hiệu chọn cho cặp A

    .sel(sel_mux_o_w || data_o_reg32_w), // tín hiệu chọn cho tất cả các cặp
    .sel_A(sel_mux_o_w || data_o_reg32_w), // tín hiệu chọn cho cặp A
    .a1(A_o_w),
    .a2(data_o_adder4_w), // NONE
    .b1(B_o_w),
    .b2(reg_A_o_w),
    .c1(C_o_w),
    .c2(reg_B_o_w),
    .d1(D_o_w),
    .d2(reg_C_o_w),
    .e1(E_o_w),
    .e2(data_o_adder3_w), // tín hiệu của Adder3 của Reg_D
    .f1(F_o_w),
    .f2(reg_E_o_w),
    .g1(G_o_w),
    .g2(reg_F_o_w),
    .h1(H_o_w),
    .h2(reg_G_o_w),
    .a_out(pairwise_mux_a_out_w),
    .b_out(pairwise_mux_b_out_w),
    .c_out(pairwise_mux_c_out_w),
    .d_out(pairwise_mux_d_out_w),
    .e_out(pairwise_mux_e_out_w),
    .f_out(pairwise_mux_f_out_w),
    .g_out(pairwise_mux_g_out_w),
    .h_out(pairwise_mux_h_out_w)
);


wire [31:0] reg_A_o_w;
registerA_32bit RegA(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_a_out_w), // none
    .data_o(reg_A_o_w)
);

wire [31:0] reg_B_o_w;
registerB_32bit RegB(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_b_out_w),
    .data_o(reg_B_o_w)
);

wire [31:0] reg_C_o_w;
registerC_32bit RegC(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_c_out_w),
    .data_o(reg_C_o_w)
);

wire [31:0] reg_D_o_w;
registerD_32bit RegD(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_d_out_w),
    .data_o(reg_D_o_w)
);

wire [31:0] reg_E_o_w;
registerE_32bit RegE(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_e_out_w),
    .data_o(reg_E_o_w)
);

wire [31:0] reg_F_o_w;
registerF_32bit RegF(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_f_out_w),
    .data_o(reg_F_o_w)
);

wire [31:0] reg_G_o_w;
registerG_32bit RegG(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_g_out_w),
    .data_o(reg_G_o_w)
);

wire [31:0] reg_H_o_w;
registerH_32bit RegH(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_h_out_w),
    .data_o(reg_H_o_w)
);

wire [31:0] data_o_CH_w;
Choice CH (
    .e(reg_E_o_w),
    .f(reg_F_o_w),
    .g(reg_G_o_w),
    .out(data_o_CH_w)
);

wire [31:0] data_o_sigma1_w;
Sigma1 sigma1 (
    .e(reg_E_o_w),
    .out(data_o_sigma1_w)
);

wire [31:0] data_o_adder2_w;
Adder2 Adder2 (
    .in1(data_o_CH_w),
    .in2(data_o_adder1_w),
    .in3(data_o_sigma1_w),
    .sum(data_o_adder2_w)
);

// Adder3 Signals
    wire [31:0] data_o_adder3_w;
Adder3 Adder3 (
    .in1(data_o_adder2_w),
    .in2(reg_D_o_w), // reg_D_o_w
    .sum(data_o_adder3_w)
);

// Maj Signals
    wire [31:0] data_o_Maj_w;
Majority Majority (
    .A(reg_A_o_w),
    .B(reg_B_o_w),
    .C(reg_C_o_w),
    .M(data_o_Maj_w)
);

// Sigma0 Signals
    wire [31:0] data_o_sigma0_w;
Sigma0 Sigma0 (
    .a(reg_A_o_w),
    .out(data_o_sigma0_w)
);

// Adder4 Signals
    wire [31:0] data_o_adder4_w;
Adder4 Adder4 (
    .in1(data_o_Maj_w),
    .in2(data_o_sigma0_w),
    .in3(data_o_adder2_w), // reg_A_o_w
    .sum(data_o_adder4_w)
);

// registerI_32bit signals
    wire [31:0] data_o_regI_w;
    wire [31:0] data_o2_regI_w;
    wire [31:0] data_o3_regI_w;

registerI_32bit RegI(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(reg_E_o_w),
    .data_i2(reg_F_o_w),
    .data_i3(reg_G_o_w),
    .data_o(data_o_regI_w),
    .data_o2(data_o2_regI_w),
    .data_o3(data_o3_regI_w)
);

// registerJ_32bit signals
    wire [31:0] data_o_regJ_w;
    wire [31:0] data_o2_regJ_w;
    wire [31:0] data_o3_regJ_w;
    wire [31:0] data_o4_regJ_w;

registerJ_32bit RegJ(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(reg_D_o_w),  // reg_D_o_w
    .data_i2(reg_C_o_w), // reg_C_o_w
    .data_i3(reg_B_o_w), // reg_B_o_w
    .data_i4(reg_A_o_w), // reg_A_o_w
    .data_o(data_o_regJ_w), 
    .data_o2(data_o2_regJ_w),
    .data_o3(data_o3_regJ_w),
    .data_o4(data_o4_regJ_w)
);

// Reg32 Signals
    wire data_o_reg32_w; // 1 bit

register_32bit Reg32(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .sel_A(sel_mux_o_w), // reg_D_o_w
    .sel_A_o(data_o_reg32_w) 
);


// top for 64bit - REMOVED: SHA512 logic disabled
//------------- SHA 384, 512 --------------//

mux32_2to1_64bit mux32_2to1_64bit (
    .data0_i(reg16_out_w2),
    .data1_i(data_o_adder_w2), // 
    .sel_i(sel_mux_w2),
    .data_o(data_o_mux_w2)
);

register0_64bit Reg0_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .sel_mux(sel_parise_mux_w2),
    .data_i(data_o_mux_w2),
    .data_i2(k_reg_o_w2),
    .data_regH_i(reg_H_o_w2),
    .sel_mux_o(sel_mux_o_w2),
    .data_o(data_o_reg0_w2),
    .data_o2(data_o2_reg0_w2),
    .data_regH_o(data_regH_o_w2)  
);

register1_64bit Reg1_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg0_w2),
    .data_o(data_o_reg1_w2) 
);

register2_64bit Reg2_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg1_w2),
    .data_o(data_o_reg2_w2) 
);

register3_64bit Reg3_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg2_w2),
    .data_o(data_o_reg3_w2) 
);

register4_64bit Reg4_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg3_w2),
    .data_o(data_o_reg4_w2) 
);

register5_64bit Reg5_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg4_w2),
    .data_o(data_o_reg5_w2) 
);

register6_64bit Reg6_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg5_w2),
    .data_o(data_o_reg6_w2) 
);

register7_64bit Reg7_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg6_w2),
    .data_o(data_o_reg7_w2) 
);

register8_64bit Reg8_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg7_w2),
    .data_o(data_o_reg8_w2) 
);

register9_64bit Reg9_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg8_w2),
    .data_o(data_o_reg9_w2) 
);

register10_64bit Reg10_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg9_w2),
    .data_o(data_o_reg10_w2) 
);

register11_64bit Reg11_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg10_w2),
    .data_o(data_o_reg11_w2) 
);

register12_64bit Reg12_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg11_w2),
    .data_o(data_o_reg12_w2) 
);

register13_64bit Reg13_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg12_w2),
    .data_o(data_o_reg13_w2) 
);

register14_64bit Reg14_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg13_w2),
    .data_o(data_o_reg14_w2) 
);

register15_64bit Reg15_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(data_o_reg14_w2),
    .data_o(data_o_reg15_w2) 
);





// Sigma0 Signals
    wire [63:0] data_o_sigma0_w2;
delta0_64bit delta0_64bit (
    .x(data_o_reg14_w2),
    .out(delta0_out_w2)
);

wire [63:0] data_o_sigma1_w2;   ///NONEE
delta1_64bit delta1_64bit (
    .x(data_o_reg1_w2), 
    .out(delta1_out_w2)
);

/// NONEE
Sigma0_64bit Sigma0_64bit (
    .x(reg_A_o_w2), 
    .out(data_o_sigma0_w2) 
);

Sigma1_64bit Sigma1_64bit (
    .x(reg_E_o_w2),
    .out(data_o_sigma1_w2)
);

Adder_64bit Adder_64bit (
    .in1(delta1_out_w2),
    .in2(data_o_reg6_w2),
    .in3(delta0_out_w2),
    .in4(data_o_reg15_w2),
    .sum(data_o_adder_w2)
);

K_register_64bit K_register_64bit (
    .clk(clk),
    .rst(reset),
    .ena_K_reg(ena_K_reg_w),
    .K_out(k_reg_o_w2)
);

Adder1_64bit Adder1_64bit (
    .in1(data_o_reg0_w2),
    .in2(data_o2_reg0_w2),
    .in3(reg_H_o_w2), //reg_H_o_w
    .sum(data_o_adder1_w2)
);

// pairwise_mux
wire [63:0] pairwise_mux_a_out_w2;
wire [63:0] pairwise_mux_b_out_w2;
wire [63:0] pairwise_mux_c_out_w2;
wire [63:0] pairwise_mux_d_out_w2;
wire [63:0] pairwise_mux_e_out_w2;
wire [63:0] pairwise_mux_f_out_w2;
wire [63:0] pairwise_mux_g_out_w2;
wire [63:0] pairwise_mux_h_out_w2;

pairwise_mux_64bit pairwise_mux_64bit (
    .sel(sel_mux_o_w2 || data_o_reg32_w2), // tín hiệu chọn cho tất cả các cặp
    .sel_A(sel_mux_o_w2 || data_o_reg32_w2), // tín hiệu chọn cho cặp A
    .a1(A_o_w2),
    .a2(data_o_adder4_w2), // NONE
    .b1(B_o_w2),
    .b2(reg_A_o_w2),
    .c1(C_o_w2),
    .c2(reg_B_o_w2),
    .d1(D_o_w2),
    .d2(reg_C_o_w2),
    .e1(E_o_w2),
    .e2(data_o_adder3_w2), // tín hiệu của Adder3 của Reg_D
    .f1(F_o_w2),
    .f2(reg_E_o_w2),
    .g1(G_o_w2),
    .g2(reg_F_o_w2),
    .h1(H_o_w2),
    .h2(reg_G_o_w2),
    .a_out(pairwise_mux_a_out_w2),
    .b_out(pairwise_mux_b_out_w2),
    .c_out(pairwise_mux_c_out_w2),
    .d_out(pairwise_mux_d_out_w2),
    .e_out(pairwise_mux_e_out_w2),
    .f_out(pairwise_mux_f_out_w2),
    .g_out(pairwise_mux_g_out_w2),
    .h_out(pairwise_mux_h_out_w2)
);

wire [63:0] reg_A_o_w2;
registerA_64bit RegA_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_a_out_w2), // none
    .data_o(reg_A_o_w2)
);

wire [63:0] reg_B_o_w2;
registerB_64bit RegB_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_b_out_w2),
    .data_o(reg_B_o_w2)
);

wire [63:0] reg_C_o_w2;
registerC_64bit RegC_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_c_out_w2),
    .data_o(reg_C_o_w2)
);

wire [63:0] reg_D_o_w2;
registerD_64bit RegD_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_d_out_w2),
    .data_o(reg_D_o_w2)
);

wire [63:0] reg_E_o_w2;
registerE_64bit RegE_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_e_out_w2),
    .data_o(reg_E_o_w2)
);

wire [63:0] reg_F_o_w2;
registerF_64bit RegF_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_f_out_w2),
    .data_o(reg_F_o_w2)
);

wire [63:0] reg_G_o_w2;
registerG_64bit RegG_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_g_out_w2),
    .data_o(reg_G_o_w2)
);

wire [63:0] reg_H_o_w2;
registerH_64bit RegH_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .data_i(pairwise_mux_h_out_w2),
    .data_o(reg_H_o_w2)
);

wire [63:0] data_o_CH_w2;
Choice_64bit CH_64bit (
    .e(reg_E_o_w2),
    .f(reg_F_o_w2),
    .g(reg_G_o_w2),
    .out(data_o_CH_w2)
);
 // NONE

wire [63:0] data_o_adder2_w2;
Adder2_64bit Adder2_64bit (
    .in1(data_o_CH_w2),
    .in2(data_o_adder1_w2),
    .in3(data_o_sigma1_w2),
    .sum(data_o_adder2_w2)
);

// Adder3 Signals
    wire [63:0] data_o_adder3_w2;
Adder3_64bit Adder3_64bit (
    .in1(data_o_adder2_w2),
    .in2(reg_D_o_w2), // reg_D_o_w
    .sum(data_o_adder3_w2)
);

// Maj Signals
    wire [63:0] data_o_Maj_w2;
Majority_64bit Majority_64bit (
    .A(reg_A_o_w2),
    .B(reg_B_o_w2),
    .C(reg_C_o_w2),
    .M(data_o_Maj_w2)
);



// Adder4 Signals
    wire [63:0] data_o_adder4_w2;
Adder4_64bit Adder4_64bit (
    .in1(data_o_Maj_w2),
    .in2(data_o_sigma0_w2),
    .in3(data_o_adder2_w2), // reg_A_o_w
    .sum(data_o_adder4_w2)
);

// không cần tín hiệu và instance của registerI_32bit

//Reg32_64bit Signals
    wire data_o_reg32_w2; // 1 bit
register_64bit Reg32_64bit(
    .CLK(clk),
    .RST(reset),
    .start(start_sha_o_w),
    .sel_A(sel_mux_o_w2), // reg_D_o_w
    .sel_A_o(data_o_reg32_w2) 
);

// wire for sha256
wire [255:0] res_sha256_w;
wire [511:0] res_sha512_w;

Reg_res_sha Reg_res_sha (
    .clk(clk),
    .rst(reset),
    .sel_res256(sel_res256_w),
    .sel_res512(sel_res512_w),
    .data_H0(reg_A_o_w),    // Use computed SHA256 results, not inputs
    .data_H1(reg_B_o_w),
    .data_H2(reg_C_o_w),
    .data_H3(reg_D_o_w),
    .data_H4(reg_E_o_w),
    .data_H5(reg_F_o_w),
    .data_H6(reg_G_o_w),
    .data_H7(reg_H_o_w),

    .data_A(reg_A_o_w),     // Final SHA256 hash values
    .data_B(reg_B_o_w),
    .data_C(reg_C_o_w),
    .data_D(reg_D_o_w),
    .data_E(reg_E_o_w),
    .data_F(reg_F_o_w),
    .data_G(reg_G_o_w),
    .data_H(reg_H_o_w),

    .data2_H0(64'h0),
    .data2_H1(64'h0),
    .data2_H2(64'h0),
    .data2_H3(64'h0),
    .data2_H4(64'h0),
    .data2_H5(64'h0),
    .data2_H6(64'h0),
    .data2_H7(64'h0),

    .data2_A(64'h0),
    .data2_B(64'h0),
    .data2_C(64'h0),
    .data2_D(64'h0),
    .data2_E(64'h0),
    .data2_F(64'h0),
    .data2_G(64'h0),
    .data2_H(64'h0),

    .res_sha256_o(res_sha256_w),
    .res_sha512_o(res_sha512_w)
);

wire [511:0] res_mux_sha_o_w;
mux_3to1_512bit mux_res_sha(
    .sel_mux_res_sha(2'b00),
    .in1(res_sha256_w),
    .in2(384'd0),
    .in3(res_sha512_w),
    .out(res_mux_sha_o_w)
);
//----------------- End SHA 384, 512 ------------------//

// Output assignments
assign sha256_result = res_sha256_w;
assign sha256_valid = sel_res256_w;  // Use sel_res256 as valid signal

endmodule
// sha256_reg16