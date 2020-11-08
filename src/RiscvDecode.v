module RiscvDecode
(
  input   [31:0]               fetched_instr_i,
  output  reg [1:0]             ex_op_a_sel_o,
  output  reg [2:0]                ex_op_b_sel_o,
  output  reg [`ALU_OP_WIDTH-1:0]  alu_op_o,
  output  reg                  mem_req_o,
  output  reg                  mem_we_o,
  output  reg [2:0]            mem_size_o,
  output  reg                  gpr_we_a_o,
  output  reg                  wb_src_sel_o,
  output  reg                  illegal_instr_o,
  output  reg                  branch_o,
  output  reg                  jal_o,
  output  reg                  jarl_o
);


wire[2:0] funct3 = fetched_instr_i[14:12];
wire[6:0] funct7 = fetched_instr_i[31:25];

always @(*) begin
  mem_we_o <= 1'b0;
  mem_req_o <= 1'b0;
  illegal_instr_o <= 1'b1;
  jal_o <= 1'b0;
  jarl_o <= 1'b0;
  gpr_we_a_o <= 1'b0;
  wb_src_sel_o <= 1'b0;
  branch_o <= 1'b0;

  case(fetched_instr_i[1:0])
      2'b11: begin
        if (fetched_instr_i[6:2] != 5'b11100 && fetched_instr_i[6:2] != 5'b00011) begin
          illegal_instr_o <= 1'b0;          
        end

       case (fetched_instr_i[6:1])
          `OP_OPCODE: begin 
            ex_op_a_sel_o <= `OP_A_RS1;
            ex_op_b_sel_o <= `OP_B_RS2;
            gpr_we_a_o <= 1'b1;
            
            case (funct3)
              3'h0: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_ADD;
                    illegal_instr_o <= 0;
                  end

                  7'h20: begin
                    alu_op_o <= `ALU_SUB;
                    illegal_instr_o <= 0;
                  end

                  default:
                    illegal_instr_o <= 1;
                endcase
              end

              3'h4: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_XOR;
                    illegal_instr_o <= 0;
                  end

                  default:
                    illegal_instr_o <= 1;
                endcase
              end

              3'h6: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_OR;
                    illegal_instr_o <= 0;
                    gpr_we_a_o <= 1;
                  end
                  default:
                    illegal_instr_o <= 1;
                endcase
              end

              3'h7: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_AND;
                    illegal_instr_o <= 0;
                    gpr_we_a_o <= 1;
                  end
                  default:
                    illegal_instr_o <= 1;
                endcase
              end

              3'h1: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_SRA;
                    illegal_instr_o <= 0;
                    gpr_we_a_o <= 1;
                  end
                  default:
                    illegal_instr_o <= 0;
                endcase
              end

              3'h5: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_SRL;
                    illegal_instr_o <= 0;
                    gpr_we_a_o <= 1;
                  end

                  7'h20: begin
                    alu_op_o <= `ALU_SRA;
                    illegal_instr_o <= 0;
                    gpr_we_a_o <= 1;
                  end

                  default:
                    illegal_instr_o <= 1;
                endcase
              end

              3'h2: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_LTS;
                    illegal_instr_o <= 0;
                    gpr_we_a_o <= 1;
                  end
                  default:
                    illegal_instr_o <= 1;
                endcase
              end

              3'h3: begin
                case(funct7)
                  7'h0: begin
                    alu_op_o <= `ALU_LTU;
                    illegal_instr_o <= 0;
                    gpr_we_a_o <= 1;
                  end

                  default:
                    illegal_instr_o <= 1;
                endcase
              end

              default:
                illegal_instr_o <= 1;
            endcase
          end

          default:
            illegal_instr_o <= 1'b1;
        
        `OP_IMM_OPCODE: begin
            ex_op_a_sel_o = `OP_A_RS1;
            ex_op_b_sel_o = `OP_B_IMM_I;
            case (funct3)
                3'h0:
                    alu_op_o <= `ALU_ADD;
                3'h3:
                    alu_op_o <= `ALU_SLTU;
                3'h4:
                    alu_op_o <= `ALU_XOR;
                3'h6:
                    alu_op_o <= `ALU_OR;
                3'h7:
                    alu_op_o <= `ALU_AND;
                3'h1: begin
                    case(funct7)
                        7'h0:
                            alu_op_o <= `ALU_SLL;
                        default:
                            illegal_instr_o <= 1;
                    endcase
                end
                3'h2:
                    alu_op_o <= `ALU_SLTS;
                3'h3: begin
                    case(funct7)
                        7'h0:
                            alu_op_o <= `ALU_SRL;
                        7'h20:
                            alu_op_o <= `ALU_SRA;
                        default:
                            illegal_instr_o <= 1;
                    endcase
                    end
                default:
                    illegal_instr_o <= 1;
            endcase
        end

        `LOAD_OPCODE: begin
            alu_op_o <= `ALU_ADD;
            ex_op_a_sel_o <= `OP_A_RS1;
            ex_op_b_sel_o <= `OP_B_IMM_I;
            case(funct3)
                3'h0:
                    mem_size_o <= `LDST_B;
                3'h1:
                    mem_size_o <= `LDST_H;
                3'h2:
                    mem_size_o <= `LDST_W;
                3'h4:
                    mem_size_o <= `LDST_BU;
                3'h5:
                    mem_size_o <= `LDST_HU;
                default:
                    illegal_instr_o <= 1;
            endcase
        end

        `STORE_OPCODE: begin
            alu_op_o <= `ALU_ADD;
            ex_op_a_sel_o <= `OP_A_RS1;
            ex_op_b_sel_o <= `OP_B_IMM_S;
            case(funct3)
                3'h0:
                    mem_size_o <= `LDST_B;
                3'h1:
                    mem_size_o <= `LDST_H;
                3'h2:
                    mem_size_o <= `LDST_W;
                default:
                    illegal_instr_o <= 1;
            endcase
        end

        `BRANCH_OPCODE: begin
            ex_op_a_sel_o <= `OP_A_RS1;
            ex_op_b_sel_o <= `OP_B_RS2;
            
        end
       endcase
      end
      
      default:
        illegal_instr_o <= 1'b1;

  endcase
end
endmodule
