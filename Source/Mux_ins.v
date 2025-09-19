module mux_ins_rom (
    input [31:0] ins_addr_nap, ins_addr_risc, ins_data_nap, ins_data_risc,  // 0 và 1 là của nạp, 2 và 3 là của 
    input   we_cpu, we_risc,       // 4 tín hiệu 1 bit
    input               en_risc,
    input        sel,                             // Tín hiệu ch�?n
    output [31:0] addr_ins, data_ins,              // 2 đầu ra 32 bit
    output      we_ins,                  // 2 đầu ra 1 bit
    output           en_o_risc
);

    // Kết nối đầu ra với đầu vào dựa trên tín hiệu ch�?n sel
    assign addr_ins = sel ? ins_addr_risc : ins_addr_nap;       // Ch�?n giữa in0_32 và in2_32
    assign data_ins = sel ? ins_data_risc : ins_data_nap;       // Ch�?n giữa in1_32 và in3_32

    assign we_ins  = sel ? we_risc : we_cpu;         // Ch�?n giữa in0_1 và in2_1
    assign en_o_risc  =  1'b1;         // Ch�?n giữa in1_1 và in3_1

endmodule
