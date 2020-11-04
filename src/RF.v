module RF(
input clk,
input rst,
input [4:0] A1, 
input [4:0] A2,
output [31:0] RD1,
output [31:0] RD2,
input WE3,
input [4:0] A3,
input [31:0] WD3 
);

reg [31:0] RAM [0:31];
	  
	 assign RD1 = (A1 == 5'd0) ? 32'd0 : RAM[A1];
	 assign RD2 = (A2 == 5'd0) ? 32'd0 : RAM[A2];
	 
	 integer i;
	 always @ (posedge clk) begin
		 
// $display("\nA1 : %d", A1);
// $display("A2 : %d", A2);
// $display("A3 : %d", A3);
// $display("Сумма : %d", RAM[17]);
// $display("16 : %d", RAM[18]);
// $display("C1 : %d", RAM[1]);
// $display("C2 : %d", RAM[15]);
// $display("RD1 : %d", RD1);

	   if (rst) 
		for (i = 0; i < 32; i=i+1) 
			RAM[i] <= 32'd0;
	   else
			if (WE3) RAM[A3] <= WD3;
	 end

endmodule