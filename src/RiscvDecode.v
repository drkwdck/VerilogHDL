module RiscvDecode
(
  input   [31:0]               fetched_instr_i,
  output  [1:0]                ex_op_a_sel_o,
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
endmodule
