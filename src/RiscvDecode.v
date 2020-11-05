module RiscvDecode
(
  input   [31:0]               fetched_instr_i,
  output  reg [1:0]                ex_op_a_sel_o,
  output  [2:0]                ex_op_b_sel_o,
  output  [`ALU_OP_WIDTH-1:0]  alu_op_o,
  output                       mem_req_o,
  output                       mem_we_o,
  output  [2:0]                mem_size_o,
  output                       gpr_we_a_o,
  output                       wb_src_sel_o,
  output                       illegal_instr_o,
  output                       branch_o,
  output                       jal_o,
  output                       jarl_o
);

reg ex_op_a_sel[1:0], ex_op_b_sel[2:0], alu_op[`ALU_OP_WIDTH-1:0], 
write_enable, mem_request, mem_size[2:0], illegal_instr, jal, jarl,
gpr_we_a, wb_src_sel, branch;


assign ex_op_b_sel_o[0] = ex_op_b_sel[0];
assign ex_op_b_sel_o[1] = ex_op_b_sel[1];

assign mem_size_o[0] = mem_size[0];
assign mem_size_o[1] = mem_size[1];
assign mem_size_o[2] = mem_size[2];

assign alu_op_o = {alu_op[0], alu_op[1], alu_op[2], alu_op[3], alu_op[4], alu_op[5]};
assign mem_size_o = {mem_size[0], mem_size[1], mem_size[2]};
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

  ex_op_a_sel[0] <= 1'b0;
  ex_op_a_sel[1] <= 1'b0;
  ex_op_b_sel[0] <= 1'b0;
  ex_op_b_sel[0] <= 1'b0;

  mem_size[0] <= 1'b0;
  mem_size[1] <= 1'b0;
  mem_size[2] <= 1'b0;


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
          end

          `STORE_OPCODE: begin
            write_enable <= 1'b1;
            mem_request <= 1'b1;
          end

          `OP_IMM_OPCODE: begin
            gpr_we_a <= 1'b1;
          end

          `AUIPC_OPCODE: begin
            gpr_we_a <= 1'b1;
            ex_op_a_sel[0] <= 1'b1;
            ex_op_a_sel[1] <= 1'b0;
            ex_op_b_sel[0] <= 1'b0;
            ex_op_b_sel[1] <= 1'b1;
          end

          `OP_OPCODE: begin
            gpr_we_a <= 1'b1;
            ex_op_b_sel[1] <= 1'b1;
          end

          `LUI_OPCODE: begin
            gpr_we_a <= 1'b1;
            ex_op_b_sel[1] <= 1'b1;
          end

          `BRANCH_OPCODE: begin
            ex_op_b_sel[1] <= 1'b1;
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
