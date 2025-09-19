module Sigma0_64bit (
    input  wire [63:0] x,     // Input 64-bit word
    output wire [63:0] out // Output of σ₀
);

    // Compute σ₀ directly
    

    assign out = ((x >> 28) | (x << 36)) ^  // (x rightrotate 28)
                    ((x >> 34) | (x << 30)) ^  // (x rightrotate 34)
                    ((x >> 39) | (x << 25));   // (x rightrotate 39)
endmodule