// module Registers_file (
//     input wire clk,
//     input wire reset,
//     input wire reg_write,
//     input wire [4:0] rs1_addr,
//     input wire [4:0] rs2_addr,
//     input wire [4:0] rd_addr,
    
//     input wire [31:0] rd_data,         // Thay đổi thành 64-bit
//     output wire [31:0] rs1_data,       // Thay đổi thành 64-bit
//     output wire [31:0] rs2_data,        // Thay đổi thành 64-bit
//     output wire [31:0] rss
// );

//     // Khai báo 32 thanh ghi 64-bit
//     reg [31:0] registers [31:0];       // Thay đổi thành 64-bit

//     // Khai báo biến cho vòng lặp for
//     integer i;

//     // Ghi dữ liệu vào thanh ghi đích nếu reg_write bật
//     always @(posedge clk or posedge reset) begin
//         if (reset) begin
//             // Reset tất cả các thanh ghi v�? 0
//             for (i = 0; i < 32; i = i + 1) begin
//                 registers[i] <= 32'b0;  // Thay đổi thành 64-bit
//             end
//         end else if (reg_write && rd_addr != 5'b0) begin
//             // Thanh ghi x0 luôn bằng 0 trong RISC-V
//             registers[rd_addr] <= rd_data;
//         end else begin
//             registers[0] <= 32'd0;  // Day la tr??ng hop chua xet 
//             end
//         end

//     // �?�?c dữ liệu từ các thanh ghi nguồn
//     assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr]; // Thanh ghi x0 luôn trả v�? 0
//     assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];
//     assign rss      = registers[18];

// endmodule

module Registers_file (
    input wire clk,
    input wire reset,
    input wire start,           // Tín hiệu enable của module
    input wire reg_write,
    input wire [4:0] rs1_addr,
    input wire [4:0] rs2_addr,
    input wire [4:0] rd_addr,
    
    input wire [31:0] rd_data,         // Thay đổi thành 64-bit
    output wire [31:0] rs1_data,       // Thay đổi thành 64-bit
    output wire [31:0] rs2_data,        // Thay đổi thành 64-bit
    output wire [31:0] rss
);

    // Khai báo 32 thanh ghi 64-bit
    reg [31:0] registers [31:0];       // Thay đổi thành 64-bit

    // Khai báo biến cho vòng lặp for
    integer i;

    // Ghi dữ liệu vào thanh ghi đích nếu reg_write bật
   always @(posedge clk or negedge reset) begin
    if (!reset) begin
            // Reset tất cả các thanh ghi về 0
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;  // Thay đổi thành 64-bit
            end
        end else if (start) begin
            if (reg_write && rd_addr != 5'b0) begin
                // Thanh ghi x0 luôn bằng 0 trong RISC-V
                registers[rd_addr] <= rd_data;
            end else begin
                registers[0] <= 32'd0;  // Trường hợp mặc định
            end
        end else begin
            // Trường hợp start không được bật, giữ nguyên giá trị thanh ghi
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= registers[i];
            end
        end
    end

    // Đọc dữ liệu từ các thanh ghi nguồn
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr]; // Thanh ghi x0 luôn trả về 0
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];
    assign rss      = registers[18];

endmodule
