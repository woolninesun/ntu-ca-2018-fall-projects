module PC (
    clk_i, rst_i, start_i, pc_i, hazard_i, stall_i,
                           pc_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input               hazard_i;
input               stall_i;
input       [31:0]  pc_i;
output  reg [31:0]  pc_o;

always @( posedge clk_i or negedge rst_i ) begin
    if ( ~rst_i ) begin
        pc_o <= 32'b0;
    end
    else begin
        if (stall_i === 1'b1) begin
        end
        else if ( start_i && !hazard_i )
            pc_o <= pc_i;
        else
            pc_o <= pc_o;
    end
end

endmodule
