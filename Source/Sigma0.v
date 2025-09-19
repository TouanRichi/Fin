module Sigma0 (
    input  wire [31:0] a,   // Đầu vào 32-bit
    output wire [31:0] out  // Đầu ra 32-bit
);

    // Tính toán \Sigma_0
    assign out = (a >> 2 | a << (30)) ^  // rightrotate 2
                 (a >> 13 | a << (19)) ^ // rightrotate 13
                 (a >> 22 | a << (10));  // rightrotate 22

endmodule