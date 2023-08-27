module CMP_Unit #(
    parameter A_WIDTH = 16,
    parameter B_WIDTH = 16
) (
    input clk,rst,
    input [A_WIDTH - 1 : 0] A,
    input [B_WIDTH - 1 : 0] B,    
    input [1 : 0] CMP_ALU_FUNC,
    input CMP_Enable,
    output reg [A_WIDTH + B_WIDTH - 1 : 0] CMP_OUT,
    output reg CMP_Flag       
);

// Active Low Asynchronous Reset
always @(posedge clk or negedge rst) begin
    if(!rst) begin
       CMP_OUT  <= 16'b0;
       CMP_Flag <= 1'b0;
    end
    else begin
    // Control CMP_Flag
    CMP_Flag <= CMP_Enable;    
    if(CMP_Enable) begin
        case (CMP_ALU_FUNC)
            // case 0 : NOP (No Operation)
            2'b00: CMP_OUT <= 16'b0; 
            // case 1 : Comparison --> Equal
            2'b01: begin
                if( A == B)
                CMP_OUT <= 16'b1;
                else
                CMP_OUT <= 16'b0;
            end
            // case 2 : Comparison --> Greater than
            2'b10:begin
                if( A > B)
                CMP_OUT <= 16'b10;
                else
                CMP_OUT <= 16'b0;
            end
            // case 3 : Comparison --> Smaller than
            2'b11:begin
                if( A < B)
                CMP_OUT <= 16'b11;
                else
                CMP_OUT <= 16'b0;
            end
            default: begin
                CMP_OUT <= 16'b0;
            end
        endcase
    end
  end
end
    
endmodule


