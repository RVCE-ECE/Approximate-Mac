module configurable_multiplier_tb;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic        [1:0]  mode;
    logic signed [15:0] p;

    configurable_multiplier dut (
        .a(a),
        .b(b),
        .mode(mode),
        .p(p)
    );

    initial begin

        a = 5;
        b = 3;

        mode = 2'b00;
        #10;
        $display("Mode=%b A=%0d B=%0d P=%0d", mode, a, b, p);

        mode = 2'b01;
        #10;
        $display("Mode=%b A=%0d B=%0d P=%0d", mode, a, b, p);

        mode = 2'b10;
        #10;
        $display("Mode=%b A=%0d B=%0d P=%0d", mode, a, b, p);

        a = -5;
        b = 3;

        mode = 2'b00;
        #10;
        $display("Mode=%b A=%0d B=%0d P=%0d", mode, a, b, p);

        mode = 2'b01;
        #10;
        $display("Mode=%b A=%0d B=%0d P=%0d", mode, a, b, p);

        mode = 2'b10;
        #10;
        $display("Mode=%b A=%0d B=%0d P=%0d", mode, a, b, p);

        $finish;

    end

endmodule
