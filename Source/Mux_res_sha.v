module mux_3to1_512bit (
    input  wire [1:0]  sel_mux_res_sha ,       // Tín hiệu chọn (2 bit để chọn 1 trong 3 đầu vào)
    input  wire [255:0] in1,     // Đầu vào 256 bit
    input  wire [383:0] in2,     // Đầu vào 384 bit
    input  wire [511:0] in3,     // Đầu vào 512 bit
    output wire [511:0] out      // Đầu ra 512 bit
);

    // Tạm mở rộng các đầu vào nhỏ hơn lên 512 bit (padding ở cuối)
    wire [511:0] in1_extended = {in1, 256'b0}; // Padding 256 bit 0 ở cuối
    wire [511:0] in2_extended = {in2, 128'b0}; // Padding 128 bit 0 ở cuối

    // Logic MUX
    assign out = (sel_mux_res_sha == 2'b00) ? in1_extended : // Chọn đầu vào 1
                 (sel_mux_res_sha == 2'b01) ? in2_extended : // Chọn đầu vào 2
                 (sel_mux_res_sha == 2'b10) ? in3 :          // Chọn đầu vào 3
                 512'b0;                         // Mặc định nếu không hợp lệ

endmodule