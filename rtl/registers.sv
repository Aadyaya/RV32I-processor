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
initial begin
    for (int i = 0; i < 32; i = i + 1) begin
        registers[i] = 32'd0;
    end
end    // 32 registers, each 32 bits
    logic [31:0] registers [31:0];

    // READ operation (combinational)
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];

    // WRITE operation (sequential)
   // Change your Register File clock trigger from posedge to negedge:
always_ff @(negedge clk) begin
    if (reg_write && write_reg != 5'd0) begin
        registers[write_reg] <= write_data;
    end
end

endmodule