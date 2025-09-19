module mux32_2to1 (
    input  wire [31:0] data0_i, // Đầu vào 32-bit thứ nhất
    input  wire [31:0] data1_i, // Đầu vào 32-bit thứ hai
    input  wire        sel_i,   // Tín hiệu điều khiển
    output wire [31:0] data_o   // Đầu ra 32-bit
);

    // Logic chọn dữ liệu đầu ra dựa trên tín hiệu điều khiển
    assign data_o = (sel_i) ? data1_i : data0_i;

endmodule