module PC(
input reset,
input clk,
input [31:0] IN,
output [31:0] OUT
);

reg [31:0] PC;

assign OUT = PC;

always @ (posedge clk or posedge reset)
begin

	if(reset) begin
		PC <= 32'b00000000000000000000000000000000;
	end
	else begin
	PC <= IN;
	end
end



endmodule