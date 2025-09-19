module delta1_64bit (
    input  wire [63:0] x,     // Input 64-bit word
    output wire [63:0] out // Output of Σ₁
);

    // Compute Σ₁ directly
    assign out = ((x >> 19) | (x << 45)) ^  // (x rightrotate 19)
                    ((x >> 61) | (x << 3))  ^  // (x rightrotate 61)
                    (x >> 6);                 // (x rightshift 6)   

endmodule