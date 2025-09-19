module RISC_Top(
    input clk,
    input reset,
    input start_in,
    
	input [31:0] DMAD_addr_in,
	input [31:0] DMAD_data_in,
	input [7:0] DMAD_wea_in,

    input [31:0] DMAI_addr_in,
	input [31:0] DMAI_data_in,
	input [7:0] DMAI_wea_in,
	output state_done

    // output [31:0] inst_out
);

wire state_start;
wire [31:0] pc_nextt, pc, pc_next, pc_next1, pc_next2, pc_next3;
wire [31:0]  pc1, pc2, pc3, rd12, rd22, result_u, u_type, u_type3, u_type4;
wire [31:0] inst, inst1, inst2, inst3, inst4;
wire [4:0] alu_ctrl1, alu_ctrl2;
wire [2:0] alu_op, alu_op1;
wire lui, auipc, jal, jalr, mem_write, mem_read, alu_src, branch, mem_to_reg, reg_write; 
wire lui1, auipc1, jal1, jalr1, mem_write1, mem_read1, alu_src1, branch1, mem_to_reg1, reg_write1; 
wire lui2, auipc2, jal2, jalr2, mem_write2, mem_read2, alu_src2, branch2, mem_to_reg2, reg_write2; 
wire lui3, auipc3, jal3, jalr3, mem_write3, mem_read3, branch3, mem_to_reg3, reg_write3;
wire lui4, auipc4, mem_to_reg4;
wire reg_write4;

wire [31:0] rd1, rd2, rd11, rd23, rd_data, rd33;
wire [31:0] imm1, imm2;
wire [31:0] pc_imm, pc_imm3, pc_branch;
wire [31:0] result,result_load, result_load4, result_load5, result_load7;
wire signed [31:0] result1, result_load3, result2,result3;
wire [31:0] j_type, j_type4;
wire ecall, ecall1, ecall2, ecall3;
// ena_ins, wea;

wire [31:0] alo,data_ins, addr_ins, data_ins_d, addr_ins_d;
wire [7:0] we_ins, we_ins_d;
wire en_o_risc, en_o_risc_d;


