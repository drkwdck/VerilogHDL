module DM (
	input [31:0] A,
	input [31:0] WD,
	input clk,
	input WE,
	output [31:0] RD
);

reg [31:0] mem [0:63];

always @ (posedge clk)

	if ((A >= 32'h73000000) & (A <= 32'h730000fc))
		if (WE) mem[(A & 32'hfc) >> 2] <= WD;

endmodule