module approx_multiplier_v1_tb;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic signed [15:0] exact_p;
    logic signed [15:0] approx_p;

    exact_multiplier dut_exact (
        .a(a),
        .b(b),
        .p(exact_p)
    );

    approx_multiplier_v1 dut_approx (
        .a(a),
        .b(b),
        .p(approx_p)
    );

    initial begin

        a = 5;  b = 3;
        #10;
        $display("A=%0d B=%0d Exact=%0d Approx=%0d Error=%0d",
                 a, b, exact_p, approx_p,
                 (exact_p > approx_p) ? exact_p - approx_p : approx_p - exact_p);

        a = -5; b = 3;
        #10;
        $display("A=%0d B=%0d Exact=%0d Approx=%0d Error=%0d",
                 a, b, exact_p, approx_p,
                 (exact_p > approx_p) ? exact_p - approx_p : approx_p - exact_p);

        a = 4;  b = 4;
        #10;
        $display("A=%0d B=%0d Exact=%0d Approx=%0d Error=%0d",
                 a, b, exact_p, approx_p,
                 (exact_p > approx_p) ? exact_p - approx_p : approx_p - exact_p);

        a = -128; b = 127;
        #10;
        $display("A=%0d B=%0d Exact=%0d Approx=%0d Error=%0d",
                 a, b, exact_p, approx_p,
                 (exact_p > approx_p) ? exact_p - approx_p : approx_p - exact_p);

        $finish;

    end

endmodule
