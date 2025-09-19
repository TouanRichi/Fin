
// #include "sha256.h"
// #include "sha256.c"

// #include <stdio.h>
// #include <string.h>
// #include <time.h>

// int main(void){
//     const char *text = "abc";
//     char hex[SHA256_HEX_SIZE];

//     struct timespec start, end;

//     // Lấy thời gian bắt đầu
//     clock_gettime(CLOCK_MONOTONIC, &start);

//     sha256_hex(text, strlen(text), hex);

//     // Lấy thời gian kết thúc
//     clock_gettime(CLOCK_MONOTONIC, &end);

//     // Tính thời gian thực thi (đơn vị: giây và nano giây)
//     double elapsed = (end.tv_sec - start.tv_sec) +
//                      (end.tv_nsec - start.tv_nsec) / 1e9;

//     // Nhập tần số CPU (Hz)
//     double freq;
//     printf("Nhập tần số CPU (Hz, ví dụ 2112000000 cho 2.11 GHz): ");
//     scanf("%lf", &freq);

//     // Tính số chu kỳ CPU
//     double cycles = elapsed * freq;

//     printf("The SHA-256 sum of \"%s\" is:\n\n", text);
//     printf("%s\n\n", hex);

//     printf("Thời gian thực thi: %.9f giây\n", elapsed);
//     printf("Số chu kỳ CPU ước tính: %.0f cycles\n", cycles);

//     return 0;
// }

#include "sha256.h"
#include "sha256.c"

#include <stdio.h>
#include <string.h>
#include <time.h>

#define CPU_FREQ 2112000000.0 // 2112 MHz
#define NUM_RUNS 10000

int main(void){
    const char *text = "abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu";
    char hex[SHA256_HEX_SIZE];

    struct timespec start, end;
    double total_elapsed = 0.0;

    // Chạy thử lần đầu để in kết quả
    clock_gettime(CLOCK_MONOTONIC, &start);
    sha256_hex(text, strlen(text), hex);
    clock_gettime(CLOCK_MONOTONIC, &end);

    double elapsed_first = (end.tv_sec - start.tv_sec) +
                          (end.tv_nsec - start.tv_nsec) / 1e9;

    printf("The SHA-256 sum of \"%s\" is:\n\n", text);
    printf("%s\n\n", hex);
    printf("Thời gian thực thi (lần 1): %.9f giây\n", elapsed_first);

    // Lặp lại tính thời gian NUM_RUNS lần (không in kết quả hash)
    for (int i = 0; i < NUM_RUNS; ++i) {
        clock_gettime(CLOCK_MONOTONIC, &start);
        sha256_hex(text, strlen(text), hex);
        clock_gettime(CLOCK_MONOTONIC, &end);

        double elapsed = (end.tv_sec - start.tv_sec) +
                         (end.tv_nsec - start.tv_nsec) / 1e9;
        total_elapsed += elapsed;
    }

    double avg_elapsed = total_elapsed / NUM_RUNS;
    double avg_cycles = avg_elapsed * CPU_FREQ;

    printf("Thời gian thực thi trung bình (trên %d lần): %.9f giây\n", NUM_RUNS, avg_elapsed);
    printf("Số chu kỳ CPU trung bình ước tính: %.0f cycles\n", avg_cycles);

    return 0;
}