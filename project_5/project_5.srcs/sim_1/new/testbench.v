module testbench;
    reg [7:0] multiplicand;   // 8-bit multiplicand
    reg [7:0] multiplier;     // 8-bit multiplier
    wire [15:0] product;      // 16-bit product

    // Instantiate the Booth multiplier
    booth_multiplier uut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

    initial begin
        // Test case 1: 13 x 7
        multiplicand = 8'd13;
        multiplier = 8'd7;
        #10;
        $display("Test 1: %d x %d = %d", multiplicand, multiplier, product);

        // Test case 2: 25 x 15
        multiplicand = 8'd25;
        multiplier = 8'd15;
        #10;
        $display("Test 2: %d x %d = %d", multiplicand, multiplier, product);

        // Test case 3: 50 x 3
        multiplicand = 8'd50;
        multiplier = 8'd3;
        #10;
        $display("Test 3: %d x %d = %d", multiplicand, multiplier, product);

        // Test case 4: 100 x 0
        multiplicand = 8'd100;
        multiplier = 8'd0;
        #10;
        $display("Test 4: %d x %d = %d", multiplicand, multiplier, product);

        // Test case 5: 0 x 255
        multiplicand = 8'd8;
        multiplier = 8'd2;
        #10;
        $display("Test 5: %d x %d = %d", multiplicand, multiplier, product);

        // End simulation
        $finish;
    end
endmodule
