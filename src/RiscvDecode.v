module RiscvDecode
(
  input   [31:0]               fetched_instr_i,
  output  reg [1:0]             ex_op_a_sel_o,
  output  reg [2:0]                ex_op_b_sel_o,
  output  reg [`ALU_OP_WIDTH-1:0]  alu_op_o,
  output                       mem_req_o,
  output                       mem_we_o,
  output  reg [2:0]            mem_size_o,
  output                       gpr_we_a_o,
  output                       wb_src_sel_o,
  output                       illegal_instr_o,
  output                       branch_o,
  output                       jal_o,
  output                       jarl_o
);

reg  write_enable, mem_request, illegal_instr, jal, jarl, gpr_we_a, wb_src_sel, branch;


assign mem_we_o = write_enable;
assign mem_req_o = mem_request;
assign illegal_instr_o = illegal_instr;
assign gpr_we_a_o = gpr_we_a;
assign wb_src_sel_o = wb_src_sel;
assign jal_o = jal;
assign jarl_o = jarl;
assign branch_o = branch;

always @(*) begin
  illegal_instr <= 1'b1;
  write_enable <= 1'b0;
  mem_request <= 1'b0;
  illegal_instr <= 1'b0;
  jal <= 1'b0;
  jarl <= 1'b0;
  gpr_we_a <= 1'b0;
  wb_src_sel <= 1'b0;
  branch <= 1'b0;

  case(fetched_instr_i[1:0])
      2'b11: begin
        if (fetched_instr_i[6:2] != 5'b11100 && fetched_instr_i[6:2] != 5'b00011) begin
          illegal_instr <= 1'b0;          
        end

       case (fetched_instr_i[6:2])
          `LOAD_OPCODE: begin
            mem_request <= 1'b1;
            gpr_we_a <= 1'b1;
            wb_src_sel <= 1'b1;
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_IMM_I;
            mem_size_o =  `LDST_B;
            alu_op_o = `ALU_ADD;
          end

          `OP_IMM_OPCODE: begin
            gpr_we_a <= 1'b1;
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_IMM_U;
          end

          `AUIPC_OPCODE: begin
            gpr_we_a <= 1'b1;
            ex_op_b_sel_o = `OP_B_IMM_U << 12;
            alu_op_o = `ALU_ADD;
            ex_op_a_sel_o = `OP_A_CURR_PC;
          end

          // ?
          `STORE_OPCODE: begin
            write_enable <= 1'b1;
            mem_request <= 1'b1;
            alu_op_o = `ALU_ADD;
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_IMM_I;
          end

          `OP_OPCODE: begin
            gpr_we_a <= 1'b1;
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_RS2;
            // alu_op_o = fetched_instr_i[31:25];
          end

          `LUI_OPCODE: begin
            gpr_we_a <= 1'b1;
            ex_op_b_sel_o = `OP_B_IMM_U;
            ex_op_a_sel_o = `OP_A_ZERO;
            alu_op_o = `ALU_ADD;
          end

          `BRANCH_OPCODE: begin
            branch <= 1'b1;
          end

          `JALR_OPCODE: begin
            gpr_we_a <= 1'b1;
            jarl <= 1'b1;
          end

          `JAL_OPCODE: begin
            gpr_we_a <= 1'b1;
            jal <= 1'b1;
          end

          `SYSTEM_OPCODE: begin
            // нужен пустой
          end

          default:
            illegal_instr <= 1'b1;
       endcase
      end
      
      default:
        illegal_instr <= 1'b1;
  endcase
end
endmodule
