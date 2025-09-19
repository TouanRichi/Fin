module fsm_controller(
    input wire clk,             // Clock signal
    input wire rst,             // Reset signal
    input wire start_sha,       // Start signal from Control Unit and custom Instruction
 // Chọn chế độ SHA (256, 384, 512)
    input [31:0] w0_sha256,
    input [31:0] w1_sha256,
    input [31:0] w2_sha256,
    input [31:0] w3_sha256,
    input [31:0] w4_sha256,
    input [31:0] w5_sha256,
    input [31:0] w6_sha256,
    input [31:0] w7_sha256,
    input [31:0] w8_sha256,
    input [31:0] w9_sha256,
    input [31:0] w10_sha256,
    input [31:0] w11_sha256,
    input [31:0] w12_sha256,
    input [31:0] w13_sha256,
    input [31:0] w14_sha256,
    input [31:0] w15_sha256,

    input [63:0] w0_sha512,
    input [63:0] w1_sha512,
    input [63:0] w2_sha512,
    input [63:0] w3_sha512,
    input [63:0] w4_sha512,
    input [63:0] w5_sha512,
    input [63:0] w6_sha512,
    input [63:0] w7_sha512,
    input [63:0] w8_sha512,
    input [63:0] w9_sha512,
    input [63:0] w10_sha512,
    input [63:0] w11_sha512,
    input [63:0] w12_sha512,
    input [63:0] w13_sha512,
    input [63:0] w14_sha512,
    input [63:0] w15_sha512,

    input [63:0] A_i2,
    input [63:0] B_i2,
    input [63:0] C_i2,
    input [63:0] D_i2,
    input [63:0] E_i2,
    input [63:0] F_i2,
    input [63:0] G_i2,
    input [63:0] H_i2,

    input [31:0] A_i,
    input [31:0] B_i,
    input [31:0] C_i,
    input [31:0] D_i,
    input [31:0] E_i,
    input [31:0] F_i,
    input [31:0] G_i,
    input [31:0] H_i,
    output reg start_sha_o,     // Tín hiệu thanh ghi hoạt động

    output reg sel_mux,          // Chọn MUX
    output reg sel_mux2,          // Chọn MUX
    
    output reg sel_res256,      // Kết quả SHA256
    output reg sel_res512,      // Kết quả SHA512

    output reg ena_K_reg,       // Kích hoạt thanh ghi K

    output reg [31:0] reg16_out, // Đầu ra thanh ghi 16
    output reg [63:0] reg16_out2, // Đầu ra thanh ghi 16
    
    output reg sel_parise_mux,
    output reg sel_parise_mux2,

    output wire [31:0] A_o,
    output wire [31:0] B_o,
    output wire [31:0] C_o,
    output wire [31:0] D_o,
    output wire [31:0] E_o,
    output wire [31:0] F_o,
    output wire [31:0] G_o,
    output wire [31:0] H_o,
    output wire [63:0] A_o2,
    output wire [63:0] B_o2,
    output wire [63:0] C_o2,
    output wire [63:0] D_o2,
    output wire [63:0] E_o2,
    output wire [63:0] F_o2,
    output wire [63:0] G_o2,
    output wire [63:0] H_o2,
    
    output reg done_Sha


);

    // FOR 256
    reg [31:0] A_o_r;
    reg [31:0] B_o_r;
    reg [31:0] C_o_r;
    reg [31:0] D_o_r;
    reg [31:0] E_o_r;
    reg [31:0] F_o_r;
    reg [31:0] G_o_r;
    reg [31:0] H_o_r;

    // Expanded key words - Must be declared before use
    reg [31:0] reg16 [0:15];
    reg [63:0] reg16_2 [0:15];

    assign A_o = A_o_r;
    assign B_o = B_o_r;
    assign C_o = C_o_r;
    assign D_o = D_o_r;
    assign E_o = E_o_r;
    assign F_o = F_o_r;
    assign G_o = G_o_r;
    assign H_o = H_o_r;

    reg [31:0] const_H0_r = 32'h6A09E667;
    reg [31:0] const_H1_r = 32'hBB67AE85;
    reg [31:0] const_H2_r = 32'h3C6EF372;
    reg [31:0] const_H3_r = 32'hA54FF53A;
    reg [31:0] const_H4_r = 32'h510E527F;
    reg [31:0] const_H5_r = 32'h9B05688C;
    reg [31:0] const_H6_r = 32'h1F83D9AB;
    reg [31:0] const_H7_r = 32'h5BE0CD19;
