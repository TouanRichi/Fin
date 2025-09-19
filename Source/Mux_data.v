module mux_data_mem (
    input [31:0] ins_addr_nap, ins_addr_risc, ins_data_nap, ins_data_risc,  // 0 và 1 là của nạp, 2 và 3 là của 
    input   we_cpu, we_risc,       // 4 tín hiệu 1 bit
    input               en_risc,
    input        sel,                             // Tín hiệu chọn
    output [31:0] addr_ins, data_ins,              // 2 đầu ra 32 bit
    output      we_ins,                  // 2 đầu ra 1 bit
    output           en_o_risc
);

    // Kết nối đầu ra với đầu vào dựa trên tín hiệu chọn sel
    assign addr_ins = sel ? ins_addr_risc : ins_addr_nap;       // Chọn giữa in0_32 và in2_32
    assign data_ins = sel ? ins_data_risc : ins_data_nap;       // Chọn giữa in1_32 và in3_32

    assign we_ins  = sel ? we_risc : we_cpu;         // Chọn giữa in0_1 và in2_1
    assign en_o_risc  = sel ? en_risc : 1'b1;         // Chọn giữa in1_1 và in3_1

endmodule
