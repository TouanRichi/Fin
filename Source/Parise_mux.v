`timescale 1ns / 1ps

module pairwise_mux (
    input wire sel,              // Tín hiệu chọn cho tất cả các cặp
    input wire sel_A,            // Tín hiệu chọn cho cặp A
    input wire [31:0] a1,        // Đầu vào a1
    input wire [31:0] a2,        // Đầu vào a2
    input wire [31:0] b1,        // Đầu vào b1
    input wire [31:0] b2,        // Đầu vào b2
    input wire [31:0] c1,        // Đầu vào c1
    input wire [31:0] c2,        // Đầu vào c2
    input wire [31:0] d1,        // Đầu vào d1
    input wire [31:0] d2,        // Đầu vào d2
    input wire [31:0] e1,        // Đầu vào e1
    input wire [31:0] e2,        // Đầu vào e2
    input wire [31:0] f1,        // Đầu vào f1
    input wire [31:0] f2,        // Đầu vào f2
    input wire [31:0] g1,        // Đầu vào g1
    input wire [31:0] g2,        // Đầu vào g2
    input wire [31:0] h1,        // Đầu vào h1
    input wire [31:0] h2,        // Đầu vào h2
    output reg [31:0] a_out,     // Đầu ra từ a1, a2
    output reg [31:0] b_out,     // Đầu ra từ b1, b2
    output reg [31:0] c_out,     // Đầu ra từ c1, c2
    output reg [31:0] d_out,     // Đầu ra từ d1, d2
    output reg [31:0] e_out,     // Đầu ra từ e1, e2
    output reg [31:0] f_out,     // Đầu ra từ f1, f2
    output reg [31:0] g_out,     // Đầu ra từ g1, g2
    output reg [31:0] h_out      // Đầu ra từ h1, h2
);

    always @(*) begin
        // Multiplexing logic for each pair based on sel
        a_out = sel_A ? a1 : a2; // Chọn giữa a1 và a2
        b_out = sel ? b1 : b2; // Chọn giữa b1 và b2
        c_out = sel ? c1 : c2; // Chọn giữa c1 và c2
        d_out = sel ? d1 : d2; // Chọn giữa d1 và d2
        e_out = sel ? e1 : e2; // Chọn giữa e1 và e2
        f_out = sel ? f1 : f2; // Chọn giữa f1 và f2
        g_out = sel ? g1 : g2; // Chọn giữa g1 và g2
        h_out = sel ? h1 : h2; // Chọn giữa h1 và h2
    end

endmodule