//-----------------------------------------------

    // FOR 384,512
    reg [63:0] A_o_r2;
    reg [63:0] B_o_r2;
    reg [63:0] C_o_r2;
    reg [63:0] D_o_r2;
    reg [63:0] E_o_r2;
    reg [63:0] F_o_r2;
    reg [63:0] G_o_r2;
    reg [63:0] H_o_r2;

    assign A_o2 = A_o_r2; 
    assign B_o2 = B_o_r2;
    assign C_o2 = C_o_r2;
    assign D_o2 = D_o_r2;
    assign E_o2 = E_o_r2;
    assign F_o2 = F_o_r2;
    assign G_o2 = G_o_r2;
    assign H_o2 = H_o_r2;

    // CONSTANT FOR 384
    reg [63:0] const_H0_r2 = 64'hCBBB9D5DC1059ED8;
    reg [63:0] const_H1_r2 = 64'h629A292A367CD507;
    reg [63:0] const_H2_r2 = 64'h9159015A3070DD17;
    reg [63:0] const_H3_r2 = 64'h152FECD8F70E5939;
    reg [63:0] const_H4_r2 = 64'h67332667FFC00B31;
    reg [63:0] const_H5_r2 = 64'h8EB44A8768581511;
    reg [63:0] const_H6_r2 = 64'hDB0C2E0D64F98FA7;
    reg [63:0] const_H7_r2 = 64'h47B5481DBEFA4FA4;

    // CONSTANT FOR 512
    reg [63:0] const_H0_r3 = 64'h6A09E667F3BCC908;
    reg [63:0] const_H1_r3 = 64'hBB67AE8584CAA73B;
    reg [63:0] const_H2_r3 = 64'h3C6EF372FE94F82B;
    reg [63:0] const_H3_r3 = 64'hA54FF53A5F1D36F1;
    reg [63:0] const_H4_r3 = 64'h510E527FADE682D1;
    reg [63:0] const_H5_r3 = 64'h9B05688C2B3E6C1F;
    reg [63:0] const_H6_r3 = 64'h1F83D9ABFB41BD6B;
    reg [63:0] const_H7_r3 = 64'h5BE0CD19137E2179;

    always @(posedge clk or posedge rst) begin
        if (~rst) begin
            A_o_r <= 32'h0;
            B_o_r <= 32'h0;
            C_o_r <= 32'h0;
            D_o_r <= 32'h0;
            E_o_r <= 32'h0;
            F_o_r <= 32'h0;
            G_o_r <= 32'h0;
            H_o_r <= 32'h0;

            A_o_r2 <= 64'h0;
            B_o_r2 <= 64'h0;
            C_o_r2 <= 64'h0;
            D_o_r2 <= 64'h0;
            E_o_r2 <= 64'h0;
            F_o_r2 <= 64'h0;
            G_o_r2 <= 64'h0;
            H_o_r2 <= 64'h0;

            reg16[0] <= 32'h0;
            reg16[1] <= 32'h0;
            reg16[2] <= 32'h0;
            reg16[3] <= 32'h0;
            reg16[4] <= 32'h0;
            reg16[5] <= 32'h0;
            reg16[6] <= 32'h0;
            reg16[7] <= 32'h0;
            reg16[8] <= 32'h0;
            reg16[9] <= 32'h0;
            reg16[10] <= 32'h0;
            reg16[11] <= 32'h0;
            reg16[12] <= 32'h0;
            reg16[13] <= 32'h0;
            reg16[14] <= 32'h0;
            reg16[15] <= 32'h0;
            reg16_2[0] <= 64'h0;
            reg16_2[1] <= 64'h0;
            reg16_2[2] <= 64'h0;
            reg16_2[3] <= 64'h0;
            reg16_2[4] <= 64'h0;
            reg16_2[5] <= 64'h0;
            reg16_2[6] <= 64'h0;
            reg16_2[7] <= 64'h0;
            reg16_2[8] <= 64'h0;
            reg16_2[9] <= 64'h0;
            reg16_2[10] <= 64'h0;
            reg16_2[11] <= 64'h0;
            reg16_2[12] <= 64'h0;
            reg16_2[13] <= 64'h0;
            reg16_2[14] <= 64'h0;
            reg16_2[15] <= 64'h0;

        end else begin
            if (start_sha) begin
                A_o_r <= A_i;
                B_o_r <= B_i;
                C_o_r <= C_i;
                D_o_r <= D_i;
                E_o_r <= E_i;
                F_o_r <= F_i;
                G_o_r <= G_i;
                H_o_r <= H_i;
            
                A_o_r2 <= A_i2;
                B_o_r2 <= B_i2;
                C_o_r2 <= C_i2;
                D_o_r2 <= D_i2;
                E_o_r2 <= E_i2;
                F_o_r2 <= F_i2;
                G_o_r2 <= G_i2;
                H_o_r2 <= H_i2;

                // Gán các w đầu vào thanh ghi 16
                reg16[0] <= w0_sha256;
                reg16[1] <= w1_sha256;
                reg16[2] <= w2_sha256;
                reg16[3] <= w3_sha256;
                reg16[4] <= w4_sha256;
                reg16[5] <= w5_sha256;
                reg16[6] <= w6_sha256;
                reg16[7] <= w7_sha256;
                reg16[8] <= w8_sha256;
                reg16[9] <= w9_sha256;
                reg16[10] <= w10_sha256;
                reg16[11] <= w11_sha256;
                reg16[12] <= w12_sha256;
                reg16[13] <= w13_sha256;
                reg16[14] <= w14_sha256;
                reg16[15] <= w15_sha256;
                reg16_2[0] <= w0_sha512;
                reg16_2[1] <= w1_sha512;
                reg16_2[2] <= w2_sha512;
                reg16_2[3] <= w3_sha512;
                reg16_2[4] <= w4_sha512;
                reg16_2[5] <= w5_sha512;
                reg16_2[6] <= w6_sha512;
                reg16_2[7] <= w7_sha512;
                reg16_2[8] <= w8_sha512;
                reg16_2[9] <= w9_sha512;
                reg16_2[10] <= w10_sha512;
                reg16_2[11] <= w11_sha512;
                reg16_2[12] <= w12_sha512;
                reg16_2[13] <= w13_sha512;
                reg16_2[14] <= w14_sha512;
                reg16_2[15] <= w15_sha512;

                    
            end else begin
                A_o_r <= A_o_r;
                B_o_r <= B_o_r;
                C_o_r <= C_o_r;
                D_o_r <= D_o_r;
                E_o_r <= E_o_r;
                F_o_r <= F_o_r;
                G_o_r <= G_o_r;
                H_o_r <= H_o_r;

                A_o_r2 <= A_o_r2;
                B_o_r2 <= B_o_r2;
                C_o_r2 <= C_o_r2;
                D_o_r2 <= D_o_r2;
                E_o_r2 <= E_o_r2;
                F_o_r2 <= F_o_r2;
                G_o_r2 <= G_o_r2;
                H_o_r2 <= H_o_r2;

                // Gán các w đầu vào thanh ghi 16
                reg16[0] <= reg16[0];
                reg16[1] <= reg16[1];
                reg16[2] <= reg16[2];
                reg16[3] <= reg16[3];
                reg16[4] <= reg16[4];
                reg16[5] <= reg16[5];
                reg16[6] <= reg16[6];
                reg16[7] <= reg16[7];
                reg16[8] <= reg16[8];
                reg16[9] <= reg16[9];
                reg16[10] <= reg16[10];
                reg16[11] <= reg16[11];
                reg16[12] <= reg16[12];
                reg16[13] <= reg16[13];
                reg16[14] <= reg16[14];
                reg16[15] <= reg16[15];
                reg16_2[0] <= reg16_2[0];
                reg16_2[1] <= reg16_2[1];
                reg16_2[2] <= reg16_2[2];
                reg16_2[3] <= reg16_2[3];
                reg16_2[4] <= reg16_2[4];
                reg16_2[5] <= reg16_2[5];
                reg16_2[6] <= reg16_2[6];
                reg16_2[7] <= reg16_2[7];
                reg16_2[8] <= reg16_2[8];
                reg16_2[9] <= reg16_2[9];
                reg16_2[10] <= reg16_2[10];
                reg16_2[11] <= reg16_2[11];
                reg16_2[12] <= reg16_2[12];
                reg16_2[13] <= reg16_2[13];
                reg16_2[14] <= reg16_2[14];
                reg16_2[15] <= reg16_2[15];
            
            end
        end
    end

    // initial begin
    //     // reg16[0] <= 32'h68656C6C;
    //     // reg16[1] <= 32'h6F20776F;
    //     // reg16[2] <= 32'h726C6480;

    //     reg16[0] <= 32'h61626380;
    //     reg16[1] <= 32'h00000000;
    //     reg16[2] <= 32'h00000000;
        
    //     reg16[3] <= 32'h00000000;
    //     reg16[4] <= 32'h00000000; 
    //     reg16[5] <= 32'h00000000;  
    //     reg16[6] <= 32'h00000000;
    //     reg16[7] <= 32'h00000000;
    //     reg16[8] <= 32'h00000000;
    //     reg16[9] <= 32'h00000000;
    //     reg16[10] <= 32'h00000000;
    //     reg16[11] <= 32'h00000000;
    //     reg16[12] <= 32'h00000000;
    //     reg16[13] <= 32'h00000000;
    //     reg16[14] <= 32'h00000000;
    //     reg16[15] <= 32'h00000018;

    //     reg16_2[0] <= 64'h6162638000000000; // other = 0
    //     reg16_2[1] <= 64'h0000000000000000;
    //     reg16_2[2] <= 64'h0000000000000000;
    //     reg16_2[3] <= 64'h0000000000000000;
    //     reg16_2[4] <= 64'h0000000000000000;
    //     reg16_2[5] <= 64'h0000000000000000;
    //     reg16_2[6] <= 64'h0000000000000000;
    //     reg16_2[7] <= 64'h0000000000000000;
    //     reg16_2[8] <= 64'h0000000000000000;
    //     reg16_2[9] <= 64'h0000000000000000;
    //     reg16_2[10] <= 64'h0000000000000000;
    //     reg16_2[11] <= 64'h0000000000000000;
    //     reg16_2[12] <= 64'h0000000000000000;
    //     reg16_2[13] <= 64'h0000000000000000;
    //     reg16_2[14] <= 64'h0000000000000000;
    //     reg16_2[15] <= 64'h0000000000000018;

    // end 
    // Gán các w đầu vào thanh ghi 16

    // Enable and counter signals
    reg ena_cnt_r;
    wire ena_cnt_w;
    assign ena_cnt_w = ena_cnt_r;

    reg [8:0] cnt_r;            // Bộ đếm 9-bit
    wire [8:0] cnt_w;           // Giá trị mới của bộ đếm
    assign cnt_w = cnt_r;
    // Bộ đếm tăng lên mỗi chu kỳ đồng hồ
    always @(posedge clk or posedge rst) begin
        if (!rst) begin
            cnt_r <= 9'd0;       // Reset bộ đếm về 0
        end else begin
            if (ena_cnt_w) begin
            cnt_r <= cnt_w + 9'd1;     // Cập nhật giá trị bộ đếm
            end else begin
            cnt_r <= 9'd0;      // Reset bộ đếm
            end
        end
    end

    // State definitions
    parameter IDLE   = 3'b000, 
              STATE1 = 3'b001, 
              STATE2 = 3'b010, 
              STATE3 = 3'b011,
              STATE4 = 3'b100, 
              DONE   = 3'b101;

    // State registers
    reg [2:0] current_state_r;  // Trạng thái hiện tại
    reg [2:0] next_state_r;     // Trạng thái tiếp theo
    wire [2:0] current_state_w; // Trạng thái hiện tại (để đọc)
    assign current_state_w = current_state_r;
    wire [2:0] next_state_w;    // Trạng thái tiếp theo (để đọc)
    assign next_state_w = next_state_r;

    // State transition logic (synchronous logic)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            current_state_r <= IDLE;  // Reset về trạng thái chờ
            start_sha_o <= 1'b0;      // Không kích hoạt thanh ghi SHA
        end else begin
            current_state_r <= next_state_w; // Always update to next state
            if (start_sha && current_state_r == IDLE) begin
                start_sha_o <= 1'b1; // Kích hoạt thanh ghi SHA khi bắt đầu
            end else if (current_state_r == DONE) begin
                start_sha_o <= 1'b0; // Tắt tín hiệu khi hoàn thành
            end
            // Otherwise keep start_sha_o unchanged
        end
    end

    // Next state determination logic (combinational logic)
    always @(current_state_r or start_sha or cnt_r) begin
        // Default next state
        next_state_r = current_state_r;  // Stay in current state by default

        case (current_state_r)
            IDLE: begin
                if (start_sha) begin
                    next_state_r = STATE1; // Chuyển sang trạng thái 1 khi nhận tín hiệu start
                end else begin
                    next_state_r = IDLE;  // Giữ trạng thái chờ
                end
            end
            STATE1: begin
                next_state_r = STATE2; // STATE1 chỉ tốn 1 chu kỳ
            end
            STATE2: begin
                if (cnt_r == 9'd16) begin
                    next_state_r = STATE3; // Chuyển sang trạng thái 3 khi hoàn thành STATE2
                end else begin
                    next_state_r = STATE2; // Giữ trạng thái 2
                end
            end
            STATE3: begin
                if (cnt_r == 9'd65) begin
                    next_state_r = STATE4; // Chuyển sang trạng thái DONE khi hoàn thành STATE3
                end else begin
                    next_state_r = STATE3; // Giữ trạng thái 3
                end
            end
            STATE4: begin
                if (cnt_r == 9'd82) begin
                    next_state_r = DONE; // Chuyển sang trạng thái DONE khi hoàn thành STATE4
                end else begin
                    next_state_r = STATE4; // Giữ trạng thái 4
                end
            end
            DONE: begin
                if (!start_sha) begin
                    next_state_r = IDLE; // Quay lại trạng thái chờ khi tín hiệu start tắt
                end else begin
                    next_state_r = DONE; // Giữ trạng thái hoàn thành
                end
            end
            default: begin
                next_state_r = IDLE; // Mặc định quay lại trạng thái chờ
            end
        endcase
    end

    initial begin
        reg16_out <= 32'b0; // Khởi tạo đầu ra thanh ghi 16 về 0
        cnt_r <= 9'b0; // Khởi tạo bộ đếm về 0
    end

// Thêm tín hiệu cho phép đọc lần lượt Reg16
    always @(posedge clk or posedge rst) begin
        if (!rst) begin
            reg16_out <= 32'b0; // Reset đầu ra về 0
        end else begin
            case (current_state_w) 
            IDLE: begin 
                reg16_out <= 32'b0; // Đầu ra là 0 khi ở trạng thái chờ
                reg16_out2 <= 64'b0; // Đầu ra là 0 khi ở trạng thái chờ
            end
            // STATE1: begin
            //      reg16_out <= reg16[cnt_w]; // Đầu ra là 0 khi ở trạng thái chờ
            // end
            STATE2: begin
                if (cnt_r < 9'd16) begin
                    reg16_out <= reg16[cnt_w]; // Đầu ra là giá trị của thanh ghi 16
                    reg16_out2 <= reg16_2[cnt_w]; // Đầu ra là giá trị của thanh ghi 16
                end else begin
                 reg16_out <= reg16_out ; // Giữ nguyên giá trị hiện tại
                    reg16_out2 <= reg16_out2 ; // Giữ nguyên giá trị hiện tại
                end
            end
            default: begin
                reg16_out <= reg16_out; // Đầu ra là 0 khi ở trạng thái chờ
                reg16_out2 <= reg16_out2; // Đầu ra là 0 khi ở trạng thái chờ
            end
        endcase
        end
        
    end



    // Control output logic (combinational logic)
    always @(current_state_r or start_sha or cnt_r or ena_cnt_r) begin
        // Default values

        sel_parise_mux = 1'b0; // Không chọn MUX_REG_ABCDEDGH
        sel_parise_mux2 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
        sel_mux = 1'b0;
        sel_mux2 = 1'b0;     // Chọn MUX 0
        ena_cnt_r = 1'b0;
        ena_K_reg = 1'b0;
        sel_res256 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
        sel_res512 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
        done_Sha   = 1'b0;

        case (current_state_r)
            IDLE: begin
                sel_mux = 1'b0;     // Chọn MUX 0
                sel_mux2 = 1'b0;     // Chọn MUX 0
                ena_cnt_r = 1'b0;   // Không kích hoạt bộ đếm
                ena_K_reg = 1'b0;   // Không kích hoạt thanh ghi K
                sel_parise_mux = 1'b1; // Không chọn MUX_REG_ABCDEDGH
                sel_parise_mux2 = 1'b1; // Không chọn MUX_REG_ABCDEDGH
                sel_res256 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                sel_res512 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                done_Sha   = 1'b0;
            end
            STATE1: begin
                sel_mux = 1'b0;     // Chọn MUX 0
                sel_mux2 = 1'b0;     // Chọn MUX 0
                ena_cnt_r = 1'b0;   // Không kích hoạt bộ đếm
                ena_K_reg = 1'b0;   // Không Kích hoạt thanh ghi K
                sel_parise_mux = 1'b1; // Không chọn MUX_REG_ABCDEDGH
                sel_parise_mux2 = 1'b1; // Không chọn MUX_REG_ABCDEDGH
                sel_res256 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                sel_res512 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                done_Sha   = 1'b0;
            end
            STATE2: begin
                sel_mux = 1'b0;     // Chọn MUX 0
                sel_mux2 = 1'b0;     // Chọn MUX 0
                ena_cnt_r = 1'b1;   // Kích hoạt bộ đếm
                ena_K_reg = 1'b1;   // Kích hoạt thanh ghi K
                sel_parise_mux = 1'b0; // Chọn MUX_REG_ABCDEDGH
                sel_parise_mux2 = 1'b0; // Chọn MUX_REG_ABCDEDGH
                sel_res256 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                sel_res512 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                done_Sha   = 1'b0;
            end
            STATE3: begin
                sel_mux = 1'b1;     // Chọn MUX 1
                sel_mux2 = 1'b1;     // Chọn MUX 1
                ena_cnt_r = 1'b1;   // Kích hoạt bộ đếm
                ena_K_reg = 1'b1;   // Kích hoạt thanh ghi K
                sel_parise_mux = 1'b0; // Chọn MUX_REG_ABCDEDGH
                sel_parise_mux2 = 1'b0; // Chọn MUX_REG_ABCDEDGH
                sel_res256 = 1'b0; // Chốt kết quả sha256
                sel_res512 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                done_Sha   = 1'b0;
            end

            // STATE4 tiếp tục đếm tới 81 để tính sha384,512
            STATE4: begin
                sel_mux = 1'b1;     // Chọn MUX 1
                sel_mux2 = 1'b1;     // Chọn MUX 1
                ena_cnt_r = 1'b1;   // Kích hoạt bộ đếm
                ena_K_reg = 1'b1;   // Kích hoạt thanh ghi K
                sel_parise_mux = 1'b0; // Chọn MUX_REG_ABCDEDGH
                sel_parise_mux2 = 1'b0; // Chọn MUX_REG_ABCDEDGH
                if(cnt_w == 9'd66) begin
                    sel_res256 = 1'b1; // Chốt kết quả sha256
                end else begin 
                    sel_res256 = 1'b0; // chưa Chốt kết quả sha256
                end
                if(cnt_w == 9'd82) begin
                    sel_res512 = 1'b1; // Chốt kết quả sha256
                end else begin
                    sel_res512 = 1'b0; // chưa Chốt kết quả sha256
                end
                done_Sha   = 1'b0;
            end

            DONE: begin
                sel_mux = 1'b0;     // Chọn MUX 0
                sel_mux2 = 1'b0;     // Chọn MUX 0
                ena_cnt_r = 1'b0;   // Không kích hoạt bộ đếm
                ena_K_reg = 1'b0;   // Không kích hoạt thanh ghi K
                sel_parise_mux = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                sel_parise_mux2 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                sel_res256 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                sel_res512 = 1'b0; // Không chọn MUX_REG_ABCDEDGH
                done_Sha   = 1'b1;  // Chot dap an
            end
            default: begin
                sel_mux = sel_mux; // Giữ nguyên trạng 
                sel_mux2 = sel_mux2; // Giữ nguyên trạng thái
                ena_cnt_r = ena_cnt_r; // Giữ nguyên trạng thái
                ena_K_reg = ena_K_reg; // Giữ nguyên trạng thái
                sel_parise_mux = sel_parise_mux; // Giữ nguyên trạng thái
                sel_parise_mux2 = sel_parise_mux2; // Giữ nguyên trạng thái
                sel_res256 = sel_res256; // Giữ nguyên trạng thái
                sel_res512 = sel_res512; // Giữ nguyên trạng thái
                done_Sha = done_Sha;
            end
        endcase
    end
endmodule