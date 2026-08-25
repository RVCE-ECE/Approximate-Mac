module exact_multiplier_tb;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic signed [15:0] p;

    integer i;
    integer j;
    integer expected;
    integer errors;

    exact_multiplier dut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin

        errors = 0;

        for (i = -128; i <= 127; i = i + 1) begin

            for (j = -128; j <= 127; j = j + 1) begin

                a = i;
                b = j;

                #1;

                expected = i * j;

                if (p !== expected) begin
                    $display("ERROR: A=%0d B=%0d Expected=%0d Got=%0d",
                             i, j, expected, p);
                    errors = errors + 1;
                end

            end

        end

        if (errors == 0)
            $display("PASS: All 65536 INT8 combinations are correct.");
        else
            $display("FAIL: %0d errors found.", errors);

        $finish;

    end

endmodule
