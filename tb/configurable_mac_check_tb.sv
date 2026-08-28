module configurable_mac_check_tb;

    logic clk;
    logic reset;
    logic enable;
    logic clear;

    logic signed [7:0] a;
    logic signed [7:0] b;
    logic        [1:0] mode;

    logic signed [31:0] acc;
    logic signed [31:0] expected_acc;
    logic signed [15:0] expected_product;

    integer errors;

    configurable_mac dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .clear(clear),
        .a(a),
        .b(b),
        .mode(mode),
        .acc(acc)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    function automatic signed [15:0] calc_product(
        input signed [7:0] x,
        input signed [7:0] y,
        input        [1:0] m
    );
        reg signed [7:0]  x_medium;
        reg signed [7:0]  y_medium;
        reg signed [6:0]  x_medium_7;
        reg signed [6:0]  y_medium_7;
        reg signed [13:0] medium_product;

        reg signed [5:0]  x_strong;
        reg signed [5:0]  y_strong;
        reg signed [11:0] strong_product;

        reg signed [15:0] exact_product;

        begin
            exact_product = x * y;

            x_medium = x >>> 1;
            y_medium = y >>> 1;
            x_medium_7 = x_medium[6:0];
            y_medium_7 = y_medium[6:0];
            medium_product = x_medium_7 * y_medium_7;

            x_strong = x >>> 2;
            y_strong = y >>> 2;
            strong_product = x_strong * y_strong;

            case (m)
                2'b00: calc_product = exact_product;
                2'b01: calc_product = medium_product <<< 2;
                2'b10: calc_product = strong_product <<< 4;
                default: calc_product = exact_product;
            endcase
        end
    endfunction

    task automatic apply_and_check(
    input signed [7:0] next_a,
    input signed [7:0] next_b,
    input        [1:0] next_mode,
    input              next_enable,
    input              next_clear
);
    begin
        // Apply inputs safely before the active clock edge
        @(negedge clk);

        a      = next_a;
        b      = next_b;
        mode   = next_mode;
        enable = next_enable;
        clear  = next_clear;

        // Calculate expected accumulator value
        if (reset)
            expected_acc = 32'sd0;
        else if (next_clear)
            expected_acc = 32'sd0;
        else if (next_enable)
            expected_acc = expected_acc +
                           calc_product(next_a, next_b, next_mode);

        // MAC updates on this rising edge
        @(posedge clk);
        #1;

        if (acc !== expected_acc) begin
            $display(
                "ERROR: Time=%0t Mode=%b A=%0d B=%0d Expected_ACC=%0d Got_ACC=%0d",
                $time, next_mode, next_a, next_b, expected_acc, acc
            );
            errors = errors + 1;
        end
        else begin
            $display(
                "PASS: Time=%0t Mode=%b A=%0d B=%0d ACC=%0d",
                $time, next_mode, next_a, next_b, acc
            );
        end

        // Prevent the same product from being accumulated again
        @(negedge clk);
        enable = 1'b0;
        clear  = 1'b0;
    end
endtask
    initial begin
        errors = 0;
        expected_acc = 0;

        reset  = 1;
        enable = 0;
        clear  = 0;
        a      = 0;
        b      = 0;
        mode   = 2'b00;

        // Reset cycle
        @(negedge clk);
        @(posedge clk);
        #1;

        if (acc !== 32'sd0) begin
            $display("ERROR: Reset failed. Got_ACC=%0d", acc);
            errors = errors + 1;
        end
        else begin
            $display("PASS: Reset ACC=0");
        end

        reset = 0;

        // Exact accumulation
        apply_and_check(8'sd5,   8'sd3,  2'b00, 1'b1, 1'b0);
        apply_and_check(-8'sd5,  8'sd3,  2'b00, 1'b1, 1'b0);

        // Medium approximation
        apply_and_check(8'sd7,   8'sd5,  2'b01, 1'b1, 1'b0);

        // Strong approximation
        apply_and_check(8'sd7,   8'sd5,  2'b10, 1'b1, 1'b0);

        // Clear
        apply_and_check(8'sd7,   8'sd5,  2'b10, 1'b1, 1'b1);

        // More accumulation
        apply_and_check(8'sd10,  8'sd10, 2'b00, 1'b1, 1'b0);
        apply_and_check(-8'sd2,  8'sd20, 2'b01, 1'b1, 1'b0);
        apply_and_check(8'sd9,   8'sd9,  2'b10, 1'b1, 1'b0);

        // Enable/hold
        apply_and_check(8'sd100, 8'sd100, 2'b00, 1'b0, 1'b0);

        $display("");

        if (errors == 0)
            $display("PASS: CONFIGURABLE MAC SELF-CHECK PASSED.");
        else
            $display("FAIL: %0d errors found.", errors);

        $finish;
    end

endmodule
