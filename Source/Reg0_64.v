module register0_64bit (
    input wire              CLK,    // Tín hiệu đồng hồ
    input wire              RST,    // Tín hiệu reset
    input wire              start,  // Tín hiệu start
    input wire              sel_mux, // Tín hiệu chọn mux
    input wire [63:0]       data_i, // Dữ liệu đầu vào
    input wire [63:0]       data_i2, // Dữ liệu đầu vào thứ hai
    input wire [63:0]       data_regH_i, // Dữ liệu đầu vào thứ ba
    output reg             sel_mux_o, // Đầu ra từ mux
    output reg [63:0]       data_o,  // Dữ liệu đầu ra
    output reg [63:0]       data_o2,  // Dữ liệu đầu ra thứ hai
    output reg [63:0]       data_regH_o // Dữ liệu đầu ra thứ ba

);

    always @(posedge CLK or posedge RST) begin
        if (~RST) begin
            // Reset thanh ghi về 0
            data_o <= 32'b0;
            data_o2 <= 32'b0;
            sel_mux_o <= 32'b0;
            data_regH_o <= 32'b0;
        end else begin
            if (start) begin
                // Nếu tín hiệu start được bật, nạp dữ liệu vào thanh ghi
                data_o <= data_i;
                data_o2 <= data_i2;
                sel_mux_o <= sel_mux;
                data_regH_o <= data_regH_i;
            end else begin
            // Giữ nguyên giá trị hiện tại
            data_o <= data_o;
            data_o2 <= data_o2;
            sel_mux_o <= sel_mux_o;
            data_regH_o <= data_regH_o;
            end
        end
    end
endmodule