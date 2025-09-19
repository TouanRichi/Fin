module Sigma1_64bit (
    input  wire [63:0] x,     // Input 64-bit word
    output wire [63:0] out // Output of σ₁
);

    // Compute σ₁ directly
    assign out = ((x >> 14) | (x << 50)) ^  // (x rightrotate 14)
                    ((x >> 18) | (x << 46)) ^  // (x rightrotate 18)
                    ((x >> 41) | (x << 23));   // (x rightrotate 41)                             
endmodule