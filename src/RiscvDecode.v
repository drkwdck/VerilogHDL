module riscv_decode(
input [31:0] fetched_instr_i, //Instruction
output reg [1:0] ex_op_a_sel_o, // Alu operand a
output reg [2:0] ex_op_b_sel_o, //Alu operand b
output reg [5:0] alu_op_o, //Alu operation
output reg mem_req_o, //I don't give a fuck what is it
output reg mem_we_o, //Data memory WE
output reg [2:0] mem_size_o, //Data memory size selector
output reg gpr_we_a_o, //Register file WE
output reg wb_src_sel_o, //Register file WS
output reg illegal_instr_o, //Error
output reg branch_o, //Branch if condition
output reg jal_o, //Jump and link with immediate
output reg jarl_o //Jump and link with register data
);

wire [6:0] opcode = fetched_instr_i[6:0];
wire [2:0] funct3 = fetched_instr_i[14:12];
wire [6:0] funct7 = fetched_instr_i[31:25];

assign ImmJ = { {11{fetched_instr_i[31]}} , fetched_instr_i[31], fetched_instr_i[19:12],
 fetched_instr_i[20], fetched_instr_i[30:21], 1'b0};
 
assign ImmI = { {20{fetched_instr_i[31]}} , {fetched_instr_i[31:20]}};

//=======opcodes
localparam RegReg = 7'b0110011;
localparam RegImm = 7'b0010011;
localparam Load = 7'b0000011;
localparam Store = 7'b0100011;
localparam Jal = 7'b1101111;
localparam Jalr = 7'b1100111;
localparam Branch = 7'b1100011;
localparam Lui = 7'b0110111;
localparam Auipc = 7'b0010111;
localparam MiscMem = 7'b0001111; 
localparam System = 7'b1110011;
//========logic
always @(*)
begin

case(opcode)
	RegReg: begin
				ex_op_a_sel_o <= 2'b00;
				ex_op_b_sel_o <= 3'b000;
				gpr_we_a_o <= 1;
				wb_src_sel_o <= 0;
				mem_we_o <= 0;
				jal_o <= 0;
				jarl_o <= 0;
				branch_o <= 0;

				case(funct3) // Selection of operation
					3'h0: begin 
							if(funct7 == 7'h00) begin
									alu_op_o <= 6'b011000;
									illegal_instr_o <= 0;
							end
							else if(funct7 == 7'h20) begin
									alu_op_o <= 6'b011001;
									illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h1: begin
							if(funct7 == 7'h00) begin
								alu_op_o <= 6'b100111;
								illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h2: begin
							if(funct7 == 7'h00) begin
								alu_op_o <= 6'b000010;
								illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h3: begin
							if(funct7 == 7'h00) begin
								alu_op_o <= 6'b000001;
								illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h4: begin
							if(funct7 == 7'h00) begin
								alu_op_o <= 6'b101111;
								illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h5: begin 
							if(funct7 == 7'h00) begin
									alu_op_o <= 6'b100101;
									illegal_instr_o <= 0;
							end
							else if(funct7 == 7'h20) begin
									alu_op_o <= 6'b100100;
									illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h6: begin
							if(funct7 == 7'h00) begin
								alu_op_o = 6'b101110;
								illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h7: begin
							if(funct7 == 7'h00) begin
								alu_op_o <= 6'b010101;
								illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					default: begin 
								illegal_instr_o <= 1;
								end
				endcase
				end
	RegImm: begin
				ex_op_a_sel_o <= 2'b00;
				ex_op_b_sel_o <= 3'b01;
				gpr_we_a_o <= 1;
				wb_src_sel_o <= 0;
				mem_we_o <= 0;
				jal_o <= 0;
				jarl_o <= 0;
				branch_o <= 0;
				
				case(funct3) 
					3'h0: begin 
									alu_op_o <= 6'b011000;
									illegal_instr_o <= 0;
							end
					3'h1: begin
							if(funct7 == 7'h00) begin
								alu_op_o <= 6'b100111;
								illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h2: begin
								alu_op_o <= 6'b000010;
								illegal_instr_o <= 0;
							end
					3'h3: begin
								alu_op_o <= 6'b000011;
								illegal_instr_o <= 0;
							end
					3'h4: begin
								alu_op_o <= 6'b101111;
								illegal_instr_o <= 0;
							end
					3'h5: begin 
							if(funct7 == 7'h00) begin
									alu_op_o <= 6'b100101;
									illegal_instr_o <= 0;
							end
							else if(funct7 == 7'h20) begin
									alu_op_o <= 6'b100100;
									illegal_instr_o <= 0;
							end
							else begin
								illegal_instr_o <= 1;
							end
							end
					3'h6: begin
								alu_op_o <= 6'b101110;
								illegal_instr_o <= 0;
							end
					3'h7: begin
								alu_op_o <= 6'b010101;
								illegal_instr_o <= 0;
							end
					default: begin 
								illegal_instr_o <= 1;
								end
				endcase
				end
	Load: begin
			mem_req_o <= 1;
			ex_op_a_sel_o <= 2'b00;
			ex_op_b_sel_o <= 3'b001;
			alu_op_o <= 6'b011000;
			gpr_we_a_o <= 1;
			wb_src_sel_o <= 1;
			mem_we_o <= 0;
			jal_o <= 0;
			jarl_o <= 0;
			branch_o <= 0;
			
			if((funct3 >= 3'h0 & funct3 <= 3'h2) || funct3 == 3'h4 || funct3 == 3'h5) begin
				mem_size_o <= funct3;
				illegal_instr_o <= 0;
			end
			else begin
				illegal_instr_o <= 1;
			end
			end
	Store: begin
			mem_req_o <= 1;
			ex_op_a_sel_o <= 2'b00;
			ex_op_b_sel_o <= 3'b011;
			alu_op_o <= 6'b011000;
			gpr_we_a_o <= 0;
			mem_we_o <= 1;
			jal_o <= 0;
			jarl_o <= 0;
			branch_o <= 0;
			
			if(funct3 >= 3'h0 & funct3 <= 3'h2) begin
				mem_size_o <= funct3;
				illegal_instr_o <= 0;
			end
			else begin
				illegal_instr_o <= 1;
			end
			end
	Jal: begin
				if(ImmJ < 64 || ImmJ > -64) begin
				ex_op_a_sel_o <= 2'b01;
				ex_op_b_sel_o <= 3'b100;
				alu_op_o <= 6'b011000;
				wb_src_sel_o <= 0;
				gpr_we_a_o <= 1;
				mem_we_o <= 0;
				jal_o <= 1;
				jarl_o <= 0;
				illegal_instr_o <= 0;
			end
			else begin
				illegal_instr_o <= 1;
			end
			end
	Jalr: begin
			if(funct3 == 3'h0) begin
				ex_op_a_sel_o <= 2'b01;
				ex_op_b_sel_o <= 3'b100;
				alu_op_o <= 6'b011000;
				wb_src_sel_o <= 0;
				gpr_we_a_o <= 1;
				mem_we_o <= 0;
				branch_o <= 0;
				jal_o <= 0;
				jarl_o <= 1;
				illegal_instr_o <= 0;
			end
			else begin
				illegal_instr_o <= 1;
			end
			end
	Branch: begin
			ex_op_a_sel_o <= 2'b00;
			ex_op_b_sel_o <= 3'b000;
			gpr_we_a_o <= 0;
			mem_we_o <= 0;
			branch_o <= 1;
			jal_o <= 0;
			jarl_o <= 0;
			case(funct3)
				3'h0: begin alu_op_o <= 6'b001100; illegal_instr_o <= 0; end
				3'h1: begin alu_op_o <= 6'b001101; illegal_instr_o <= 0; end
				3'h4: begin alu_op_o <= 6'b000000; illegal_instr_o <= 0; end
				3'h5: begin alu_op_o <= 6'b001010; illegal_instr_o <= 0; end
				3'h6: begin alu_op_o <= 6'b000001; illegal_instr_o <= 0; end
				3'h7: begin alu_op_o <= 6'b001011; illegal_instr_o <= 0; end
				default: begin 
							illegal_instr_o <= 1;
							end
			endcase
			end
	Lui: begin
			ex_op_a_sel_o <= 2'b10;
			ex_op_b_sel_o <= 3'b010;
			gpr_we_a_o <= 1;
			wb_src_sel_o <= 0;
			alu_op_o <= 6'b011000;
			mem_we_o <= 0;
			jal_o <= 0;
			jarl_o <= 0;
			branch_o <= 0;
			illegal_instr_o <= 0;
			end
	Auipc: begin
			ex_op_a_sel_o <= 2'b01;
			ex_op_b_sel_o <= 3'b010;
			alu_op_o <= 6'b011000;
			wb_src_sel_o <= 0;
			gpr_we_a_o <= 1;
			mem_we_o <= 0;
			jal_o <= 0;
			jarl_o <= 0;
			branch_o <= 0;
			illegal_instr_o <= 0;
			end
	MiscMem: begin
				mem_req_o <= 0;
				mem_we_o <= 0;
				gpr_we_a_o <= 0;
				branch_o <= 0;
				jal_o <= 0;
				jarl_o <= 0;
				illegal_instr_o <= 0;
				end
	System: begin
				mem_req_o <= 0;
				mem_we_o <= 0;
				gpr_we_a_o <= 0;
				branch_o <= 0;
				jal_o <= 0;
				jarl_o <= 0;
				illegal_instr_o <= 0;
				end
	default: begin 
			illegal_instr_o <= 1;
			end	
endcase

if(illegal_instr_o) begin
	mem_req_o <= 0;
	mem_we_o <= 0;
	gpr_we_a_o <= 0;
	branch_o <= 0;
	jal_o <= 0;
	jarl_o <= 0;
end


end

endmodule