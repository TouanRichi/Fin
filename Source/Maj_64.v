module Majority_64bit (
    input  wire [63:0] A,  // Đầu vào thứ nhất
    input  wire [63:0] B,  // Đầu vào thứ hai
    input  wire [63:0] C,  // Đầu vào thứ ba
    output wire [63:0] M   // Kết quả đầu ra
);

    // Tính giá trị Majority theo định nghĩa
    assign M = (A & B) ^ (A & C) ^ (B & C);

endmodule