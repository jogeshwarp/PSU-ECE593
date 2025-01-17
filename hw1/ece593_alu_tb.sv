module ece593_alu_tb;

    // Parameters
    parameter INPUT_DATABUS_WIDTH = 16;
    parameter RESULTBUS_WIDTH = 32;

    // Testbench signals
    logic [INPUT_DATABUS_WIDTH-1:0] A, B;
    logic clk, rst, start_op;
    logic [2:0] op_sel;
    logic [RESULTBUS_WIDTH-1:0] result;
    logic end_op;

    // DUT instantiation
    ece593_alu #(
        .INPUT_DATABUS_WIDTH(INPUT_DATABUS_WIDTH),
        .RESULTBUS_WIDTH(RESULTBUS_WIDTH)
    ) dut (
        .A(A), .B(B), .clk(clk), .rst(rst), .start_op(start_op),
        .op_sel(op_sel), .result(result), .end_op(end_op)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Testbench stimulus
    initial begin
        // Initialize signals
        rst = 1; start_op = 0; A = 16'h0100; B = 16'h0001; op_sel = 3'b000;
        #10 rst = 0;
        $display("A=%d, B=%d, No Operation Result=%d", A, B, result);

        // Test addition
        A = 16'h0010; B = 16'h0001; op_sel = 3'b001; start_op = 1;
        #10 start_op = 0; 
        $display("A=%d, B=%d, Addition Result=%d", A, B, result);

        // Test subtraction
        A = 16'h0100; B = 16'h0010; op_sel = 3'b010; start_op = 1;
        #10 start_op = 0; #20;
        $display("A=%d, B=%d, Subtraction Result=%d", A, B, result);

        // Test XOR
        A = 16'h0101; B = 16'h0011; op_sel = 3'b011; start_op = 1;
        #10 start_op = 0; #20;
        $display("A=%d, B=%d, XOR Result=%d", A, B, result);

        // Test multiplication (3 cycles delay)
        A = 16'h0001; B = 16'h0111; op_sel = 3'b100; start_op = 1;
        #10 start_op = 0; #30; // Wait for 3 cycles
        $display("A=%d, B=%d, Multiplication Result=%d", A, B, result);

        // Test AND
        A = 16'h0011; B = 16'h1010; op_sel = 3'b101; start_op = 1;
        #10 start_op = 0; #20;
        $display("A=%d, B=%d, AND Result=%d", A, B, result);

        // Test display operation
        op_sel = 3'b110; start_op = 1;
        #10 start_op = 0; #20;
        $display("Jogeshwar Reddy Pallapothula, ece593");

        // End simulation
        $finish;
    end
endmodule

