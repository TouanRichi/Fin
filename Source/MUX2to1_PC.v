module MUX2to1_PC(
    input [31:0] a,
    input [31:0] b,
    input [31:0] sel1, // sel1 là result
    input sel2, jal, jalr, // sel2 là branch, jalr 
    output [31:0] c
);
    assign c = ((sel1==32'd1 && sel2==1'b1) || (jalr||jal)) ? b : a;
endmodule
