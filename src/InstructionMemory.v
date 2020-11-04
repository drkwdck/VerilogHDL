module InstructionMemory(
	input clk,
	input  WE,
	input [31:0] A,
	output [31:0] RD
);
	reg [31:0] RAM [47:0];
	initial $readmemb ("instructions.txt", RAM);
	assign RD = RAM[A];
endmodule