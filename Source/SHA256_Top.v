`timescale 1ns / 1ps

// RISC-V SHA256 Co-processor Top-level module for FPGA implementation
// Optimized I/O interface to fit FPGA device constraints
module SHA256_Top (
    input clk,
    input reset,
    
    // Co-processor control interface
    input start_in,
    input [1:0] operation_mode,  // 00: SHA256, 01: SHA384, 10: SHA512, 11: reserved
    
    // Simplified data interface - RISC-V processor writes data sequentially
    input [31:0] data_in,        // 32-bit data input from RISC-V
    input [4:0] data_addr,       // Address for data (0-23: A-H + w0-w15)
    input data_valid,            // Data write enable
    
    // SHA256 result outputs (to RISC-V processor)
    output reg [31:0] data_out,  // 32-bit data output to RISC-V
    output reg result_valid,     // Result ready signal
    output reg busy,             // Co-processor busy signal
    
    // Debug output to prevent optimization
    output wire design_active
);

    // Internal registers for SHA256 inputs
    reg [31:0] hash_init [0:7];  // A_i through H_i
    reg [31:0] message_schedule [0:15];  // w0_sha256 through w15_sha256
    reg [255:0] sha256_result_reg;
    reg [4:0] output_counter;
    
    // Control signals
    reg start_sha256;
    reg [255:0] internal_result;
    wire internal_valid;
    
    // State machine for co-processor control
    reg [2:0] state;
    localparam IDLE = 3'b000;
    localparam LOADING = 3'b001;
    localparam COMPUTING = 3'b010;
    localparam OUTPUTTING = 3'b011;
    localparam DONE = 3'b100;
    
    // Data loading logic
    always @(posedge clk) begin
        if (~reset) begin
            state <= IDLE;
            start_sha256 <= 1'b0;
            result_valid <= 1'b0;
            busy <= 1'b0;
            output_counter <= 5'b0;
            data_out <= 32'h0;
            // Initialize hash values to SHA256 constants
            hash_init[0] <= 32'h6a09e667;
            hash_init[1] <= 32'hbb67ae85;
            hash_init[2] <= 32'h3c6ef372;
            hash_init[3] <= 32'ha54ff53a;
            hash_init[4] <= 32'h510e527f;
            hash_init[5] <= 32'h9b05688c;
            hash_init[6] <= 32'h1f83d9ab;
            hash_init[7] <= 32'h5be0cd19;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 1'b0;
                    result_valid <= 1'b0;
                    start_sha256 <= 1'b0;
                    if (start_in) begin
                        state <= LOADING;
                        busy <= 1'b1;
                    end
                end
                
                LOADING: begin
                    // Load data from RISC-V processor
                    if (data_valid) begin
                        if (data_addr < 5'd8) begin
                            // Loading hash initial values A-H
                            hash_init[data_addr] <= data_in;
                        end else if (data_addr < 5'd24) begin
                            // Loading message schedule w0-w15
                            message_schedule[data_addr - 5'd8] <= data_in;
                        end
                    end
                    
                    // Start computation when all data is loaded
                    if (data_addr == 5'd23 && data_valid) begin
                        state <= COMPUTING;
                        start_sha256 <= 1'b1;
                    end
                end
                
                COMPUTING: begin
                    start_sha256 <= 1'b0;
                    if (internal_valid) begin
                        sha256_result_reg <= internal_result;
                        state <= OUTPUTTING;
                        output_counter <= 5'b0;
                    end
                end
                
                OUTPUTTING: begin
                    // Output 32-bit chunks of 256-bit result
                    result_valid <= 1'b1;
                    case (output_counter)
                        5'd0: data_out <= sha256_result_reg[31:0];
                        5'd1: data_out <= sha256_result_reg[63:32];
                        5'd2: data_out <= sha256_result_reg[95:64];
                        5'd3: data_out <= sha256_result_reg[127:96];
                        5'd4: data_out <= sha256_result_reg[159:128];
                        5'd5: data_out <= sha256_result_reg[191:160];
                        5'd6: data_out <= sha256_result_reg[223:192];
                        5'd7: data_out <= sha256_result_reg[255:224];
                        default: data_out <= 32'h0;
                    endcase
                    
                    output_counter <= output_counter + 1;
                    if (output_counter >= 5'd7) begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    result_valid <= 1'b0;
                    busy <= 1'b0;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Instantiate the RISC-V SHA256 co-processor core
    RISC_SHA risc_sha_coprocessor (
        .clk(clk),
        .reset(reset),
        .start_in(start_sha256),
        .A_i(hash_init[0]),
        .B_i(hash_init[1]),
        .C_i(hash_init[2]),
        .D_i(hash_init[3]),
        .E_i(hash_init[4]),
        .F_i(hash_init[5]),
        .G_i(hash_init[6]),
        .H_i(hash_init[7]),
        .w0_sha256(message_schedule[0]),
        .w1_sha256(message_schedule[1]),
        .w2_sha256(message_schedule[2]),
        .w3_sha256(message_schedule[3]),
        .w4_sha256(message_schedule[4]),
        .w5_sha256(message_schedule[5]),
        .w6_sha256(message_schedule[6]),
        .w7_sha256(message_schedule[7]),
        .w8_sha256(message_schedule[8]),
        .w9_sha256(message_schedule[9]),
        .w10_sha256(message_schedule[10]),
        .w11_sha256(message_schedule[11]),
        .w12_sha256(message_schedule[12]),
        .w13_sha256(message_schedule[13]),
        .w14_sha256(message_schedule[14]),
        .w15_sha256(message_schedule[15]),
        .sha256_result(internal_result),
        .sha256_valid(internal_valid)
    );

    // Design activity indicator
    assign design_active = busy | result_valid;

endmodule