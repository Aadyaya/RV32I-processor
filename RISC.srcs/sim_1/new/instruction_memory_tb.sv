`timescale 1ns / 1ps

module instruction_mem_tb();

    logic [31:0] addr;
    logic [31:0] instruction;

    // Instantiate UUT
    instruction_memory uut (
        .addr(addr),
        .instruction(instruction)
    );

    initial begin
        $display("Testing Instruction Memory...");
        
        addr = 32'd0; #10;
        $display("Addr: %0d | Instruction: %h", addr, instruction);
        
        addr = 32'd4; #10;
        $display("Addr: %0d | Instruction: %h", addr, instruction);
        
        addr = 32'd8; #10;
        $display("Addr: %0d | Instruction: %h", addr, instruction);

        $finish;
    end
endmodule