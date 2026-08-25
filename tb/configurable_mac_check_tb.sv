logic clk;
logic reset;
logic enable;
logic clear;

logic signed [7:0] a;
logic signed [7:0] b;
logic [1:0] mode;

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
    clk = 0;
    forever #5 clk = ~clk;
end

function automatic signed [15:0] calc_product(
    input signed [7:0] x,
    input signed [7:0] y,
    input [1:0] m
);
    reg signed [15:0] temp;
    begin
        temp = x * y;

        case (m)
            2'b00: calc_product = temp;
            2'b01: calc_product = {temp[15:1], 1'b0};
            2'b10: calc_product = {temp[15:2], 2'b00};
            default: calc_product = temp;
        endcase
    end
endfunction

task automatic check_cycle;
    begin
        expected_product = calc_product(a, b, mode);

        @(negedge clk);

        if (reset)
            expected_acc = 0;
        else if (clear)
            expected_acc = 0;
        else if (enable)
            expected_acc = expected_acc + expected_product;

        @(posedge clk);
        #1;

        if (acc !== expected_acc) begin
            $display(
                "ERROR: Time=%0t Mode=%b A=%0d B=%0d Expected_ACC=%0d Got_ACC=%0d",
                $time, mode, a, b, expected_acc, acc
            );
            errors = errors + 1;
        end
        else begin
            $display(
                "PASS: Time=%0t Mode=%b A=%0d B=%0d ACC=%0d",
                $time, mode, a, b, acc
            );
        end
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

    check_cycle;

    @(negedge clk);
    reset = 0;

    a = 5;
    b = 3;
    mode = 2'b00;
    enable = 1;
    clear = 0;
    check_cycle;

    a = -5;
    b = 3;
    mode = 2'b00;
    check_cycle;

    a = 7;
    b = 5;
    mode = 2'b01;
    check_cycle;

    a = 7;
    b = 5;
    mode = 2'b10;
    check_cycle;

    clear = 1;
    enable = 1;
    check_cycle;

    @(negedge clk);
    clear = 0;

    a = 10;
    b = 10;
    mode = 2'b00;
    enable = 1;
    check_cycle;

    a = -2;
    b = 20;
    mode = 2'b01;
    check_cycle;

    a = 9;
    b = 9;
    mode = 2'b10;
    check_cycle;

    enable = 0;
    a = 100;
    b = 100;
    mode = 2'b00;
    check_cycle;

    $display("");

    if (errors == 0)
        $display("PASS: CONFIGURABLE MAC SELF-CHECK PASSED.");
    else
        $display("FAIL: %0d errors found.", errors);

    $finish;
end
