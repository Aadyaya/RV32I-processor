`timescale 1ns/1ps

module register_file_tb;

    logic clk;
    logic reg_write;

    logic [4:0] read_reg1;
    logic [4:0] read_reg2;
    logic [4:0] write_reg;

    logic [31:0] write_data;

    logic [31:0] read_data1;
    logic [31:0] read_data2;


    // instantiate DUT
    register_file dut (
        .clk(clk),
        .reg_write(reg_write),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    // clock generation (10ns period)
    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reg_write = 0;

        // -------------------------
        // TEST 1: write to x1
        // -------------------------
        #10;
        write_reg  = 5'd1;
        write_data = 32'd25;
        reg_write  = 1;

        #10;
        reg_write = 0;


        // read x1
        read_reg1 = 5'd1;

        #10;
        $display("x1 = %0d (expected 25)", read_data1);


        // -------------------------
        // TEST 2: write to x2
        // -------------------------
        #10;
        write_reg  = 5'd2;
        write_data = 32'd40;
        reg_write  = 1;

        #10;
        reg_write = 0;


        // read x1 and x2 together
        read_reg1 = 5'd1;
        read_reg2 = 5'd2;

        #10;
        $display("x1 = %0d (expected 25)", read_data1);
        $display("x2 = %0d (expected 40)", read_data2);


        // -------------------------
        // TEST 3: try writing x0
        // -------------------------
        #10;
        write_reg  = 5'd0;
        write_data = 32'd999;
        reg_write  = 1;

        #10;
        reg_write = 0;

        read_reg1 = 5'd0;

        #10;
        $display("x0 = %0d (expected 0)", read_data1);


        // -------------------------
        // TEST 4: overwrite x1
        // -------------------------
        #10;
        write_reg  = 5'd1;
        write_data = 32'd100;
        reg_write  = 1;

        #10;
        reg_write = 0;

        read_reg1 = 5'd1;

        #10;
        $display("x1 = %0d (expected 100)", read_data1);


        #20;
        $finish;

    end

endmodule