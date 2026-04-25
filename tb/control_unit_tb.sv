`timescale 1ns / 1ps

module control_unit_tb();

    // Inputs
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // Outputs
    logic       reg_write;
    logic       alu_src;
    logic [3:0] alu_sel;

    // Instantiate the Unit Under Test (UUT)
    control_unit uut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_sel(alu_sel)
    );

    // Task to apply stimulus
    task check_instr(input [6:0] op, input [2:0] f3, input [6:0] f7, input string name);
        begin
            opcode = op;
            funct3 = f3;
            funct7 = f7;
            #10; // Wait for combinational logic to settle
            $display("Instr: %s | Op: %b | Sel: %b | RegW: %b | Src: %b", 
                      name, op, alu_sel, reg_write, alu_src);
        end
    endtask

    initial begin
        $display("Starting Control Unit Test...");
        $display("---------------------------------------");

        // Test R-type instructions (Opcode: 0110011, alu_src should be 0)
        check_instr(7'b0110011, 3'b000, 7'b0000000, "ADD");
        check_instr(7'b0110011, 3'b000, 7'b0100000, "SUB");
        check_instr(7'b0110011, 3'b111, 7'b0000000, "AND");
        check_instr(7'b0110011, 3'b110, 7'b0000000, "OR");

        // Test I-type instructions (Opcode: 0010011, alu_src should be 1)
        check_instr(7'b0010011, 3'b000, 7'bxxxxxxx, "ADDI");
        check_instr(7'b0010011, 3'b100, 7'bxxxxxxx, "XORI");
        check_instr(7'b0010011, 3'b010, 7'bxxxxxxx, "SLTI");

        // Test Default/Unknown
        check_instr(7'b1111111, 3'b000, 7'b0000000, "UNKNOWN");

        $display("---------------------------------------");
        $display("Test Complete.");
        $finish;
    end

endmodule