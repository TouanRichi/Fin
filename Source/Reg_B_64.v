module registerB_64bit (
    input wire              CLK,    // Tín hiệu đồng hồ
    input wire              RST,    // Tín hiệu reset
    input wire              start,  // Tín hiệu start
    input wire [63:0]       data_i, // Dữ liệu đầu vào
    output reg [63:0]       data_o  // Dữ liệu đầu ra
);

    always @(posedge CLK or posedge RST) begin
        if (~RST) begin
            // Reset thanh ghi về 0
            data_o <= 32'b0;
        end else begin
            if (start) begin
                // Nếu tín hiệu start được bật, nạp dữ liệu vào thanh ghi
                data_o <= data_i;
            end else begin
            // Giữ nguyên giá trị hiện tại
            data_o <= data_o;
            end
        end
    end
endmodule