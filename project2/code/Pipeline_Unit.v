`include "opcodes.vh"

module IFID (
    clk_i, pc_i, inst_i, hazard_i, branch_i, stall_i,
           pc_o, inst_o
);

input               clk_i;
input               hazard_i, branch_i, stall_i;
input       [31:0]  pc_i, inst_i;
output  reg [31:0]  pc_o, inst_o;

always @( posedge clk_i ) begin
    if (stall_i === 1'b1) begin 
    end
    else begin
        pc_o = ( hazard_i ) ? pc_o : pc_i;
        if ( branch_i )
            inst_o  = 0;
        else
            inst_o = ( hazard_i ) ? inst_o : inst_i;
    end
   
end

endmodule

module IDEX (    
    clk_i, hazard_i,
    control_i, RS1data_i, RS2data_i, immediate_i, RS1addr_i, RS2addr_i, RDaddr_i, stall_i,
    control_o, RS1data_o, RS2data_o, immediate_o, RS1addr_o, RS2addr_o, RDaddr_o
);

input               clk_i;
input               hazard_i, stall_i;
input       [ 3:0]  control_i;    
input       [31:0]  RS1data_i, RS2data_i, immediate_i;
input       [ 4:0]  RS1addr_i, RS2addr_i, RDaddr_i;
output  reg [ 3:0]  control_o;
output  reg [31:0]  RS1data_o, RS2data_o, immediate_o;
output  reg [ 4:0]  RS1addr_o, RS2addr_o, RDaddr_o;

always @( posedge clk_i ) begin
    if (stall_i === 1'b1) begin
    end
    else begin
        control_o   <= ( hazard_i ) ? `Ctrl_NOP : control_i;
        RS1data_o   <= RS1data_i;
        RS2data_o   <= RS2data_i;
        immediate_o <= immediate_i;
        RS1addr_o   <= RS1addr_i;
        RS2addr_o   <= RS2addr_i;
        RDaddr_o    <= RDaddr_i;

        
    end

end

endmodule

module EXMEM (
    clk_i, control_i, ALUResult_i, RS2data_i, RDaddr_i, stall_i,
           control_o, ALUResult_o, RS2data_o, RDaddr_o
);

input               clk_i;
input       [ 3:0]  control_i;    
input       [31:0]  ALUResult_i;
input       [31:0]  RS2data_i;
input       [ 4:0]  RDaddr_i;
input               stall_i;
output  reg [ 3:0]  control_o;
output  reg [31:0]  ALUResult_o;
output  reg [31:0]  RS2data_o;
output  reg [ 4:0]  RDaddr_o;

always @( posedge clk_i ) begin
    if (stall_i === 1'b1) begin
    end
    else begin
        control_o   <= control_i;
        ALUResult_o <= ALUResult_i;
        RS2data_o   <= RS2data_i;
        RDaddr_o    <= RDaddr_i;
    end
    
end

endmodule

module MEMWB (
    clk_i, control_i, memData_i, ALUResult_i, RDaddr_i, stall_i,
    control_o, WB_Data_o, RDaddr_o, RegWrite_o
);

input               clk_i;
input       [ 3:0]  control_i;
input       [31:0]  memData_i;
input       [31:0]  ALUResult_i;
input       [ 4:0]  RDaddr_i;
input               stall_i;
output  reg [ 3:0]  control_o;
output  reg [31:0]  WB_Data_o;
output  reg [ 4:0]  RDaddr_o;
output  reg         RegWrite_o;

always @( posedge clk_i ) begin
    if (stall_i === 1'b1) begin
    end
    else begin
        control_o   <= control_i;
        WB_Data_o   <= ( control_i == `Ctrl_LW )? memData_i: ALUResult_i;
        RDaddr_o    <= RDaddr_i;

        casex ( control_i )
            `Ctrl_SW    : begin RegWrite_o <= 0; end
            `Ctrl_BEQ   : begin RegWrite_o <= 0; end
            `Ctrl_NOP   : begin RegWrite_o <= 0; end
            default     : begin RegWrite_o <= 1; end
        endcase
    end
end

endmodule

