`timescale 1ns/1ps

module alu_tb;

    // inputs to ALU
    logic [31:0] A;
    logic [31:0] B;
    logic [3:0]  ALU_Sel;

    // outputs from ALU
    logic [31:0] ALU_Out;
    logic Zero;


    // instantiate ALU
    alu dut (

        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .ALU_Out(ALU_Out),
        .Zero(Zero)

    );


    // task for checking result
    task check_result(

        input [31:0] expected

    );

        begin

            #5;

            if(ALU_Out == expected)
                $display("PASS: ALU_Sel=%b A=%0d B=%0d Output=%0d",
                          ALU_Sel, A, B, ALU_Out);

            else
                $display("FAIL: ALU_Sel=%b A=%0d B=%0d Expected=%0d Got=%0d",
                          ALU_Sel, A, B, expected, ALU_Out);

        end

    endtask


    // stimulus
    initial
    begin

        $display("Starting ALU Test...");

        // ADD
        A = 10; B = 5; ALU_Sel = 4'b0000;
        check_result(15);

        // SUB
        A = 10; B = 5; ALU_Sel = 4'b0001;
        check_result(5);

        // AND
        A = 6; B = 3; ALU_Sel = 4'b0010;
        check_result(2);

        // OR
        A = 6; B = 3; ALU_Sel = 4'b0011;
        check_result(7);

        // XOR
        A = 6; B = 3; ALU_Sel = 4'b0100;
        check_result(5);

        // SLT true case
        A = 3; B = 5; ALU_Sel = 4'b0101;
        check_result(1);

        // SLT false case
        A = 10; B = 2; ALU_Sel = 4'b0101;
        check_result(0);

        // zero flag check
        A = 5; B = 5; ALU_Sel = 4'b0001; // 5-5
        #5;

        if(Zero)
            $display("PASS: Zero flag working");

        else
            $display("FAIL: Zero flag not working");


        $display("ALU testing completed");

        $finish;

    end

endmodule