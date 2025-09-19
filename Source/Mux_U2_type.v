module Mux_U2(
    input [31:0] a,
    input [31:0] b,
    input sel1,
    input sel2,
    output [31:0] c
);
    assign c = (sel1 == 1'b1 || sel2 == 1'b1) ? a : b; // Chọn giá trị a nếu sel1 hoặc sel2 là 1, ngược lại chọn b
endmodule
