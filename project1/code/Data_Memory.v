module Data_Memory (
    clk_i, memAddr_i, memData_i, memRead_i, memWrite_i,
                      memData_o
);

input               clk_i;
input       [31:0]  memAddr_i, memData_i;
input               memRead_i, memWrite_i;
output      [31:0]  memData_o;

reg         [ 7:0]  memory[0:31];

// Read Memory
assign memData_o = ( memRead_i === 1 )? memory[memAddr_i]:0;

// Write Memory
always @( posedge clk_i ) begin
    if ( memWrite_i === 1 )
        memory[memAddr_i] <= memData_i;
end

endmodule
