module tt_um_approximate_mac (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Input mapping:
    // ui_in[7:0] = signed operand a
    // uio_in[7:0] = signed operand b
    //
    // Mode/control mapping:
    // ui_in[0] is also part of operand a, so controls are
    // placed in the unused control interface below.
    //
    // uio_in is used entirely for operand b.
    // For this initial wrapper, fixed controls are used.

    wire signed [7:0] a;
    wire signed [7:0] b;
    wire signed [31:0] acc;

    assign a = ui_in;
    assign b = uio_in;

    configurable_mac mac_inst (
        .clk    (clk),
        .reset  (~rst_n),
        .enable (1'b1),
        .clear  (1'b0),
        .a      (a),
        .b      (b),
        .mode   (2'b00),
        .acc    (acc)
    );

    // Output the lower 8 bits of the accumulator.
    assign uo_out = acc[7:0];

    // No bidirectional output driving for this version.
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // ena is required by the TinyTapeout interface.
    wire _unused = &{ena, acc[31:8], 1'b0};

endmodule
