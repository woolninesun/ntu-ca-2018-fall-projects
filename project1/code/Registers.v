module Registers (
    clk_i, RS1addr_i, RS2addr_i, RDaddr_i,  RDdata_i, RegWrite_i, 
           RS1data_o, RS2data_o 
);

// Ports
input               clk_i;
input       [ 4:0]  RS1addr_i, RS2addr_i;
input       [ 4:0]  RDaddr_i;
input       [31:0]  RDdata_i;
input               RegWrite_i;
output      [31:0]  RS1data_o, RS2data_o;

reg         [31:0]  register    [0:31];

// Read Data
assign  RS1data_o = ( RegWrite_i && ( RDaddr_i == RS1addr_i)) ?
                        RDdata_i: register[RS1addr_i];
assign  RS2data_o = ( RegWrite_i && ( RDaddr_i == RS2addr_i)) ?
                        RDdata_i: register[RS2addr_i];

always@( posedge clk_i ) begin
    if (RegWrite_i)
        register[RDaddr_i] = RDdata_i;
end

endmodule 
