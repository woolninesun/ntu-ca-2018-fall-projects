module MUX32 (
    data1_i, data2_i, select_i,
    data_o
);

input       [31:0]  data1_i, data2_i;
input               select_i;
output  reg [31:0]  data_o;

always @( * ) begin
    if ( select_i == 1 ) 
        data_o = data2_i;
    else
        data_o = data1_i;
end

endmodule

module MUX32_Forwarding (
    data1_i, data2_i, data3_i, select_i,
    data_o
);

input       [31:0]  data1_i, data2_i, data3_i;
input       [ 1:0]  select_i;
output  reg [31:0]  data_o;

always @( * ) begin
    case( select_i )
        2'b00:   data_o = data1_i;  // 00 register data
        2'b01:   data_o = data2_i;  // 01 MEM hazard (forward from MEMWB)
        2'b10:   data_o = data3_i;  // 10 EX  hazard (forward from EXMEM)
        default: data_o = data1_i;
    endcase
end

endmodule
