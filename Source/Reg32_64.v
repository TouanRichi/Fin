module register_64bit (
    input wire              CLK,    // Tín hiệu đồng hồ
    input wire              RST,    // Tín hiệu reset
    input wire              start,  // Tín hiệu start
    input wire        sel_A, // Dữ liệu đầu vào

    output reg        sel_A_o);

    always @(posedge CLK or posedge RST) begin
        if (~RST) begin
            // Reset thanh ghi về 0
            sel_A_o <= 1'b0;
            
        end else begin
            if (start) begin
                // Nếu tín hiệu start được bật, nạp dữ liệu vào thanh ghi
                sel_A_o <= sel_A;
               
            end else begin
            // Giữ nguyên giá trị hiện tại
            sel_A_o <= sel_A_o;
            
            end
        end
    end
    
endmodule