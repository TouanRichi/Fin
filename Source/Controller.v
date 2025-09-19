module state_control(
        input clk,
        input rst,
        input start_in,
        input [31:0] done_flag,   // ứng với mã lệnh ecall = 00008067
        // input control_mux_bram, // use for bram ins and data
        output reg state_start,
        output reg state_done
    );

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            state_start <= 0;
            state_done <= 0;
        end else begin         
        if (start_in == 1'b1 && done_flag == 32'h0) begin
            state_start <= 1;
        // end else if (start_in == 1'b1 && done_flag == 32'h00000073)begin 
        end else if (done_flag == 32'h00000073)begin 
            state_done <=1;
            state_start <= 0;
        end else begin
            state_start <= state_start;
            state_done <=0;
        end
        end
    end

endmodule
