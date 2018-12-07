`include "opcodes.vh"

module Control ( 
    Op_i, RegDst_o, ALUOp_o, ALUSrc_o, RegWrite_o
);

input   [6:0]   Op_i;
output          RegDst_o;
output  [1:0]   ALUOp_o;
output          ALUSrc_o;
output          RegWrite_o;

reg             RegDst_o, ALUSrc_o, RegWrite_o;
reg     [1:0]   ALUOp_o;

always @( Op_i ) begin
    case( Op_i )
        `Opcode_R_type:
        begin
            RegDst_o   = 1'b0;
            ALUOp_o    = `ALUOp_R_type;
            ALUSrc_o   = 1'b0;
            RegWrite_o = 1'b1;
        end

        `Opcode_I_type:
        begin
            RegDst_o   = 1'b0;
            ALUOp_o    = `ALUOp_I_type;
            ALUSrc_o   = 1'b1;
            RegWrite_o = 1'b1;
        end
    endcase
end

endmodule
