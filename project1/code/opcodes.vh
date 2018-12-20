// Opcodes
`define Opcode_R_TYPE   7'b0110011
    `define Funct_OR        10'b0000000110
    `define Funct_AND       10'b0000000111
    `define Funct_ADD       10'b0000000000
    `define Funct_SUB       10'b0100000000
    `define Funct_MUL       10'b0000001000
`define Opcode_ADDI     7'b0010011
`define Opcode_LW       7'b0000011
`define Opcode_SW       7'b0100011
`define Opcode_BEQ      7'b1100011

`define Ctrl_OR         4'b0000
`define Ctrl_AND        4'b0001
`define Ctrl_ADD        4'b0010
`define Ctrl_SUB        4'b0011
`define Ctrl_MUL        4'b0100
`define Ctrl_ADDI       4'b0101
`define Ctrl_LW         4'b0110
`define Ctrl_SW         4'b0111
`define Ctrl_BEQ        4'b1000
`define Ctrl_NOP        4'b1111
