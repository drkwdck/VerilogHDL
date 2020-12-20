`timescale 1ns/1ps

module ALU_32bits_tb();
	reg  [5:0]  operator_i_in;
	reg  [31:0] operand_a_i_in;
	reg  [31:0] operand_b_i_in;
	wire [31:0] result_o_out;
	wire        comparison_result_o_out;
	ALU_32bits ALU_32bits_dut(operator_i_in, operand_a_i_in, operand_b_i_in, result_o_out, comparison_result_o_out);

	task ALU_task;
	
		input integer a_tb;
		input integer b_tb;
		input reg  [5:0]  oper_tb;
		begin
			operand_a_i_in = a_tb;
			operand_b_i_in = b_tb;
			operator_i_in = oper_tb;
			#10;
			case(operator_i_in)
				6'b011000: $display("%d + %d = %d\n", $signed(operand_a_i_in), $signed(operand_b_i_in), $signed(result_o_out));
							 
				6'b011001: $display("%d - %d = %d\n", $signed(operand_a_i_in), $signed(operand_b_i_in), $signed(result_o_out));
				
				6'b101111: $display("\n %b\n ^\n %b\n =\n %b\n", operand_a_i_in, operand_b_i_in, result_o_out);
							 
				6'b101110: $display("\n %b\n |\n %b\n =\n %b\n", operand_a_i_in, operand_b_i_in, result_o_out);
							 
				6'b010101: $display("\n %b\n &\n %b\n =\n %b\n", operand_a_i_in, operand_b_i_in, result_o_out);
							 
				6'b100100: $display("\n %b\n >>>\n %b\n =\n %b\n", operand_a_i_in, operand_b_i_in, result_o_out);
							 
				6'b100101: $display("\n %b\n >>\n %b\n =\n %b\n", operand_a_i_in, operand_b_i_in, result_o_out);
							 
				6'b100111: $display("\n %b\n <<\n %b\n =\n %b\n", operand_a_i_in, operand_b_i_in, result_o_out);
							 
				6'b000000: $display("%h < %h ? %b\n", operand_a_i_in, operand_b_i_in, comparison_result_o_out);
							 
				6'b000001: $display("%h < %h ? %b\n", operand_a_i_in, operand_b_i_in, comparison_result_o_out);
							 
				6'b001010: $display("%h >= %h ? %b\n", operand_a_i_in, operand_b_i_in, comparison_result_o_out);
							 
				6'b001011: $display("%h >= %h ? %b\n", operand_a_i_in, operand_b_i_in, comparison_result_o_out);
							 
				6'b001100:  $display("%d == %d ? %b\n", operand_a_i_in, operand_b_i_in, comparison_result_o_out);
							 
				6'b001101:  $display("%d != %d ? %b\n", operand_a_i_in, operand_b_i_in, comparison_result_o_out);
			endcase
		end
	endtask

	initial begin
		$display("\nADD___________________\n");
		ALU_task(32'd348, 32'd1098, 6'b011000);
		#15;
		ALU_task(32'd12, -32'd2289, 6'b011000);
		#15;
		ALU_task(-32'd3444, 32'd986, 6'b011000);
		#15;
		ALU_task(32'h7fffffff, 32'h7fffffff, 6'b011000);
		#15;
		
		$display("\nSUB____________________\n");
		ALU_task(32'd987, 32'd98, 6'b011001);
		#15;
		ALU_task(32'd212, -32'd289, 6'b011001);
		#15;
		ALU_task(-32'd443, 32'd6897, 6'b011001);
		#15;
		ALU_task(-32'd1,32'h80000000, 6'b011001);
		#15;
		
		$display("\nXOR____________________\n");
		ALU_task(32'd944387, 32'd45398, 6'b101111);
		#15;
		ALU_task(32'd209012, -32'd255489, 6'b101111);
		#15;
		ALU_task(-32'd43433, 32'd6897, 6'b101111);
		#15;
		ALU_task(-32'd342471,-32'd0882323, 6'b101111);
		#15;
		
		$display("\nOR_____________________\n");
		ALU_task(32'd343534, 32'd2343, 6'b101110);
		#15;
		ALU_task(32'd232412, -32'd342489, 6'b101110);
		#15;
		ALU_task(-32'd4356, 32'd6767923, 6'b101110);
		#15;
		ALU_task(-32'd234341,-32'd76421, 6'b101110);
		#15;
		
		$display("\nAND____________________\n");
		ALU_task(32'd546856, 32'd456543, 6'b010101);
		#15;
		ALU_task(32'd932049, -32'd9675, 6'b010101);
		#15;
		ALU_task(-32'd342987, 32'd86435456, 6'b010101);
		#15;
		ALU_task(-32'd568561,-32'd2354534, 6'b010101);
		#15;
		
		$display("\nSRA____________________\n");
		ALU_task(32'd546856, 32'd4, 6'b100100);
		#15;
		ALU_task(-32'd932049, 32'd2, 6'b100100);
		#15;
		ALU_task(32'd342987, -32'd8, 6'b100100);
		#15;
		ALU_task(-32'd568561,32'd2354534, 6'b100100);
		#15;
		
		$display("\nSRL____________________\n");
		ALU_task(32'd546856, 32'd4, 6'b100101);
		#15;
		ALU_task(-32'd932049, 32'd2, 6'b100101);
		#15;
		ALU_task(32'd342987, -32'd8, 6'b100101);
		#15;
		ALU_task(-32'd568561,32'd2354534, 6'b100101);
		#15;
		
		$display("\nSLL____________________\n");
		ALU_task(32'd546856, 32'd4, 6'b100111);
		#15;
		ALU_task(-32'd932049, 32'd2, 6'b100111);
		#15;
		ALU_task(32'd342987, -32'd8, 6'b100111);
		#15;
		ALU_task(-32'd568561,32'd2354534, 6'b100111);
		#15;
		
		$display("\nLTS____________________\n");
		ALU_task(32'd546856, 32'd64, 6'b000000);
		#15;
		ALU_task(-32'd932049, 32'd4566, 6'b000000);
		#15;
		ALU_task(32'd342987, -32'd983022, 6'b000000);
		#15;
		ALU_task(-32'd568561,-32'd235534, 6'b000000);
		
		$display("\nLTU____________________\n");
		ALU_task(32'd546856, 32'd64, 6'b000001);
		#15;
		ALU_task(-32'd932049, 32'd4566, 6'b000001);
		#15;
		ALU_task(32'd342987, -32'd983022, 6'b000001);
		#15;
		ALU_task(-32'd568561,-32'd2354534, 6'b000001);
		
		$display("\nGES____________________\n");
		ALU_task(32'd5456, 32'd64, 6'b001010);
		#15;
		ALU_task(-32'd932, 32'd466, 6'b001010);
		#15;
		ALU_task(32'd3487, -32'd983022, 6'b001010);
		#15;
		ALU_task(-32'd56851,-32'd23554, 6'b001010);
		
		$display("\nGEU____________________\n");
		ALU_task(32'd5456, 32'd64, 6'b001011);
		#15;
		ALU_task(-32'd932, 32'd466, 6'b001011);
		#15;
		ALU_task(32'd3487, -32'd983022, 6'b001011);
		#15;
		ALU_task(-32'd568851,-32'd23554, 6'b001011);
		
		$display("\nEQ_____________________\n");
		ALU_task(32'd10, 32'd10, 6'b001100);
		#15;
		ALU_task(-32'd9, 32'd9, 6'b001100);
		#15;
		ALU_task(-32'd235, -32'd123, 6'b001100);
		#15;
		ALU_task(32'h80000000,32'h7fffffff + 1, 6'b001100);
		
		$display("\nNE_____________________\n");
		ALU_task(32'd10, 32'd10, 6'b001101);
		#15;
		ALU_task(-32'd9, 32'd9, 6'b001101);
		#15;
		ALU_task(-32'd235, -32'd123, 6'b001101);
		#15;
		ALU_task(32'h80000000,32'h7fffffff + 1, 6'b001101);
	end	
endmodule