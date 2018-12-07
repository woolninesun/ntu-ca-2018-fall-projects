VERILOG_FILE = 				\
	testbench.v				\
	CPU.v 					\
	PC.v 					\
	Adder.v 				\
	Instruction_Memory.v 	\
	Control.v 				\
	Registers.v 			\
	Sign_Extend.v 			\
	MUX32.v 				\
	ALU.v 					\
	ALU_Control.v

rv32cpu: $(VERILOG_FILE)
	@iverilog $(VERILOG_FILE) -o $@

run: rv32cpu
	@vvp rv32cpu

clean: rv32cpu rv32cpu.vcd output.txt
	@rm rv32cpu rv32cpu.vcd output.txt
