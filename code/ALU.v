`include "opcodes.vh"

module ALU (
    data1_i, data2_i, ALUCtrl_i, data_o, Zero_o
);

input   [31:0]  data1_i, data2_i;
input   [2:0]   ALUCtrl_i;
output  [31:0]  data_o;
output          Zero_o;

reg     [31:0]  data_o;
reg             Zero_o;

always @( data1_i or data2_i or ALUCtrl_i ) begin
    case(ALUCtrl_i)
        `ALUCtrl_OR : data_o = data1_i | data2_i ;
        `ALUCtrl_AND: data_o = data1_i & data2_i ;
        `ALUCtrl_ADD: data_o = data1_i + data2_i ;
        `ALUCtrl_SUB: data_o = data1_i - data2_i ;
        `ALUCtrl_MUL: data_o = data1_i * data2_i ;
    endcase

    if ( data_o == 32'b0 )
        Zero_o = 1'b1;
    else
        Zero_o = 1'b0;
end

endmodule
