module approx_multiplier_arch_exhaustive_tb;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic signed [15:0] product;

    integer a_i;
    integer b_i;

    integer total_tests;
    integer error_count;

    integer signed exact_product;
    integer signed approx_product;
    integer signed error_value;

    longint signed abs_error;
    longint signed sum_abs_error;
    longint signed sum_squared_error;
    longint signed max_error;

    approx_multiplier_arch dut (
        .a(a),
        .b(b),
        .product(product)
    );

    initial begin
        total_tests = 0;
        error_count = 0;
        sum_abs_error = 0;
        sum_squared_error = 0;
        max_error = 0;

        for (a_i = -128; a_i <= 127; a_i = a_i + 1) begin
            for (b_i = -128; b_i <= 127; b_i = b_i + 1) begin

                a = a_i;
                b = b_i;

                #1;

                exact_product = a_i * b_i;
                approx_product = $signed(product);

                error_value = approx_product - exact_product;

                if (error_value < 0)
                    abs_error = -error_value;
                else
                    abs_error = error_value;

                total_tests = total_tests + 1;
                sum_abs_error = sum_abs_error + abs_error;
                sum_squared_error = sum_squared_error + (abs_error * abs_error);

                if (abs_error > max_error)
                    max_error = abs_error;

                if (error_value != 0)
                    error_count = error_count + 1;

            end
        end

        $display("============================================");
        $display("ARCHITECTURAL APPROXIMATE MULTIPLIER RESULTS");
        $display("============================================");
        $display("Total tests       : %0d", total_tests);
        $display("Error count       : %0d", error_count);
        $display("Error rate        : %f %%", (100.0 * error_count) / total_tests);
        $display("MAE               : %f", (1.0 * sum_abs_error) / total_tests);
        $display("MSE               : %f", (1.0 * sum_squared_error) / total_tests);
        $display("Maximum error     : %0d", max_error);
        $display("============================================");

        $finish;
    end

endmodule
