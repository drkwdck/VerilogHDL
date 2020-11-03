module ALU(
input [3:0] operator,
input [31:0] left,
input [31:0] right,
output reg [31:0] result,
output reg comparison
);

localparam ALU_ADD = 4'b0000;
localparam ALU_SUB = 4'b0001;

localparam ALU_XOR = 4'b0010;
localparam ALU_OR  = 4'b0011;
localparam ALU_AND = 4'b0100;

localparam ALU_SRA = 4'b0101;
localparam ALU_SRL = 4'b0110;
localparam ALU_SLL = 4'b0111;

localparam ALU_LTS = 4'b1000;
localparam ALU_LTU = 4'b1001;
localparam ALU_GES = 4'b1010;
localparam ALU_GEU = 4'b1011;

localparam ALU_EQ = 4'b1100;
localparam ALU_NE = 4'b1101;

always@(*) begin
	case (operator)
	ALU_ADD: begin 
		result = left + right; comparison = 0; 
		end
	ALU_SUB: begin 
		result = left - right; comparison = 0; 
		end

	ALU_XOR: begin 
		result = left ^ right; comparison = 0; 
		end

	ALU_OR: begin 
		result = left | right; comparison = 0; 
		end

	ALU_AND: begin 
		result = left & right; comparison = 0; 
		end

	ALU_SRA: begin 
		result = $signed(left) >>> right; comparison = 0; 
		end

	ALU_SRL: begin 
		result = left >> right; comparison = 0; 
		end

	ALU_SLL: begin 
		result = left << right; comparison = 0; 
		end

	ALU_LTS: begin 
		result = ($signed(left) < $signed(right)) ? 1:0 ; comparison = result; 
		end

	ALU_LTU: begin 
		result = (left < right) ? 1:0 ; comparison = result; 
		end

	ALU_GES: begin 
		result = ($signed(left) >= $signed(right)) ? 1:0 ; comparison = result; 
		end

	ALU_GEU: begin 
		result = (left >= right) ? 1:0 ; comparison = result; 
		end

	ALU_EQ: begin 
		result = (left == right) ? 1:0 ; comparison = result; 
		end

	ALU_NE: begin 
		result = (left != right) ? 1:0 ; comparison = result; 
		end
		
	endcase
end

endmodule