#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define MAX_LINES 1024  // Số dòng tối đa bạn dự phòng

// Hàm in mảng 32-bit (rcon, plaintext, key) với định dạng mong muốn
void print_array_uint32(FILE *file, uint32_t *array, int size, uint32_t *index) {
    for (int i = 0; i < size; i++) {
        fprintf(file, "%08x_", *index);  // In chỉ số với định dạng 8 ký tự hex
        fprintf(file, "%08x", array[i]);  // In giá trị phần tử trong mảng dưới dạng 8 ký tự hex
        fprintf(file, "\n");
        *index += 4;  // Tăng chỉ số 4 sau mỗi lần in
    }
}

int main() {
    FILE *fin = fopen("output_padding.txt", "r");
    FILE *file = fopen("Data_Mem.txt", "w");  // Mở file "output.txt" để ghi

    if (file == NULL) {
        printf("Không thể mở file để ghi!\n");
        return 1;  // Nếu không mở được file, dừng chương trình
    }

    if (!fin) {
        printf("Không thể mở file input.txt!\n");
        return 1;
    }

     uint32_t index = 0;  // Chỉ số bắt đầu từ 0 và sẽ tiếp tục tăng dần qua tất cả mảng

    // uint32_t arr[MAX_LINES];
    uint32_t arr[MAX_LINES] = {0};  // Khởi tạo tất cả phần tử về 0
    int count = 0;
    char line[64];

    // Đọc từng dòng và chuyển sang uint32_t
    while (fgets(line, sizeof(line), fin) && count < MAX_LINES) {
        // Loại bỏ ký tự xuống dòng (nếu có)
        char *newline = line;
        while (*newline) {
            if (*newline == '\n' || *newline == '\r') {
                *newline = 0;
                break;
            }
            newline++;
        }
        // Đọc giá trị hex
        if (sscanf(line, "%x", &arr[count]) == 1) {
            count++;
        }
    }
    fclose(fin);

    printf("\n");
    printf("Finish Wirte In Data_Mem.txt.");


    // Nếu cần dùng mảng arr[] sau đó, bạn đã có dữ liệu trong arr với count phần tử


//----------------------------------------------------------------------
    uint32_t plaintext[16] = {
    0x6bc1bee2, 0x2e409f96, 0xe93d7e11, 0x7393172a,
    0xae2d8a57, 0x1e03ac9c, 0x9eb76fac, 0x45af8e51,
    0x30c81c46, 0xa35ce411, 0xe5fbc119, 0x1a0a52ef,
    0xf69f2445, 0xdf4f9b17, 0xad2b417b, 0xe66c3710
};
//-----------------------------------------------------------------------
//----------------------------------------------------------------------
    uint32_t ABC_bacis_sha256[16] = {
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000
};
//-----------------------------------------------------------------------

    
    uint32_t zero_array[16] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000
};
    print_array_uint32(file, ABC_bacis_sha256, 16, &index);
    print_array_uint32(file, arr, 16, &index); 
    print_array_uint32(file, zero_array, 16, &index); 
    print_array_uint32(file, arr+16, 16, &index); 

    return 0;
}