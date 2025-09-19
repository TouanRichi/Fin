#!/bin/bash

C_FILES=("Padding.c" "C1.c")
PY_FILES=("convert.py")

# Biên dịch và chạy các file C
for cfile in "${C_FILES[@]}"; do
    exe="${cfile%.c}_run"
    echo "Biên dịch $cfile -> $exe"
    gcc "$cfile" -o "$exe" || { echo "Lỗi biên dịch $cfile"; continue; }
    echo "Chạy $exe:"
    ./"$exe"
    echo "----------------------------"
done

# # Chạy các file Python
# for pyfile in "${PY_FILES[@]}"; do
#     echo "Chạy $pyfile:"
#     /c/Users/Acer/AppData/Local/Microsoft/WindowsApps/python3.11.exe "$pyfile"
#     echo "----------------------------"
# done

# Chạy các file Python
for pyfile in "${PY_FILES[@]}"; do
    echo "Chạy $pyfile:"
    python3 "$pyfile"
    echo "----------------------------"
done