module ALU(
input [3:0]   operator_i,
input [31:0]  operator_a_i,
input [31:0]  operator_b_i,
output reg [31:0] result_o,
output reg        comparison_result_o
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
	case (operator_i)
	ALU_ADD: begin 
		result_o = operator_a_i + operator_b_i; comparison_result_o = 0; 
		end
	ALU_SUB: begin 
		result_o = operator_a_i - operator_b_i; comparison_result_o = 0; 
		end

	ALU_XOR: begin 
		result_o = operator_a_i ^ operator_b_i; comparison_result_o = 0; 
		end
	ALU_OR: begin 
		result_o = operator_a_i | operator_b_i; comparison_result_o = 0; 
		end
	ALU_AND: begin 
		result_o = operator_a_i & operator_b_i; comparison_result_o = 0; 
		end

	ALU_SRA: begin 
		result_o = $signed(operator_a_i) >>> operator_b_i; comparison_result_o = 0; 
		end
	ALU_SRL: begin 
		result_o = operator_a_i >> operator_b_i; comparison_result_o = 0; 
		end
	ALU_SLL: begin 
		result_o = operator_a_i << operator_b_i; comparison_result_o = 0; 
		end

	ALU_LTS: begin 
		result_o = ($signed(operator_a_i) < $signed(operator_b_i)) ? 1:0 ; comparison_result_o = result_o; 
		end
	ALU_LTU: begin 
		result_o = (operator_a_i < operator_b_i) ? 1:0 ; comparison_result_o = result_o; 
		end
	ALU_GES: begin 
		result_o = ($signed(operator_a_i) >= $signed(operator_b_i)) ? 1:0 ; comparison_result_o = result_o; 
		end
	ALU_GEU: begin 
		result_o = (operator_a_i >= operator_b_i) ? 1:0 ; comparison_result_o = result_o; 
		end

	ALU_EQ: begin 
		result_o = (operator_a_i == operator_b_i) ? 1:0 ; comparison_result_o = result_o; 
		end
	ALU_NE: begin 
		result_o = (operator_a_i != operator_b_i) ? 1:0 ; comparison_result_o = result_o; 
		end
		
	endcase
end

endmodule