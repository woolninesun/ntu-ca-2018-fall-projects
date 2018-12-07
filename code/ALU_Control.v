`include "opcodes.vh"

module ALU_Control (
    funct_i, ALUOp_i, ALUCtrl_o
);

input   [9:0]   funct_i;
input   [1:0]   ALUOp_i;
output  [2:0]   ALUCtrl_o;

reg     [2:0]   ALUCtrl_o;

always @( funct_i or ALUOp_i ) begin
    case( ALUOp_i )
        `ALUOp_R_type: begin
            case( funct_i )
                `Funct_OR : ALUCtrl_o = `ALUCtrl_OR ;
                `Funct_AND: ALUCtrl_o = `ALUCtrl_AND;
                `Funct_ADD: ALUCtrl_o = `ALUCtrl_ADD;
                `Funct_SUB: ALUCtrl_o = `ALUCtrl_SUB;
                `Funct_MUL: ALUCtrl_o = `ALUCtrl_MUL;
            endcase
        end

        `ALUOp_I_type: begin
            ALUCtrl_o = `ALUCtrl_ADD;
        end
    endcase
end

endmodule

