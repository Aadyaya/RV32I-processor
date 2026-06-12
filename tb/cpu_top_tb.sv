`timescale 1ns / 1ps

module cpu_tb();

    logic clk;
    logic reset;

    // Instantiate the 3-Stage Pipelined Top Module
    cpu_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock Generation (10ns period)
    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    initial begin
        $display("==========================================================================");
        $display("          RISC-V 3-STAGE PIPELINE CONCURRENCY MONITOR                     ");
        $display("==========================================================================");
        
        reset = 1'b1;
        #15; 
        reset = 1'b0; 
        
        // Detailed Pipeline Monitor Headers
        $display(" Time  |  IF_PC   | ID_Instr | EX_ALU_Sel | EX_ALU_Result | EX_RegWrite");
        $display("--------------------------------------------------------------------------");
        
        #120; // Run simulation long enough to clear the pipeline depth
        
        $display("--------------------------------------------------------------------------");
        $display("Simulation Complete.");
        $finish;
    end

    // Monitor pipeline stages concurrently at every clock edge
    always @(posedge clk) begin
        if (!reset) begin
            $strobe("%6t | %h | %h |    %b    |   %h   |      %b", 
                    $time, 
                    uut.if_pc,          // What is being fetched right now
                    uut.id_instruction, // What is being decoded right now
                    uut.ex_alu_sel,     // What operation the ALU is doing right now
                    uut.ex_alu_result,  // The active ALU output calculation
                    uut.ex_reg_write);  // Is a write-back happening this cycle?
        end
    end

endmodule