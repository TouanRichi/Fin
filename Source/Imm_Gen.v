module ImmediateGenerator(
    input [31:0] inst_in,
    output reg [31:0] imm_out
);
    always @(*) begin
        case (inst_in[6:0])
            // I-type (e.g., ADDI, LW) - Immediate từ bit [31:20]
            7'b0010011, 7'b0000011: 
                imm_out = {{20{inst_in[31]}}, inst_in[31:20]};  // sign-extend 12 bit đến 32 bit
                
            // S-type (e.g., SW) - Immediate từ bit [31:25] và [11:7]
            7'b0100011: 
                imm_out = {{20{inst_in[31]}}, inst_in[31:25], inst_in[11:7]};
                
            // B-type (e.g., BEQ) - Immediate từ bit [31], [7], [30:25], [11:8]
            7'b1100011: 
                imm_out = {{19{inst_in[31]}}, inst_in[31], inst_in[7], inst_in[30:25], inst_in[11:8], 1'b0};

            // U-type (e.g., LUI, AUIPC) - Immediate từ bit [31:12], nối với 12 bit 
            7'b0110111, 7'b0010111: 
                imm_out = {inst_in[31:12], 12'b0};

            // J-type (e.g., JAL) - Immediate từ bit [31], [19:12], [20], [30:21], nối với 1 bit 0
            7'b1101111: 
                imm_out = {{11{inst_in[31]}}, inst_in[19:12], inst_in[20], inst_in[30:21], 1'b0};
            
            default: 
                imm_out = 32'b0;
        endcase
    end
endmodule
