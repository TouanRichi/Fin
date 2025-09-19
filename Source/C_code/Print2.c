#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main() {
    FILE *fin = fopen("input.txt", "r");        // File đầu vào chứa các số hex
    FILE *fout = fopen("Data_Mem.txt", "w");    // File đầu ra

    if (!fin || !fout) {
        printf("Không thể mở file đầu vào hoặc đầu ra!\n");
        if (fin) fclose(fin);
        if (fout) fclose(fout);
        return 1;
    }

    char line[64];
    uint32_t value;
    uint32_t index = 0;

    // Đọc từng dòng từ file input.txt
    while (fgets(line, sizeof(line), fin)) {
        // Chuyển chuỗi hex sang số uint32_t
        if (sscanf(line, "%x", &value) == 1) {
            fprintf(fout, "%08x_%08x\n", index, value);
            index += 4;
        }
    }

    fclose(fin);
    fclose(fout);

    printf("Đã ghi dữ liệu vào Data_Mem.txt\n");
    return 0;
}