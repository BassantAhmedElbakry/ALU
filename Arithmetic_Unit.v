module Arithmetic_Unit #(
    parameter A_WIDTH = 16,
    parameter B_WIDTH = 16
) (
    input clk,rst,
    input [A_WIDTH - 1 : 0] A,
    input [B_WIDTH - 1 : 0] B,
    input [1 : 0] Arith_ALU_FUNC,
    input Arith_Enable,
    output reg [A_WIDTH + B_WIDTH - 1 : 0] Arith_OUT,
    output reg Carry_OUT, Arith_Flag       
);

// Internal Signals
reg [A_WIDTH + B_WIDTH - 1 : 0] ADD_Signal;

// Active Low Asynchronous Reset
always @(posedge clk or negedge rst) begin
    if(!rst) begin 
        Arith_OUT  <=  'b0;
        Carry_OUT  <= 1'b0; 
        Arith_Flag <= 1'b0; 
end
else begin
    // Control Arith_Flag
    Arith_Flag <= Arith_Enable;
    if(Arith_Enable) begin
        case (Arith_ALU_FUNC)
            // case 0 : Addition with carry
            2'b00: begin
                // Calculate Output with Carry
                if (A_WIDTH >= B_WIDTH) begin
                    Arith_OUT <= A + B;
                    {Carry_OUT,ADD_Signal[A_WIDTH - 1 : 0]} <= A + B;
                end
                else begin
                    Arith_OUT <= A + B;
                    {Carry_OUT,ADD_Signal[B_WIDTH - 1 : 0]} <= A + B;
                end
            end
            // case 1 : Subtractor  
            2'b01: Arith_OUT <= A - B;
            // case 2 : Multiplier  
            2'b10: Arith_OUT <= A * B;
            // case 3 : Division
            2'b11: Arith_OUT <= A / B;
            default: begin
                Arith_OUT <=  'b0;
                Carry_OUT <= 1'b0; 
            end
        endcase 
    end
  end
end
    
endmodule
