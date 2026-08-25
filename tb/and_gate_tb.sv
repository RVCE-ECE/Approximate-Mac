module and_gate_tb;

    logic a;
    logic b;
    logic y;

    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin

        a = 0;
        b = 0;
        #10;
        $display("A=%0d B=%0d Y=%0d", a, b, y);

        a = 0;
        b = 1;
        #10;
        $display("A=%0d B=%0d Y=%0d", a, b, y);

        a = 1;
        b = 0;
        #10;
        $display("A=%0d B=%0d Y=%0d", a, b, y);

        a = 1;
        b = 1;
        #10;
        $display("A=%0d B=%0d Y=%0d", a, b, y);

        $finish;

    end

endmodule
