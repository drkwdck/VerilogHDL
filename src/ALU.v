module myriscv_alu(
input [5:0] operator_i,
input [31:0] operand_a_i,
input [31:0] operand_b_i,
output reg [31:0] result_o,
output reg comparison_result_o);

localparam ALU_ADD = 6'b011000; 
localparam ALU_SUB = 6'b011001; 

localparam ALU_XOR = 6'b101111; 
localparam ALU_OR = 6'b101110; 
localparam ALU_AND = 6'b010101;

localparam ALU_SRA = 6'b100100;
localparam ALU_SRL = 6'b100101;
localparam ALU_SLL = 6'b100111;
localparam ALU_LTS = 6'b000000;
localparam ALU_LTU = 6'b000001;
localparam ALU_GES = 6'b001010;
localparam ALU_GEU = 6'b001011;

localparam ALU_SLTS = 6'b000010;
localparam ALU_SLTU = 6'b000011;

localparam ALU_EQ = 6'b001100; 
localparam ALU_NE = 6'b001101; 

always@(*) begin
	case(operator_i)
		ALU_ADD: begin
			 result_o = operand_a_i + operand_b_i; comparison_result_o = 0; 
			 end
		ALU_SUB: begin
			 result_o = operand_a_i - operand_b_i; comparison_result_o = 0; 
			 end
		
		ALU_XOR: begin
			 result_o = operand_a_i ^ operand_b_i; comparison_result_o = 0; 
			 end
		ALU_OR: begin
			 result_o = operand_a_i | operand_b_i; comparison_result_o = 0; 
			 end
		ALU_AND: begin
			 result_o = operand_a_i & operand_b_i; comparison_result_o = 0; 
			 end
		
		ALU_SRA: begin
			 result_o = ($signed(operand_a_i)) >>> operand_b_i; comparison_result_o = 0; 
			 end
		ALU_SRL: begin
			 result_o = operand_a_i >> operand_b_i; comparison_result_o = 0; 
			 end
		ALU_SLL: begin
			 result_o = operand_a_i << operand_b_i; comparison_result_o = 0; 
			 end
		
		ALU_LTS: begin
			 result_o = ($signed(operand_a_i)) < ($signed(operand_b_i)) ? 1:0; comparison_result_o = result_o; 
			 end
		ALU_LTU: begin
			 result_o = operand_a_i < operand_b_i ? 1:0; comparison_result_o = result_o; 
			 end
		ALU_GES: begin
			 result_o = ($signed(operand_a_i)) >= ($signed(operand_b_i)) ? 1:0; comparison_result_o = result_o; 
			 end
		ALU_GEU: begin
			 result_o = operand_a_i >= operand_b_i ? 1:0; comparison_result_o = result_o; 
			 end
		
		ALU_SLTS: begin 
			result_o = ($signed(operand_a_i)) < ($signed(operand_b_i)) ? 1:0; comparison_result_o = result_o; 
			end
		ALU_SLTU: begin 
			result_o = operand_a_i < operand_b_i ? 1:0; comparison_result_o = result_o; 
			end
		
		ALU_EQ: begin 
			result_o = operand_a_i == operand_b_i ? 1:0; comparison_result_o = result_o; 
			end
		ALU_NE: begin 
			result_o = operand_a_i != operand_b_i ? 1:0; comparison_result_o = result_o; 
			end
		endcase
		
		end
		
endmodule