module adder_32bit (
    input [31:0] A,          // Đầu vào A, 32-bit
    input [31:0] B,          // Đầu vào B, 32-bit
    output [31:0] S          // Đầu ra S, 32-bit
);

    // Thực hiện phép cộng hai số 32-bit và gán kết quả cho S
    assign S = A + B;

endmodule
