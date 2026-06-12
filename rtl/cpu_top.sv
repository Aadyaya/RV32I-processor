`timescale 1ns / 1ps

module cpu_top (
    input logic clk,
    input logic reset
);

    // =================================================================
    // 1. STAGE FLOW WIRES
    // =================================================================
    
    // FETCH (IF) Stage Wires
    logic [31:0] if_pc;
    logic [31:0] if_instruction;
    
    // DECODE (ID) Stage Wires
    logic [31:0] id_pc;
    logic [31:0] id_instruction;
    logic        id_reg_write;
    logic        id_alu_src;
    logic [3:0]  id_alu_sel;
    logic [31:0] id_read_data1;
    logic [31:0] id_read_data2;
    logic [31:0] id_imm_ext;

    // EXECUTE / WRITE-BACK (EX/WB) Stage Wires
    logic        ex_reg_write;
    logic        ex_alu_src;
    logic [3:0]  ex_alu_sel;
    logic [31:0] ex_read_data1;
    logic [31:0] ex_read_data2;
    logic [31:0] ex_imm_ext;
    logic [4:0]  ex_write_reg;
    
    logic [31:0] ex_alu_operand_b;
    logic [31:0] ex_alu_result;
    logic        ex_zero;

    // =================================================================
    // 2. FETCH STAGE (IF)
    // =================================================================
    
    pc_top PC_MODULE (
        .clk(clk),
        .reset(reset),
        .pc(if_pc)
    );

    instruction_memory IMEM_MODULE (
        .addr(if_pc),
        .instruction(if_instruction)
    );

    // -----------------------------------------------------------------
    // PIPELINE REGISTER 1: Fetch to Decode Boundary (IF/ID)
    // -----------------------------------------------------------------
    if_id_reg IF_ID_REGISTER (
        .clk(clk),
        .reset(reset),
        .if_pc(if_pc),
        .if_instruction(if_instruction),
        .id_pc(id_pc),
        .id_instruction(id_instruction)
    );

    // =================================================================
    // 3. DECODE STAGE (ID)
    // =================================================================
    
    control_unit CU_MODULE (
        .opcode(id_instruction[6:0]),
        .funct3(id_instruction[14:12]),
        .funct7(id_instruction[31:25]),
        .reg_write(id_reg_write),
        .alu_src(id_alu_src),
        .alu_sel(id_alu_sel)
    );

    register_file REG_FILE_MODULE (
        .clk(clk),
        // CRITICAL PIPELINE PAIRING: 
        // We write back using control signals and destination addresses 
        // that have traveled completely down to the final EX/WB stage!
        .reg_write(ex_reg_write),
        .read_reg1(id_instruction[19:15]),
        .read_reg2(id_instruction[24:20]),
        .write_reg(ex_write_reg),
        .write_data(ex_alu_result), 
        
        .read_data1(id_read_data1),
        .read_data2(id_read_data2)
    );

    // Combinational Immediate Extraction inside ID stage
    assign id_imm_ext = {{20{id_instruction[31]}}, id_instruction[31:20]};

    // -----------------------------------------------------------------
    // PIPELINE REGISTER 2: Decode to Execute Boundary (ID/EX)
    // -----------------------------------------------------------------
    id_ex_reg ID_EX_REGISTER (
        .clk(clk),
        .reset(reset),
        
        .id_reg_write(id_reg_write),
        .id_alu_src(id_alu_src),
        .id_alu_sel(id_alu_sel),
        .id_read_data1(id_read_data1),
        .id_read_data2(id_read_data2),
        .id_imm_ext(id_imm_ext),
        .id_write_reg(id_instruction[11:7]), // Pass rd field ahead
        
        .ex_reg_write(ex_reg_write),
        .ex_alu_src(ex_alu_src),
        .ex_alu_sel(ex_alu_sel),
        .ex_read_data1(ex_read_data1),
        .ex_read_data2(ex_read_data2),
        .ex_imm_ext(ex_imm_ext),
        .ex_write_reg(ex_write_reg)
    );

    // =================================================================
    // 4. EXECUTE & WRITE-BACK STAGE (EX/WB)
    // =================================================================
    
    // MUX to select ALU Second Operand using EX stage register outputs
    assign ex_alu_operand_b = (ex_alu_src) ? ex_imm_ext : ex_read_data2;

    alu ALU_MODULE (
        .A(ex_read_data1),
        .B(ex_alu_operand_b),
        .ALU_Sel(ex_alu_sel),
        .ALU_Out(ex_alu_result),
        .Zero(ex_zero)
    );

endmodule