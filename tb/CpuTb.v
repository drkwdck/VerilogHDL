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