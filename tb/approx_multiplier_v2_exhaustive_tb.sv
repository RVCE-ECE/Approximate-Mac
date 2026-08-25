module approx_multiplier_v2_exhaustive_tb;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic signed [15:0] exact_p;
    logic signed [15:0] approx_p;

    integer i;
    integer j;
    integer errors;
    integer max_error;
    integer signed_error;
    integer abs_error;
    real sum_abs_error;
    real sum_squared_error;
    real mae;
    real mse;

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

        errors = 0;
        max_error = 0;
        sum_abs_error = 0;
        sum_squared_error = 0;

        for (i = -128; i <= 127; i = i + 1) begin
            for (j = -128; j <= 127; j = j + 1) begin

                a = i;
                b = j;
                #1;

                signed_error = approx_p - exact_p;

                if (signed_error < 0)
                    abs_error = -signed_error;
                else
                    abs_error = signed_error;

                if (abs_error != 0)
                    errors = errors + 1;

                if (abs_error > max_error)
                    max_error = abs_error;

                sum_abs_error = sum_abs_error + abs_error;
                sum_squared_error =
                    sum_squared_error + (abs_error * abs_error);

            end
        end

        mae = sum_abs_error / 65536.0;
        mse = sum_squared_error / 65536.0;

        $display("");
        $display("===== APPROX MULTIPLIER V2 RESULTS =====");
        $display("Total Tests   = 65536");
        $display("Error Count   = %0d", errors);
        $display("Error Rate    = %0f %%", (errors * 100.0) / 65536.0);
        $display("MAE           = %0f", mae);
        $display("MSE           = %0f", mse);
        $display("Maximum Error = %0d", max_error);
        $display("========================================");

        $finish;

    end

endmodule
