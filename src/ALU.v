`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_XOR 4'b0010
`define ALU_OR 4'b0011
`define ALU_AND 4'b0100
`define ALU_SRA 4'b0101
`define ALU_SRL 4'b0110
`define ALU_SLL 4'b0111
`define ALU_LTS 4'b1000
`define ALU_LTU 4'b1001
`define ALU_GES 4'b1010
`define ALU_GEU 4'b1011
`define ALU_EQ 4'b1100
`define ALU_NE 4'b1101

module ALU(
input [3:0] operator,
input [31:0] left,
input [31:0] right,
output reg [31:0] result,
output reg comparison
);
always@(*) begin
	case (operator)
	`ALU_ADD: begin 
		result = left + right; comparison = 0; 
		end
	`ALU_SUB: begin 
		result = left - right; comparison = 0; 
		end

	`ALU_XOR: begin 
		result = left ^ right; comparison = 0; 
		end

	`ALU_OR: begin 
		result = left | right; comparison = 0; 
		end

	`ALU_AND: begin 
		result = left & right; comparison = 0; 
		end

	`ALU_SRA: begin 
		result = $signed(left) >>> right; comparison = 0; 
		end

	`ALU_SRL: begin 
		result = left >> right; comparison = 0; 
		end

	`ALU_SLL: begin 
		result = left << right; comparison = 0; 
		end

	`ALU_LTS: begin 
		result = ($signed(left) < $signed(right)) ? 1:0 ; comparison = result; 
		end

	`ALU_LTU: begin 
		result = (left < right) ? 1:0 ; comparison = result; 
		end

	`ALU_GES: begin 
		result = ($signed(left) >= $signed(right)) ? 1:0 ; comparison = result; 
		end

	`ALU_GEU: begin 
		result = (left >= right) ? 1:0 ; comparison = result; 
		end

	`ALU_EQ: begin 
		result = (left == right) ? 1:0 ; comparison = result;
		end

	`ALU_NE: begin 
		result = (left != right) ? 1:0 ; comparison = result; 
		end
		
	endcase
end

endmodule