module register_file (

    input  logic        clk,
    input  logic        reg_write,

    input  logic [4:0]  read_reg1,
    input  logic [4:0]  read_reg2,
    input  logic [4:0]  write_reg,

    input  logic [31:0] write_data,

    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    // 32 registers, each 32 bits
    logic [31:0] registers [31:0];

    // READ operation (combinational)
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

    // WRITE operation (sequential)
    always_ff @(posedge clk) begin
        
        if (reg_write && write_reg != 5'd0) 
            registers[write_reg] <= write_data;

    end

endmodule