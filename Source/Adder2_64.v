module Adder2_64bit (
    input  wire [63:0] in1,  // Đầu vào thứ nhất
    input  wire [63:0] in2,  // Đầu vào thứ hai
    input  wire [63:0] in3,  // Đầu vào thứ ba
    output wire [63:0] sum   // Kết quả đầu ra
);

    // Thực hiện phép cộng modulo 2^32
    assign sum = in1 + in2 + in3;

endmodule