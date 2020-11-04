module InstructionMemory(
	input clk,
	input  WE,
	input [31:0] A,
	output [31:0] RD
);
	reg [31:0] RAM [0:31];
	initial $readmemb ("File_mem.txt", RAM);
	assign RD = RAM[A[5:2]];
endmodule