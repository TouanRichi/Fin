module Mux_U1(
    input [31:0] a,
    input [31:0] b,
    input sel, // đấu với dây lui
    output [31:0] c
);
    assign c = (sel == 1'b1) ? a : b; // a phải được đấu với ZERO
endmodule
