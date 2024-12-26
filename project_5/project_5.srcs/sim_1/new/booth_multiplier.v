module booth_multiplier (
    input [7:0] multiplicand,  // 8-bit multiplicand
    input [7:0] multiplier,    // 8-bit multiplier
    output reg [15:0] product  // 16-bit product
);
    reg [15:0] partial_product[0:3]; // Array for partial products
    reg [15:0] stage_1_product;
    integer i;

    // Booth code generation (2-bit LSB + assumed 0 for first step)
    wire [2:0] booth_code;
    assign booth_code = {multiplier[1], multiplier[0], 1'b0};

    always @(*) begin
        // Stage 1: Calculate the first partial product
        case (booth_code)
            3'b001, 3'b010: stage_1_product = multiplicand;
            3'b011:         stage_1_product = multiplicand << 1; // 2 * multiplicand
            3'b100:         stage_1_product = -(multiplicand << 1); // -2 * multiplicand
            3'b101, 3'b110: stage_1_product = -multiplicand;
            default:        stage_1_product = 0;
        endcase

        // Assign Stage-1 LSBs to the product
        product[1:0] = stage_1_product[1:0];
    end

    always @(*) begin
        // Initialize product register and generate partial products
        product[15:2] = 0;

        for (i = 1; i < 4; i = i + 1) begin
            // Booth encoding for Stages 2, 3, and 4
            case ({multiplier[2*i+1], multiplier[2*i], multiplier[2*i-1]})
                3'b001, 3'b010: partial_product[i] = multiplicand << (2 * i);
                3'b011:         partial_product[i] = (multiplicand << (2 * i)) << 1; // 2 * multiplicand
                3'b100:         partial_product[i] = -(multiplicand << (2 * i)) << 1; // -2 * multiplicand
                3'b101, 3'b110: partial_product[i] = -(multiplicand << (2 * i));
                default:        partial_product[i] = 0;
            endcase

            // Assign the 2-bit LSBs of each partial product to the product register
            case (i)
                1: product[3:2] = partial_product[1][1:0];
                2: product[5:4] = partial_product[2][1:0];
                3: product[7:6] = partial_product[3][1:0];
            endcase
        end

        // Sum the higher bits of all stages into the remaining product bits
        product[15:2] = product[15:2] +
                        stage_1_product[15:2] +
                        partial_product[1][15:2] +
                        partial_product[2][15:2] +
                        partial_product[3][15:2];
    end
endmodule
