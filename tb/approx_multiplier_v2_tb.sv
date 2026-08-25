module approx_multiplier_v2_tb;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic signed [15:0] exact_p;
    logic signed [15:0] approx_p;

    exact_multiplier dut_exact (
        .a(a),
        .b(b),
        .p(exact_p)
    );

    approx_multiplier_v2 dut_approx (
        .a(a),
        .b(b),
        .p(approx_p)
    );

    initial begin

        a = 5; b = 3;
        #10;
        $display("A=%0d B=%0d Exact=%0d Approx=%0d",
                 a, b, exact_p, approx_p);

        a = -5; b = 3;
        #10;
        $display("A=%0d B=%0d Exact=%0d Approx=%0d",
                 a, b, exact_p, approx_p);

        a = 4; b = 4;
        #10;
        $display("A=%0d B=%0d Exact=%0d Approx=%0d",
                 a, b, exact_p, approx_p);

        $finish;

    end

endmodule
