`include "opcodes.vh"

module Control (
    funct_i, opcode_i,
    data_o
);

input       [9:0]   funct_i;
input       [6:0]   opcode_i;
output  reg [3:0]   data_o;

always @( * ) begin
    case ( opcode_i )
        `Opcode_R_TYPE  : begin
            case ( funct_i )
                `Funct_OR   : data_o = `Ctrl_OR;
                `Funct_AND  : data_o = `Ctrl_AND;
                `Funct_ADD  : data_o = `Ctrl_ADD;
                `Funct_SUB  : data_o = `Ctrl_SUB;
                `Funct_MUL  : data_o = `Ctrl_MUL;
            endcase
        end
        `Opcode_ADDI    : data_o = `Ctrl_ADDI;
        `Opcode_LW      : data_o = `Ctrl_LW;
        `Opcode_SW      : data_o = `Ctrl_SW;
        `Opcode_BEQ     : data_o = `Ctrl_BEQ;
        default         : data_o = `Ctrl_NOP;
    endcase
end

endmodule
