module instruction_memory (
    input  logic [31:0] addr,          // Address from PC
    output logic [31:0] instruction    // 32-bit instruction output
);

    // Memory array: 64 entries of 32-bit width (adjust size as needed)
    logic [31:0] rom [0:63];

    // Load your machine code from a text file during simulation startup
    initial begin
        $readmemh("program.mem", rom);
    end

    // Instruction fetching logic
    // Note: Since PC increments by 4, we divide by 4 (shift right by 2) 
    // to get the word-aligned index for our array.
    assign instruction = rom[addr[31:2]];

endmodule