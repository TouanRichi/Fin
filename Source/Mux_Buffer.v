module Mux_Buffer(
    input [31:0] a,
    input [31:0] b,
    input sel, // đấu với dây plus11
    output [31:0] c
);
    assign c = (sel == 1'b1) ? b : a; // a phải là rs1 + imm (kết quả của result)
                                      // b là pc + imm
endmodule
