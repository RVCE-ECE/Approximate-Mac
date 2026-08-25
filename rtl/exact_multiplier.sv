module exact_multiplier (
    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,
    output logic signed [15:0] p
);

    assign p = a * b;

endmodule
