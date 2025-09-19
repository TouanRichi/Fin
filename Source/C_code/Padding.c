
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Hàm chuyển 1 byte thành chuỗi nhị phân
void byte_to_binary(uint8_t byte, char *binary) {
    for (int i = 7; i >= 0; i--) {
        binary[7 - i] = (byte & (1 << i)) ? '1' : '0';
    }
    binary[8] = '\0'; // Kết thúc chuỗi
}

// Hàm thực hiện padding như thuật toán SHA-256
uint8_t* sha256_pad(const uint8_t* input, size_t input_len, size_t *padded_len) {
    size_t bit_len = input_len * 8;
    size_t pad_len = input_len + 1; // Thêm 1 byte (0x80)
    
    // Đảm bảo rằng dữ liệu sau padding có kích thước chia hết cho 512 bit (64 byte)
    while ((pad_len % 64) != 56) {
        pad_len++;
    }

    // Tổng kích thước sau padding
    *padded_len = pad_len + 8; // Thêm 8 byte để lưu độ dài dữ liệu gốc

    // Tạo mảng dữ liệu sau padding
    uint8_t *padded = (uint8_t*)calloc(*padded_len, 1); // Khởi tạo tất cả là 0
    memcpy(padded, input, input_len);                  // Sao chép dữ liệu gốc
    padded[input_len] = 0x80;                          // Thêm bit 1 theo chuẩn SHA-256

    // Thêm độ dài dữ liệu gốc (big-endian) vào cuối
    for (int i = 0; i < 4; i++) {
        padded[*padded_len - 1 - i] = (bit_len >> (i * 8)) & 0xFF;
    }

    return padded;
}

int main() {
    const char *input_file = "input_padding.txt";
    const char *output_file_hex = "output_padding.txt";
    const char *output_file_bin = "output2.txt";

    // Đọc dữ liệu từ file input
    FILE *fin = fopen(input_file, "rb");
    if (!fin) {
        perror("Không thể mở file input");
        return 1;
    }

    fseek(fin, 0, SEEK_END);
    size_t file_size = ftell(fin);
    rewind(fin);

    uint8_t *data = (uint8_t*)malloc(file_size);
    fread(data, 1, file_size, fin);
    fclose(fin);

    // Thực hiện padding
    size_t padded_len;
    uint8_t *padded_data = sha256_pad(data, file_size, &padded_len);
    free(data);

    // Ghi dữ liệu ra file hex
    FILE *fout_hex = fopen(output_file_hex, "w");
    if (!fout_hex) {
        perror("Không thể mở file output (hex)");
        free(padded_data);
        return 1;
    }

    // Ghi dữ liệu hex đúng kích thước, không lặp
    for (size_t i = 0; i < padded_len; i++) {
        fprintf(fout_hex, "%02x", padded_data[i]); // Ghi byte dưới dạng hex
        if ((i + 1) % 4 == 0) fprintf(fout_hex, "\n"); // Xuống dòng sau mỗi 4 byte (32 bit)
    }
    fclose(fout_hex);

    // Ghi dữ liệu ra file nhị phân (bin dưới dạng bit)
    FILE *fout_bin = fopen(output_file_bin, "w");
    if (!fout_bin) {
        perror("Không thể mở file output (binary)");
        free(padded_data);
        return 1;
    }

    // char binary[9]; // Lưu chuỗi nhị phân của 1 byte
    // for (size_t i = 0; i < padded_len; i++) {
    //     byte_to_binary(padded_data[i], binary);
    //     fprintf(fout_bin, "%s", binary); // Ghi byte dưới dạng chuỗi nhị phân
    //     if ((i + 1) % 4 == 0) fprintf(fout_bin, "\n"); // Xuống dòng sau mỗi 4 byte (32 bit)
    // }
    fclose(fout_bin);

    free(padded_data);

    printf("Finish Padding. Result have saved in file '%s' and '%s'.\n", output_file_hex, output_file_bin);
    return 0;
}
