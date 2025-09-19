module Reg1(
    input clk,
    input reset,
    input start,

    // input lui_in,
    // input auipc_in,
    // input jal_in,
    // input jalr_in,
    // input mem_write_in,
    // input mem_read_in,
    // input [2:0] alu_op_in,
    // input alu_src_in,
    // input branch_in,
    // input mem_to_reg_in,
    // input reg_write_in,

    input [31:0] pc_plus4_in,
    input [31:0] pc_in,
        input load_temp_in,
    input plus1_in,
    // input [31:0] inst_in,
    // input ecall_in,

    // output reg lui_out,
    // output reg auipc_out,
    // output reg  jal_out,
    // output reg  jalr_out, 
    // output reg  mem_write_out,
    // output reg mem_read_out,
    // output reg [2:0] alu_op_out,
    // output reg alu_src_out,
    // output reg branch_out,
    // output reg mem_to_reg_out,
    // output reg reg_write_out,

    output reg [31:0] pc_plus4_out,
    output reg [31:0] pc_out,
        output reg load_temp_out,
    output reg plus1_out
    // output reg [31:0] inst_out,
    // output reg ecall_out
    
);

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        pc_out <= 32'b0;
        pc_plus4_out <= 32'b0; // Đặt giá trị mặc định cho pc_plus4_out khi rese
        load_temp_out <= 1'b0;
        plus1_out <= 1'b0;
    end else if (start) begin
        pc_out <= pc_in;
        pc_plus4_out <= pc_plus4_in;
        load_temp_out <= load_temp_in;
        plus1_out <= plus1_in;
    end else begin
        pc_out <= 32'b0;
        pc_plus4_out <= 32'b0; // Gán giá trị cho pc_plus4_out
        load_temp_out <= 1'b0;
        plus1_out <= 1'b0;
    end
end

endmodule
