`timescale 1ns / 1ps

// =================================================================
// 1. FETCH TO DECODE PIPELINE REGISTER (IF/ID)
// =================================================================
module if_id_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] if_pc,          // PC from Fetch stage
    input  logic [31:0] if_instruction, // Raw machine code from IMEM
    output logic [31:0] id_pc,          // Latched PC for Decode stage
    output logic [31:0] id_instruction  // Latched instruction for Decode stage
);

    always_ff @(posedge clk) begin
        if (reset) begin
            id_pc          <= 32'd0;
            id_instruction <= 32'd0; // Acts as a NOP (No Operation)
        end else begin
            id_pc          <= if_pc;
            id_instruction <= if_instruction;
        end
    end

endmodule


// =================================================================
// 2. DECODE TO EXECUTE PIPELINE REGISTER (ID/EX)
// =================================================================
module id_ex_reg (
    input  logic        clk,
    input  logic        reset,
    
    // Control Signals from ID stage
    input  logic        id_reg_write,
    input  logic        id_alu_src,
    input  logic [3:0]  id_alu_sel,
    
    // Datapath Values from ID stage
    input  logic [31:0] id_read_data1,
    input  logic [31:0] id_read_data2,
    input  logic [31:0] id_imm_ext,
    input  logic [4:0]  id_write_reg,   // rd field (instruction[11:7])
    
    // Outputs Latched for EX Stage
    output logic        ex_reg_write,
    output logic        ex_alu_src,
    output logic [3:0]  ex_alu_sel,
    output logic [31:0] ex_read_data1,
    output logic [31:0] ex_read_data2,
    output logic [31:0] ex_imm_ext,
    output logic [4:0]  ex_write_reg
);

    always_ff @(posedge clk) begin
        if (reset) begin
            ex_reg_write <= 1'b0;
            ex_alu_src   <= 1'b0;
            ex_alu_sel   <= 4'b0000;
            ex_read_data1<= 32'd0;
            ex_read_data2<= 32'd0;
            ex_imm_ext   <= 32'd0;
            ex_write_reg <= 5'd0;
        end else begin
            ex_reg_write <= id_reg_write;
            ex_alu_src   <= id_alu_src;
            ex_alu_sel   <= id_alu_sel;
            ex_read_data1<= id_read_data1;
            ex_read_data2<= id_read_data2;
            ex_imm_ext   <= id_imm_ext;
            ex_write_reg <= id_write_reg;
        end
    end

endmodule