module configurable_multiplier (
    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,
    input  logic        [1:0]  mode,
    output logic signed [15:0] p
);

    logic signed [15:0] exact_product;
    logic signed [7:0]  a_medium;
    logic signed [7:0]  b_medium;
    logic signed [15:0] medium_product;

    logic signed [5:0]  a_strong;
    logic signed [5:0]  b_strong;
    logic signed [11:0] strong_product;

    always_comb begin
        // Exact 8x8 multiplication
        exact_product = a * b;

        // Medium approximation:
        // Keep upper 7 bits and discard 1 LSB from each operand.
        a_medium = a >>> 1;
        b_medium = b >>> 1;
        medium_product = (a_medium * b_medium) <<< 2;

        // Strong approximation:
        // Keep upper 6 bits and discard 2 LSBs from each operand.
        a_strong = a >>> 2;
        b_strong = b >>> 2;
        strong_product = a_strong * b_strong;

        case (mode)
            2'b00: p = exact_product;
            2'b01: p = medium_product;
            2'b10: p = strong_product <<< 4;
            2'b11: p = exact_product;
            default: p = exact_product;
        endcase
    end

endmodule
