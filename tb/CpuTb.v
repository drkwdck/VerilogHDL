`timescale 10ns/1ns


module CpuUnit();
reg clk;
reg reset;
wire [31:0] dataMemoryOut;
wire [31:0] dataMemoryAdress;
wire [2:0] MemSize;
wire MemWE;

Cpu dut(
.clk(clk),
.reset(reset),
.dataMemoryOut(dataMemoryOut),
.dataMemoryAdress(dataMemoryAdress),
.MemSize(MemSize),
.MemWE(MemWE)
);

integer i = 0;
initial begin
reset = 1; #1;
clk = 0; #1;
clk = 1; #1;
reset = 0; #1;
while(i < 100)
	begin
	clk = 0; #1;
	clk = 1; #1;
	i = i + 1;
	end
end

endmodule