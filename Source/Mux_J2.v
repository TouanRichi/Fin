module Mux_J2(
    input [31:0] a,
    input [31:0] b,
    input sel1, 
    input sel2,
    output [31:0] c
);
    assign c = (sel1 == 1'b1 || sel2 == 1'b1) ? a : b; // a phải là pc + 4                                                      // b là result
endmodule
