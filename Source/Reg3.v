module Reg3(
    input clk,
    input reset,

    input lui_in,
    input auipc_in,
    input jal_in,
    input jalr_in,
    input  mem_write_in,
    input  mem_read_in,
    input branch_in,
    input mem_to_reg_in,    
    input reg_write_in,
    input [31:0] inst_in,
    input [31:0] pc_plus4_in, // dây này đang đấu chung với 1 tín hiệu nhớ để ý
    input [31:0] pc_imm_in,
    input [31:0] result_in,
    input [31:0] rd23_in,
    input [31:0] u_type_in,
    input ecall_in,
    input [31:0] pc_in,
    input AES_W_in,
    input [1:0] key_size_in,
    input enable_AES_in,
    input [31:0] w3_in,
     input plus1_in,
     input start,
     input [1:0] mode_aes_in,
    input [1:0] sel_mux_res_sha_in,
    input start_sha_in,


    output reg lui_out,
    output reg  auipc_out,
    output reg  jal_out,
    output reg  jalr_out,
    output reg mem_write_out,
    output reg mem_read_out,

    output reg branch_out,
    output reg mem_to_reg_out,
    output reg reg_write_out,  
    output reg [31:0] inst_out, 
    output reg [31:0] pc_plus4_out,
    output reg [31:0] pc_imm_out,
    output reg [31:0] result_out,
    output reg [31:0] rd23_out,
    output reg [31:0] u_type_out,
    output reg ecall_out,
    output reg [31:0] pc_out,
    output reg AES_W_out,
    output reg [1:0] key_size_out,
    output reg enable_AES_out,
    output reg [31:0] w3_out,
    output reg plus1_out,
    output reg [1:0] mode_aes_out,
    output reg [1:0] sel_mux_res_sha_out,
    output reg start_sha_out

);
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset tất cả các output về giá trị mặc định
        pc_plus4_out <= 32'b0; 
        inst_out <= 32'b0;
        reg_write_out <= 1'b0;
        lui_out <= 1'b0;
        auipc_out <= 1'b0;
        jal_out <= 1'b0;
        jalr_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_read_out <= 1'b0;

        branch_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        pc_imm_out <= 32'b0;
        result_out <= 32'b0;
        rd23_out   <= 32'b0;
        u_type_out <= 32'b0;
        ecall_out <= 1'b0;
        pc_out <= 32'b0;
        AES_W_out <= 1'b0;
        key_size_out <= 2'b0;
        enable_AES_out <= 1'b0;
        w3_out <= 32'b0;
        plus1_out <= 1'b0;
        mode_aes_out <= 2'b0;
        sel_mux_res_sha_out <= 2'b0;
        start_sha_out <= 1'b0;


    end else if (start) begin
        // Truyền giá trị từ input vào output khi không reset

        pc_plus4_out <= pc_plus4_in;
        inst_out <= inst_in;
        reg_write_out <= reg_write_in;
        lui_out <= lui_in;
        auipc_out <= auipc_in;
        jal_out <= jal_in;
        jalr_out <= jalr_in;
        mem_write_out <= mem_write_in;
        mem_read_out <= mem_read_in;

        branch_out <= branch_in;
        mem_to_reg_out <= mem_to_reg_in;
        pc_imm_out <= pc_imm_in;
        result_out <= result_in;
        rd23_out   <= rd23_in;
        u_type_out <= u_type_in;
        ecall_out <= ecall_in;
        pc_out <= pc_in;
        AES_W_out <= AES_W_in;
        key_size_out <= key_size_in;
        enable_AES_out <= enable_AES_in;
        w3_out <= w3_in;
        plus1_out <= plus1_in;
        mode_aes_out <= mode_aes_in;
        sel_mux_res_sha_out <= sel_mux_res_sha_in;
        start_sha_out <= start_sha_in;
    end else begin
        pc_plus4_out <= 32'b0; 
        inst_out <= 32'b0;
        reg_write_out <= 1'b0;
        lui_out <= 1'b0;
        auipc_out <= 1'b0;
        jal_out <= 1'b0;
        jalr_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_read_out <= 1'b0;

        branch_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        pc_imm_out <= 32'b0;
        result_out <= 32'b0;
        rd23_out   <= 32'b0;
        u_type_out <= 32'b0;
        ecall_out <= 1'b0;
        pc_out <= 32'b0;
        AES_W_out <= 1'b0;
        key_size_out <= 2'b0;
        enable_AES_out <= 1'b0;
        w3_out <= 32'b0;
        plus1_out <= 1'b0;
        mode_aes_out <= 2'b0;
        sel_mux_res_sha_out <= 2'b0;
        start_sha_out <= 1'b0;

    end

end

endmodule
