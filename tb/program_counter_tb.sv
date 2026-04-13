`timescale 1ns/1ps

module pc_top_tb;

    logic clk;
    logic reset;
    logic [31:0] pc;

    pc_top dut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        #10;
        reset = 0;

        #50; // observe multiple increments

        $finish;
    end

    initial begin
        $monitor("Time=%0t | PC=%0d", $time, pc);
    end

endmodule