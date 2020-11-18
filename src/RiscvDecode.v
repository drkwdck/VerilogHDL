module RiscvDecode ( input   [31 : 0]  fetched_instr_i,//Инструкция для декодирования, считанная из памяти инструкций 
output reg [1 : 0]    ex_op_a_sel_o,//Управляющий сигнал мультиплексора для выбора первого операнда АЛУ 
output reg  [2 : 0]   ex_op_b_sel_o,//Управляющий сигнал мультиплексора для выбора второго операнда АЛУ 
output reg  [`ALU_OP_WIDTH - 1 : 0]  alu_op_o,//Операция АЛУ  
output reg mem_req_o,//Запрос на доступ к памяти (часть интерфейса памяти) 
output  reg  mem_we_o,//Сигнал разрешения записи в память, «write enable» (при равенстве нулю происходит чтение) 
output reg  [2 : 0]   mem_size_o,//Управляющий сигнал для выбора размера слова при чтении-записи в память (часть интерфейса памяти) 
output  reg gpr_we_a_o,//Сигнал разрешения записи в регистровый файл 
output  reg wb_src_sel_o,//Управляющий сигнал мультиплексора для выбора данных, записываемых в регистровый файл 
output  reg illegal_instr_o,//Сигнал о некорректной инструкции (на схеме не отмечен) 
output reg branch_o,//Сигнал об инструкции условного перехода 
output reg  jal_o,//Сигнал об инструкции безусловного перехода jal 
output  reg jarl_o ); //Сигнал об инструкции безусловного перехода jarl 

always@(*)
begin
	case(fetched_instr_i[6 : 0])
	7'b0110011: // R-TYPE
	begin
		ex_op_a_sel_o = 2'b0;
		ex_op_b_sel_o = 3'b0;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b1;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		case(fetched_instr_i[14 : 12])		
		3'b000: 
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_ADD;//add
			else if(fetched_instr_i[31 : 25] == 7'b0100000)//hex 20
				alu_op_o = `ALU_SUB;//sub
			else 
				illegal_instr_o = 1'b1;
		3'b001:	
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_SLL; //shift left logical
			else
				illegal_instr_o = 1'b1;
		3'b010:
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_SLTS;  //a<b(LTS)
			else
				illegal_instr_o = 1'b1;
		3'b011:
		   if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_SLTU;//a<b(LTU)
			else
				illegal_instr_o = 1'b1;
		3'b100:
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_XOR;//xor
			else
				illegal_instr_o = 1'b1;
		3'b101:
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_SRL;//shift right logical
			else if (fetched_instr_i[31 : 25] == 7'b0100000)//hex 20
				alu_op_o = `ALU_SRA;//shift right arithmetic
			else
			illegal_instr_o = 1'b1;
		3'b110:
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_OR;//or
			else
				illegal_instr_o = 1'b1;
		3'b111:
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_AND;//and
			else
				illegal_instr_o = 1'b1;		
		default:	
			illegal_instr_o = 1'b1;		
		endcase		
	end
	
	7'b0010011:// I-TYPE
	begin
		ex_op_a_sel_o = 2'b00;
		ex_op_b_sel_o = 3'b001;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b1;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		case(fetched_instr_i[14 : 12])
		3'b000:
			alu_op_o = `ALU_ADD;//add		
		3'b001:	
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_SLL; //shift left logical
			else
				illegal_instr_o = 1'b1;
		3'b010:
			alu_op_o = `ALU_SLTS;//lts
		3'b011:
			alu_op_o = `ALU_SLTU;//ltu
		3'b100:
			alu_op_o = `ALU_XOR;//xor
		3'b101:
			if(fetched_instr_i[31 : 25] == 7'b0)
				alu_op_o = `ALU_SRL;//shift right logical
			else if (fetched_instr_i[31 : 25] == 7'b0000010)
				alu_op_o = `ALU_SRA;//shift right arithmetic
			else
				illegal_instr_o = 1'b1;
		3'b110:
			alu_op_o = `ALU_OR;//or
		3'b111:
			alu_op_o = `ALU_AND;//and
		default:
			illegal_instr_o = 1'b1;
		endcase	
	end
	
	7'b0110111://lui
	begin 
		ex_op_a_sel_o = 2'b10;
		ex_op_b_sel_o = 3'b010;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b1;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		alu_op_o = `ALU_ADD;
		
	end
	
	7'b0000011://load from memory
	begin
		ex_op_a_sel_o = 2'b00;
		ex_op_b_sel_o = 3'b001;				
		mem_req_o = 1'b1;
		mem_we_o = 1'b0;
		gpr_we_a_o = 1'b1;
		wb_src_sel_o = 1'b1;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		alu_op_o = `ALU_ADD;
		
		if(fetched_instr_i[14 : 12] < 3'b110 && fetched_instr_i[14 : 12] !=  3'b011)
			mem_size_o = fetched_instr_i[14:12];
		else
			illegal_instr_o = 1'b1;
			
	end
	
	7'b0100011:// store data
	begin
		ex_op_a_sel_o = 2'b00;
		ex_op_b_sel_o = 3'b011;				
		mem_req_o = 1'b1;
		mem_we_o = 1'b1;
		gpr_we_a_o = 1'b0;
		wb_src_sel_o = 1'b1;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		alu_op_o = `ALU_ADD;
		
		if(fetched_instr_i[14 : 12] < 3'b011)
			mem_size_o = fetched_instr_i[14 : 12];
		else
			illegal_instr_o = 1'b1;	
			
	end
	
	7'b1100011://brach(if)
	begin 
		ex_op_a_sel_o = 2'b00;
		ex_op_b_sel_o = 3'b000;	
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b0;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b1;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		case(fetched_instr_i[14 : 12])//func3
		3'b000:
			alu_op_o = `ALU_EQ;
		3'b001:
			alu_op_o = `ALU_NE;
		3'b100:
			alu_op_o = `ALU_LTS;
		3'b101:
			alu_op_o = `ALU_GES;
		3'b110:
			alu_op_o = `ALU_LTU;
		3'b111:
			alu_op_o = `ALU_GEU;
		default:
			illegal_instr_o = 1'b1;
		endcase
	end

	7'b1101111://jal(rd=pc+4;pc+=imm)
	begin
		ex_op_a_sel_o = 2'b01;
		ex_op_b_sel_o = 3'b100;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b1;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b1;
		jarl_o = 1'b0;
		alu_op_o = `ALU_ADD;
	end

	7'b1100111://jalr(rd=pc+4;pc=rs1+imm)
	begin
		ex_op_a_sel_o = 2'b01;
		ex_op_b_sel_o = 3'b100;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b1;
		wb_src_sel_o = 1'b0;		
		branch_o = 1'b0;
		jal_o = 1'b0;		
		jarl_o = 1'b1;
		alu_op_o = `ALU_ADD;
		if(fetched_instr_i[14 : 12]==3'b0)
			illegal_instr_o = 1'b0;
		else
			illegal_instr_o = 1'b1;
		
	end
	
	7'b0001111:
	begin
		ex_op_a_sel_o = 2'b00;
		ex_op_b_sel_o = 3'b000;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b0;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		alu_op_o = `ALU_ADD;
	end
	
	7'b1110011:
	begin
		ex_op_a_sel_o = 2'b00;
		ex_op_b_sel_o = 3'b000;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b0;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
	end			
	
	7'b0100011:
	begin
		ex_op_a_sel_o = 2'b00;
		ex_op_b_sel_o = 3'b000;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b0;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
	end
	
	7'b0010111:
	begin
		ex_op_a_sel_o = 2'b01;
		ex_op_b_sel_o = 3'b010;				
		mem_req_o = 1'b0;
		mem_we_o = 1'b0;
		mem_size_o = 1'b0;//idk TODO
		gpr_we_a_o = 1'b1;
		wb_src_sel_o = 1'b0;
		illegal_instr_o = 1'b0;
		branch_o = 1'b0;
		jal_o = 1'b0;
		jarl_o = 1'b0;
		alu_op_o = `ALU_ADD;
	end
	
	default:
	begin
		illegal_instr_o = 1'b1;
		mem_we_o = 1'b0;
		gpr_we_a_o = 1'b0;
	end
	
	endcase
end

endmodule