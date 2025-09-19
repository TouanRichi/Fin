module Adder3 (
    input  wire [31:0] in1,  // Đầu vào thứ nhất
    input  wire [31:0] in2,  // Đầu vào thứ hai
    output wire [31:0] sum   // Kết quả đầu ra
);

    // Thực hiện phép cộng modulo 2^32
    assign sum = in1 + in2;

endmodule