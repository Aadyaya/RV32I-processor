`timescale 1ns / 1ps

module cpu_tb();

    // Testbench Signals
    logic clk;
    logic reset;

    // Instantiate the Top Module Unit Under Test (UUT)
    cpu_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock Generation: 10ns period (100 MHz clock frequency)
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // Simulation Setup and Monitor Logic
    initial begin
        $display("==================================================");
        $display("   Starting RISC-V 3-Stage Core Baseline Test     ");
        $display("==================================================");
        
        // Assert reset to initialize the PC and clear pipeline states
        reset = 1'b1;
        #15; // Hold reset across one full clock edge
        reset = 1'b0; 
        
        // Monitor key CPU signals in the Tcl console at every rising edge
        $display("Time |     PC     | Instruction | ALU Sel | ALU Result | RegWrite");
        $display("------------------------------------------------------------");
        
        // Run simulation for a fixed window to observe instructions executing
        // Adjust the time based on how many instructions are in your program.mem
        #100;
        
        $display("------------------------------------------------------------");
        $display("Simulation Complete.");
        $finish;
    end

    // Probe internal signals using hierarchical paths for easier console tracking
    always @(posedge clk) begin
        if (!reset) begin
            // We use standard $strobe to display signals *after* all assignments settle on the clock edge
            $strobe("%4t |  %h  |  %h   |   %b  |  %h  |    %b", 
                    $time, 
                    uut.pc, 
                    uut.instruction, 
                    uut.alu_sel, 
                    uut.alu_result, 
                    uut.reg_write);
        end
    end

endmodule