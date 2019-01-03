`include "opcodes.vh"

module Immediate_Generator (
    instr_i,
    data_o
);

input       [31:0]  instr_i;
output  reg [31:0]  data_o;
        reg [19:0]  extend_bits;

always @( * ) begin
    extend_bits = { 20{instr_i[31]} };
    case( instr_i[6:0] )
        `Opcode_ADDI: begin
            data_o = { extend_bits, instr_i[31:20]                              };
        end
        `Opcode_LW  : begin
            data_o = { extend_bits, instr_i[31:20]                              };
        end
        `Opcode_SW  : begin
            data_o = { extend_bits, instr_i[31:25], instr_i[11:7]               };
        end
        `Opcode_BEQ : begin
            data_o = { extend_bits, instr_i[7], instr_i[30:25], instr_i[11:8]   };
        end
        default     : begin
            data_o = { extend_bits, 12'b0                                       };
        end
    endcase
end

endmodule
