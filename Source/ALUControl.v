// module ALUControl(
//     input [2:0] funct3,
//     input [6:0] funct7,
//     input [2:0] alu_op,
//     output reg [4:0] alu_ctrl
// );

//     always @(*) begin
//         case (alu_op)
//             3'b000: begin               // R Type
//                 case (funct3)
//                     3'b000: begin
//                         case (funct7)
//                             7'd0: alu_ctrl = 5'b00000; // ADD
//                             7'd32: alu_ctrl = 5'b00001;// SUB
//                             7'd1:  alu_ctrl = 5'b10000; // MUL
//                             default: alu_ctrl = 5'b00000; // ADD
//                         endcase
//                     end
//                     3'b100: alu_ctrl = (funct7 == 7'd1)?5'b10100: 5'b00010; // XOR
//                     3'b110: alu_ctrl = (funct7 == 7'd1)?5'b10110: 5'b00011; // OR
//                     3'b111: alu_ctrl = (funct7 == 7'd1)?5'b10111: 5'b00100; // AND
//                     3'b001: alu_ctrl = (funct7 == 7'd1)? 5'b10001 : 5'b00101; // MULH SLL
//                     3'b101: begin
//                         case (funct7)
//                             7'b0100000: alu_ctrl = 5'b00111; // sra
//                             7'd1:  alu_ctrl = 5'b10101; // divu
//                             default: alu_ctrl = 5'b00110;// srl
//                         endcase
//                     end  
//                     3'b010: alu_ctrl = (funct7 == 7'd1)? 5'b10010 : 5'b01000; // MULSH SLT
//                     3'b011: alu_ctrl = (funct7 == 7'd1)? 5'b10011 : 5'b01001; // SLTU

//                     default: alu_ctrl = 5'b00000;
//                 endcase
//             end

//             3'b001: begin               // I Type
//                 case (funct3)
//                     3'b000: alu_ctrl = 5'b00000; // ADDI
//                     3'b100: alu_ctrl = 5'b00010; // XORI
//                     3'b100: alu_ctrl = 5'b00010; // XORI
//                     3'b110: alu_ctrl = 5'b00011; // ORI
//                     3'b111: alu_ctrl = 5'b00100; // ANDI
//                     3'b001: alu_ctrl = 5'b00101; // SLLI
//                     3'b101: alu_ctrl = (funct7 == 7'b0100000) ? 5'b00111 : 5'b00110; // SRL/SRAI
//                     3'b010: alu_ctrl = 5'b01000; // SLTI
//                     3'b011: alu_ctrl = 5'b01001; // SLTIU
//                     default: alu_ctrl = 5'b00000;
//                 endcase
//             end

//             3'b010: begin // LOAD, STORE TYPE
//                 alu_ctrl = 5'b00000; // ADDI
//             end

//             3'b100: begin               // B-type
//                 case (funct3)
//                     3'b000: alu_ctrl = 5'b01010; // BEQ
//                     3'b001: alu_ctrl = 5'b01011; // BNE
//                     3'b100: alu_ctrl = 5'b01000; // BLT
//                     3'b101: alu_ctrl = 5'b01100; // BGE
//                     3'b110: alu_ctrl = 5'b01001; // BLTU
//                     3'b111: alu_ctrl = 5'b01101; // BGEU
//                     default: alu_ctrl = 5'b00000;
//                 endcase
//             end
            
//             default: alu_ctrl = 5'b00000;
//         endcase
//     end
// endmodule


module ALUControl(
    input [2:0] funct3,
    input [6:0] funct7,
    input [2:0] alu_op,
    output reg [4:0] alu_ctrl
);
    reg [12:0] mixed_all;  // Sửa thành reg để dùng trong always block

    always @(*) begin
        mixed_all = {alu_op, funct3, funct7}; // Ghép tín hiệu alu_op, funct3, funct7
        case (mixed_all)
            13'b000_000_0000000: alu_ctrl = 5'b00000; // ADD
            13'b000_000_1000000: alu_ctrl = 5'b00001; // SUB
            13'b000_000_0000001: alu_ctrl = 5'b10000; // MUL
            13'b000_100_0000000: alu_ctrl = 5'b00010; // XOR
            13'b000_100_0000001: alu_ctrl = 5'b10100; // MUL XOR
            13'b000_110_0000000: alu_ctrl = 5'b00011; // OR
            13'b000_110_0000001: alu_ctrl = 5'b10110; // MUL OR
            13'b000_111_0000000: alu_ctrl = 5'b00100; // AND
            13'b000_111_0000001: alu_ctrl = 5'b10111; // MUL AND
            13'b000_001_0000000: alu_ctrl = 5'b00101; // SLL
            13'b000_001_0000001: alu_ctrl = 5'b10001; // MULH
            13'b000_101_0100000: alu_ctrl = 5'b00111; // SRA
            13'b000_101_0000000: alu_ctrl = 5'b00110; // SRL
            13'b000_101_0000001: alu_ctrl = 5'b10101; // DIVU
            13'b000_010_0000000: alu_ctrl = 5'b01000; // SLT
            13'b000_010_0000001: alu_ctrl = 5'b10010; // MULSH
            13'b000_011_0000000: alu_ctrl = 5'b01001; // SLTU
            13'b000_011_0000001: alu_ctrl = 5'b10011; // MULSLTU
            13'b001_000_0000000: alu_ctrl = 5'b00000; // ADDI
            13'b001_100_0000000: alu_ctrl = 5'b00010; // XORI
            13'b001_110_0000000: alu_ctrl = 5'b00011; // ORI
            13'b001_111_0000000: alu_ctrl = 5'b00100; // ANDI
            13'b001_001_0000000: alu_ctrl = 5'b00101; // SLLI
            13'b001_101_0100000: alu_ctrl = 5'b00111; // SRAI
            13'b001_101_0000000: alu_ctrl = 5'b00110; // SRLI
            13'b001_010_0000000: alu_ctrl = 5'b01000; // SLTI
            13'b001_011_0000000: alu_ctrl = 5'b01001; // SLTIU
            13'b010_000_0000000: alu_ctrl = 5'b00000; // LOAD/STORE ADD
            13'b100_000_0000000: alu_ctrl = 5'b01010; // BEQ
            13'b100_001_0000000: alu_ctrl = 5'b01011; // BNE
            13'b100_100_0000000: alu_ctrl = 5'b01000; // BLT
            13'b100_101_0000000: alu_ctrl = 5'b01100; // BGE
            13'b100_110_0000000: alu_ctrl = 5'b01001; // BLTU
            13'b100_111_0000000: alu_ctrl = 5'b01101; // BGEU
            default: alu_ctrl = 5'b00000; // Default
        endcase
    end
endmodule
