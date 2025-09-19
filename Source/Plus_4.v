module PC_plus4(
    input [31:0] pc_in,     // Đầu vào là giá trị pc hiện tại
    output [31:0] pc_out    // Đầu ra là giá trị pc tiếp theo
);

assign pc_out = pc_in + 32'd4; // Cộng giá trị PC hiện tại với 4
// assign pc_next = pc_out + 64'd4;  // Khai báo rõ ràng 64-bit

endmodule
