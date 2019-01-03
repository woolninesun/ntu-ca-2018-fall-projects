`include "opcodes.vh"

module ALU (
    data1_i, data2_i, control,
    data_o
);


input       [31:0]  data1_i, data2_i;
input       [ 3:0]  control;
output  reg [31:0]  data_o;
output  reg         zero_o;

always @( data1_i or data2_i or control ) begin
    case ( control )
        `Ctrl_OR    : begin data_o = data1_i | data2_i; end 
        `Ctrl_AND   : begin data_o = data1_i & data2_i; end 
        `Ctrl_ADD   : begin data_o = data1_i + data2_i; end 
        `Ctrl_SUB   : begin data_o = data1_i - data2_i; end 
        `Ctrl_MUL   : begin data_o = data1_i * data2_i; end

        `Ctrl_ADDI  : begin data_o = data1_i + data2_i; end 
        `Ctrl_LW    : begin data_o = data1_i + data2_i; end 
        `Ctrl_SW    : begin data_o = data1_i + data2_i; end 
        `Ctrl_BEQ   : begin data_o = data1_i - data2_i; end 
    endcase
end

endmodule
