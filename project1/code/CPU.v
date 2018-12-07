module CPU (
    clk_i, rst_i, start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] pc_current, pc_next, instruction;
wire [31:0] extended;

wire [1:0]  ctrl_ALUOp;
wire        ctrl_RegDst, ctrl_ALUSrc, ctrl_RegWrite;

wire [31:0] RS_data, RD_data;

wire [31:0] MUX_result;

wire [2:0]  ALU_ctrl;
wire [31:0] ALU_result;
wire        zero;

PC PC (
    .clk_i      ( clk_i      ),
    .rst_i      ( rst_i      ),
    .start_i    ( start_i    ),
    .pc_i       ( pc_next    ),
    .pc_o       ( pc_current )
);

Adder Add_PC (
    .data1_i    ( pc_current ),
    .data2_i    ( 32'd4      ),
    .data_o     ( pc_next    )
);

Instruction_Memory Instruction_Memory (
    .addr_i     ( pc_current  ), 
    .instr_o    ( instruction )
);

Control Control (
    .Op_i       ( instruction [6:0] ),
    .RegDst_o   ( ctrl_RegDst       ),
    .ALUOp_o    ( ctrl_ALUOp        ),
    .ALUSrc_o   ( ctrl_ALUSrc       ),
    .RegWrite_o ( ctrl_RegWrite     )
);

Registers Registers (
    .clk_i      ( clk_i               ),
    .RSaddr_i   ( instruction [19:15] ),
    .RTaddr_i   ( instruction [24:20] ),
    .RDaddr_i   ( instruction [11:7]  ), 
    .RDdata_i   ( ALU_result          ),
    .RegWrite_i ( ctrl_RegWrite       ), 
    .RSdata_o   ( RS_data             ), 
    .RTdata_o   ( RD_data             ) 
);
 
Sign_Extend Sign_Extend (
    .data_i     ( instruction ),
    .data_o     ( extended    )
);

MUX32 MUX_ALUSrc (
    .data1_i    ( RD_data     ),
    .data2_i    ( extended    ),
    .select_i   ( ctrl_ALUSrc ),
    .data_o     ( MUX_result  )
);

ALU ALU (
    .data1_i    ( RS_data    ),
    .data2_i    ( MUX_result ),
    .ALUCtrl_i  ( ALU_ctrl   ),
    .data_o     ( ALU_result ),
    .Zero_o     ( zero       )
);

ALU_Control ALU_Control (
    .funct_i    ( { instruction[31:25], instruction[14:12] } ),
    .ALUOp_i    ( ctrl_ALUOp ),
    .ALUCtrl_o  ( ALU_ctrl   )
);

endmodule

