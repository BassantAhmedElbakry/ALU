// Scale my time to micro second 
`timescale 1us/1us

module alu_tb #(    
  parameter A_WIDTH_TB = 16,
  parameter B_WIDTH_TB = 16) ();

// Design TB signals
    reg CLK_tb,rst_tb;
    reg  [3 : 0] ALU_FUNC_tb;
    reg  [A_WIDTH_TB   - 1 : 0] A_tb;
    reg  [B_WIDTH_TB   - 1 : 0] B_tb;
    wire [A_WIDTH_TB + B_WIDTH_TB - 1 : 0] Arith_OUT_tb, Logic_OUT_tb, CMP_OUT_tb, Shift_OUT_tb;
    wire Carry_OUT_tb, Arith_Flag_tb, Logic_Flag_tb, CMP_Flag_tb, Shift_Flag_tb;

// Instantiate module
alu_top #(.A_WIDTH_TOP(A_WIDTH_TB), .B_WIDTH_TOP(B_WIDTH_TB))alu (
    .CLK(CLK_tb),
    .rst(rst_tb),
    .A(A_tb),
    .B(B_tb),
    .ALU_FUNC(ALU_FUNC_tb),
    .Arith_OUT(Arith_OUT_tb),
    .Logic_OUT(Logic_OUT_tb),
    .CMP_OUT(CMP_OUT_tb),
    .Shift_OUT(Shift_OUT_tb),
    .Carry_OUT(Carry_OUT_tb),
    .Arith_Flag(Arith_Flag_tb),
    .Logic_Flag(Logic_Flag_tb),
    .CMP_Flag(CMP_Flag_tb),
    .Shift_Flag(Shift_Flag_tb)
);

// Generate clock --> 100k Hz --> Tperiod = 10 micro seconds --> Duty cycle = 60%
always begin
    #4 CLK_tb = ~ CLK_tb; 
    #6 CLK_tb = ~ CLK_tb;
end

// flags variable of 4 bits to check all the flags  
wire [3 : 0] flags_tb;
assign flags_tb = {Arith_Flag_tb,Logic_Flag_tb,CMP_Flag_tb,Shift_Flag_tb};

// Initial Block
initial begin

    $dumpfile ("alu.vcd");
    $dumpvars;

    // Initial values
    A_tb = 16'b1111; // A = 15
    B_tb = 16'b101;  // B = 5
    ALU_FUNC_tb = 4'b0000;
    CLK_tb = 1'b0;
    rst_tb = 1'b1;

    // Reset
    rst_tb = 1'b0;
    #10
    rst_tb = 1'b1;

    // ************************************* TESTS ************************************* // 

    // TEST 1 --> test the addition operator and the Arith_flag is high and the other are low
    ALU_FUNC_tb = 4'b0000;
    // Arith_OUT = A + B = 20 = 10100 in Binary
    #10 if (Arith_OUT_tb == 'b10100 && Carry_OUT_tb == 1'b0 && flags_tb == 4'b1000) begin
      $display ("TEST 1  IS PASSED");
    end
    else begin
      $display ("TEST 1  IS FAILED");
    end

    // TEST 2 --> test the addition operator with carry
    ALU_FUNC_tb = 4'b0000;
    A_tb = 'hFFFF;
    B_tb = 'b01;
    // OUT = 0x10000 
    #10 if (Arith_OUT_tb == 'h10000 && Carry_OUT_tb == 1'b1 && flags_tb == 4'b1000) begin
      $display ("TEST 2  IS PASSED");
    end
    else begin
      $display ("TEST 2  IS FAILED");
    end

    // TEST 3 --> test the subtractor operator and the Arith_flag is high and the other are low
    ALU_FUNC_tb = 4'b0001;
    A_tb = 16'b1111;
    B_tb = 16'b101;
    // Arith_OUT = A - B = 10 = 1010 in Binary
    #10 if (Arith_OUT_tb == 16'b1010 && flags_tb == 4'b1000) begin
      $display ("TEST 3  IS PASSED");
    end
    else begin
      $display ("TEST 3  IS FAILED");
    end

    // TEST 4 --> test the subtractor operator 
    ALU_FUNC_tb = 4'b0001;
    // A = 5 & B = 6
    A_tb = 'b101;
    B_tb = 'b110;
    // Arith_OUT = A - B = -1 
    #10 if (Arith_OUT_tb == A_tb - B_tb && flags_tb == 4'b1000) begin
      $display ("TEST 4  IS PASSED");
    end
    else begin
      $display ("TEST 4  IS FAILED");
    end

    // TEST 5 --> test the multiplication operator and the Arith_flag is high and the other are low
    ALU_FUNC_tb = 4'b0010;
    // A = 15 & B = 5
    A_tb = 16'b1111;
    B_tb = 16'b101;
    // Arith_OUT = A * B = 75 = 1001011 in Binary
    #10 if (Arith_OUT_tb == 'b1001011 && flags_tb == 4'b1000) begin
      $display ("TEST 5  IS PASSED");
    end
    else begin
      $display ("TEST 5  IS FAILED");
    end

    // TEST 6 --> test the multiplication operator at A = 9_bits and B is 8_bits --> OUT = 9 + 8 = 17_bits  
    ALU_FUNC_tb = 4'b0010;
    // A = 319 & B = 243
    A_tb = 'b100111111;
    B_tb = 'hF3;
    // Arith_OUT = A * B = 77517 = 10010111011001101 in Binary 
    #10 if (Arith_OUT_tb == 'b10010111011001101 && flags_tb == 4'b1000) begin
      $display ("TEST 6  IS PASSED");
    end
    else begin
      $display ("TEST 6  IS FAILED");
    end    

    // TEST 7 --> test the division operator and the Arith_flag is high and the other are low  
    ALU_FUNC_tb = 4'b0011;
    // A = 15 and B = 5 --> OUT = 15 / 5 = 3
    A_tb = 'hF;
    B_tb = 'b0101;
    // Arith_OUT = A / B = 3 = 0011 in Binary 
    #10 if (Arith_OUT_tb == 'b0011 && flags_tb == 4'b1000) begin
      $display ("TEST 7  IS PASSED");
    end
    else begin
      $display ("TEST 7  IS FAILED");
    end 

    // TEST 8 --> test the division operator and the Arith_flag is high and the other are low  
    ALU_FUNC_tb = 4'b0011;
    // A = 5 and B = 15 --> OUT = 5 / 15 = 3
    A_tb = 'h5;
    B_tb = 'hF;
    // Arith_OUT = A / B = 0.333  
    #10 if (Arith_OUT_tb == 'b0 && flags_tb == 4'b1000) begin
      $display ("TEST 8  IS PASSED");
    end
    else begin
      $display ("TEST 8  IS FAILED");
    end

    // Test 9 --> test the rst signal
    rst_tb = 1'b0;
    ALU_FUNC_tb = 4'b0000;
    // A = 15 and B = 5 --> A + B = 20
    A_tb = 'hF;
    B_tb = 'b101;
    // Arith_OUT = 0 & Carry_OUT = 0 & Arith_Flag_tb = 0
    #10 if (Arith_OUT_tb == 'b0 && Carry_OUT_tb == 1'b0 && flags_tb == 4'b0000) begin
      $display ("TEST 9  IS PASSED");
    end
    else begin
      $display ("TEST 9  IS FAILED");
    end    

    // Test 10 --> test the logic AND operator and the Logic_flag is high and the other are low
    rst_tb = 1'b1;
    ALU_FUNC_tb = 4'b0100;
    // A = 15 and B = 5
    A_tb = 16'hF;
    B_tb = 16'b101; 
    // Logic_OUT = A & B = 0101
    #10 if (Logic_OUT_tb == 16'b0101 && flags_tb == 4'b0100) begin
      $display ("TEST 10 IS PASSED");
    end
    else begin
      $display ("TEST 10 IS FAILED");
    end

    // Test 11 --> test the logic OR operator and the Logic_flag is high and the other are low
    ALU_FUNC_tb = 4'b0101;
    // Logic_OUT = A | B = 1111
    #10 if (Logic_OUT_tb == 16'b1111 && flags_tb == 4'b0100) begin
      $display ("TEST 11 IS PASSED");
    end
    else begin
      $display ("TEST 11 IS FAILED");
    end 

    // Test 12 --> test the logic NAND operator and the Logic_flag is high and the other are low
    ALU_FUNC_tb = 4'b0110;
    // ALU_OUT = ~(A & B) = 1111111111111010
    #10 if (Logic_OUT_tb == ~(A_tb & B_tb) && flags_tb == 4'b0100) begin
      $display ("TEST 12 IS PASSED");
    end
    else begin
      $display ("TEST 12 IS FAILED");
    end 

    // Test 13 --> test the logic NOR operator and the Logic_flag is high and the other are low
    ALU_FUNC_tb = 4'b0111;
    // ALU_OUT = ~(A | B) = 1111111111110000
    #10 if (Logic_OUT_tb == ~(A_tb | B_tb) && flags_tb == 4'b0100) begin
      $display ("TEST 13 IS PASSED");
    end
    else begin
      $display ("TEST 13 IS FAILED");
    end   

    // TEST 14 --> test equal operator and the CMP_flag is high and the other are low
    ALU_FUNC_tb = 4'b1001;
    // A = 5 & B = 5 --> A equal B
    A_tb = 'b101;
    #10 if (CMP_OUT_tb == 'b1 && flags_tb == 4'b0010) begin
      $display ("TEST 14 IS PASSED");
    end
    else begin
      $display ("TEST 14 IS FAILED");
    end

    // TEST 15 --> test equal operator and the CMP_flag is high and the other are low
    ALU_FUNC_tb = 4'b1001;
    // A = 15 & B = 5 --> A doesn't equal B
    A_tb = 'hF;
    #10 if (CMP_OUT_tb == 'b0 && flags_tb == 4'b0010) begin
      $display ("TEST 15 IS PASSED");
    end
    else begin
      $display ("TEST 15 IS FAILED");
    end    

    // TEST 16 --> test greater than operator and the CMP_flag is high and the other are low
    ALU_FUNC_tb = 4'b1010;
    // A = 15 & B = 5 --> A greater than B
    A_tb = 'b1111;
    #10 if (CMP_OUT_tb == 'b10 && flags_tb == 4'b0010) begin
      $display ("TEST 16 IS PASSED");
    end
    else begin
      $display ("TEST 16 IS FAILED");
    end

    // TEST 17 --> test greater than operator and the CMP_flag is high and the other are low
    ALU_FUNC_tb = 4'b1010;
    // A = 15 & B = 31 --> A smaller than B
    B_tb = 'b11111;
    #10 if (CMP_OUT_tb == 16'b0 && flags_tb == 4'b0010) begin
      $display ("TEST 17 IS PASSED");
    end
    else begin
      $display ("TEST 17 IS FAILED");
    end  

    // TEST 18 --> test smaller than operator and the CMP_flag is high and the other are low
    ALU_FUNC_tb = 4'b1011;
    // A = 15 & B = 5 --> A greater than B
    A_tb = 'b1111;
    B_tb = 'b101;
    #10 if (CMP_OUT_tb == 'b0 && flags_tb == 4'b0010) begin
      $display ("TEST 18 IS PASSED");
    end
    else begin
      $display ("TEST 18 IS FAILED");
    end  

    // TEST 19 --> test smaller than operator and the CMP_flag is high and the other are low
    ALU_FUNC_tb = 4'b1011;
    // A = 15 & B = 31 --> A smaller than B
    A_tb = 'b1111;
    B_tb = 'b11111;
    #10 if (CMP_OUT_tb == 'b11 && flags_tb == 4'b0010) begin
      $display ("TEST 19 IS PASSED");
    end
    else begin
      $display ("TEST 19 IS FAILED");
    end  

    // TEST 20 --> test NOP (NO Operation)
    ALU_FUNC_tb = 4'b1000;
    #10 if (CMP_OUT_tb == 'b0 && flags_tb == 4'b0010) begin
      $display ("TEST 20 IS PASSED");
    end
    else begin
      $display ("TEST 20 IS FAILED");
    end  

    // TEST 21 --> test Shift Right operator and the Shift_flag is high and the other are low
    ALU_FUNC_tb = 4'b1100;
    // A = 1111 --> After shift right by 1 --> A = 0111
    #10 if (Shift_OUT_tb == 16'b0111 && flags_tb == 4'b0001) begin
      $display ("TEST 21 IS PASSED");
    end
    else begin
      $display ("TEST 21 IS FAILED");
    end  

    // TEST 22 --> test Shift Left operator and the Shift_flag is high and the other are low
    ALU_FUNC_tb = 4'b1101;
    // A = 1111 --> After shift left by 1 --> A = 11110
    #10 if (Shift_OUT_tb == 'b11110 && flags_tb == 4'b0001) begin
      $display ("TEST 22 IS PASSED");
    end
    else begin
      $display ("TEST 22 IS FAILED");
    end 

    // TEST 23 --> test Shift Right operator and the Shift_flag is high and the other are low
    ALU_FUNC_tb = 4'b1110;
    // B = 1111 --> After shift right by 1 --> B = 0111
    B_tb = 'b1111;
    #10 if (Shift_OUT_tb == 'b0111 && flags_tb == 4'b0001) begin
      $display ("TEST 23 IS PASSED");
    end
    else begin
      $display ("TEST 23 IS FAILED");
    end  

    // TEST 24 --> test Shift Left operator and the Shift_flag is high and the other are low
    ALU_FUNC_tb = 4'b1111;
    // B = 1111 --> After shift left by 1 --> B = 11110
    B_tb = 'b1111;
    #10 if (Shift_OUT_tb == 'b11110 && flags_tb == 4'b0001) begin
      $display ("TEST 24 IS PASSED");
    end
    else begin
      $display ("TEST 24 IS FAILED");
    end 

    $finish;
    
end

endmodule
