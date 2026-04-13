`timescale 1ns/1ps

module program_counter_tb;

    logic clk;
    logic reset;
    logic [31:0] next_pc;
    logic [31:0] pc;

    // DUT
    program_counter dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        next_pc = 0;

        // -------------------------
        // TEST 1: Reset behavior
        // -------------------------
        #10;
        reset = 0;
        $display("PC after reset = %0d (expected 0)", pc);

        // -------------------------
        // TEST 2: PC increments
        // -------------------------
        next_pc = 32'd4;
        #10;
        $display("PC = %0d (expected 4)", pc);

        next_pc = 32'd8;
        #10;
        $display("PC = %0d (expected 8)", pc);

        next_pc = 32'd12;
        #10;
        $display("PC = %0d (expected 12)", pc);

        // -------------------------
        // TEST 3: Jump case
        // -------------------------
        next_pc = 32'd100;
        #10;
        $display("PC = %0d (expected 100)", pc);

        // -------------------------
        // TEST 4: Reset again
        // -------------------------
        reset = 1;
        #10;
        $display("PC after reset = %0d (expected 0)", pc);

        #10;
        $finish;
    end

endmodule