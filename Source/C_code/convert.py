def add_pc_address(input_file, output_file):
    count = 0

    with open(input_file, 'r') as f:
        lines = f.readlines()

    with open(output_file, 'w') as f:
        pc_address = 0
        for line in lines:
            line = line.strip()
            if line:
                count = count + 1 
                hex_value = line.strip()
                pc_hex = "{:016x}".format(pc_address)
                pc_address += 4
                output_line = f"{pc_hex}_{hex_value}\n"
                f.write(output_line)
input_file = 'Instructions.txt'
output_file = 'Inst_ROM.txt'
# common_file = '/home/ss13/riscv_crypto/RV32i/' \
#               'RV32i.srcs/sim_1/new/common.vh'
add_pc_address(input_file, output_file)
