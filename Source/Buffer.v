module buffer (
    input [6:0] address,        // �?ịa chỉ đầu vào (7 bit cho 128 vị trí)
    input [31:0] data,          // Dữ liệu đầu vào (32 bit)
    input reset,                // Tín hiệu reset
    input en_write,             // Tín hiệu cho phép ghi
    input clk,                  // Tín hiệu xung nhịp
    input en_read,              // Tín hiệu cho phép  */
    output reg [31:0] out0,     // Các cổng đầu ra 32 bit đơn lẻ
    output reg [31:0] out1,
    output reg [31:0] out2,
    output reg [31:0] out3,
    output reg [31:0] out4,
    output reg [31:0] out5,
    output reg [31:0] out6,
    output reg [31:0] out7,
    output reg [31:0] out8,
    output reg [31:0] out9,
    output reg [31:0] out10,
    output reg [31:0] out11,
    output reg [31:0] out12,
    output reg [31:0] out13,
    output reg [31:0] out14,
    output reg [31:0] out15,
    output reg [31:0] out16,
    output reg [31:0] out17,
    output reg [31:0] out18,
    output reg [31:0] out19,
    output reg [31:0] out20,
    output reg [31:0] out21,
    output reg [31:0] out22,
    output reg [31:0] out23,
    output reg [31:0] out24,
    output reg [31:0] out25,
    output reg [31:0] out26,
    output reg [31:0] out27,
    output reg [31:0] out28,
    output reg [31:0] out29,
    output reg [31:0] out30,
    output reg [31:0] out31,
    output reg [31:0] out32,
    output reg [31:0] out33,
    output reg [31:0] out34,
    output reg [31:0] out35,
    output reg [31:0] out36,
    output reg [31:0] out37,
    output reg [31:0] out38,
    output reg [31:0] out39,
    output reg [31:0] out40,
    output reg [31:0] out41,
    output reg [31:0] out42,
    output reg [31:0] out43,
    output reg [31:0] out44,
    output reg [31:0] out45,
    output reg [31:0] out46,
    output reg [31:0] out47,
    output reg [31:0] out48,
    output reg [31:0] out49,
    output reg [31:0] out50,
    output reg [31:0] out51,
    output reg [31:0] out52,
    output reg [31:0] out53,
    output reg [31:0] out54,
    output reg [31:0] out55,
    output reg [31:0] out56,
    output reg [31:0] out57,
    output reg [31:0] out58,
    output reg [31:0] out59,
    output reg [31:0] out60,
    output reg [31:0] out61,
    output reg [31:0] out62,
    output reg [31:0] out63,
    output reg [31:0] out64,
    output reg [31:0] out65,
    output reg [31:0] out66,
    output reg [31:0] out67,
    output reg [31:0] out68,
    output reg [31:0] out69,
    output reg [31:0] out70,
    output reg [31:0] out71,
    output reg [31:0] out72,
    output reg [31:0] out73,
    output reg [31:0] out74,
    output reg [31:0] out75,
    output reg [31:0] out76,
    output reg [31:0] out77,
    output reg [31:0] out78,
    output reg [31:0] out79,
    output reg [31:0] out80,
    output reg [31:0] out81,
    output reg [31:0] out82,
    output reg [31:0] out83,
    output reg [31:0] out84,
    output reg [31:0] out85,
    output reg [31:0] out86,
    output reg [31:0] out87,
    output reg [31:0] out88,
    output reg [31:0] out89,
    output reg [31:0] out90,
    output reg [31:0] out91,
    output reg [31:0] out92,
    output reg [31:0] out93,
    output reg [31:0] out94,
    output reg [31:0] out95,
    output reg [31:0] out96,
    output reg [31:0] out97,
    output reg [31:0] out98,
    output reg [31:0] out99,
    output reg [31:0] out100,
    output reg [31:0] out101,
    output reg [31:0] out102,
    output reg [31:0] out103,
    output reg [31:0] out104,
    output reg [31:0] out105,
    output reg [31:0] out106,
    output reg [31:0] out107,
    output reg [31:0] out108,
    output reg [31:0] out109,
    output reg [31:0] out110,
    output reg [31:0] out111,
    output reg [31:0] out112,
    output reg [31:0] out113,
    output reg [31:0] out114,
    output reg [31:0] out115,
    output reg [31:0] out116,
    output reg [31:0] out117,
    output reg [31:0] out118,
    output reg [31:0] out119,
    output reg [31:0] out120,
    output reg [31:0] out121,
    output reg [31:0] out122,
    output reg [31:0] out123,
    output reg [31:0] out124,
    output reg [31:0] out125,
    output reg [31:0] out126,
    output reg [31:0] out127
);

    // Khai báo bộ đệm 128 thanh ghi, mỗi thanh ghi 32 bit
    reg [31:0] buffer_mem [0:127];  // Bộ đệm 128 x 32 bit

    integer i;  // Khai báo biến lặp

    // // Quá trình ghi dữ liệu vào bộ đệm và cập nhật ngay ra đầu ra
    // always @(posedge clk or negedge reset) begin
    //     if (~reset) begin
    //         // Reset tất cả các phần tử của bộ đệm và đầu ra v�? 0
    //         for (i = 0; i < 128; i = i + 1) begin
    //             buffer_mem[i] <= 32'b0;
    //         end
    //     end else if (en_write) begin
    //         // Nếu `en_write` được kích hoạt, ghi dữ liệu vào bộ đệm tại vị trí `address`
    //         buffer_mem[address] <= data;
    //     end else begin
    //         for (i = 0; i < 128; i = i + 1) begin
    //             buffer_mem[i] <= buffer_mem[i];
    //         end
    //     end
    // end

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            // Reset tất cả các phần tử của bộ đệm và đầu ra v�? 0
            for (i = 0; i < 128; i = i + 1) begin
                buffer_mem[i] <= 32'b0;
            end
        end else begin 
            if (en_write) begin 
                buffer_mem[address] <= data;
            end else begin 
                for (i = 0; i < 128; i = i + 1) begin
                buffer_mem[i] <= buffer_mem[i];
                end
            end 
        end 
    end 


    // Cập nhật trực tiếp đầu ra khi `en_read` được kích hoạt
    always @(posedge clk) begin
        if (en_read) begin
            out0 <= buffer_mem[0];
            out1 <= buffer_mem[1];
            out2 <= buffer_mem[2];
            out3 <= buffer_mem[3];
            out4 <= buffer_mem[4];
            out5 <= buffer_mem[5];
            out6 <= buffer_mem[6];
            out7 <= buffer_mem[7];
            out8 <= buffer_mem[8];
            out9 <= buffer_mem[9];
            out10 <= buffer_mem[10];
            out11 <= buffer_mem[11];
            out12 <= buffer_mem[12];
            out13 <= buffer_mem[13];
            out14 <= buffer_mem[14];
            out15 <= buffer_mem[15];
            out16 <= buffer_mem[16];
            out17 <= buffer_mem[17];
            out18 <= buffer_mem[18];
            out19 <= buffer_mem[19];
            out20 <= buffer_mem[20];
            out21 <= buffer_mem[21];
            out22 <= buffer_mem[22];
            out23 <= buffer_mem[23];
            out24 <= buffer_mem[24];
            out25 <= buffer_mem[25];
            out26 <= buffer_mem[26];
            out27 <= buffer_mem[27];
            out28 <= buffer_mem[28];
            out29 <= buffer_mem[29];
            out30 <= buffer_mem[30];
            out31 <= buffer_mem[31];
            out32 <= buffer_mem[32];
            out33 <= buffer_mem[33];
            out34 <= buffer_mem[34];
            out35 <= buffer_mem[35];
            out36 <= buffer_mem[36];
            out37 <= buffer_mem[37];
            out38 <= buffer_mem[38];
            out39 <= buffer_mem[39];
            out40 <= buffer_mem[40];
            out41 <= buffer_mem[41];
            out42 <= buffer_mem[42];
            out43 <= buffer_mem[43];
            out44 <= buffer_mem[44];
            out45 <= buffer_mem[45];
            out46 <= buffer_mem[46];
            out47 <= buffer_mem[47];
            out48 <= buffer_mem[48];
            out49 <= buffer_mem[49];
            out50 <= buffer_mem[50];
            out51 <= buffer_mem[51];
            out52 <= buffer_mem[52];
            out53 <= buffer_mem[53];
            out54 <= buffer_mem[54];
            out55 <= buffer_mem[55];
            out56 <= buffer_mem[56];
            out57 <= buffer_mem[57];
            out58 <= buffer_mem[58];
            out59 <= buffer_mem[59];
            out60 <= buffer_mem[60];
            out61 <= buffer_mem[61];
            out62 <= buffer_mem[62];
            out63 <= buffer_mem[63];
            out64 <= buffer_mem[64];
            out65 <= buffer_mem[65];
            out66 <= buffer_mem[66];
            out67 <= buffer_mem[67];
            out68 <= buffer_mem[68];
            out69 <= buffer_mem[69];
            out70 <= buffer_mem[70];
            out71 <= buffer_mem[71];
            out72 <= buffer_mem[72];
            out73 <= buffer_mem[73];
            out74 <= buffer_mem[74];
            out75 <= buffer_mem[75];
            out76 <= buffer_mem[76];
            out77 <= buffer_mem[77];
            out78 <= buffer_mem[78];
            out79 <= buffer_mem[79];
            out80 <= buffer_mem[80];
            out81 <= buffer_mem[81];
            out82 <= buffer_mem[82];
            out83 <= buffer_mem[83];
            out84 <= buffer_mem[84];
            out85 <= buffer_mem[85];
            out86 <= buffer_mem[86];
            out87 <= buffer_mem[87];
            out88 <= buffer_mem[88];
            out89 <= buffer_mem[89];
            out90 <= buffer_mem[90];
            out91 <= buffer_mem[91];
            out92 <= buffer_mem[92];
            out93 <= buffer_mem[93];
            out94 <= buffer_mem[94];
            out95 <= buffer_mem[95];
            out96 <= buffer_mem[96];
            out97 <= buffer_mem[97];
            out98 <= buffer_mem[98];
            out99 <= buffer_mem[99];
            out100 <= buffer_mem[100];
            out101 <= buffer_mem[101];
            out102 <= buffer_mem[102];
            out103 <= buffer_mem[103];
            out104 <= buffer_mem[104];
            out105 <= buffer_mem[105];
            out106 <= buffer_mem[106];
            out107 <= buffer_mem[107];
            out108 <= buffer_mem[108];
            out109 <= buffer_mem[109];
            out110 <= buffer_mem[110];
            out111 <= buffer_mem[111];
            out112 <= buffer_mem[112];
            out113 <= buffer_mem[113];
            out114 <= buffer_mem[114];
            out115 <= buffer_mem[115];
            out116 <= buffer_mem[116];
            out117 <= buffer_mem[117];
            out118 <= buffer_mem[118];
            out119 <= buffer_mem[119];
            out120 <= buffer_mem[120];
            out121 <= buffer_mem[121];
            out122 <= buffer_mem[122];
            out123 <= buffer_mem[123];
            out124 <= buffer_mem[124];
            out125 <= buffer_mem[125];
            out126 <= buffer_mem[126];
            out127 <= buffer_mem[127];
        end else begin
    out0 <= 32'd0;
    out1 <= 32'd0;
    out2 <= 32'd0;
    out3 <= 32'd0;
    out4 <= 32'd0;
    out5 <= 32'd0;
    out6 <= 32'd0;
    out7 <= 32'd0;
    out8 <= 32'd0;
    out9 <= 32'd0;
    out10 <= 32'd0;
    out11 <= 32'd0;
    out12 <= 32'd0;
    out13 <= 32'd0;
    out14 <= 32'd0;
    out15 <= 32'd0;
    out16 <= 32'd0;
    out17 <= 32'd0;
    out18 <= 32'd0;
    out19 <= 32'd0;
    out20 <= 32'd0;
    out21 <= 32'd0;
    out22 <= 32'd0;
    out23 <= 32'd0;
    out24 <= 32'd0;
    out25 <= 32'd0;
    out26 <= 32'd0;
    out27 <= 32'd0;
    out28 <= 32'd0;
    out29 <= 32'd0;
    out30 <= 32'd0;
    out31 <= 32'd0;
    out32 <= 32'd0;
    out33 <= 32'd0;
    out34 <= 32'd0;
    out35 <= 32'd0;
    out36 <= 32'd0;
    out37 <= 32'd0;
    out38 <= 32'd0;
    out39 <= 32'd0;
    out40 <= 32'd0;
    out41 <= 32'd0;
    out42 <= 32'd0;
    out43 <= 32'd0;
    out44 <= 32'd0;
    out45 <= 32'd0;
    out46 <= 32'd0;
    out47 <= 32'd0;
    out48 <= 32'd0;
    out49 <= 32'd0;
    out50 <= 32'd0;
    out51 <= 32'd0;
    out52 <= 32'd0;
    out53 <= 32'd0;
    out54 <= 32'd0;
    out55 <= 32'd0;
    out56 <= 32'd0;
    out57 <= 32'd0;
    out58 <= 32'd0;
    out59 <= 32'd0;
    out60 <= 32'd0;
    out61 <= 32'd0;
    out62 <= 32'd0;
    out63 <= 32'd0;
    out64 <= 32'd0;
    out65 <= 32'd0;
    out66 <= 32'd0;
    out67 <= 32'd0;
    out68 <= 32'd0;
    out69 <= 32'd0;
    out70 <= 32'd0;
    out71 <= 32'd0;
    out72 <= 32'd0;
    out73 <= 32'd0;
    out74 <= 32'd0;
    out75 <= 32'd0;
    out76 <= 32'd0;
    out77 <= 32'd0;
    out78 <= 32'd0;
    out79 <= 32'd0;
    out80 <= 32'd0;
    out81 <= 32'd0;
    out82 <= 32'd0;
    out83 <= 32'd0;
    out84 <= 32'd0;
    out85 <= 32'd0;
    out86 <= 32'd0;
    out87 <= 32'd0;
    out88 <= 32'd0;
    out89 <= 32'd0;
    out90 <= 32'd0;
    out91 <= 32'd0;
    out92 <= 32'd0;
    out93 <= 32'd0;
    out94 <= 32'd0;
    out95 <= 32'd0;
    out96 <= 32'd0;
    out97 <= 32'd0;
    out98 <= 32'd0;
    out99 <= 32'd0;
    out100 <= 32'd0;
    out101 <= 32'd0;
    out102 <= 32'd0;
    out103 <= 32'd0;
    out104 <= 32'd0;
    out105 <= 32'd0;
    out106 <= 32'd0;
    out107 <= 32'd0;
    out108 <= 32'd0;
    out109 <= 32'd0;
    out110 <= 32'd0;
    out111 <= 32'd0;
    out112 <= 32'd0;
    out113 <= 32'd0;
    out114 <= 32'd0;
    out115 <= 32'd0;
    out116 <= 32'd0;
    out117 <= 32'd0;
    out118 <= 32'd0;
    out119 <= 32'd0;
    out120 <= 32'd0;
    out121 <= 32'd0;
    out122 <= 32'd0;
    out123 <= 32'd0;
    out124 <= 32'd0;
    out125 <= 32'd0;
    out126 <= 32'd0;
    out127 <= 32'd0;

            end
        end

    endmodule
