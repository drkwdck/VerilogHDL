module SizeSelector(
input [2:0] selector,
input [31:0] S8,
input [31:0] S16,
input [31:0] W,
input [31:0] U8,
input [31:0] U16,
output reg [31:0] out
);


always @(*)
begin
case(selector)
	3'd0: begin out = S8; end
	3'd1: begin out = S16; end
	3'd2: begin out = W; end
	3'd4: begin out = U8; end
	3'd5: begin out = U16; end
endcase
end

endmodule