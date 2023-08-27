module Shift_Unit #(
    parameter A_WIDTH = 16,
    parameter B_WIDTH = 16
) (
    input clk,rst,
    input [A_WIDTH - 1 : 0] A,
    input [B_WIDTH - 1 : 0] B,
    input [1 : 0] Shift_ALU_FUNC,
    input Shift_Enable,
    output reg [A_WIDTH + B_WIDTH - 1 : 0] Shift_OUT,
    output reg Shift_Flag       
);

// Active Low Asynchronous Reset
always @(posedge clk or negedge rst) begin
  if(!rst) begin
    Shift_OUT  <= 16'b0;
    Shift_Flag <= 1'b0;
end
else begin
    // Control Shift_Flag
    Shift_Flag <= Shift_Enable;
    if(Shift_Enable) begin
        case (Shift_ALU_FUNC)
            // case 0 : Shift Right by 1
            2'b00: Shift_OUT <= A >> 1; 
            // case 1 : Shift Left by 1
            2'b01: Shift_OUT <= A << 1;
            // case 2 : Shift Right by 1
            2'b10: Shift_OUT <= B >> 1;
            // case 3 : Shift Left by 1
            2'b11: Shift_OUT <= B << 1;
            default: begin
                Shift_OUT <= 16'b0;
            end
        endcase
    end
  end
end
    
endmodule


