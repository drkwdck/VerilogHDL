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
module ALU_2(
  input[3:0] operator_i,
  input[31:0] operand_a_i,
  input[31:0] operand_b_i,
  output reg[31:0]result_o,
  output reg comparison_result_o
  );

always @(*) begin

case(operator_i)
`ALU_ADD: begin 
result_o=operand_a_i+operand_b_i;
comparison_result_o=0;
end
`ALU_SUB: begin
result_o=($signed(operand_a_i)-$signed(operand_b_i));
result_o=$signed(result_o);
comparison_result_o=0;
end
`ALU_XOR: begin
 result_o=operand_a_i^operand_b_i;
comparison_result_o=0;
end
`ALU_OR: begin
result_o=operand_a_i|operand_b_i;
comparison_result_o=0;
end
`ALU_AND: begin
result_o=operand_a_i&operand_b_i;
comparison_result_o=0;
end
`ALU_SRA: begin
result_o=($signed(operand_a_i))>>>operand_b_i;
comparison_result_o=0;
end
`ALU_SRL: begin
result_o=operand_a_i>>operand_b_i;
comparison_result_o=0;
end
`ALU_SLL: begin
result_o=operand_a_i<<operand_b_i;
comparison_result_o=0;
end

`ALU_LTS: begin 
result_o=(operand_a_i<operand_b_i)?1:0;
comparison_result_o=result_o;
end

`ALU_LTU: begin
result_o=($signed(operand_a_i)<$signed(operand_b_i))?1:0;
comparison_result_o=result_o;
end

`ALU_GES: begin 
result_o=(operand_a_i>=operand_b_i)?1:0;
comparison_result_o=result_o;
end

`ALU_GEU: begin
result_o=($signed(operand_a_i)>=$signed(operand_b_i))?1:0;
comparison_result_o=result_o;
end

`ALU_EQ:  begin 
result_o=(operand_a_i==operand_b_i)?1:0;
comparison_result_o=result_o;
end

`ALU_LTS: begin
result_o=(operand_a_i!=operand_b_i)?1:0;
comparison_result_o=result_o;
end
endcase
end
endmodule
