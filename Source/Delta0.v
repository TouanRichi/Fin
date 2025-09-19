module delta0 (
    input  wire [31:0] w1,    // Input 32-bit word
    output wire [31:0] delta0 // Output of σ0
);

    // Compute σ0 directly
    assign delta0 = ((w1 >> 7) | (w1 << 25)) ^  // (w1 rightrotate 7)
                    ((w1 >> 18) | (w1 << 14)) ^ // (w1 rightrotate 18)
                    (w1 >> 3);                 // (w1 rightshift 3)

endmodule