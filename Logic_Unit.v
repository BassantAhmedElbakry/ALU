module Logic_Unit #(
    parameter A_WIDTH = 16,
    parameter B_WIDTH = 16
) (
    input clk,rst,
    input [A_WIDTH - 1 : 0] A,
    input [B_WIDTH - 1 : 0] B,
    input [1 : 0] Logic_ALU_FUNC,
    input Logic_Enable,
    output reg [A_WIDTH + B_WIDTH - 1 : 0] Logic_OUT,
    output reg Logic_Flag       
);

// Active Low Asynchronous Reset
always @(posedge clk or negedge rst) begin
    if(!rst) begin
    Logic_OUT  <= 16'b0;
    Logic_Flag <= 1'b0;
end
else begin
    // Control Logic_Flag
    Logic_Flag <= Logic_Enable;
    if(Logic_Enable) begin
        case (Logic_ALU_FUNC)
            // case 0 : AND Operator
            2'b00: Logic_OUT <=   A & B; 
            // case 1 : OR Operator
            2'b01: Logic_OUT <=   A | B;
            // case 2 : NAND Operator
            2'b10: Logic_OUT <= ~(A & B);
            // case 3 : NOR Operator
            2'b11: Logic_OUT <= ~(A | B);
            default: begin
                Logic_OUT <= 16'b0;
            end
        endcase
    end
  end
end
    
endmodule

