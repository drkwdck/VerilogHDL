module riscv_cpu(
    input clk_i,
    input arstn_i,

    input [31:0] instr_rdata_i,
    output [31:0] instr_addr_o,

    input data_gnt_i,
    input data_rvalid_i,
    input [31:0] data_rdata_i,
    output data_req_o,
    output data_we_o,
    output [3:0] data_be_o,
    output [31:0] data_addr_o,
    output [31:0] data_wdata_o
);

//PC and InstrMem wires
wire [31:0] Instr = instr_rdata_i;
wire [31:0] FromPC;
reg [31:0] ToPC;
wire illegal_instr;
wire mem_stal;
wire mem_req;
wire pc_stal = illegal_instr | !mem_req;

assign instr_addr_o = FromPC;

//Register file wires
wire [4:0] RA1 = Instr[19:15];
wire [4:0] RA2 = Instr[24:20];
wire [4:0] WA = Instr[11:7];
wire RfWE;
wire [31:0] RfRD1;
wire [31:0] RfRD2;
reg [31:0] RfWD;

assign MemWD = RfRD2;

//Alu wires
reg [31:0] OperandA;
reg [31:0] OperandB;
wire [5:0] Operation;
wire [31:0] Result;
wire ComparisonResult;

assign MemA = Result;

//Immediates
wire [31:0] ImmI = { {20{Instr[31]}} , {Instr[31:20]}};
wire [31:0] ImmS = { {20{Instr[31]}} , Instr[31:25], Instr[11:7]};
wire [31:0] ImmJ = { {11{Instr[31]}} , Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0};
wire [31:0] ImmB = { {19{Instr[31]}} , Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};
wire [31:0] UImm = {Instr[31:12] , 12'b0};

//decode wires
wire [1:0] OperatorASelector;
wire [2:0] OperatorBSelector;
wire RFWSSelector;
wire IsBranch;
wire IsJal;
wire IsJarl;

//Other wires
reg [31:0] NextInstr;
wire BranchSelector = IsBranch & ComparisonResult;
wire JumpSelector = IsJal | BranchSelector;
wire [31:0] MemRD;
wire [2:0] MemSize;



PC ProgC(
.EN(!pc_stal),
.RESET(arstn_i),
.CLK(clk_i), 
.IN(ToPC),
.OUT(FromPC)
 );
 
 register_file RF(
 .RESET(arstn_i),
 .CLK(clk_i),
 .WE(RfWE),
 .WDA(WA),
 .RDA1(RA1),
 .RDA2(RA2),
 .WD(RfWD),
 .RD1(RfRD1),
 .RD2(RfRD2)
 );
 
 myriscv_alu ALU(
.operator_i(Operation),
.operand_a_i(OperandA),
.operand_b_i(OperandB),
.result_o(Result),
.comparison_result_o(ComparisonResult)
);

riscv_decode MainDecoder(
.fetched_instr_i(Instr), //Instruction
.ex_op_a_sel_o(OperatorASelector), // Alu operand a
.ex_op_b_sel_o(OperatorBSelector), //Alu operand b
.alu_op_o(Operation), //Alu operation
.mem_req_o(MemReq), //Data required
.mem_we_o(MemWE), //Data memory WE
.mem_size_o(MemSize), //Data memory size selector
.gpr_we_a_o(RfWE), //Register file WE
.wb_src_sel_o(RFWSSelector), //Register file WS
.illegal_instr_o(illegal_instr), //Error
.branch_o(IsBranch), //Branch if condition
.jal_o(IsJal), //Jump and link with immediate
.jarl_o(IsJarl), //Jump and link with register data

.lsu_stall_req_i(mem_stal),
.core_enpc_o(mem_req)
);

miriscv_lsu lsu(
.clk_i(clk_i),
.arstn_i(arstn_i),
 //Data protocol
.data_gnt_i(data_gnt_i),
.data_rvalid_i(data_rvalid_i),
.data_rdata_i(data_rdata_i),

.data_req_o(data_req_o),
.data_we_o(data_we_o),
.data_be_o(data_be_o),
.data_addr_o(data_addr_o),
.data_wdata_o(data_wdata_o),

// core protocol   
.lsu_addr_i(Result),   
.lsu_we_i(MemWE),
.lsu_size_i(MemSize),
.lsu_data_i(RfRD2),
.lsu_req_i(MemReq),
//.lsu_kill_i(),

.lsu_stall_req_o(mem_stal),
.lsu_data_o(MemRD)
);

reg [31:0] BoJImm;

always @(*)
begin

case(IsJarl)
	0: begin ToPC <= NextInstr + FromPC; end
	1: begin ToPC <= RfRD1 + ImmI; end
endcase

case(JumpSelector)
	0: begin NextInstr <= 32'h00000004; end
	1: begin NextInstr <= BoJImm; end
endcase

case(IsBranch)
	0: begin BoJImm <= ImmJ; end
	1: begin BoJImm <= ImmB; end
endcase

case(OperatorASelector)
	2'd0: begin OperandA <= RfRD1; end
	2'd1: begin OperandA <= FromPC; end
	2'd2: begin OperandA <= 32'b0; end
endcase

case(OperatorBSelector)
	3'd0: begin OperandB <= RfRD2; end
	3'd1: begin OperandB <= ImmI; end
	3'd2: begin OperandB <= UImm; end
	3'd3: begin OperandB <= ImmS; end
	3'd4: begin OperandB <= 32'h00000004; end
endcase

case(RFWSSelector)
	0: begin RfWD <= Result; end
	1: begin RfWD <= MemRD; end
endcase

end
 
 endmodule