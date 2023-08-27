module alu_top #(
    parameter A_WIDTH_TOP = 16,
    parameter B_WIDTH_TOP = 16
) (
    input   CLK,rst,
    input   [3 : 0] ALU_FUNC,
    input   [A_WIDTH_TOP - 1 : 0] A,
    input   [B_WIDTH_TOP - 1 : 0] B,
    output  [A_WIDTH_TOP + B_WIDTH_TOP - 1 : 0] Arith_OUT, Logic_OUT, CMP_OUT,Shift_OUT,
    output  Carry_OUT, Arith_Flag, Logic_Flag, CMP_Flag, Shift_Flag
);

// Internal Connections
wire Arith_EN, Logic_EN, CMP_EN, Shift_EN;

Decoder_Unit U0 (
    .DEC_ALU_FUNC(ALU_FUNC[3 : 2]),
    .DEC_Arith_Enable(Arith_EN),
    .DEC_Logic_Enable(Logic_EN),
    .DEC_CMP_Enable  (CMP_EN),
    .DEC_Shift_Enable(Shift_EN)
);
    
Arithmetic_Unit #(.A_WIDTH(A_WIDTH_TOP), .B_WIDTH(B_WIDTH_TOP)) U1 (
    .clk(CLK),
    .rst(rst),
    .A(A),
    .B(B),
    .Arith_ALU_FUNC(ALU_FUNC[1 : 0]),
    .Arith_Enable(Arith_EN),
    .Arith_OUT(Arith_OUT),
    .Carry_OUT(Carry_OUT),
    .Arith_Flag(Arith_Flag)
);

Logic_Unit #(.A_WIDTH(A_WIDTH_TOP), .B_WIDTH(B_WIDTH_TOP)) U2 (
    .clk(CLK),
    .rst(rst),
    .A(A),
    .B(B),
    .Logic_ALU_FUNC(ALU_FUNC[1 : 0]),
    .Logic_Enable(Logic_EN),
    .Logic_OUT(Logic_OUT),
    .Logic_Flag(Logic_Flag)
);

CMP_Unit #(.A_WIDTH(A_WIDTH_TOP), .B_WIDTH(B_WIDTH_TOP)) U3 (
    .clk(CLK),
    .rst(rst),
    .A(A),
    .B(B),
    .CMP_ALU_FUNC(ALU_FUNC[1 : 0]),
    .CMP_Enable(CMP_EN),
    .CMP_OUT(CMP_OUT),
    .CMP_Flag(CMP_Flag)
);

Shift_Unit #(.A_WIDTH(A_WIDTH_TOP), .B_WIDTH(B_WIDTH_TOP)) U4 (
    .clk(CLK),
    .rst(rst),
    .A(A),
    .B(B),
    .Shift_ALU_FUNC(ALU_FUNC[1 : 0]),
    .Shift_Enable(Shift_EN),
    .Shift_OUT(Shift_OUT),
    .Shift_Flag(Shift_Flag)
);

endmodule