// signal of custom Buffer 
wire [31:0] w1, w2, w3, w4, w5, w6, w7, w8, w22, w23;
wire load_temp, plus1, plus12, plus13;
wire load_temp1, plus11;
wire [31:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9,
            out10, out11, out12, out13, out14, out15, out16, out17, out18, out19,
            out20, out21, out22, out23, out24, out25, out26, out27, out28, out29,
            out30, out31, out32, out33, out34, out35, out36, out37, out38, out39,
            out40, out41, out42, out43, out44, out45, out46, out47, out48, out49,
            out50, out51, out52, out53, out54, out55, out56, out57, out58, out59,
            out60, out61, out62, out63, out64, out65, out66, out67, out68, out69,
            out70, out71, out72, out73, out74, out75, out76, out77, out78, out79,
            out80, out81, out82, out83, out84, out85, out86, out87, out88, out89,
            out90, out91, out92, out93, out94, out95, out96, out97, out98, out99,
            out100, out101, out102, out103, out104, out105, out106, out107, out108, out109,
            out110, out111, out112, out113, out114, out115, out116, out117, out118, out119,
            out120, out121, out122, out123, out124, out125, out126, out127;

wire [1:0] mode_aes, mode_aes2, mode_aes3;
wire AES_W,enable_AES;
wire [1:0] key_size, key_size2, key_size3;
wire AES_W2,enable_AES2;
wire AES_W3,enable_AES3;

// AES signal involve
wire [31:0] data_aes,addr_aes;
wire en_w_datamem; // tín hiệu này xor với en_w của datameme
wire done_aes_w;
wire done_AES;
wire [127:0] result_AES;

    PC PC(
        .clk(clk),
        .reset(reset),
        .pc_in(pc_nextt),
        .start(state_start),
        // .ecall_detected(ecall3),
        // .pc_ecall(pc3),

        .pc_out(pc)
        // .ena_ins(ena_ins),
        // .wea(wea)
    );

    PC_plus4 PC_plus4(
        .pc_in(pc),
        .pc_out(pc_next)
    );

    Reg1 Re1(
    .clk(clk),
    .reset(reset),
    .pc_plus4_in(pc_next),
    .pc_in(pc),
    .start(state_start),
    // .inst_in(inst),
    // .reg_write_in(reg_write),
    // .alu_op_in(alu_op),
    // .alu_src_in(alu_src),
    // .branch_in(branch),
    // .mem_to_reg_in(mem_to_reg),
    // .mem_write_in(mem_write),
    // .mem_read_in(mem_read),
    // .lui_in(lui),
    // .auipc_in(auipc),
    // .jal_in(jal),
    // .jalr_in(jalr),
    // .ecall_in(ecall),
     .load_temp_in(load_temp),
    .plus1_in(plus1),


    // Outputs
    // .lui_out(lui1),
    // .auipc_out(auipc1),
    // .jal_out(jal1),
    // .jalr_out(jalr1),
    // .mem_write_out(mem_write1),
    // .mem_read_out(mem_read1),
    // .alu_op_out(alu_op1),
    // .alu_src_out(alu_src1),
    // .branch_out(branch1),
    // .mem_to_reg_out(mem_to_reg1),
    // .reg_write_out(reg_write1),
    // .inst_out(inst1),
    // .ecall_out(ecall1)
    .pc_plus4_out(pc_next1),
    .pc_out(pc1),
    .load_temp_out(load_temp1),
    .plus1_out(plus11)

    );

Reg2 Re2 (
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .lui_in(lui),
    .auipc_in(auipc),
    .jal_in(jal),
    .jalr_in(jalr),
    .mem_write_in(mem_write),
    .mem_read_in(mem_read),
    .alu_ctrl_in(alu_ctrl1),
    .alu_src_in(alu_src),
    .branch_in(branch),
    .mem_to_reg_in(mem_to_reg),
    .reg_write_in(reg_write),
    .inst_in(inst),
    .pc_plus4_in(pc_next1),
    .pc_in(pc1),
    .rd1_in(rd1),
    .rd2_in(rd2),
    .imm1_in(imm1),
    .ecall_in(ecall),
    .AES_W_in(AES_W),
    .key_size_in(key_size),
    .mode_aes_in(mode_aes),
    .enable_AES_in(enable_AES),
    .re_adder_32_in(w3),
    .w2_in(w2),
    .plus1_in(plus1),
    .sel_mux_res_sha_in(sel_mux_res_sha_w),
    .start_sha_in(start_sha_w),
    

    // Outputs
    .lui_out(lui2),
    .auipc_out(auipc2),
    .jal_out(jal2),
    .jalr_out(jalr2),
    .mem_write_out(mem_write2),
    .mem_read_out(mem_read2),
    .alu_ctrl_out(alu_ctrl2),
    .alu_src_out(alu_src2),
    .branch_out(branch2),
    .mem_to_reg_out(mem_to_reg2),
    .reg_write_out(reg_write2),
    .inst_out(inst2),
    .pc_plus4_out(pc_next2),
    .pc_out(pc2),
    .rd1_out(rd12),
    .rd2_out(rd22),
    .imm1_out(imm2),
    .ecall_out(ecall2),
    .AES_W_out(AES_W2),
    .key_size_out(key_size2),
    .re_adder_32_out(w4),
    .w2_out(w22),
    .plus1_out(plus12),
    .mode_aes_out(mode_aes2),
    .enable_AES_out(enable_AES2),
    .sel_mux_res_sha_out(sel_mux_res_sha_w2),
    .start_sha_out(start_sha_w2)
);

    Reg3 Re3(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .lui_in(lui2),
    .auipc_in(auipc2),
    .jal_in(jal2),
    .jalr_in(jalr2),
    .mem_write_in(mem_write2),
    .mem_read_in(mem_read2), 
    .branch_in(branch2),
    .mem_to_reg_in(mem_to_reg2),
    .reg_write_in(reg_write2),
    .inst_in(inst2),
    .pc_plus4_in(pc_next2),
    .pc_imm_in(pc_imm),
    .result_in(w5),
    .rd23_in(rd22),
    .u_type_in(u_type),
    .ecall_in(ecall2),
    .pc_in(pc2),//
    .AES_W_in(AES_W2),
    .key_size_in(key_size2),
    .mode_aes_in(mode_aes2),
    .enable_AES_in(enable_AES2),
    .w3_in(w22),
    .plus1_in(plus12),
    .sel_mux_res_sha_in(sel_mux_res_sha_w2),
    .start_sha_in(start_sha_w2),

    // Outputs
    .lui_out(lui3),
    .auipc_out(auipc3),
    .jal_out(jal3),
    .jalr_out(jalr3),
    .mem_write_out(mem_write3),
    .mem_read_out(mem_read3),

    .branch_out(branch3),
    .mem_to_reg_out(mem_to_reg3),
    .reg_write_out(reg_write3),
    .inst_out(inst3),
    .pc_plus4_out(pc_next3),
    .pc_imm_out(pc_imm3), 
    .result_out(w6),
    .rd23_out(rd23),
    .u_type_out(u_type3),
    .ecall_out(ecall3),
    .pc_out(pc3),
    .AES_W_out(AES_W3),
    .key_size_out(key_size3),
    .mode_aes_out(mode_aes3),
    .enable_AES_out(enable_AES3),
    .w3_out(w23),
    .plus1_out(plus13),
    .sel_mux_res_sha_out(sel_mux_res_sha_w3),
    .start_sha_out(start_sha_w3)   
    );

    Reg4 Re4(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .lui_in(lui3),
    .auipc_in(auipc3),
    .mem_to_reg_in(mem_to_reg3),
    .reg_write_in(reg_write3),
    .inst_in(inst3),
    
    // .result_load_in(alo),

    .j_type_in(j_type),
    .u_type_in(u_type3),

    // Outputs
    .lui_out(lui4),
    .auipc_out(auipc4),
    .mem_to_reg_out(mem_to_reg4),
    .reg_write_out(reg_write4),
    .inst_out(inst4),

    // .result_load_out(result_load_out),

    .j_type_out(j_type4),
    .u_type_out(u_type4)
    );

//InstructionMemory Ins_Mem(
//    .addr(pc),

//    .inst_out(alo)
//);

ControlUnit CU(

    .opcode(inst[6:0]),
    .funct3(inst[14:12]),
    
    // Output
    .branch(branch),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .jalr(jalr),
    .jal(jal),
    .lui(lui),
    .auipc(auipc),
    .ecall(ecall),
    .plus1(plus1),
    .load_temp(load_temp),

    .AES_W(AES_W),
    .key_size(key_size),
    .mode_aes(mode_aes),
    .enable_AES(enable_AES),
    .sel_mux_res_sha(sel_mux_res_sha_w),
    .start_sha(start_sha_w)
    
);


wire [1:0] sel_mux_res_sha_w;
wire [1:0] sel_mux_res_sha_w2;
wire [1:0] sel_mux_res_sha_w3;

wire start_sha_w;
wire start_sha_w2;
wire start_sha_w3;

ALUControl ALU_CU(

    .funct3(inst[14:12]),
    .funct7(inst[31:25]),
    .alu_op(alu_op),

    .alu_ctrl(alu_ctrl1)
);

Registers_file RF(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .reg_write(reg_write4),            ///
    .rs1_addr(inst[19:15]),
    .rs2_addr(inst[24:20]),
    .rd_addr(inst4[11:7]), 

    .rd_data(rd_data),
    .rs1_data(rd1),
    .rs2_data(rd2),
    .rss(w1)
    );

ImmediateGenerator Imm_Gen(
    .inst_in(inst),
    .imm_out(imm1)
);
    
MUX2to1_ALU MUX_ALU(

    .a(rd22),
    .b(imm2),
    .sel(alu_src2),

    .c(rd11)
);

Adder Adder(
    .a(pc2),
    .b(imm2),

    .c(pc_imm)
);

ALU ALU(
    .a(rd12),
    .b(rd11),
    .alu_ctrl(alu_ctrl2),
    .result(result)
);

Mux_U1 Mux_U1(
    
   .a(result),
   .b(pc2),
   .sel(lui2),

   .c(result_u)
);

Adder_U Adder_U(
   .a(imm2),
   .b(result_u),
    
   .c(u_type)
);

Mux_J1 Mux_J1(
    .a(w6),
    .b(pc_imm3),
    .sel(jalr3),
    
    .c(pc_branch)
);

MUX2to1_PC MUX_PC(
    .a(pc_next3),
    .b(pc_branch),
    .sel1(w6),
    .sel2(branch3),
    .jal(jal3),
    .jalr(jalr3),

    .c(pc_nextt)
);

// DataMemory Data_Mem(
//    .clk(clk),
//    .reset(reset),
//    .mem_write(mem_write3),
//    .mem_read(mem_read3),
//    .addr(result1>>>2),
//    .sel(result1[31:28]),
//    .write_data(rd23),
//    .funct3(inst3[14:12]),
//    .res(res),

//    .done_AES(done_AES),
//    .AES_result(result_AES),
//    .enable_AES(enable_AES),

//    .AES_input0(AES_input0),
//    .AES_input1(AES_input1),
//    .AES_input2(AES_input2),
//    .AES_input3(AES_input3),
//    .AES_input4(AES_input4),
//    .AES_input5(AES_input5),
//    .AES_input6(AES_input6),
//    .AES_input7(AES_input7),

    
//    .read_data(alo)
// );

// data_mem data_mem(
//     .clka(clk),
//     .addra(DMAD_addr_in>>2),
//     .dina(DMAD_data_in),
//     .douta(result_load5),  // khai báo
//     .ena(1'b1),
//     .wea(DMAD_wea_in),

//     .clkb(clk),
//     .addrb(w7[12:0]>>2),
//     .dinb(rd33),
//     .doutb(result_load4),
//     // .ena(mem_write3|mem_read3),
//     .enb((mem_read3|plus13)|mem_write3|en_w_datamem),
//     .web(mem_write3|en_w_datamem)

//     );

data_mem data_mem(
    .clka(clk),
    .addra(addr_ins_d[12:0]>>2),
    .dina(data_ins_d),
    .douta(result_load4),
    .ena(en_o_risc_d),
    .wea(we_ins_d[0:0])
    
);

mux_data_mem mux_data_mem(
    .ins_addr_nap(DMAD_addr_in),
    .ins_addr_risc(w7),
    .ins_data_nap(DMAD_data_in),
    .ins_data_risc(rd33),
    .we_cpu(DMAD_wea_in[0:0]),
    .we_risc(mem_write3|en_w_datamem),
    .en_risc((mem_read3|plus13)|mem_write3|en_w_datamem),

    .sel(state_start),
    
    .addr_ins(addr_ins_d),
    .data_ins(data_ins_d),
    .we_ins(we_ins_d[0:0]),
    .en_o_risc(en_o_risc_d)
);








// ins_mem ins_mem(
//     .clka(clk),
//     .addra(DMAI_addr_in>>2),
//     .dina(DMAI_data_in),
//     .douta(result_load7),  // khai báo
//     .ena(1'b1),
//     .wea(DMAI_wea_in),

// //////////////
//     .clkb(clk),
//     .addrb(pc[12:0]>>2),
//     .dinb(32'b0),
    
//     // .ena(mem_write3|mem_read3),
//     .enb(1'b1),
//     .web(1'd0),

//     .doutb(inst)
//     );

mux_ins_rom mux_ins_rom(
    .ins_addr_nap(DMAI_addr_in>>2),
    .ins_addr_risc(pc>>2),
    .ins_data_nap(DMAI_data_in),
    .ins_data_risc(32'b0),
    .we_cpu(DMAI_wea_in[0:0]),
    .we_risc(1'd0),
    .en_risc(mem_write3|mem_read3),

    .sel(state_start),

    .addr_ins(addr_ins),
    .data_ins(data_ins),
    .we_ins(we_ins[0:0]),
    .en_o_risc(en_o_risc)
);

ins_mem ins_mem(
    .clka(clk),
    .addra(addr_ins[12:0]),
    .dina(data_ins),
    .douta(inst),
    .ena(en_o_risc),
    .wea(we_ins[0:0])
    
);


Mux_J2 Mux_J2(
    .a(pc_next3),
    .b(w6),
    .sel1(jal3),
    .sel2(jalr3),

    .c(j_type)
);

MUX2to1_WB MUX_WB(
    .a(result_load4),
    .b(j_type4),
    .sel(mem_to_reg4),

    .c(result_load)
);

Mux_U2 Mux_U2(
    .a(u_type4),
    .b(result_load),
    .sel1(lui4),
    .sel2(auipc4),

    .c(rd_data)

);






counter_offset counter_offset(
    .clk(clk),
    .reset(reset),
    .plus_1(plus1),
    .load_temp(load_temp),
    .temp_reg(w1),
    .count(w2)
    );

adder_32bit adder_32bit(
    .A(w1),
    .B(w2),
    .S(w3)
    );      
  

Mux_Buffer Mux_Buffer(
    .a(result),
    .b(w4<<2),
    .sel(plus1),

    // output
    // .c(result2), // chua biet
    .c(w5)
);

buffer buffer(
   .address(w8[6:0]),
   .data(result_load4),
   .reset(reset),
   .en_write(plus13),
   .clk(clk),
   .en_read(1'b1),
    
   .out0(out0),
   .out1(out1),
   .out2(out2),
   .out3(out3),
   .out4(out4),
   .out5(out5),
   .out6(out6),
   .out7(out7),
   .out8(out8),
   .out9(out9),
   .out10(out10),
   .out11(out11),
   .out12(out12),
   .out13(out13),
   .out14(out14),
   .out15(out15),
   .out16(out16),
   .out17(out17),
   .out18(out18),
   .out19(out19),
   .out20(out20),
   .out21(out21),
   .out22(out22),
   .out23(out23),
   .out24(out24),
   .out25(out25),
   .out26(out26),
   .out27(out27),
   .out28(out28),
   .out29(out29),
   .out30(out30),
   .out31(out31),
   .out32(out32),
   .out33(out33),
   .out34(out34),
   .out35(out35),
   .out36(out36),
   .out37(out37),
   .out38(out38),
   .out39(out39),
   .out40(out40),
   .out41(out41),
   .out42(out42),
   .out43(out43),
   .out44(out44),
   .out45(out45),
   .out46(out46),
   .out47(out47),
   .out48(out48),
   .out49(out49),
   .out50(out50),
   .out51(out51),
   .out52(out52),
   .out53(out53),
   .out54(out54),
   .out55(out55),
   .out56(out56),
   .out57(out57),
   .out58(out58),
   .out59(out59),
   .out60(out60),
   .out61(out61),
   .out62(out62),
   .out63(out63),
   .out64(out64),
   .out65(out65),
   .out66(out66),
   .out67(out67),
   .out68(out68),
   .out69(out69),
   .out70(out70),
   .out71(out71),
   .out72(out72),
   .out73(out73),
   .out74(out74),
   .out75(out75),
   .out76(out76),
   .out77(out77),
   .out78(out78),
   .out79(out79),
   .out80(out80),
   .out81(out81),
   .out82(out82),
   .out83(out83),
   .out84(out84),
   .out85(out85),
   .out86(out86),
   .out87(out87),
   .out88(out88),
   .out89(out89),
   .out90(out90),
   .out91(out91),
   .out92(out92),
   .out93(out93),
   .out94(out94),
   .out95(out95),
   .out96(out96),
   .out97(out97),
   .out98(out98),
   .out99(out99),
   .out100(out100),
   .out101(out101),
   .out102(out102),
   .out103(out103),
   .out104(out104),
   .out105(out105),
   .out106(out106),
   .out107(out107),
   .out108(out108),
   .out109(out109),
   .out110(out110),
   .out111(out111),
   .out112(out112),
   .out113(out113),
   .out114(out114),
   .out115(out115),
   .out116(out116),
   .out117(out117),
   .out118(out118),
   .out119(out119),
   .out120(out120),
   .out121(out121),
   .out122(out122),
   .out123(out123),
   .out124(out124),
   .out125(out125),
   .out126(out126),
   .out127(out127)

);

Buffer32 Buffer32(
    .clk(clk),
    .reset(reset),
    .start(state_start),
    .in_data(w23),
    .out_data(w8)
);

keyExpansion keyExpansion(
    .clk(clk),
    .reset(reset),
    .AES_mode(mode_aes3),
    .enable_AES(enable_AES3),
    .AES_W(AES_W3),
    .key_size(key_size3),
    .iv1(out4),
    .iv2(out5),
    .iv3(out6),
    .iv4(out7),
    
    .plaint1(out0),
    .plaint2(out1),
    .plaint3(out2),
    .plaint4(out3),
    .key0(out8),
    .key1(out9),
    .key2(out10),
    .key3(out11),
    .key4(out12),
    .key5(out13),
    .key6(out14),
    .key7(out15),

    .result(result_AES),
    .done_aes_r(done_aes_w)
    // còn thiếu mấy tín hiệu đang ch�? bổ sung
    );

wr_b2data wr_b2data(
    .clk(clk),
    .reset(reset),
    .result_SHA_in(res_mux_sha_o_w),
    .enable_wb(done_Sha_w),
    // Output
    .en_w_datamem(en_w_datamem),
    .data_aes(data_aes),
    .addr_aes(addr_aes)
    
);

// ADDR
MUX_AES1 MUX_AES1( 
    .a(w6),
    .b(addr_aes),
    .sel(en_w_datamem),
    .c(w7)
);

MUX_AES2 MUX_AES2(
    .a(rd23),
    .b(data_aes),
    .sel(en_w_datamem),
    .c(rd33)
);

state_control state_control(
    .clk(clk),
    .rst(reset),
    .start_in(start_in),
    .done_flag(inst4), // lấy từ ins của reg 4

    .state_start(state_start),// map vào các thanh ghi và 2 mux bram
    .state_done(state_done) // này map vào test bench 
);







//------------------------------------------------------------------------
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
wire sel_res512_w;

wire [63:0] out0_64, out1_64, out2_64, out3_64, out4_64, out5_64,
            out6_64, out7_64;

wire [63:0] out16_64, out17_64, out18_64, out19_64, out20_64,
            out21_64, out22_64, out23_64, out24_64, out25_64,
            out26_64, out27_64, out28_64, out29_64, out30_64,
            out31_64, out32_64;

// Giả sử out0 đến out31 đã được khai báo là wire [31:0]
assign out0_64  = {out0,  out1};
assign out1_64  = {out2,  out3};
assign out2_64  = {out4,  out5};
assign out3_64  = {out6,  out7};
assign out4_64  = {out8,  out9};
assign out5_64  = {out10, out11};
assign out6_64  = {out12, out13};
assign out7_64  = {out14, out15};

assign out16_64  = {out16, out17};
assign out17_64  = {out18, out19};
assign out18_64 = {out20, out21};
assign out19_64 = {out22, out23};
assign out20_64 = {out24, out25};
assign out21_64 = {out26, out27};
assign out22_64 = {out28, out29};
assign out23_64 = {out30, out31};
assign out24_64 = {out32, out33};
assign out25_64 = {out34, out35};
assign out26_64 = {out36, out37};
assign out27_64 = {out38, out39};
assign out28_64 = {out40, out41};
assign out29_64 = {out42, out43};
assign out30_64 = {out44, out45};
assign out31_64 = {out46, out47};
assign out32_64 = {out48, out49};


// wire [63:0] out32_64;
// wire [63:0] out33_64;
// wire [63:0] out34_64;
// wire [63:0] out35_64;
// wire [63:0] out36_64;
// wire [63:0] out37_64;
// wire [63:0] out38_64;
// wire [63:0] out39_64;

// assign out32_64 = {out32, out33};
// assign out33_64 = {out34, out35};
// assign out34_64 = {out36, out37};
// assign out35_64 = {out38, out39};
// assign out36_64 = {out40, out41};
// assign out37_64 = {out42, out43};
// assign out38_64 = {out44, out45};
// assign out39_64 = {out46, out47};


fsm_controller fsm_controller (
    .clk(clk),
    .rst(reset),
    .start_sha(start_sha_w & start_in),

    .w0_sha256(out16),
    .w1_sha256(out17),
    .w2_sha256(out18),
    .w3_sha256(out19),
    .w4_sha256(out20),
    .w5_sha256(out21),
    .w6_sha256(out22),
    .w7_sha256(out23),
    .w8_sha256(out24),
    .w9_sha256(out25),
    .w10_sha256(out26),
    .w11_sha256(out27),
    .w12_sha256(out28),
    .w13_sha256(out29),
    .w14_sha256(out30),
    .w15_sha256(out31),
    .w0_sha512(out16_64),
    .w1_sha512(out17_64),
    .w2_sha512(out18_64),
    .w3_sha512(out19_64),
    .w4_sha512(out20_64),
    .w5_sha512(out21_64),
    .w6_sha512(out22_64),
    .w7_sha512(out23_64),
    .w8_sha512(out24_64),
    .w9_sha512(out25_64),
    .w10_sha512(out26_64),
    .w11_sha512(out27_64),
    .w12_sha512(out28_64),
    .w13_sha512(out29_64),
    .w14_sha512(out30_64),
    .w15_sha512(out31_64),

    .A_i(out0),
    .B_i(out1),
    .C_i(out2),
    .D_i(out3),
    .E_i(out4),
    .F_i(out5),
    .G_i(out6),
    .H_i(out7),

    .A_i2(out0_64),
    .B_i2(out1_64),
    .C_i2(out2_64),
    .D_i2(out3_64),
    .E_i2(out4_64),
    .F_i2(out5_64),
    .G_i2(out6_64),
    .H_i2(out7_64),
    
    .start_sha_o(start_sha_o_w),

    .sel_mux(sel_mux_w),
    .sel_mux2(sel_mux_w2),

    .sel_res256(sel_res256_w),
    .sel_res512(sel_res512_w),

    .ena_K_reg(ena_K_reg_w),

    .sel_parise_mux(sel_parise_mux_w),
    .sel_parise_mux2(sel_parise_mux_w2),
    
    .reg16_out(reg16_out_w),
    .reg16_out2(reg16_out_w2),
    
    .A_o(A_o_w),
    .B_o(B_o_w),
    .C_o(C_o_w),
    .D_o(D_o_w),
    .E_o(E_o_w),
    .F_o(F_o_w),
    .G_o(G_o_w),
    .H_o(H_o_w),
    .A_o2(A_o_w2),
    .B_o2(B_o_w2),
    .C_o2(C_o_w2),
    .D_o2(D_o_w2),
    .E_o2(E_o_w2),
    .F_o2(F_o_w2),
    .G_o2(G_o_w2),
    .H_o2(H_o_w2),
    .done_Sha(done_Sha_w)
    
);
wire done_Sha_w;

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

Adder_Sha Adder_Sha (
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


// top for 64bit
// FSM Signals
    wire sel_mux_w2;
    wire ena_K_reg_w2;
    wire sel_parise_mux_w2; 
    wire [63:0] reg16_out_w2;
    wire [63:0] A_o_w2;
    wire [63:0] B_o_w2;
    wire [63:0] C_o_w2;
    wire [63:0] D_o_w2;
    wire [63:0] E_o_w2;
    wire [63:0] F_o_w2;
    wire [63:0] G_o_w2;
    wire [63:0] H_o_w2;

// Mux Signals
    wire [63:0] data_o_mux_w2;

// Reg0 Signals
    wire [63:0] data_o_reg0_w2;
    wire [63:0] data_o2_reg0_w2;
    wire [63:0] data_regH_o_w2;
    wire sel_mux_o_w2;

// Reg1 Signals
    wire [63:0] data_o_reg1_w2;

// Reg2 Signals
    wire [63:0] data_o_reg2_w2;

// Reg3 Signals
    wire [63:0] data_o_reg3_w2;

// Reg4 Signals
    wire [63:0] data_o_reg4_w2;

// Reg5 Signals
    wire [63:0] data_o_reg5_w2;

// Reg6 Signals
    wire [63:0] data_o_reg6_w2;

// Reg7 Signals
    wire [63:0] data_o_reg7_w2;

// Reg8 Signals
    wire [63:0] data_o_reg8_w2;

// Reg9 Signals
    wire [63:0] data_o_reg9_w2;

// Reg10 Signals
    wire [63:0] data_o_reg10_w2;

// Reg11 Signals
    wire [63:0] data_o_reg11_w2;

// Reg12 Signals
    wire [63:0] data_o_reg12_w2;

// Reg13 Signals
    wire [63:0] data_o_reg13_w2;

// Reg14 Signals
    wire [63:0] data_o_reg14_w2;

// Reg15 Signals
    wire [63:0] data_o_reg15_w2;

// Delta signals
    wire [63:0] delta0_out_w2;

// Delta1 Signals
    wire [63:0] delta1_out_w2;

// Adder Signals
    wire [63:0] data_o_adder_w2;

// K_register Signals
    wire [63:0] k_reg_o_w2;    

// Adder1 Signals
    wire [63:0] data_o_adder1_w2;

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
    .data_H0(A_o_w),
    .data_H1(B_o_w),
    .data_H2(C_o_w),
    .data_H3(D_o_w),
    .data_H4(E_o_w),
    .data_H5(F_o_w),
    .data_H6(G_o_w),
    .data_H7(H_o_w),

    .data_A(reg_A_o_w),
    .data_B(reg_B_o_w),
    .data_C(reg_C_o_w),
    .data_D(reg_D_o_w),
    .data_E(reg_E_o_w),
    .data_F(reg_F_o_w),
    .data_G(reg_G_o_w),
    .data_H(reg_H_o_w),

    .data2_H0(A_o_w2),
    .data2_H1(B_o_w2),
    .data2_H2(C_o_w2),
    .data2_H3(D_o_w2),
    .data2_H4(E_o_w2),
    .data2_H5(F_o_w2),
    .data2_H6(G_o_w2),
    .data2_H7(H_o_w2),

    .data2_A(reg_A_o_w2),
    .data2_B(reg_B_o_w2),
    .data2_C(reg_C_o_w2),
    .data2_D(reg_D_o_w2),
    .data2_E(reg_E_o_w2),
    .data2_F(reg_F_o_w2),
    .data2_G(reg_G_o_w2),
    .data2_H(reg_H_o_w2),

    .res_sha256_o(res_sha256_w),
    .res_sha512_o(res_sha512_w)
);

wire [511:0] res_mux_sha_o_w;
mux_3to1_512bit mux_res_sha(
    .sel_mux_res_sha(sel_mux_res_sha_w3),
    .in1(res_sha256_w),
    .in2(384'd0),
    .in3(res_sha512_w),
    .out(res_mux_sha_o_w)
);
//----

endmodule
