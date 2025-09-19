// module PC(
//     input clk,
//     input reset,
//     input [31:0] pc_in,
//     input [31:0] pc_ecall,
//     input ecall_detected,     // Tín hi?u cho bi?t có l?nh ecall

//     output reg [31:0] pc_out
//     // output reg ena_ins,       // ena signal 
//     // output reg wea
// );

// always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             pc_out <= 32'b0;    // Khi reset, pc_out ???c ??t v?? 0
//             // ena_ins <= 0;       // Disable instruction fetch when reset
//             // wea <= 0;
//         end
//         else if (ecall_detected) begin
//             pc_out <= pc_ecall; // Khi g?p ecall, gi? nguyên giá tr? c?a pc_out
//             // ena_ins <= 0;       // Disable instruction fetch on ecall
//             // wea <= 0;
//         end
//         else begin
//             pc_out <= pc_in;    // C?p nh?t pc_out bình th???ng n?u không có ecall
//             // ena_ins <= 1;       // Enable instruction fetch
//             // wea <= 0;    
//         end
//     end

// endmodule


module PC(
    input clk,
    input reset,
    input start,               // C?? start ?? ki?m soát ho?t ??ng
    input [31:0] pc_in,
//    input [31:0] pc_ecall,
//    input ecall_detected,     // Tín hi?u cho bi?t có l?nh ecall

    output reg [31:0] pc_out
    // output reg ena_ins,       // ena signal 
    // output reg wea
);

// always @(posedge clk or negedge reset) begin
//         if (!reset) begin
//             pc_out <= 32'b0;    // Khi reset, pc_out ???c ??t v?? 0
//             // ena_ins <= 0;       // Disable instruction fetch when reset
//             // wea <= 0;
//         end
//         else if (start) begin
//             if (ecall_detected) begin
//                 pc_out <= pc_ecall; // Khi g?p ecall, gán giá tr? pc_ecall vào pc_out
//             end else begin
//                 pc_out <= pc_in;    // N?u không, gán giá tr? pc_in vào pc_out
//             end
//         end else begin
//             pc_out <= pc_out;    // Khi start không ???c kích ho?t, pc_out ???c ??t v?? 0
//         end
//     end
// endmodule

always @(posedge clk or negedge reset) begin
       if (!reset) begin
           pc_out <= 32'b0; 
       end else begin
           if (start) begin
           pc_out <= pc_in;
           end else begin
            pc_out <= pc_out;
             end
       end
end
endmodule


