module delta1 (
    input  wire [31:0] w14,   // Input 32-bit word
    output wire [31:0] delta1 // Output of σ1
);

    // Compute σ1 directly
    assign delta1 = ((w14 >> 17) | (w14 << 15)) ^  // (w14 rightrotate 17)
                    ((w14 >> 19) | (w14 << 13)) ^ // (w14 rightrotate 19)
                    (w14 >> 10);                 // (w14 rightshift 10)

endmodule