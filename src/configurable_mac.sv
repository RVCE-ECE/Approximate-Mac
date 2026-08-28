module configurable_mac (
    input  logic                clk,
    input  logic                reset,
    input  logic                enable,
    input  logic                clear,

    input  logic signed [7:0]   a,
    input  logic signed [7:0]   b,
    input  logic        [1:0]   mode,

    output logic signed [31:0]  acc
);

    logic signed [15:0] product;

    configurable_multiplier multiplier_inst (
        .a(a),
        .b(b),
        .mode(mode),
        .p(product)
    );

    always @(posedge clk) begin

        if (reset)
            acc <= 32'sd0;

        else if (clear)
            acc <= 32'sd0;

        else if (enable)
            acc <= acc + product;

    end

endmodule
