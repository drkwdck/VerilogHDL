module PC(
input reset,
input CLK,
input [31:0] IN,
output [31:0] OUT
);

reg [31:0] CUR;

assign OUT = CUR;

always @ (posedge CLK or posedge reset)
begin

	if(reset) begin
		CUR <= 32'b00000000000000000000000000000000;
	end
	else begin
	CUR <= IN;
	end
end



endmodule