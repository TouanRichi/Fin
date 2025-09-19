module MUX_AES2(
    input [31:0] a, // a là tín hiệu AES
    input [31:0] b, 
    input sel,
    output [31:0] c
);
    assign c = (sel) ? b : a;
endmodule
