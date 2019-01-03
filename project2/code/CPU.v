`include "opcodes.vh"

module CPU (
    clk_i, 
    rst_i, 
    start_i,

    mem_data_i, 
    mem_ack_i,  
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

// Ports
input               clk_i, rst_i, start_i;
//
// to Data Memory interface     
//
input   [256-1:0]   mem_data_i; 
input               mem_ack_i;  
output  [256-1:0]   mem_data_o; 
output  [32-1:0]    mem_addr_o;     
output              mem_enable_o; 
output              mem_write_o; 

wire                tmp_RegWrite;
wire        [31:0]  tmp_Immediate;
reg                 RegWrite    = 1'b0;
reg         [31:0]  Immediate   = 32'b0;
always @( tmp_RegWrite  ) begin RegWrite    <= tmp_RegWrite;    end
always @( tmp_Immediate ) begin Immediate   <= tmp_Immediate;   end

Control Control (
    .funct_i    ( { IFID.inst_o[31:25], IFID.inst_o[14:12] }    ),
    .opcode_i   ( IFID.inst_o[ 6: 0]                            ),
    .data_o     ()
);

Adder Adder_PC (
    .data1_i    ( PC.pc_o   ),
    .data2_i    ( 32'd4     ),
    .data_o     ()
);

PC PC (
    .clk_i      ( clk_i                             ),
    .rst_i      ( rst_i                             ),
    .start_i    ( start_i                           ),
    .hazard_i   ( Hazard_Detection_Unit.hazard_o    ),
    .pc_i       ( MUX_PC.data_o                     ),
    .stall_i    ( dcache.p1_stall_o                 ),
    .pc_o       ()
);

MUX32 MUX_PC (
    .data1_i    ( Adder_PC.data_o                   ),
    .data2_i    ( Adder_Branch.data_o               ),
    .select_i   ( Branch_Detection_Unit.data_o      ),
    .data_o     ()
);

Adder_Branch Adder_Branch (
    .data1_i    ( IFID.pc_o ),
    .data2_i    ( Immediate ),    
    .data_o     ()
);

Instruction_Memory Instruction_Memory (
    .addr_i     ( PC.pc_o   ),
    .inst_o     ()
);

IFID IFID (
    .clk_i          ( clk_i                             ),
    .pc_i           ( PC.pc_o                           ),
    .inst_i         ( Instruction_Memory.inst_o         ),
    .hazard_i       ( Hazard_Detection_Unit.hazard_o    ),
    .branch_i       ( Branch_Detection_Unit.data_o      ),
    .stall_i        ( dcache.p1_stall_o                 ),
    .pc_o           (),
    .inst_o         ()
);

Registers Registers (
    .clk_i      ( clk_i                 ),
    .RS1addr_i  ( IFID.inst_o[19:15]    ),
    .RS2addr_i  ( IFID.inst_o[24:20]    ),
    .RDaddr_i   ( MEMWB.RDaddr_o        ), 
    .RDdata_i   ( MEMWB.WB_Data_o       ),
    .RegWrite_i ( RegWrite              ), 
    .RS1data_o  (), 
    .RS2data_o  () 
);

Branch_Detection_Unit Branch_Detection_Unit (
    .control_i  ( Control.data_o        ),
    .data1_i    ( Registers.RS1data_o   ),
    .data2_i    ( Registers.RS2data_o   ),    
    .data_o     ()
);

Immediate_Generator Immediate_Generator (
    .instr_i    ( IFID.inst_o           ),
    .data_o     ( tmp_Immediate         )
);

Hazard_Detection_Unit Hazard_Detection_Unit (
    .IFID_RS1addr_i ( IFID.inst_o[19:15]            ),
    .IFID_RS2addr_i ( IFID.inst_o[24:20]            ),
    .IDEX_MemRead_i ( IDEX.control_o === `Ctrl_LW   ),
    .IDEX_RDaddr_i  ( IDEX.RDaddr_o                 ),
    .hazard_o       ()
);

IDEX IDEX (
    .clk_i          ( clk_i                             ),
    .control_i      ( Control.data_o                    ),
    .RS1data_i      ( Registers.RS1data_o               ),
    .RS2data_i      ( Registers.RS2data_o               ),
    .immediate_i    ( Immediate                         ),
    .RS1addr_i      ( IFID.inst_o[19:15]                ),
    .RS2addr_i      ( IFID.inst_o[24:20]                ),
    .RDaddr_i       ( IFID.inst_o[11: 7]                ),
    .hazard_i       ( Hazard_Detection_Unit.hazard_o    ),
    .stall_i        ( dcache.p1_stall_o                 ),
    .control_o      (),
    .RS1data_o      (),
    .RS2data_o      (),
    .immediate_o    (),
    .RS1addr_o      (),
    .RS2addr_o      (),
    .RDaddr_o       ()
);

