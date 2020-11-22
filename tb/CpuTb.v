`timescale 10ns/1ns


module CpuUnit();
reg clk;
reg reset;
wire [31:0] pcLastState;
wire [31:0] currentInstrucntion;
wire [31:0] dataMemoryOutput;
wire [31:0] dataMemoryOut;
wire [31:0] dataMemoryAdress;
wire [2:0] MemSize;
wire MemWE;

Cpu dut(
.clk(clk),
.reset(reset),
.pcLastState(pcLastState),
.currentInstrucntion(currentInstrucntion),
.dataMemoryOutput(dataMemoryOutput),
.dataMemoryOut(dataMemoryOut),
.dataMemoryAdress(dataMemoryAdress),
.MemSize(MemSize),
.MemWE(MemWE)
);

DM data(
.clk(clk),
.WE(MemWE),
.size(MemSize),
.WD(dataMemoryOut),
.A(dataMemoryAdress),
.RD(dataMemoryOutput)
);

InstructionMemory Instructions(
.A(pcLastState), 
.Instr(currentInstrucntion)
);

initial begin
reset = 1; #1;
clk = 0; #1;
clk = 1; #1;
reset = 0; #1;
while(1)
	begin
	clk = 0; #1;
	clk = 1; #1;
	end
end

endmodule