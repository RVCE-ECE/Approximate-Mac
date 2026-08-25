module approx_multiplier_arch_medium (
    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,
    output logic signed [15:0] product
);

    // Medium architectural approximation:
    // Remove only one LSB from each operand.
    // This creates an effective 7-bit x 7-bit multiplier.
    logic signed [6:0] a_reduced;
    logic signed [6:0] b_reduced;
    logic signed [13:0] reduced_product;

    always_comb begin
        a_reduced = a >>> 1;
        b_reduced = b >>> 1;

        reduced_product = a_reduced * b_reduced;

        // Restore the binary weight lost from both operands.
        product = reduced_product <<< 2;
    end

endmodule
