module Mux_J1(
    input [31:0] a,
    input [31:0] b,
    input sel, // đấu với dây jalr
    output [31:0] c
);
    assign c = (sel == 1'b1) ? a : b; // a phải là rs1 + imm (kết quả của result)
                                      // b là pc + imm
endmodule
