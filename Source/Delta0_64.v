module delta0_64bit (
    input  wire [63:0] x,    // Input 64-bit word
    output wire [63:0] out // Output of Σ₀
);

    // Compute Σ₀ directly
    

    assign out = ((x >> 1) | (x << 63)) ^  // (x rightrotate 1)
                    ((x >> 8) | (x << 56)) ^  // (x rightrotate 8)
                    (x >> 7);                 // (x rightshift 7)
endmodule