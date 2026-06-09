`timescale 1ns / 1ps

module cpu_top (
    input logic clk,
    input logic reset
);

    // Internal Wires for Datapath Interconnection
    logic [31:0] pc;
    logic [31:0] instruction;
    
    // Control Unit Signals
    logic        reg_write;
    logic        alu_src;
    logic [3:0]  alu_sel;
    
    // Register File Signals
    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic [31:0] write_data; // Directly tied to ALU output for now
    
    // Immediate Generation (Sign Extension for I-type)
    logic [31:0] imm_ext;
    assign imm_ext = {{20{instruction[31]}}, instruction[31:20]};
    
    // ALU Signals
    logic [31:0] alu_operand_b;
    logic [31:0] alu_result;
    logic        zero;

    // -----------------------------------------------------------------
    // 1. INSTANTIATE: Program Counter Top Module
    // -----------------------------------------------------------------
    pc_top PC_MODULE (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // -----------------------------------------------------------------
    // 2. INSTANTIATE: Instruction Memory
    // -----------------------------------------------------------------
    instruction_memory IMEM_MODULE (
        .addr(pc),
        .instruction(instruction)
    );

    // -----------------------------------------------------------------
    // 3. INSTANTIATE: Control Unit
    // -----------------------------------------------------------------
    control_unit CU_MODULE (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_sel(alu_sel)
    );

    // -----------------------------------------------------------------
    // 4. INSTANTIATE: Register File
    // -----------------------------------------------------------------
    register_file REG_FILE_MODULE (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(instruction[19:15]),
        .read_reg2(instruction[24:20]),
        .write_reg(instruction[11:7]),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // MUX to select ALU Second Operand (Register vs Immediate)
    assign alu_operand_b = (alu_src) ? imm_ext : read_data2;

    // -----------------------------------------------------------------
    // 5. INSTANTIATE: ALU
    // -----------------------------------------------------------------
    alu ALU_MODULE (
        .A(read_data1),
        .B(alu_operand_b),
        .ALU_Sel(alu_sel),
        .ALU_Out(alu_result),
        .Zero(zero)
    );

    // Write back routing (Straight loop from ALU output back to RF input)
    assign write_data = alu_result;

endmodule