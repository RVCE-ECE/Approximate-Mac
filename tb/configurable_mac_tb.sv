module configurable_mac_tb;

    logic clk;
    logic reset;
    logic enable;
    logic clear;

    logic signed [7:0]  a;
    logic signed [7:0]  b;
    logic        [1:0]  mode;

    logic signed [31:0] acc;

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

    // Clock: 10 time units
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Initial values
        reset  = 1;
        enable = 0;
        clear  = 0;
        a      = 0;
        b      = 0;
        mode   = 2'b00;

        // Reset MAC
        #10;
        reset = 0;

        // Cycle 1: Exact mode
        // 5 × 3 = 15
        a = 5;
        b = 3;
        mode = 2'b00;
        enable = 1;
        #10;

        // Cycle 2: Exact mode
        // -2 × 4 = -8
        // ACC = 15 + (-8) = 7
        a = -2;
        b = 4;
        mode = 2'b00;
        #10;

        // Clear accumulator
        clear = 1;
        #10;
        clear = 0;

        // Cycle 3: Mild approximation
        // 5 × 3 = 15 → 14
        a = 5;
        b = 3;
        mode = 2'b01;
        enable = 1;
        #10;

        // Cycle 4: Stronger approximation
        // 5 × 3 = 15 → 12
        // ACC = 14 + 12 = 26
        a = 5;
        b = 3;
        mode = 2'b10;
        #10;

        // Disable accumulation
        enable = 0;
        a = 10;
        b = 10;
        #10;

        $display("Final ACC = %0d", acc);

        $finish;

    end

    // Display accumulator after every clock edge
    always @(posedge clk) begin
        #1;
        $display("Time=%0t Mode=%b A=%0d B=%0d Enable=%b Clear=%b ACC=%0d",
                 $time, mode, a, b, enable, clear, acc);
    end

endmodule
