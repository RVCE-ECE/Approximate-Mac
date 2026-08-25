module approx_multiplier_arch (
    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,
    output logic signed [15:0] product
);

    // Architectural approximation:
    // Reduce each operand by two LSBs before multiplication.
    // This creates an effective 6-bit x 6-bit multiplier.
    logic signed [5:0] a_reduced;
    logic signed [5:0] b_reduced;
    logic signed [11:0] reduced_product;

    always_comb begin
        a_reduced = a >>> 2;
        b_reduced = b >>> 2;

        reduced_product = a_reduced * b_reduced;

        // Restore the binary weight of the reduced operands.
        product = reduced_product <<< 4;
    end

endmodule
