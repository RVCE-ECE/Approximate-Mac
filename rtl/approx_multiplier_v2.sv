module approx_multiplier_v2 (
    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,
    output logic signed [15:0] p
);

    logic signed [15:0] exact_product;

    assign exact_product = a * b;

    assign p = {exact_product[15:2], 2'b00};

endmodule
