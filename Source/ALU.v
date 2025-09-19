// module ALU(
//     input [31:0] a, b,           // a = rs1, b = rs2
//     input [4:0] alu_ctrl,        // ALU control signal (5-bit)
//     output reg [31:0] result
// );
//     always @(*) begin
//         case (alu_ctrl)
//             5'b00000: result = a + b;          // ADD
//             5'b00001: result = a - b;          // SUB
//             5'b00010: result = a ^ b;          // XOR
//             5'b00011: result = a | b;          // OR
//             5'b00100: result = a & b;          // AND
//             5'b00101: result = a << b[4:0];    // SLL (shift left logic, 5-bit shift amount)
//             5'b00110: result = a >> b[4:0];    // SRL (shift right logic, 5-bit shift amount)
//             5'b00111: result = $signed(a) >>> b[4:0]; // SRA (arithmetic shift right)

//             5'b01000: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT (signed)
//             5'b01001: result = (a < b) ? 32'b1 : 32'b0;  // SLTU (unsigned)
//             5'b01010: result = ($signed(a) == $signed(b)) ? 32'b1 : 32'b0; // BEQ
//             5'b01011: result = ($signed(a) != $signed(b)) ? 32'b1 : 32'b0; // BNE
//             5'b01100: result = ($signed(a) >= $signed(b)) ? 32'b1 : 32'b0; // BGE
//             5'b01101: result = (a >= b) ? 32'b1 : 32'b0;  // BGEU (unsigned)

//             5'b01110: result = b << 12;                 // LUI
//             5'b01111: result = a + (b << 12);           // AUIPC
            
//             // Các l?nh nhân và chia (RISC-V M extension)
//             5'b10000: result = a * b;                   // MUL (32-bit multiplication)
//             5'b10001: result = ($signed(a) * $signed(b)) >> 32;  // MULH (32-bit multiplication, high part)
//             5'b10010: result = ($signed(a) * b) >> 32;  // MULHSU (mixed signed/unsigned)
//             5'b10011: result = a * b >> 32;             // MULHU (unsigned multiplication, high part)
            
//             5'b10100: result = $signed(a) / $signed(b); // DIV (signed)
//             5'b10101: result = a / b;                   // DIVU (unsigned)
            
//             5'b10110: result = $signed(a) % $signed(b); // REM (signed remainder)
//             5'b10111: result = a % b;                   // REMU (unsigned remainder)

//             // Các l?nh b? sung khác có th? thêm t?i ?ây
//             default: result = 32'b0;
//         endcase
//     end
// endmodule

module ALU(
    input [31:0] a, b,           // a = rs1, b = rs2
    input [4:0] alu_ctrl,        // ALU control signal (5-bit)
    output reg signed [31:0] result
);

    wire res_temp;
    wire signed [31:0] a_temp, b_temp;


    parameter one = 32'd1, zero_0 = 32'd0;
    assign res_temp = result;
    assign A_temp = a;
    assign B_temp = b;


    always @(a or b or alu_ctrl or A_temp or B_temp) begin
        case (alu_ctrl)
            5'b00000: result <= a + b;          // ADD
            5'b00001: result <= a - b;          // SUB
            5'b00010: result <= a ^ b;          // XOR
            5'b00011: result <= a | b;          // OR
            5'b00100: result <= a & b;          // AND
            5'b00101: result <= a << b;    // SLL (shift left logic, 5-bit shift amount)
            5'b00110: result <= a >> b;    // SRL (shift right logic, 5-bit shift amount)
            5'b00111: result <= (A_temp >>> b); // SRA (arithmetic shift right)

            5'b01000: result <= (A_temp < B_temp) ? one : zero_0; // SLT (signed)
            5'b01001: result <= (a < b) ? one : zero_0;  // SLTU (unsigned)
            5'b01010: result <= (A_temp == B_temp) ? one : zero_0; // BEQ
            5'b01011: result <= (A_temp != B_temp) ? one : zero_0; // BNE
            5'b01100: result <= (A_temp >= B_temp) ? one : zero_0; // BGE
            5'b01101: result <= (a >= b) ? one : zero_0;  // BGEU (unsigned)

            // 5'b01110: result = b << 12;                 // LUI
            // 5'b01111: result = a + (b << 12);           // AUIPC
            
            // Các l?nh nhân và chia (RISC-V M extension)
            // 5'b10000: result <= a * b;                   // MUL (32-bit multiplication)
            // 5'b10001: result = (A_temp * B_temp) >> 32;  // MULH (32-bit multiplication, high part)
            // 5'b10010: result = ($signed(a) * b) >> 32;  // MULHSU (mixed signed/unsigned)
            // 5'b10011: result = a * b >> 32;             // MULHU (unsigned multiplication, high part)
            
            // 5'b10100: result <= A_temp / B_temp; // DIV (signed)
            // 5'b10101: result = a / b;                   // DIVU (unsigned)
            
            // 5'b10110: result = $signed(a) % $signed(b); // REM (signed remainder)
            // 5'b10111: result = a % b;                   // REMU (unsigned remainder)

            // Các l?nh b? sung khác có th? thêm t?i ?ây
            default: result <= 32'b0;
        endcase
    end
endmodule
