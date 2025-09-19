
// module counter_offset (
//     input clk,                   // Tín hiệu xung nhịp đồng bộ
//     input plus_1,                // Tín hiệu đi�?u khiển tăng
//     input load_temp,             // Tín hiệu cho phép ghi giá trị vào temp_reg_internal
//     input [31:0] temp_reg,       // �?ầu vào thanh ghi tạm chứa giá trị so sánh
//     output reg [31:0] count      // �?ầu ra của bộ đếm
// );

//     // Biến tạm bên trong module, dùng để lưu giá trị từ temp_reg
//     reg [31:0] temp_reg_internal;

//     // Biến trạng thái để kiểm soát lần xuất giá trị `0` trước khi tăng
//     reg reset_state;

//     // Khởi tạo giá trị ban đầu
//     initial begin
//         count = 32'b0;
//         temp_reg_internal = 32'b0;
//         reset_state = 1'b0;
//     end

//     // Quá trình cập nhật temp_reg_internal khi load_temp được kích hoạt
//     always @(posedge clk) begin
//         if (load_temp) begin
//             // Ghi giá trị từ temp_reg vào biến tạm bên trong temp_reg_internal
//             temp_reg_internal <= temp_reg;
//         end else begin
//             temp_reg_internal <= temp_reg_internal;
//         end
//     end

//     // Quá trình đi�?u khiển bộ đếm
//     always @(posedge clk) begin
//         if (plus_1) begin
//             if (!reset_state) begin
//                 // Khi reset_state chưa được kích hoạt, xuất giá trị 0 và chuyển trạng thái
//                 count <= 32'b0;
//                 reset_state <= 1'b1;
//             end else if (count + 1 >= temp_reg_internal) begin
//                 // Reset count v�? 0 nếu đạt giá trị temp_reg_internal
//                 count <= 32'b0;
//             end else begin
//                 // Tăng giá trị count thêm 1
//                 count <= count + 1;
//             end
//         end else begin
//             // Giữ nguyên giá trị của count và reset trạng thái khi không có plus_1
//             count <= count;
//             reset_state <= 1'b0;
//         end
//     end

// endmodule


 module counter_offset (
     input clk,                   // Tín hiệu xung nhịp đồng bộ
     input reset,                // Tín hiệu reset
     input plus_1,               // Tín hiệu đi�?u khiển tăng
     input load_temp,            // Tín hiệu cho phép ghi giá trị vào temp_reg_internal
     input [31:0] temp_reg,      // �?ầu vào thanh ghi tạm chứa giá trị so sánh
     output reg [31:0] count     // �?ầu ra của bộ đếm
 );

     // Biến tạm bên trong module, dùng để lưu giá trị từ temp_reg
     reg [31:0] temp_reg_internal;

     // Khởi tạo giá trị ban đầu
     initial begin
         count = 32'b0;
         temp_reg_internal = 32'b0;
     end

     //Quá trình cập nhật temp_reg_in ternal khi load_temp được kích hoạt
     always @(posedge clk or negedge reset) begin
     if (!reset) begin
             temp_reg_internal <= 32'b0; // Reset giá trị biến tạm
         end else if (load_temp) begin
             temp_reg_internal <= temp_reg; // Ghi giá trị từ temp_reg vào biến tạm
         end else begin
             temp_reg_internal <= temp_reg_internal; // Giữ nguyên giá trị nếu không có sự kiện
         end
     end


     // Quá trình đi�?u khiển bộ đếm
     always @(posedge clk or negedge reset) begin
     if (!reset) begin
             count <= 32'b0; // Reset giá trị bộ đếm
         end else if (plus_1) begin
             if (count + 1 >= temp_reg_internal) begin
                 count <= 32'b0; // Reset count v�? 0 nếu đạt giá trị temp_reg_internal
             end else begin
                 count <= count + 1; // Tăng giá trị count thêm 1
             end
         end else begin
             count <= 0; // Giữ nguyên giá trị nếu không có sự kiện
         end
     end

 endmodule

//module counter_offset (
//    input clk,                   // Tín hiệu xung nhịp đồng bộ
//    input reset,                // Tín hiệu reset
//    input plus_1,               // Tín hiệu đi�?u khiển tăng
//    input load_temp,            // Tín hiệu cho phép ghi giá trị vào temp_reg_internal
//    input [31:0] temp_reg,      // �?ầu vào thanh ghi tạm chứa giá trị so sánh
//    output reg [31:0] count     // �?ầu ra của bộ đếm
//);


//    // các biến trung gian 
//    wire [31:0] temp_internal_w, count_w;
//    reg  [31:0] temp_internal_r;
    
//    assign temp_internal_w = temp_internal_r;
//    assign count_w = count;

//    always @(posedge clk or negedge reset) begin 
//        if(~reset) begin 
//            temp_internal_r <= 32'd0;
//            count           <= 32'd0;
//        end else begin 
//            if(plus_1)begin 
//                if (count_w + 32'd1 >= temp_internal_w) begin 
//                    count <= 32'd0;
//                end else begin 
//                    count <= count + 32'd1;
//                end 
//            end else begin 
//                temp_internal_r <= 32'd0;
//                count           <= 32'd0;
//            end 
//        end
//    end 

//    always @(load_temp) begin 
//        case(load_temp) 
//            1'b1: begin 
//               temp_internal_r = temp_reg; 
//            end 
//            default: begin 
//               temp_internal_r = temp_internal_w; 
//            end 
//        endcase
//    end
//    endmodule