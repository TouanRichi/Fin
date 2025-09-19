module Sigma1 (
    input  wire [31:0] e,   // Đầu vào 32-bit
    output wire [31:0] out  // Đầu ra 32-bit
);

    // Tính toán \Sigma_1
    assign out = (e >> 6 | e << (26)) ^  // rightrotate 6
                 (e >> 11 | e << (21)) ^ // rightrotate 11
                 (e >> 25 | e << (7));  // rightrotate 25

endmodule