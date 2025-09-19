echo "Đang biên dịch tất cả các file Verilog..."
iverilog -o RISC_Top_tb.vvp \
    Adder.v \
    ALU.v \
    ALUControl.v \
    ControlUnit.v \
    Imm_Gen.v \
    Mux_J1.v \
    Mux_J2.v \
    Mux_U2_type.v \
    Mux.v \
    Mux2to1_ALU.v \
    MUX2to1_PC.v \
    Mux2to1_WB.v \
    PC.v \
    Plus_4.v \
    Reg1.v \
    Reg2.v \
    Reg3.v \
    Reg4.v \
    Registers_file.v \
    blk_mem_gen_v8_4.v \
    ins_mem.v \
    data_mem.v \
    Counter_offset.v\
    Adder_C.v\
    Mux_Buffer.v\
    buffer.v\
    Buffer_temp.v\
    keyexpansion.v\
    wr_b2data.v\
    Mux_AES1.v\
    Mux_AES2.v\
    Controller.v\
    Mux_data.v\
    Mux_ins.v\
    Top.v \
    Top_tb.v 
    
   
echo "Đang chạy mô phỏng..."
vvp RISC_Top_tb.vvp

if [ -f "Riscv_pipeline.vcd" ]; then
    echo "Đang mở GTKWave để xem dạng sóng..."
    gtkwave Riscv_pipeline.vcd 
else
    echo "File VCD không tồn tại. Kiểm tra lại testbench để đảm bảo file VCD được tạo."
fi




