module keyExpansion (
    input wire clk,                // Clock signal
    input wire reset,              // Reset signal
    input wire [1:0] AES_mode,     // CBC, ECB, CFB, CTR  
    input wire enable_AES,                  
    input wire AES_W,
    input wire [1:0] key_size,
    

    input wire [31:0] plaint1, //4 byte first // phần này cũng xem như là cipher mới
    input wire [31:0] plaint2, // next 4 byte
    input wire [31:0] plaint3, // next 4 byte
    input wire [31:0] plaint4, // next 4 byte

    input wire [31:0] iv1,     // 
    input wire [31:0] iv2,     // 
    input wire [31:0] iv3,     // 
    input wire [31:0] iv4,     // 

    input wire [31:0] key0,    // 4 byte first key
    input wire [31:0] key1,    // 4 next byte key
    input wire [31:0] key2,    // 4 next byte key
    input wire [31:0] key3,    // 4 next byte key
    input wire [31:0] key4,    // 4 next byte key (if key is 192)
    input wire [31:0] key5,    // 4 next byte key (if key is 192)
    input wire [31:0] key6,    // 4 next byte key (if key is 256)
    input wire [31:0] key7,    // 4 next byte key (if key is 256)
    output reg [127:0] result,                // Signal indicating key expansion is complete
    output reg done_aes_r
);
//    reg done_exp;
    reg [255:0] key;
    reg [127:0] input_plaintxt;
    reg [31:0] words [0:59];// Expanded key words
    reg [127:0] round_keys [0:14];
    reg [3:0] round;     // V�ng l?p hi?n t?i (0 ??n 10)
    reg [127:0] round_key;
    reg done_wb_r;
    
    reg [127:0] state_r;
    integer j;

    // Registers for Nk, Nr, and iteration
    reg [3:0] nk;
    reg [3:0] nr;
    reg [5:0] i; // Current word index (supports up to 60 words for AES-256)
    reg [31:0] temp_next;

    
    // Sbox value
    
     reg [7:0] sbox [0:255];
     initial begin 
            // Replace with full S-box values for AES implementation
    sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; sbox[8'h02] = 8'h77; sbox[8'h03] = 8'h7b;
    sbox[8'h04] = 8'hf2; sbox[8'h05] = 8'h6b; sbox[8'h06] = 8'h6f; sbox[8'h07] = 8'hc5;
    sbox[8'h08] = 8'h30; sbox[8'h09] = 8'h01; sbox[8'h0a] = 8'h67; sbox[8'h0b] = 8'h2b;
    sbox[8'h0c] = 8'hfe; sbox[8'h0d] = 8'hd7; sbox[8'h0e] = 8'hab; sbox[8'h0f] = 8'h76;
    sbox[8'h10] = 8'hca; sbox[8'h11] = 8'h82; sbox[8'h12] = 8'hc9; sbox[8'h13] = 8'h7d;
    sbox[8'h14] = 8'hfa; sbox[8'h15] = 8'h59; sbox[8'h16] = 8'h47; sbox[8'h17] = 8'hf0;
    sbox[8'h18] = 8'had; sbox[8'h19] = 8'hd4; sbox[8'h1a] = 8'ha2; sbox[8'h1b] = 8'haf;
    sbox[8'h1c] = 8'h9c; sbox[8'h1d] = 8'ha4; sbox[8'h1e] = 8'h72; sbox[8'h1f] = 8'hc0;
    sbox[8'h20] = 8'hb7; sbox[8'h21] = 8'hfd; sbox[8'h22] = 8'h93; sbox[8'h23] = 8'h26;
    sbox[8'h24] = 8'h36; sbox[8'h25] = 8'h3f; sbox[8'h26] = 8'hf7; sbox[8'h27] = 8'hcc;
    sbox[8'h28] = 8'h34; sbox[8'h29] = 8'ha5; sbox[8'h2a] = 8'he5; sbox[8'h2b] = 8'hf1;
    sbox[8'h2c] = 8'h71; sbox[8'h2d] = 8'hd8; sbox[8'h2e] = 8'h31; sbox[8'h2f] = 8'h15;
    sbox[8'h30] = 8'h04; sbox[8'h31] = 8'hc7; sbox[8'h32] = 8'h23; sbox[8'h33] = 8'hc3;
    sbox[8'h34] = 8'h18; sbox[8'h35] = 8'h96; sbox[8'h36] = 8'h05; sbox[8'h37] = 8'h9a;
    sbox[8'h38] = 8'h07; sbox[8'h39] = 8'h12; sbox[8'h3a] = 8'h80; sbox[8'h3b] = 8'he2;
    sbox[8'h3c] = 8'heb; sbox[8'h3d] = 8'h27; sbox[8'h3e] = 8'hb2; sbox[8'h3f] = 8'h75;
    sbox[8'h40] = 8'h09; sbox[8'h41] = 8'h83; sbox[8'h42] = 8'h2c; sbox[8'h43] = 8'h1a;
    sbox[8'h44] = 8'h1b; sbox[8'h45] = 8'h6e; sbox[8'h46] = 8'h5a; sbox[8'h47] = 8'ha0;
    sbox[8'h48] = 8'h52; sbox[8'h49] = 8'h3b; sbox[8'h4a] = 8'hd6; sbox[8'h4b] = 8'hb3;
    sbox[8'h4c] = 8'h29; sbox[8'h4d] = 8'he3; sbox[8'h4e] = 8'h2f; sbox[8'h4f] = 8'h84;
    sbox[8'h50] = 8'h53; sbox[8'h51] = 8'hd1; sbox[8'h52] = 8'h00; sbox[8'h53] = 8'hed;
    sbox[8'h54] = 8'h20; sbox[8'h55] = 8'hfc; sbox[8'h56] = 8'hb1; sbox[8'h57] = 8'h5b;
    sbox[8'h58] = 8'h6a; sbox[8'h59] = 8'hcb; sbox[8'h5a] = 8'hbe; sbox[8'h5b] = 8'h39;
    sbox[8'h5c] = 8'h4a; sbox[8'h5d] = 8'h4c; sbox[8'h5e] = 8'h58; sbox[8'h5f] = 8'hcf;
    sbox[8'h60] = 8'hd0; sbox[8'h61] = 8'hef; sbox[8'h62] = 8'haa; sbox[8'h63] = 8'hfb;
    sbox[8'h64] = 8'h43; sbox[8'h65] = 8'h4d; sbox[8'h66] = 8'h33; sbox[8'h67] = 8'h85;
    sbox[8'h68] = 8'h45; sbox[8'h69] = 8'hf9; sbox[8'h6a] = 8'h02; sbox[8'h6b] = 8'h7f;
    sbox[8'h6c] = 8'h50; sbox[8'h6d] = 8'h3c; sbox[8'h6e] = 8'h9f; sbox[8'h6f] = 8'ha8;
    sbox[8'h70] = 8'h51; sbox[8'h71] = 8'ha3; sbox[8'h72] = 8'h40; sbox[8'h73] = 8'h8f;
    sbox[8'h74] = 8'h92; sbox[8'h75] = 8'h9d; sbox[8'h76] = 8'h38; sbox[8'h77] = 8'hf5;
    sbox[8'h78] = 8'hbc; sbox[8'h79] = 8'hb6; sbox[8'h7a] = 8'hda; sbox[8'h7b] = 8'h21;
    sbox[8'h7c] = 8'h10; sbox[8'h7d] = 8'hff; sbox[8'h7e] = 8'hf3; sbox[8'h7f] = 8'hd2;
    sbox[8'h80] = 8'hcd; sbox[8'h81] = 8'h0c; sbox[8'h82] = 8'h13; sbox[8'h83] = 8'hec;
    sbox[8'h84] = 8'h5f; sbox[8'h85] = 8'h97; sbox[8'h86] = 8'h44; sbox[8'h87] = 8'h17;
    sbox[8'h88] = 8'hc4; sbox[8'h89] = 8'ha7; sbox[8'h8a] = 8'h7e; sbox[8'h8b] = 8'h3d;
    sbox[8'h8c] = 8'h64; sbox[8'h8d] = 8'h5d; sbox[8'h8e] = 8'h19; sbox[8'h8f] = 8'h73;
    sbox[8'h90] = 8'h60; sbox[8'h91] = 8'h81; sbox[8'h92] = 8'h4f; sbox[8'h93] = 8'hdc;
    sbox[8'h94] = 8'h22; sbox[8'h95] = 8'h2a; sbox[8'h96] = 8'h90; sbox[8'h97] = 8'h88;
    sbox[8'h98] = 8'h46; sbox[8'h99] = 8'hee; sbox[8'h9a] = 8'hb8; sbox[8'h9b] = 8'h14;
    sbox[8'h9c] = 8'hde; sbox[8'h9d] = 8'h5e; sbox[8'h9e] = 8'h0b; sbox[8'h9f] = 8'hdb;
    sbox[8'ha0] = 8'he0; sbox[8'ha1] = 8'h32; sbox[8'ha2] = 8'h3a; sbox[8'ha3] = 8'h0a;
    sbox[8'ha4] = 8'h49; sbox[8'ha5] = 8'h06; sbox[8'ha6] = 8'h24; sbox[8'ha7] = 8'h5c;
    sbox[8'ha8] = 8'hc2; sbox[8'ha9] = 8'hd3; sbox[8'haa] = 8'hac; sbox[8'hab] = 8'h62;
    sbox[8'hac] = 8'h91; sbox[8'had] = 8'h95; sbox[8'hae] = 8'he4; sbox[8'haf] = 8'h79;
    sbox[8'hb0] = 8'he7; sbox[8'hb1] = 8'hc8; sbox[8'hb2] = 8'h37; sbox[8'hb3] = 8'h6d;
    sbox[8'hb4] = 8'h8d; sbox[8'hb5] = 8'hd5; sbox[8'hb6] = 8'h4e; sbox[8'hb7] = 8'ha9;
    sbox[8'hb8] = 8'h6c; sbox[8'hb9] = 8'h56; sbox[8'hba] = 8'hf4; sbox[8'hbb] = 8'hea;
    sbox[8'hbc] = 8'h65; sbox[8'hbd] = 8'h7a; sbox[8'hbe] = 8'hae; sbox[8'hbf] = 8'h08;
    sbox[8'hc0] = 8'hba; sbox[8'hc1] = 8'h78; sbox[8'hc2] = 8'h25; sbox[8'hc3] = 8'h2e;
    sbox[8'hc4] = 8'h1c; sbox[8'hc5] = 8'ha6; sbox[8'hc6] = 8'hb4; sbox[8'hc7] = 8'hc6;
    sbox[8'hc8] = 8'he8; sbox[8'hc9] = 8'hdd; sbox[8'hca] = 8'h74; sbox[8'hcb] = 8'h1f;
    sbox[8'hcc] = 8'h4b; sbox[8'hcd] = 8'hbd; sbox[8'hce] = 8'h8b; sbox[8'hcf] = 8'h8a;
    sbox[8'hd0] = 8'h70; sbox[8'hd1] = 8'h3e; sbox[8'hd2] = 8'hb5; sbox[8'hd3] = 8'h66;
    sbox[8'hd4] = 8'h48; sbox[8'hd5] = 8'h03; sbox[8'hd6] = 8'hf6; sbox[8'hd7] = 8'h0e;
    sbox[8'hd8] = 8'h61; sbox[8'hd9] = 8'h35; sbox[8'hda] = 8'h57; sbox[8'hdb] = 8'hb9;
    sbox[8'hdc] = 8'h86; sbox[8'hdd] = 8'hc1; sbox[8'hde] = 8'h1d; sbox[8'hdf] = 8'h9e;
    sbox[8'he0] = 8'he1; sbox[8'he1] = 8'hf8; sbox[8'he2] = 8'h98; sbox[8'he3] = 8'h11;
    sbox[8'he4] = 8'h69; sbox[8'he5] = 8'hd9; sbox[8'he6] = 8'h8e; sbox[8'he7] = 8'h94;
    sbox[8'he8] = 8'h9b; sbox[8'he9] = 8'h1e; sbox[8'hea] = 8'h87; sbox[8'heb] = 8'he9;
    sbox[8'hec] = 8'hce; sbox[8'hed] = 8'h55; sbox[8'hee] = 8'h28; sbox[8'hef] = 8'hdf;
    sbox[8'hf0] = 8'h8c; sbox[8'hf1] = 8'ha1; sbox[8'hf2] = 8'h89; sbox[8'hf3] = 8'h0d;
    sbox[8'hf4] = 8'hbf; sbox[8'hf5] = 8'he6; sbox[8'hf6] = 8'h42; sbox[8'hf7] = 8'h68;
    sbox[8'hf8] = 8'h41; sbox[8'hf9] = 8'h99; sbox[8'hfa] = 8'h2d; sbox[8'hfb] = 8'h0f;
    sbox[8'hfc] = 8'hb0; sbox[8'hfd] = 8'h54; sbox[8'hfe] = 8'hbb; sbox[8'hff] = 8'h16;

     end 

    // Rcon array (round constants)
    reg [31:0] rcon [0:9];

    initial begin
        rcon[0] = 32'h01000000; rcon[1] = 32'h02000000; rcon[2] = 32'h04000000; rcon[3] = 32'h08000000;
        rcon[4] = 32'h10000000; rcon[5] = 32'h20000000; rcon[6] = 32'h40000000; rcon[7] = 32'h80000000;
        rcon[8] = 32'h1B000000; rcon[9] = 32'h36000000;
    end

    // State machine control
    reg [3:0] state;
    localparam IDLE = 4'd0, INIT = 4'd1, CALC_TEMP = 4'd2, UPDATE_TEMP = 4'd3, UPDATE_WORDS = 4'd4, DONE_EXPANSION = 4'd5;
    localparam PROCESS_CIPHER = 4'd6,  DONE_AES = 4'd7, WB2data_mem = 4'd8, DONE_WB = 4'd9;


    // SubWord and RotWord functions
    function [31:0] SubWord(input [31:0] word);    
        begin 
            SubWord[31:24] = sbox[word[31:24]];
            SubWord[23:16] = sbox[word[23:16]];
            SubWord[15:8]  = sbox[word[15:8]];
            SubWord[7:0]   = sbox[word[7:0]];
        end
    endfunction

    function [31:0] RotWord(input [31:0] word);
        begin
            RotWord = {word[23:0], word[31:24]};
        end
    endfunction


    // Cipher function
    function [127:0] AddRoundKey(input [127:0] state, input [127:0] round_key);
        AddRoundKey = state ^ round_key;
    endfunction

    function [127:0] SubBytes(input [127:0] state_in);
        
        reg [127:0] state_out;
        begin
            for (j = 0; j < 16; j = j + 1) begin
                state_out[j*8 +: 8] = sbox[state_in[j*8 +: 8]];  // Tra c?u t? S-box
            end
            SubBytes = state_out;
        end
    endfunction

    function [127:0] ShiftRows(input [127:0] state_in);
    reg [7:0] state_matrix [3:0][3:0];  // Ma tr?n 4x4 l?u c�c byte
    reg [7:0] state_out_matrix [3:0][3:0];  // Ma tr?n 4x4 sau khi ShiftRows
    integer i, j;
    begin
        // B??c 1: S?p x?p c�c byte c?a state_in th�nh ma tr?n 4x4
        state_matrix[0][0] = state_in[127:120];
        state_matrix[1][0] = state_in[119:112];
        state_matrix[2][0] = state_in[111:104];
        state_matrix[3][0] = state_in[103:96];
        
        state_matrix[0][1] = state_in[95:88];
        state_matrix[1][1] = state_in[87:80];
        state_matrix[2][1] = state_in[79:72];
        state_matrix[3][1] = state_in[71:64];
        
        state_matrix[0][2] = state_in[63:56];
        state_matrix[1][2] = state_in[55:48];
        state_matrix[2][2] = state_in[47:40];
        state_matrix[3][2] = state_in[39:32];
        
        state_matrix[0][3] = state_in[31:24];
        state_matrix[1][3] = state_in[23:16];
        state_matrix[2][3] = state_in[15:8];
        state_matrix[3][3] = state_in[7:0];

        // B??c 2: Th?c hi?n ShiftRows tr�n t?ng h�ng
        // H�ng 1: Kh�ng d?ch
        for (j = 0; j < 4; j = j + 1) begin
            state_out_matrix[0][j] = state_matrix[0][j];
        end

        // H�ng 2: D?ch sang tr�i 1 byte
        state_out_matrix[1][0] = state_matrix[1][1];
        state_out_matrix[1][1] = state_matrix[1][2];
        state_out_matrix[1][2] = state_matrix[1][3];
        state_out_matrix[1][3] = state_matrix[1][0];

        // H�ng 3: D?ch sang tr�i 2 byte
        state_out_matrix[2][0] = state_matrix[2][2];
        state_out_matrix[2][1] = state_matrix[2][3];
        state_out_matrix[2][2] = state_matrix[2][0];
        state_out_matrix[2][3] = state_matrix[2][1];

        // H�ng 4: D?ch sang tr�i 3 byte
        state_out_matrix[3][0] = state_matrix[3][3];
        state_out_matrix[3][1] = state_matrix[3][0];
        state_out_matrix[3][2] = state_matrix[3][1];
        state_out_matrix[3][3] = state_matrix[3][2];

        // B??c 3: Chuy?n ma tr?n 4x4 v?? l?i th�nh 128-bit ??u ra
        ShiftRows = {state_out_matrix[0][0], state_out_matrix[1][0], state_out_matrix[2][0], state_out_matrix[3][0],
                     state_out_matrix[0][1], state_out_matrix[1][1], state_out_matrix[2][1], state_out_matrix[3][1],
                     state_out_matrix[0][2], state_out_matrix[1][2], state_out_matrix[2][2], state_out_matrix[3][2],
                     state_out_matrix[0][3], state_out_matrix[1][3], state_out_matrix[2][3], state_out_matrix[3][3]};
       
        end
    endfunction


    // H�m xtime: Nh�n v?i 2 trong GF(2^8)
    function [7:0] xtime(input [7:0] b);
        xtime = (b << 1) ^ ((b & 8'h80) ? 8'h1b : 8'h00);
    endfunction

    // H�m nh�n GF(2^8) v?i 2
    function [7:0] mul_by_2(input [7:0] b);
        mul_by_2 = xtime(b);
    endfunction

    // H�m nh�n GF(2^8) v?i 3 (3 * b = (2 * b) XOR b)
    function [7:0] mul_by_3(input [7:0] b);
        mul_by_3 = xtime(b) ^ b;
    endfunction

    // H�m MixColumns ch�nh
    function [127:0] MixColumns(input [127:0] state_in);
        reg [31:0] col0, col1, col2, col3;          // C�c c?t c?a ma tr?n 4x4
        reg [31:0] out_col0, out_col1, out_col2, out_col3; // C�c c?t sau khi MixColumns

        begin
            // T�ch t?ng c?t t? state_in
            col0 = state_in[127:96];
            col1 = state_in[95:64];
            col2 = state_in[63:32];
            col3 = state_in[31:0];

            // MixColumns cho t?ng c?t
            out_col0 = {mul_by_2(col0[31:24]) ^ mul_by_3(col0[23:16]) ^ col0[15:8] ^ col0[7:0],
                        col0[31:24] ^ mul_by_2(col0[23:16]) ^ mul_by_3(col0[15:8]) ^ col0[7:0],
                        col0[31:24] ^ col0[23:16] ^ mul_by_2(col0[15:8]) ^ mul_by_3(col0[7:0]),
                        mul_by_3(col0[31:24]) ^ col0[23:16] ^ col0[15:8] ^ mul_by_2(col0[7:0])};

            out_col1 = {mul_by_2(col1[31:24]) ^ mul_by_3(col1[23:16]) ^ col1[15:8] ^ col1[7:0],
                        col1[31:24] ^ mul_by_2(col1[23:16]) ^ mul_by_3(col1[15:8]) ^ col1[7:0],
                        col1[31:24] ^ col1[23:16] ^ mul_by_2(col1[15:8]) ^ mul_by_3(col1[7:0]),
                        mul_by_3(col1[31:24]) ^ col1[23:16] ^ col1[15:8] ^ mul_by_2(col1[7:0])};

            out_col2 = {mul_by_2(col2[31:24]) ^ mul_by_3(col2[23:16]) ^ col2[15:8] ^ col2[7:0],
                        col2[31:24] ^ mul_by_2(col2[23:16]) ^ mul_by_3(col2[15:8]) ^ col2[7:0],
                        col2[31:24] ^ col2[23:16] ^ mul_by_2(col2[15:8]) ^ mul_by_3(col2[7:0]),
                        mul_by_3(col2[31:24]) ^ col2[23:16] ^ col2[15:8] ^ mul_by_2(col2[7:0])};

            out_col3 = {mul_by_2(col3[31:24]) ^ mul_by_3(col3[23:16]) ^ col3[15:8] ^ col3[7:0],
                        col3[31:24] ^ mul_by_2(col3[23:16]) ^ mul_by_3(col3[15:8]) ^ col3[7:0],
                        col3[31:24] ^ col3[23:16] ^ mul_by_2(col3[15:8]) ^ mul_by_3(col3[7:0]),
                        mul_by_3(col3[31:24]) ^ col3[23:16] ^ col3[15:8] ^ mul_by_2(col3[7:0])};

            // K?t h?p l?i c�c c?t ?? t?o ra ??u ra 128-bit
            MixColumns = {out_col0, out_col1, out_col2, out_col3};
        end

    endfunction


    // Initial or Reset Logic
    always @(posedge clk or posedge reset) begin
        if (~reset) begin
            state <= IDLE;
            nk <= 4'd4;;
            nr <= 4'd10;
            i <= 0;
            temp_next <= 32'b0;
//            done_exp <= 0;

        // end else if (AES_W) begin 

        //     key_size_r <= key_size;

        end else if (enable_AES) begin
            case (state)
                IDLE: begin
//                    done_exp <= 0;
                    case (key_size)
                        2'd0: begin
                            nk <= 4;  // AES-128
                            nr <= 10;
                        end
                        2'd1: begin
                            nk <= 6;  // AES-192
                            nr <= 12;
                        end
                        2'd2: begin
                            nk <= 8;  // AES-256
                            nr <= 14;
                        end
                        default: begin
                            nk <= nk;
                            nr <= nr;
                        end
                    endcase
                    state <= INIT;
                    key = {key0,key1,key2,key3,key4,key5,key6,key7};

                end

                INIT: begin
                    if (AES_mode == 0) begin // ECB
                        input_plaintxt <= {plaint1,plaint2,plaint3,plaint4};
                    end else if (AES_mode == 2'd1) begin // CFB
                        input_plaintxt <= {iv1, iv2, iv3, iv4};
                    end else if (AES_mode == 2'd2) begin // CBC
                        input_plaintxt <= {plaint1,plaint2,plaint3,plaint4} ^ {iv1, iv2, iv3, iv4};
                    end else begin 
                        input_plaintxt <= {iv1,iv2,iv3,iv4};
                    end 

                            words[0] <= key[255:224];
                            words[1] <= key[223:192];
                            words[2] <= key[191:160];
                            words[3] <= key[159:128];
                            words[4] <= key[127:96];
                            words[5] <= key[95:64];
                            words[6] <= key[63:32];
                            words[7] <= key[31:0];
                    i <= nk;
                    state <= CALC_TEMP;

                end

                CALC_TEMP: begin
                    if (i < (4 * (nr + 1))) begin
                        temp_next <= words[i - 1]; // C?p nh?t gi� tr? c?a temp
                        state <= UPDATE_TEMP; // Chuy?n sang tr?ng th�i t�nh to�n temp_next
                    end else begin
                        state <= DONE_EXPANSION;
                        for (i = 0; i < 15; i = i + 1) begin
                          round_keys[i] = {words[4*i], words[4*i+1], words[4*i+2], words[4*i+3]};
                         end
                    end
                end

                UPDATE_TEMP: begin
                    if (i % nk == 0) begin
                        temp_next <= SubWord(RotWord(temp_next)) ^ rcon[i / nk - 1];
                    end else if (nk > 6 && i % nk == 4) begin
                        temp_next <= SubWord(temp_next);
                    end else begin
                        temp_next <= temp_next;
                    end
                    state <= UPDATE_WORDS; // Chuy?n sang c?p nh?t words
                end

                UPDATE_WORDS: begin
                    words[i] <= words[i - nk] ^ temp_next; // C?p nh?t gi� tr? words
                    i <= i + 1;
                    state <= CALC_TEMP; // Quay l?i t�nh to�n temp
                end

                DONE_EXPANSION: begin
                   
                    state_r <= AddRoundKey(input_plaintxt,round_keys[0]);
                    state <= PROCESS_CIPHER;
                    round <= 1;
                end

                PROCESS_CIPHER: begin
                    if (round < nr)  begin
                        state_r <= AddRoundKey(MixColumns(ShiftRows(SubBytes(state_r))), round_keys[round]);
                        round <= round + 1;
                    end else begin
                        state_r <= AddRoundKey(ShiftRows(SubBytes(state_r)), round_keys[round]);
                        state <= DONE_AES;
                    end 
                end 

                DONE_AES: begin
                    if (AES_mode == 2'b0 || AES_mode == 2'd2) begin
                        result <= state_r;
                    end else if (AES_mode == 2'd1 || AES_mode == 2'd3) begin 
                        result <= state_r ^ {plaint1,plaint2,plaint3,plaint4};        
                    end else begin
                        result <= state_r;
                    end 
                    done_aes_r <= 1;
                    state <= IDLE;
                    //round <= 0;
                end

                WB2data_mem: 
                if (round < 5) begin 
                    done_aes_r <= 1;
                    round = round + 1;
                end else begin
                    state <= IDLE;
                    done_aes_r <= 0;
                end
                default: begin
                    state <= state;
                    state_r <= state_r;
                    round <= round;
                end
            endcase
        end else begin
            state <= 0;
            nk <= 0;
            nr <= 0;
            i <= 0;

            temp_next <= 0;
            
            done_aes_r <= 0;
            
        end

    end

endmodule