MUX32 MUX_ALU_Src (
    .data1_i    ( MUX_ForwardB.data_o                        ),
    .data2_i    ( IDEX.immediate_o                      ),
    .select_i   ( (IDEX.control_o === `Ctrl_ADDI) ||
                  (IDEX.control_o === `Ctrl_LW)   ||
                  (IDEX.control_o === `Ctrl_SW)         ),
    .data_o     ()
);

MUX32_Forwarding MUX_ForwardA (
    .data1_i    ( IDEX.RS1data_o                ),
    .data2_i    ( MEMWB.WB_Data_o               ),
    .data3_i    ( EXMEM.ALUResult_o             ),
    .select_i   ( Forwarding_Unit.ForwardA_o    ),
    .data_o     ()
);

MUX32_Forwarding MUX_ForwardB (
    .data1_i    ( IDEX.RS2data_o            ),
    .data2_i    ( MEMWB.WB_Data_o               ),
    .data3_i    ( EXMEM.ALUResult_o             ),
    .select_i   ( Forwarding_Unit.ForwardB_o    ),
    .data_o     ()
);

Forwarding_Unit Forwarding_Unit (
    .IDEX_RS1addr_i     ( IDEX.RS1addr_o                        ),
    .IDEX_RS2addr_i     ( IDEX.RS2addr_o                        ),
    .EXMEM_RDaddr_i     ( EXMEM.RDaddr_o                        ),
    .MEMWB_RDaddr_i     ( MEMWB.RDaddr_o                        ),
    .EXMEM_RegWrite_i   ( (EXMEM.control_o !== `Ctrl_SW ) && 
                          (EXMEM.control_o !== `Ctrl_BEQ)       ),
    .MEMWB_RegWrite_i   ( (MEMWB.control_o !== `Ctrl_SW ) && 
                          (MEMWB.control_o !== `Ctrl_BEQ)       ),
    .ForwardA_o         (),
    .ForwardB_o         ()
);

ALU ALU (
    .data1_i    ( MUX_ForwardA.data_o   ),
    .data2_i    ( MUX_ALU_Src.data_o   ),
    .control    ( IDEX.control_o        ),
    .data_o     ()
);

EXMEM EXMEM (
    .clk_i          ( clk_i             ),
    .control_i      ( IDEX.control_o    ),
    .ALUResult_i    ( ALU.data_o        ),
    .RS2data_i      ( MUX_ForwardB.data_o    ),
    .RDaddr_i       ( IDEX.RDaddr_o     ),
    .stall_i        ( dcache.p1_stall_o ),
    .control_o      (),
    .ALUResult_o    (),
    .RS2data_o      (),
    .RDaddr_o       ()
);

// Data_Memory Data_Memory (
//     .clk_i      ( clk_i                         ),
//     .memAddr_i  ( EXMEM.ALUResult_o             ),
//     .memData_i  ( EXMEM.RS2data_o               ),
//     .memRead_i  ( EXMEM.control_o === `Ctrl_LW  ),
//     .memWrite_i ( EXMEM.control_o === `Ctrl_SW  ),
//     .memData_o  ()
// );
dcache_top dcache(
    // System clock, reset and stall
    .clk_i( clk_i), 
    .rst_i( rst_i),
    
    // to Data Memory interface     
    .mem_data_i(mem_data_i), 
    .mem_ack_i(mem_ack_i),  
    .mem_data_o(mem_data_o), 
    .mem_addr_o(mem_addr_o),     
    .mem_enable_o(mem_enable_o), 
    .mem_write_o(mem_write_o), 
    
    // to CPU interface 
    .p1_data_i( EXMEM.RS2data_o                     ), 
    .p1_addr_i( EXMEM.ALUResult_o                   ),   
    .p1_MemRead_i( EXMEM.control_o === `Ctrl_LW     ), 
    .p1_MemWrite_i( EXMEM.control_o === `Ctrl_SW    ), 
    .p1_data_o(), 
    .p1_stall_o()
);

MEMWB MEMWB (
    .clk_i          ( clk_i                 ),
    .control_i      ( EXMEM.control_o       ),
    .memData_i      ( dcache.p1_data_o ),
    .ALUResult_i    ( EXMEM.ALUResult_o     ),
    .RDaddr_i       ( EXMEM.RDaddr_o        ),
    .RegWrite_o     ( tmp_RegWrite          ),
    .stall_i        ( dcache.p1_stall_o     ),
    .control_o      (),
    .WB_Data_o      (),
    .RDaddr_o       ()
);

endmodule
