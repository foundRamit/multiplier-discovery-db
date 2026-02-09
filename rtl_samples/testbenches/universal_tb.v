`timescale 1ns/1ps

module universal_tb;

    // Parameters - Change these to match the MULT_ID you are testing
    parameter WIDTH = 8; 
    parameter TIMEOUT = 1000;

    // Inputs
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    
    // Outputs
    wire [(2*WIDTH)-1:0] product;

    // Instantiate the Unit Under Test (UUT)
    // Note: Ensure your multiplier module names match or use a generic wrapper
    ripple_carry_8bit uut (
        .a(a),
        .b(b),
        .product(product)
    );

    integer i;
    integer errors = 0;

    initial begin
        $display("Starting Verification for %0d-bit Multiplier...", WIDTH);
        
        // Test Case 1: Zero check
        a = 0; b = 10; #10;
        check_result(a, b, product);

        // Test Case 2: Max value check
        a = {WIDTH{1'b1}}; b = {WIDTH{1'b1}}; #10;
        check_result(a, b, product);

        // Test Case 3: Random Stimulus
        for (i = 0; i < 50; i = i + 1) begin
            a = $urandom_range(0, (1 << WIDTH) - 1);
            b = $urandom_range(0, (1 << WIDTH) - 1);
            #10;
            check_result(a, b, product);
        end

        if (errors == 0)
            $display("SUCCESS: All tests passed!");
        else
            $display("FAILURE: %0d errors detected.", errors);
            
        $finish;
    end

    // Task to compare hardware output vs expected mathematical result
    task check_result(input [WIDTH-1:0] val_a, input [WIDTH-1:0] val_b, input [(2*WIDTH)-1:0] actual);
        reg [(2*WIDTH)-1:0] expected;
        begin
            expected = val_a * val_b;
            if (actual !== expected) begin
                $display("ERROR: %0d * %0d = %0d (Expected %0d)", val_a, val_b, actual, expected);
                errors = errors + 1;
            end
        end
    endtask

endmodule