module control_unit (
    input  logic [6:0] opcode,    // instruction[6:0]
    input  logic [2:0] funct3,    // instruction[14:12]
    input  logic [6:0] funct7,    // instruction[31:25]
    output logic       reg_write, // Enable writing to Register File
    output logic       alu_src,   // 0: register, 1: immediate
    output logic [3:0] alu_sel    // Operation select for your ALU module
);

    always_comb begin
        // Default values to avoid latches
        reg_write = 1'b0;
        alu_src   = 1'b0;
        alu_sel   = 4'b0000;

        case (opcode)
            // R-type Instructions (ADD, SUB, AND, OR, XOR, SLT)
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0; // Use Read_Data2 from Register File
                
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000) 
                            alu_sel = 4'b0000; // ADD 
                        else 
                            alu_sel = 4'b0001; // SUB 
                    end
                    3'b111: alu_sel = 4'b0010; // AND 
                    3'b110: alu_sel = 4'b0011; // OR  
                    3'b100: alu_sel = 4'b0100; // XOR 
                    3'b010: alu_sel = 4'b0101; // SLT 
                    default: alu_sel = 4'b0000;
                endcase
            end

            // I-type Arithmetic (ADDI, ANDI, ORI, XORI)
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1; // Use immediate value instead of register 
                
                case (funct3)
                    3'b000:  alu_sel = 4'b0000; // ADDI
                    3'b111:  alu_sel = 4'b0010; // ANDI
                    3'b110:  alu_sel = 4'b0011; // ORI
                    3'b100:  alu_sel = 4'b0100; // XORI
                    3'b010:  alu_sel = 4'b0101; // SLTI
                    default: alu_sel = 4'b0000;
                endcase
            end

            default: begin
                reg_write = 1'b0;
                alu_src   = 1'b0;
                alu_sel   = 4'b0000;
            end
        endcase
    end

endmodule