module configurable_multiplier_exhaustive_tb;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic        [1:0]  mode;
    logic signed [15:0] p;
    logic signed [15:0] exact_p;

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

    configurable_multiplier dut (
        .a(a),
        .b(b),
        .mode(mode),
        .p(p)
    );

    exact_multiplier exact_dut (
        .a(a),
        .b(b),
        .p(exact_p)
    );

    task test_mode(input [1:0] test_mode);
        begin
            errors = 0;
            max_error = 0;
            sum_abs_error = 0;
            sum_squared_error = 0;

            mode = test_mode;

            for (i = -128; i <= 127; i = i + 1) begin
                for (j = -128; j <= 127; j = j + 1) begin

                    a = i;
                    b = j;
                    #1;

                    signed_error = p - exact_p;

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
            $display("===== MODE %b RESULTS =====", test_mode);
            $display("Error Count   = %0d", errors);
            $display("Error Rate    = %0f %%",
                     (errors * 100.0) / 65536.0);
            $display("MAE           = %0f", mae);
            $display("MSE           = %0f", mse);
            $display("Maximum Error = %0d", max_error);
            $display("==========================");
        end
    endtask

    initial begin

        test_mode(2'b00);
        test_mode(2'b01);
        test_mode(2'b10);
        test_mode(2'b11);

        $finish;

    end

endmodule
