module RF(
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] WD3,
	input WE,
	input reset,
	input clk,
	output [31:0] RD1,
	output [31:0] RD2
);

reg [31:0] RAM [0:31];

assign RD1 = RAM[A1];
assign RD2 = RAM[A2];
integer i;

always @ (posedge clk or posedge reset)
	
	if (reset)
		for (i = 1; i < 32; i = i + 1)
			RAM[i] <= 4'b0000;

	else if (WE)
		if (A3 != 0)
			RAM[A3] <= WD3;

endmodule