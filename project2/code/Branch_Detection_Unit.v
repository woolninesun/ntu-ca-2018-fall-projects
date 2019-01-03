`include "opcodes.vh"

module Branch_Detection_Unit (
    control_i, data1_i, data2_i,
    data_o
);

input       [ 3:0]  control_i;
input       [31:0]  data1_i;
input       [31:0]  data2_i;
output              data_o;

assign  data_o = ( (control_i === `Ctrl_BEQ) && (data1_i === data2_i) )? 1:0;
endmodule
