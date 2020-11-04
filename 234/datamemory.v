module datamemory(
input clk,
input  WE,
input [31:0] A,
//input [31:0] WD,
output [31:0] RD
);


 reg [31:0] RAM [0:15];
	 
	 initial $readmemb ("File_mem.txt", RAM);
		 
	 assign RD = RAM[A[5:2]];


endmodule





























//reg [31:0] RAM [0:15] ;
//initial $readmemb ("F:/quattustest/test.txt", RAM);
//always @ (posedge clk)
//if (WE) RAM[A[31:2]] <= WD; 
//assign RD=RAM[A[31:2]];
