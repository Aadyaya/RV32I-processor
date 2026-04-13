module program_counter (

    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] next_pc,

    output logic [31:0] pc

);

    always_ff @(posedge clk or posedge reset) begin
        
        if (reset)
            pc <= 32'd0;        // reset PC to 0
        
        else
            pc <= next_pc;      // update to next address

    end

endmodule