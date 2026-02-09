`timescale 1ns/1ps

module universal_tb;

    // Default Parameters (Override via command line if needed)
    parameter WIDTH = 8; 
    parameter TIMEOUT = 1000;

    // Inputs
    reg signed [WIDTH-1:0] a;
    reg signed [WIDTH-1:0] b;
    
    // Outputs
    wire signed [(2*WIDTH)-1:0] product;

    // --------------------------------------------------------
    // INSTANTIATION LOGIC
    // Use +define+MACRO when running simulation to select Arch
    // --------------------------------------------------------

    `ifdef TEST_BOOTH
        // Booth often uses 'm' and 'r' for Multiplicand/Multiplier
        booth_radix4 #(.WIDTH(WIDTH)) uut (
            .m(a), 
            .r(b), 
            .product(product)
        );
    `elsif TEST_WALLACE
        wallace_tree #(.WIDTH(WIDTH)) uut (
            .a(a), 
            .b(b), 
            .product(product)
        );
    `elsif TEST_DADDA
        dadda_tree #(.WIDTH(WIDTH)) uut (
            .a(a), 
            .b(b), 
            .product(product)
        );
    `else
        // Default to Ripple Carry if no flag is set
        ripple_carry_8bit uut (
            .a(a), 
            .b(b), 
            .product(product)
        );
    `endif

    // --------------------------------------------------------
    // VERIFICATION LOGIC
    // --------------------------------------------------------
    integer i;
    integer errors = 0;

    initial begin
        // Print which mode we are testing
        `ifdef TEST_BOOTH
            $display("========================================");
            $display("Testing BOOTH RADIX-4 (Width: %0d)", WIDTH);
        `elsif TEST_WALLACE
            $display("========================================");
            $display("Testing WALLACE TREE (Width: %0d)", WIDTH);
        `elsif TEST_DADDA
            $display("========================================");
            $display("Testing DADDA TREE (Width: %0d)", WIDTH);
        `else
            $display("========================================");
            $display("Testing RIPPLE CARRY (Width: %0d)", WIDTH);
        `endif
        $display("========================================");

        // Test Case 1: Zero check
        a = 0; b = 15; #10;
        check_result(a, b, product);

        // Test Case 2: Max Positive value check
        a = {1'b0, {(WIDTH-1){1'b1}}}; // Max positive in signed
        b = {1'b0, {(WIDTH-1){1'b1}}}; 
        #10;
        check_result(a, b, product);

        // Test Case 3: Negative numbers (Vital for Booth!)
        a = -5; b = 10; #10;
        check_result(a, b, product);

        // Test Case 4: Random Stimulus
        for (i = 0; i < 50; i = i + 1) begin
            a = $random; // Returns 32-bit signed random
            b = $random;
            #10;
            check_result(a, b, product);
        end

        if (errors == 0) begin
            $display("\n[PASS] All tests passed for %0d-bit architecture.", WIDTH);
        end else begin
            $display("\n[FAIL] %0d errors detected.", errors);
        end
            
        $finish;
    end

    // Task to compare hardware output vs expected mathematical result
    task check_result(input signed [WIDTH-1:0] val_a, input signed [WIDTH-1:0] val_b, input signed [(2*WIDTH)-1:0] actual);
        reg signed [(2*WIDTH)-1:0] expected;
        begin
            expected = val_a * val_b;
            if (actual !== expected) begin
                $display("ERROR: %0d * %0d = %0d (Expected %0d)", val_a, val_b, actual, expected);
                errors = errors + 1;
            end
        end
    endtask

endmodule