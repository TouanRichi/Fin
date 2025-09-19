module registerJ_32bit (
    input wire              CLK,    // Tín hiệu đồng hồ
    input wire              RST,    // Tín hiệu reset
    input wire              start,  // Tín hiệu start
    input wire [31:0]       data_i, // Dữ liệu đầu vào
    input wire [31:0]       data_i2, // Dữ liệu đầu vào thứ hai
    input wire [31:0]       data_i3, // Dữ liệu đầu vào thứ ba
    input wire [31:0]       data_i4, // Dữ liệu đầu vào thứ tư
    output reg [31:0]       data_o,  // Dữ liệu đầu ra
    output reg [31:0]       data_o2,  // Dữ liệu đầu ra thứ hai
    output reg [31:0]       data_o3, // Dữ liệu đầu ra thứ ba
    output reg [31:0]       data_o4 // Dữ liệu đầu ra thứ tư
);

    always @(posedge CLK or posedge RST) begin
        if (~RST) begin
            // Reset thanh ghi về 0
            data_o <= 32'b0;
            data_o2 <= 32'b0;
            data_o3 <= 32'b0;
            data_o4 <= 32'b0;
        end else begin
            if (start) begin
                // Nếu tín hiệu start được bật, nạp dữ liệu vào thanh ghi
                data_o <= data_i;
                data_o2 <= data_i2;
                data_o3 <= data_i3;
                data_o4 <= data_i4;
            end else begin
            // Giữ nguyên giá trị hiện tại
            data_o <= data_o;
            data_o2 <= data_o2;
            data_o3 <= data_o3;
            data_o4 <= data_o4;
            end
        end
    end
endmodule