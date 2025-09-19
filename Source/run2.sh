iverilog -o RISC_Sha_tb.vvp $(cat filelist.txt)

# Run the simulation
vvp RISC_Sha_tb.vvp 

# Open the VCD file in GTKWave
gtkwave RISC_Sha_tb.vcd