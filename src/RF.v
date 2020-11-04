module RF(
input clk,
input reset,
input [4:0] A1, 
input [4:0] A2,
output [31:0] RD1,
output [31:0] RD2,
input WE,
input [4:0] A3,
input [31:0] WD3 
);

reg [31:0] RAM [0:31];
	  
	 assign RD1 = (A1 == 5'd0) ? 32'd0 : RAM[A1];
	 assign RD2 = (A2 == 5'd0) ? 32'd0 : RAM[A2];
	 
	 integer i;
	 always @ (posedge clk)
	   if (reset) 
		for (i = 0; i < 32; i=i+1) 
			RAM[i] <= 32'd0;
	   else
			if (WE) RAM[A3] <= WD3;
endmodule

















//
//reg [31:0] RAM [31:0] ;
//
//always @ (posedge clk) 
//if (WE3) RAM[A3] <= WD3; 
//assign RD1=A1?RAM[A1]:0;
//assign RD2=A2?RAM[A2]:0;
