module Reg4(
    input clk,
    input reset,

    input  lui_in,
    input  auipc_in,
    input mem_to_reg_in,
    input reg_write_in,

    input [31:0] inst_in,
    // input [31:0] result_load_in,
    input [31:0] j_type_in, 
    input [31:0] u_type_in,
    input start,


    output reg lui_out,
    output reg  auipc_out,
    output reg  mem_to_reg_out,
    output reg reg_write_out,
    output reg  [31:0] inst_out,
    // output reg [31:0] result_load_out,
    output reg [31:0] j_type_out,
    output reg [31:0] u_type_out


);
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // Reset tất cả các output về giá trị mặc định
        inst_out <= 32'b0;
        reg_write_out <= 1'b0;
        // result_load_out <= 31'b0;
        lui_out <= 1'b0;
        auipc_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        j_type_out <= 31'b0;
        u_type_out <= 31'b0;

    end else if(start) begin
        
        // Truyền giá trị từ input vào output khi không reset
        inst_out <= inst_in;
        reg_write_out <= reg_write_in;
        // result_load_out <= result_load_in;
        lui_out <= lui_in;
        auipc_out <= auipc_in;
        mem_to_reg_out <= mem_to_reg_in;
        j_type_out <= j_type_in;
        u_type_out <= u_type_in;


    end else begin
        inst_out <= 32'b0;
        reg_write_out <= 1'b0;
        // result_load_out <= 31'b0;
        lui_out <= 1'b0;
        auipc_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        j_type_out <= 31'b0;
        u_type_out <= 31'b0;
    end
end

endmodule