module Adder_U(
    input [31:0] a,
    input [31:0] b,

    output [31:0] c
);
    assign c = a << 12 + b; // chân a phải đấu với imm
endmodule

