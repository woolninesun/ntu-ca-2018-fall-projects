// Opcodes
`define Opcode_R_type 7'b0110011
`define Opcode_I_type 7'b0010011

`define ALUOp_R_type 2'b01
`define ALUOp_I_type 2'b10

`define Funct_OR  10'b0000000110
`define Funct_AND 10'b0000000111
`define Funct_ADD 10'b0000000000
`define Funct_SUB 10'b0100000000
`define Funct_MUL 10'b0000001000

`define ALUCtrl_OR   3'b001
`define ALUCtrl_AND  3'b000
`define ALUCtrl_ADD  3'b010
`define ALUCtrl_SUB  3'b011
`define ALUCtrl_MUL  3'b100
