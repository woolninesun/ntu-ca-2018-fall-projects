module Hazard_Detection_Unit (
    IFID_RS1addr_i, IFID_RS2addr_i, IDEX_MemRead_i, IDEX_RDaddr_i,
    hazard_o
);

input       [4:0]   IFID_RS1addr_i, IFID_RS2addr_i, IDEX_RDaddr_i;
input               IDEX_MemRead_i;
output  reg         hazard_o;

wire                IDEX_MemRead = ( IDEX_MemRead_i === 1 ) ? 1:0;

always @( * ) begin
    if ( IDEX_MemRead && 
         ( ( IDEX_RDaddr_i == IFID_RS1addr_i ) ||
           ( IDEX_RDaddr_i == IFID_RS2addr_i )   )
    )
        hazard_o = 1'b1;
    else
        hazard_o = 1'b0;
end

endmodule
