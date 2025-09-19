// Reg 
module Reg_res_sha (
    input wire              clk,    // Tín hiệu đồng hồ
    input wire              rst,    // Tín hiệu reset
    input wire              sel_res256,  // Tín hiệu start
    input wire              sel_res512,  // Tín hiệu start

    input wire [31:0]       data_H0, // Dữ liệu đầu vào
    input wire [31:0]       data_H1, // Dữ liệu đầu vào
    input wire [31:0]       data_H2, // Dữ liệu đầu vào
    input wire [31:0]       data_H3, // Dữ liệu đầu vào
    input wire [31:0]       data_H4, // Dữ liệu đầu vào
    input wire [31:0]       data_H5, // Dữ liệu đầu vào
    input wire [31:0]       data_H6, // Dữ liệu đầu vào
    input wire [31:0]       data_H7, // Dữ liệu đầu vào

    input wire [31:0]       data_A, // Dữ liệu đầu vào
    input wire [31:0]       data_B, // Dữ liệu đầu vào
    input wire [31:0]       data_C, // Dữ liệu đầu vào
    input wire [31:0]       data_D, // Dữ liệu đầu vào
    input wire [31:0]       data_E, // Dữ liệu đầu vào
    input wire [31:0]       data_F, // Dữ liệu đầu vào
    input wire [31:0]       data_G, // Dữ liệu đầu vào
    input wire [31:0]       data_H, // Dữ liệu đầu vào

    // input for sha512
    input wire [63:0]       data2_H0, // Dữ liệu đầu vào
    input wire [63:0]       data2_H1, // Dữ liệu đầu vào
    input wire [63:0]       data2_H2, // Dữ liệu đầu vào
    input wire [63:0]       data2_H3, // Dữ liệu đầu vào
    input wire [63:0]       data2_H4, // Dữ liệu đầu vào
    input wire [63:0]       data2_H5, // Dữ liệu đầu vào
    input wire [63:0]       data2_H6, // Dữ liệu đầu vào
    input wire [63:0]       data2_H7, // Dữ liệu đầu vào
    input wire [63:0]       data2_A, // Dữ liệu đầu vào
    input wire [63:0]       data2_B, // Dữ liệu đầu vào
    input wire [63:0]       data2_C, // Dữ liệu đầu vào
    input wire [63:0]       data2_D, // Dữ liệu đầu vào
    input wire [63:0]       data2_E, // Dữ liệu đầu vào
    input wire [63:0]       data2_F, // Dữ liệu đầu vào
    input wire [63:0]       data2_G, // Dữ liệu đầu vào
    input wire [63:0]       data2_H, // Dữ liệu đầu vào

    output reg [255 :0]      res_sha256_o,  // Dữ liệu đầu ra
    output reg [511 :0]      res_sha512_o  // Dữ liệu đầu ra
);


    always @(posedge clk or posedge rst) begin
        if (!rst) begin
            res_sha256_o <= 256'd0; // Reset tín hiệu cho phép bộ đếm về 0
        end else begin
            if (sel_res256) begin
                // thuật toán ghép bit khi đã có A, B, C, D, E, F, G, H và H0, H1, H2, H3, H4, H5, H6, H7
                res_sha256_o <= {
                                    data_H0 + data_A,
                                    data_H1 + data_B,
                                    data_H2 + data_C,
                                    data_H3 + data_D,
                                    data_H4 + data_E,
                                    data_H5 + data_F,
                                    data_H6 + data_G,
                                    data_H7 + data_H
                                }; // Nạp dữ liệu vào thanh ghi
            end else begin
                res_sha256_o <= res_sha256_o; // Giữ nguyên giá trị băm
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (!rst) begin
            res_sha512_o <= 512'd0; // Reset tín hiệu cho phép bộ đếm về 0
        end else begin
            if (sel_res512) begin
                res_sha512_o <= {
                                data2_H0 + data2_A,
                                data2_H1 + data2_B,
                                data2_H2 + data2_C,
                                data2_H3 + data2_D,
                                data2_H4 + data2_E,
                                data2_H5 + data2_F,
                                data2_H6 + data2_G,
                                data2_H7 + data2_H
                            }; // Nạp dữ liệu vào thanh ghi
            end else begin
                res_sha512_o <= res_sha512_o; // Giữ nguyên giá trị băm
            end
        end
    end

endmodule