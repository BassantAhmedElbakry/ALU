module Decoder_Unit (
    input [1 : 0] DEC_ALU_FUNC,
    output reg DEC_Arith_Enable, DEC_Logic_Enable, DEC_CMP_Enable, DEC_Shift_Enable
);
    
always @(*) begin
    // Initial values
    DEC_Arith_Enable = 1'b0;
    DEC_Logic_Enable = 1'b0;
    DEC_CMP_Enable   = 1'b0;
    DEC_Shift_Enable = 1'b0;

    // We need only the 2 MSB bits of ALU_FUNC to determine which block we need to enable
    case (DEC_ALU_FUNC)

        // case 0: Arith Enable = 1 and others = 0
        2'b00: DEC_Arith_Enable = 1'b1;
        // case 1: Logic Enable = 1 and others = 0
        2'b01: DEC_Logic_Enable = 1'b1;
        // case 2: CMP Enable = 1 and others = 0
        2'b10: DEC_CMP_Enable   = 1'b1;
        // case 3: Shift Enable = 1 and others = 0
        2'b11: DEC_Shift_Enable = 1'b1;

        default: begin
            DEC_Arith_Enable = 1'b0;
            DEC_Logic_Enable = 1'b0;
            DEC_CMP_Enable   = 1'b0;
            DEC_Shift_Enable = 1'b0; 
    end
    endcase
end

endmodule
