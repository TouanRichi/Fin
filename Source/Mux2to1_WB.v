module MUX2to1_WB(
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] c
);
    assign c = (sel == 1'b1) ? a : b;
endmodule
