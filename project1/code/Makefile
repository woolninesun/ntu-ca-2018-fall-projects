VERILOG_FILE = Adder.v ALU.v Branch_Detection_Unit.v Control.v CPU.v Data_Memory.v  Forwarding_Unit.v Hazard_Detection_Unit.v Immediate_Generator.v Instruction_Memory.v MUX32.v PC.v Pipeline_Unit.v Registers.v testbench.v

rv32cpu: $(VERILOG_FILE)
	@iverilog $(VERILOG_FILE) -o $@

run: rv32cpu
	@vvp rv32cpu

clean: rv32cpu rv32cpu.vcd output.txt
	@rm rv32cpu rv32cpu.vcd output.txt
