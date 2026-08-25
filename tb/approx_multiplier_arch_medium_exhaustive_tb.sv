module approx_multiplier_arch_medium_exhaustive_tb;

    logic signed [7:0] a;
    logic signed [7:0] b;
    logic signed [15:0] product;

    logic signed [15:0] exact_product;
    integer error_count;
    integer total_tests;
    integer signed error_value;
    integer signed abs_error;
    integer signed max_error;
    longint signed sum_abs_error;
    longint signed sum_squared_error;

    real error_rate;
    real mae;
    real mse;

    approx_multiplier_arch_medium dut (
        .a(a),
        .b(b),
        .product(product)
    );

    initial begin
        error_count = 0;
        total_tests = 0;
        max_error = 0;
        sum_abs_error = 0;
        sum_squared_error = 0;

        for (integer ai = -128; ai <= 127; ai++) begin
            for (integer bi = -128; bi <= 127; bi++) begin

                a = ai;
                b = bi;

                #1;

                exact_product = a * b;
                error_value = product - exact_product;

                if (error_value < 0)
                    abs_error = -error_value;
                else
                    abs_error = error_value;

                if (error_value != 0)
                    error_count = error_count + 1;

                if (abs_error > max_error)
                    max_error = abs_error;

                sum_abs_error = sum_abs_error + abs_error;
                sum_squared_error = sum_squared_error +
                                    (error_value * error_value);

                total_tests = total_tests + 1;
            end
        end

        error_rate = (error_count * 100.0) / total_tests;
        mae = sum_abs_error * 1.0 / total_tests;
        mse = sum_squared_error * 1.0 / total_tests;

        $display("========================================");
        $display("MEDIUM ARCHITECTURAL APPROXIMATE MULTIPLIER RESULTS");
        $display("========================================");
        $display("Total tests       : %0d", total_tests);
        $display("Error count       : %0d", error_count);
        $display("Error rate        : %0f %%", error_rate);
        $display("MAE               : %0f", mae);
        $display("MSE               : %0f", mse);
        $display("Maximum error     : %0d", max_error);
        $display("========================================");

        $finish;
    end

endmodule
