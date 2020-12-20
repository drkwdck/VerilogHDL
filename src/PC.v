module PC(
input EN,
input RESET,
input CLK,
input [31:0] IN,
output [31:0] OUT
);

reg [31:0] CUR;

assign OUT = CUR;

always @ (posedge CLK or posedge RESET)
begin

	if(RESET) begin
		CUR <= 32'b00000000000000000000000000000000;
	end
	else if(EN) begin
	CUR <= IN;
	end
end



endmodule