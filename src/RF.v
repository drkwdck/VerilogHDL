module RF(
	input clk,
	input reset,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] WD3,
	input WE,
	output [31:0] RD1,
	output [31:0] RD2
);

reg [31:0] memory [0:31];

assign RD1 = memory[A1];
assign RD2 = memory[A2];
integer i;

always @ (posedge clk or posedge reset)
	if (reset) 
		for (i = 1; i < 32; i = i + 1)
			memory[i] <= 4'b0;
	else if (WE)
		if (A3 != 0)
			memory[A3] <= WD3;
	
endmodule