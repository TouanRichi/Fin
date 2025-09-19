`timescale 1ns / 1ps

module K_register_64bit (
    input wire clk,              // Tín hiệu đồng hồ
    input wire rst,              // Tín hiệu reset (active low)
    input wire ena_K_reg,        // Tín hiệu cho phép
    output reg [63:0] K_out      // Đầu ra 64-bit
);

    // Mảng thanh ghi K từ K[0] đến K[79] (80 thanh ghi 64-bit)
    reg [63:0] K [0:79];

    // Bộ đếm để theo dõi vị trí của K[i]
    reg [6:0] counter; // Bộ đếm 7-bit để đếm từ 0 đến 79

    // Khối reset và logic mảng
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            counter <= 7'd0;     // Reset bộ đếm về 0
            K_out <= 64'd0;      // Reset đầu ra về 0
        end else if (ena_K_reg) begin
            K_out <= K[counter]; // Gán đầu ra bằng K[counter]
            counter <= counter + 1'b1; // Tăng bộ đếm
            if (counter == 7'd79) begin
                counter <= 7'd0; // Nếu đạt đến K[79], quay lại K[0]
            end
        end
    end

    // Mảng hằng số K cho SHA-512
    initial begin
        K[0]  = 64'h428a2f98d728ae22;
        K[1]  = 64'h7137449123ef65cd;
        K[2]  = 64'hb5c0fbcfec4d3b2f;
        K[3]  = 64'he9b5dba58189dbbc;
        K[4]  = 64'h3956c25bf348b538;
        K[5]  = 64'h59f111f1b605d019;
        K[6]  = 64'h923f82a4af194f9b;
        K[7]  = 64'hab1c5ed5da6d8118;
        K[8]  = 64'hd807aa98a3030242;
        K[9]  = 64'h12835b0145706fbe;
        K[10] = 64'h243185be4ee4b28c;
        K[11] = 64'h550c7dc3d5ffb4e2;
        K[12] = 64'h72be5d74f27b896f;
        K[13] = 64'h80deb1fe3b1696b1;
        K[14] = 64'h9bdc06a725c71235;
        K[15] = 64'hc19bf174cf692694;
        K[16] = 64'he49b69c19ef14ad2;
        K[17] = 64'hefbe4786384f25e3;
        K[18] = 64'h0fc19dc68b8cd5b5;
        K[19] = 64'h240ca1cc77ac9c65;
        K[20] = 64'h2de92c6f592b0275;
        K[21] = 64'h4a7484aa6ea6e483;
        K[22] = 64'h5cb0a9dcbd41fbd4;
        K[23] = 64'h76f988da831153b5;
        K[24] = 64'h983e5152ee66dfab;
        K[25] = 64'ha831c66d2db43210;
        K[26] = 64'hb00327c898fb213f;
        K[27] = 64'hbf597fc7beef0ee4;
        K[28] = 64'hc6e00bf33da88fc2;
        K[29] = 64'hd5a79147930aa725;
        K[30] = 64'h06ca6351e003826f;
        K[31] = 64'h142929670a0e6e70;
        K[32] = 64'h27b70a8546d22ffc;
        K[33] = 64'h2e1b21385c26c926;
        K[34] = 64'h4d2c6dfc5ac42aed;
        K[35] = 64'h53380d139d95b3df;
        K[36] = 64'h650a73548baf63de;
        K[37] = 64'h766a0abb3c77b2a8;
        K[38] = 64'h81c2c92e47edaee6;
        K[39] = 64'h92722c851482353b;
        K[40] = 64'ha2bfe8a14cf10364;
        K[41] = 64'ha81a664bbc423001;
        K[42] = 64'hc24b8b70d0f89791;
        K[43] = 64'hc76c51a30654be30;
        K[44] = 64'hd192e819d6ef5218;
        K[45] = 64'hd69906245565a910;
        K[46] = 64'hf40e35855771202a;
        K[47] = 64'h106aa07032bbd1b8;
        K[48] = 64'h19a4c116b8d2d0c8;
        K[49] = 64'h1e376c085141ab53;
        K[50] = 64'h2748774cdf8eeb99;
        K[51] = 64'h34b0bcb5e19b48a8;
        K[52] = 64'h391c0cb3c5c95a63;
        K[53] = 64'h4ed8aa4ae3418acb;
        K[54] = 64'h5b9cca4f7763e373;
        K[55] = 64'h682e6ff3d6b2b8a3;
        K[56] = 64'h748f82ee5defb2fc;
        K[57] = 64'h78a5636f43172f60;
        K[58] = 64'h84c87814a1f0ab72;
        K[59] = 64'h8cc702081a6439ec;
        K[60] = 64'h90befffa23631e28;
        K[61] = 64'ha4506cebde82bde9;
        K[62] = 64'hbef9a3f7b2c67915;
        K[63] = 64'hc67178f2e372532b;
        K[64] = 64'hca273eceea26619c;
        K[65] = 64'hd186b8c721c0c207;
        K[66] = 64'heada7dd6cde0eb1e;
        K[67] = 64'hf57d4f7fee6ed178;
        K[68] = 64'h06f067aa72176fba;
        K[69] = 64'h0a637dc5a2c898a6;
        K[70] = 64'h113f9804bef90dae;
        K[71] = 64'h1b710b35131c471b;
        K[72] = 64'h28db77f523047d84;
        K[73] = 64'h32caab7b40c72493;
        K[74] = 64'h3c9ebe0a15c9bebc;
        K[75] = 64'h431d67c49c100d4c;
        K[76] = 64'h4cc5d4becb3e42b6;
        K[77] = 64'h597f299cfc657e2a;
        K[78] = 64'h5fcb6fab3ad6faec;
        K[79] = 64'h6c44198c4a475817;
    end

endmodule