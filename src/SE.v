module SE (
input  [7:0] A,
output [31:0] result
);
reg [31:0] res;
always @(*) begin
	res [31:8] <= {24{A[7]}};
	res [7:0] <= A [7:0];
end
assign result = res;
endmodule 
