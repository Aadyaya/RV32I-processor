module pc_top (
    input  logic clk,
    input  logic reset,
    output logic [31:0] pc
);

    logic [31:0] next_pc;

    // instantiate PC
    program_counter pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // next PC logic (PC + 4)
    assign next_pc = pc + 32'd4;

endmodule