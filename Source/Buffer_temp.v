// module Buffer32 (
//     input wire clk,
//     input wire reset,
//     input wire [31:0] in_data,
//     output reg [31:0] out_data
// );

// always @(posedge clk or posedge reset) begin
//     if (reset) begin
//         out_data <= 32'b0; // Reset output to 0
//     end else begin
//         out_data <= in_data; // Pass input to output on clock edge
//     end
// end

// endmodule

module Buffer32 (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [31:0] in_data,
    output reg [31:0] out_data
);

// always @(posedge clk or negedge reset) begin
//     if (!reset) begin
//         out_data <= 32'b0; // Reset output to 0
//     end else if (start) begin
//         out_data <= in_data; // Pass input to output if start is 1
//     end else begin
//         out_data <= 32'b0; // Set output to 0 if start is 0
//     end
// end

always  @(posedge clk or negedge reset) begin
    if (~reset) begin 
        out_data <= 32'b0;
    end else begin
        if (start) begin
            out_data <= in_data;
        end else begin 
            out_data <= out_data;
        end 
    end 
end 
endmodule
