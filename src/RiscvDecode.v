module RiscvDecode(
input 	  [31:0] fetched_instr_i, 
output reg [1:0] ex_op_a_sel_o, 
output reg [2:0] ex_op_b_sel_o, 
output reg [5:0] alu_op_o, 
output reg 			 mem_req_o,
output reg 			 mem_we_o, 
output reg [2:0] mem_size_o,
output reg 			 gpr_we_a_o, 
output reg 			 wb_src_sel_o,
output reg 			 illegal_instr_o, 
output reg 			 branch_o, 
output reg 			 jal_o,  
output reg 			 jarl_o 
);

wire [4:0]  opcode;
wire [6:0]  funct7;
wire [2:0]  funct3;
reg [4:0]  rs1;
reg [4:0]  rs2;
reg [4:0]  rd;

assign opcode = fetched_instr_i[6:2];
assign funct7 = fetched_instr_i[31:25];
assign funct3 = fetched_instr_i[14:12];

always @ ( * ) begin
    illegal_instr_o = ~&fetched_instr_i[1:0];
    wb_src_sel_o = (opcode ==`LOAD_OPCODE);
    mem_req_o = (opcode == `LOAD_OPCODE || opcode == `STORE_OPCODE);     
    mem_we_o = (opcode == `STORE_OPCODE); 
    gpr_we_a_o = (opcode == `AUIPC_OPCODE || opcode == `OP_IMM_OPCODE || opcode == `LUI_OPCODE || opcode == `OP_OPCODE 
                    || opcode == `JAL_OPCODE || opcode == `JALR_OPCODE || opcode == `LOAD_OPCODE); 
    branch_o = (opcode == `BRANCH_OPCODE);
    jal_o = (opcode == `JAL_OPCODE);
	  jarl_o = (opcode == `JALR_OPCODE);
	 
    case (opcode)
        `OP_OPCODE: begin
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_RS2;

            case ({funct7, funct3})
                10'b0000000_000:
                  alu_op_o = `ALU_ADD;
                10'b0100000_000 : 
                  alu_op_o = `ALU_SUB;
                10'b0000000_001 : 
                  alu_op_o = `ALU_SLL;
                10'b0000000_010 : 
                  alu_op_o = `ALU_SLTS;
                10'b0000000_011 : 
                  alu_op_o = `ALU_SLTU;
                10'b0000000_100 : 
                  alu_op_o = `ALU_XOR;
                10'b0000000_101 : 
                  alu_op_o = `ALU_SRL;
                10'b0100000_101 : 
                  alu_op_o = `ALU_SRA;
                10'b0000000_110 : 
                  alu_op_o = `ALU_OR;
                10'b0000000_111 : 
                  alu_op_o = `ALU_AND;
                default: illegal_instr_o = 1'b1;
            endcase
        end

        `OP_IMM_OPCODE: begin
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_IMM_I;
            case (funct3)
                3'b000:
                  alu_op_o = `ALU_ADD;
                3'b011:
                  alu_op_o = `ALU_SLTU;
                3'b100:
                  alu_op_o = `ALU_XOR;
                3'b110:
                  alu_op_o = `ALU_OR;
                3'b111:
                  alu_op_o = `ALU_AND;
                3'b001: begin
                    if (funct7 == 7'b0000000)
                        alu_op_o = `ALU_SLL;
                    else
                        illegal_instr_o = 1'b1;
                end
                3'b010 : alu_op_o = `ALU_SLTS;
                3'b101 : 
                  case (funct7)
                      7'b0000000 : alu_op_o = `ALU_SRL; 
                      7'b0100000 : alu_op_o = `ALU_SRA;
                      default: illegal_instr_o = 1'b1;
                  endcase 
                default: illegal_instr_o = 1'b1;
            endcase
        end

        `LOAD_OPCODE: begin
            alu_op_o = `ALU_ADD;
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_IMM_I;
            case (funct3)
                3'b000: 
                  mem_size_o = `LDST_B;
                3'b001: 
                  mem_size_o = `LDST_H;
                3'b010: 
                  mem_size_o = `LDST_W;
                3'b100: 
                  mem_size_o = `LDST_BU;
                3'b101: 
                  mem_size_o = `LDST_HU;
                default:
                  illegal_instr_o = 1'b1;
            endcase
        end

        `STORE_OPCODE: begin
            alu_op_o = `ALU_ADD;
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_IMM_S;
            case (funct3)
                3'b000:
                  mem_size_o  = `LDST_B;
                3'b001:
                  mem_size_o  = `LDST_H;
                3'b010:
                  mem_size_o  = `LDST_W;
                default: 
                  illegal_instr_o = 1'b1;
            endcase
        end

        `BRANCH_OPCODE: begin
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_RS2;
            case (funct3)
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

        `JAL_OPCODE: begin
            ex_op_a_sel_o = `OP_A_CURR_PC;
            ex_op_b_sel_o = `OP_B_INCR;
            alu_op_o = `ALU_ADD;
        end

        `JALR_OPCODE: begin
            ex_op_a_sel_o = `OP_A_CURR_PC;
            ex_op_b_sel_o = `OP_B_INCR;
            alu_op_o = `ALU_ADD;
		  end

        `LUI_OPCODE: begin
            ex_op_a_sel_o = `OP_A_ZERO;
            ex_op_b_sel_o = `OP_B_IMM_U;
            alu_op_o = `ALU_ADD;
        end

        `AUIPC_OPCODE: begin
            ex_op_a_sel_o = `OP_A_CURR_PC;
            ex_op_b_sel_o = `OP_B_IMM_U;
            alu_op_o = `ALU_ADD;
        end

        `MISC_MEM_OPCODE:;
        `SYSTEM_OPCODE:;

        default: illegal_instr_o = 1'b1;
    endcase
end
endmodule