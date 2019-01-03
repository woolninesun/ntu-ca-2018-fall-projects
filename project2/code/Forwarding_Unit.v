module Forwarding_Unit (
    IDEX_RS1addr_i, IDEX_RS2addr_i,
    EXMEM_RDaddr_i, MEMWB_RDaddr_i,
    EXMEM_RegWrite_i, MEMWB_RegWrite_i,
    ForwardA_o, ForwardB_o
);

input       [4:0]   IDEX_RS1addr_i,   IDEX_RS2addr_i;
input       [4:0]   EXMEM_RDaddr_i,   MEMWB_RDaddr_i;
input               EXMEM_RegWrite_i, MEMWB_RegWrite_i; 
output  reg [1:0]   ForwardA_o, ForwardB_o;

always @( * ) begin
    // Forward A
    ForwardA_o = 2'b00;     // default no hazard
    if      ( EXMEM_RegWrite_i  && ( EXMEM_RDaddr_i == IDEX_RS1addr_i ) )
        ForwardA_o = 2'b10; // EX hazard of rs1
    else if ( MEMWB_RegWrite_i  && ( MEMWB_RDaddr_i == IDEX_RS1addr_i ) )
        ForwardA_o = 2'b01; // MEM hazard of rs1

    // Forward B
    ForwardB_o = 2'b00;     // default no hazard
    if      ( EXMEM_RegWrite_i  && ( EXMEM_RDaddr_i == IDEX_RS2addr_i ) )
        ForwardB_o = 2'b10; // EX hazard of rs2
    else if ( MEMWB_RegWrite_i  && ( MEMWB_RDaddr_i == IDEX_RS2addr_i ) )
        ForwardB_o = 2'b01; // MEM hazard of rs2
end

endmodule
