module Choice_64bit (
    input  wire [63:0] e,   // Đầu vào thứ nhất
    input  wire [63:0] f,   // Đầu vào thứ hai
    input  wire [63:0] g,   // Đầu vào thứ ba
    output wire [63:0] out  // Đầu ra 32-bit
);

    // Tính toán hàm Choice
    assign out = (e & f) ^ (~e & g);

endmodule