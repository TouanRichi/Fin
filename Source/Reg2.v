module Reg2(
    input clk,
    input reset,

    input lui_in,
    input auipc_in,
    input jal_in,
    input jalr_in,
    input mem_write_in,
    input mem_read_in,
    input [4:0] alu_ctrl_in,
    input alu_src_in,
    input branch_in,
    input mem_to_reg_in,    
    input reg_write_in,
    input [31:0] inst_in,
    input [31:0] pc_plus4_in,
    input [31:0] pc_in,
    input [31:0] rd1_in,
    input [31:0] rd2_in,
    input [31:0] imm1_in,
    input ecall_in,

    input AES_W_in,
    input [1:0] key_size_in,
    input enable_AES_in,
    input [31:0] re_adder_32_in,
    input [31:0] w2_in,
    input plus1_in,
    input start,
    input [1:0] mode_aes_in,
    input [1:0] sel_mux_res_sha_in,
    input start_sha_in,

    output reg lui_out,
    output reg auipc_out,
    output reg  jal_out,
    output reg jalr_out,
    output reg  mem_write_out,
    output reg  mem_read_out,
    output reg [4:0] alu_ctrl_out,
    output reg alu_src_out,
    output reg branch_out,
    output reg mem_to_reg_out,
    output reg reg_write_out,
    output reg [31:0] inst_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] pc_out,
    output reg [31:0] rd1_out,
    output reg [31:0] rd2_out,
    output reg [31:0] imm1_out,
    output reg ecall_out,
    output reg AES_W_out,
    output reg [1:0] key_size_out,
    output reg enable_AES_out,
    output reg [31:0] re_adder_32_out,
    output reg [31:0] w2_out,
    output reg plus1_out,
    output reg [1:0] mode_aes_out,
    output reg [1:0] sel_mux_res_sha_out,
    output reg start_sha_out
);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset tất cả các output về giá trị mặc định
        pc_out <= 32'b0;
        pc_plus4_out <= 32'b0; 
        inst_out <= 32'b0;
        reg_write_out <= 1'b0;
        alu_ctrl_out <= 5'b0;
        alu_src_out <= 1'b0;
        branch_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        lui_out <= 1'b0;
        auipc_out <= 1'b0;
        jal_out <= 1'b0;
        jalr_out <= 1'b0;
        rd1_out <= 32'b0;
        rd2_out <= 32'b0;
        imm1_out <= 32'b0;
        ecall_out <= 1'b0;

        AES_W_out <= 1'b0;
        key_size_out <= 2'b0;
        enable_AES_out <= 1'b0;
        re_adder_32_out <= 32'b0;
        w2_out <= 32'b0;
        plus1_out <= 1'b0;
        mode_aes_out <= 2'b0;
        sel_mux_res_sha_out <= 2'b0;
        start_sha_out <= 1'b0;

    end else if (start) begin
        // Truyền giá trị từ input vào output khi không reset
        pc_out <= pc_in;
        pc_plus4_out <= pc_plus4_in;
        inst_out <= inst_in;
        reg_write_out <= reg_write_in;
        alu_ctrl_out <= alu_ctrl_in;
        alu_src_out <= alu_src_in;
        branch_out <= branch_in;
        mem_to_reg_out <= mem_to_reg_in;
        mem_write_out <= mem_write_in;
        mem_read_out <= mem_read_in;
        lui_out <= lui_in;
        auipc_out <= auipc_in;
        jal_out <= jal_in;
        jalr_out <= jalr_in;
        rd1_out <= rd1_in;
        rd2_out <= rd2_in;
        imm1_out <= imm1_in;
        ecall_out <= ecall_in;
        
        AES_W_out <= AES_W_in;
        key_size_out <= key_size_in;
        enable_AES_out <= enable_AES_in;
        re_adder_32_out <= re_adder_32_in;
        w2_out <= w2_in;
        plus1_out <= plus1_in;
        mode_aes_out <= mode_aes_in;
        sel_mux_res_sha_out <= sel_mux_res_sha_in;
        start_sha_out <= start_sha_in;
    end else begin
        pc_out <= 32'b0;
        pc_plus4_out <= 32'b0; 
        inst_out <= 32'b0;
        reg_write_out <= 1'b0;
        alu_ctrl_out <= 5'b0;
        alu_src_out <= 1'b0;
        branch_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        lui_out <= 1'b0;
        auipc_out <= 1'b0;
        jal_out <= 1'b0;
        jalr_out <= 1'b0;
        rd1_out <= 32'b0;
        rd2_out <= 32'b0;
        imm1_out <= 32'b0;
        ecall_out <= 1'b0;

        AES_W_out <= 1'b0;
        key_size_out <= 2'b0;
        enable_AES_out <= 1'b0;
        re_adder_32_out <= 32'b0;
        w2_out <= 32'b0;
        plus1_out <= 1'b0;
        mode_aes_out <= 2'b0;
        sel_mux_res_sha_out <= 2'b0;
        start_sha_out <= 1'b0;
    end
end

endmodule
