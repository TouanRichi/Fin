module wr_b2data(
    input clk,
    input reset,
    input wire [511:0] result_SHA_in,
    input wire enable_wb,
    output reg en_w_datamem,
    output reg [31:0] data_aes,
    output reg [31:0] addr_aes
);
reg done_flag;
reg [31:0] temp_data_out [0:15];
reg [31:0] addr_aes_temp;
integer i;
reg [1:0] state; 
reg [2:0] round;
localparam IDLE = 2'd0, N1 = 2'd1, DONE = 2'd2;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        data_aes <= 32'b0;
        addr_aes <= 32'b0;
        en_w_datamem <= 1'b0;
        state <= IDLE;
    end
    else if (enable_wb) begin
        case (state)
            IDLE: begin 
                for (i = 0; i<16; i = i +1) begin
                    temp_data_out[i] = result_SHA_in[511 - (i * 32) -: 32];
                end
                state <= N1;
                round <= 0;
            end  

            N1: begin
                if (round < 16) begin 
                    data_aes <= temp_data_out[round];
                    addr_aes <= 32'd0 + round*4;
                    en_w_datamem <= 1'b1;
                    round <= round + 1;
                end else begin 
                    state <= DONE;
                    en_w_datamem <= 1'b0;
                end 
                end

            DONE: begin
                done_flag <= 1;
                state <= IDLE;
            end 
            default: begin
                data_aes <= data_aes;
            addr_aes <= addr_aes;
            en_w_datamem <= en_w_datamem;
            state <= state;
            end

        endcase
    end else begin
        data_aes <= 0;
        addr_aes <= 0;
        en_w_datamem <= 0;
        state <= 0;
    end
end
endmodule