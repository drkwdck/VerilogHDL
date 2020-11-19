module riscv_cpu(
//CPU control
input CLK,
input RESET,
//Execution
output [31:0] FromPC,
input [31:0] CurInstr,
//Memory
input [31:0] MemRD,
output [31:0] MemWD,
output [31:0] MemA,
output [2:0] MemSize,
output MemWE,
//Runtime state
output IsError,
output reg IsEnd,

//debug
output [31:0] RFWD,
output [4:0] RFWA,
output [31:0] RFRS1,
output [4:0] RFRS1A,
output [31:0] RFRS2,
output [4:0] RFRS2A,
output RFWS,
output RFWE,
output [31:0] imm_I,
output [31:0] imm_S,
output [31:0] imm_J,
output [31:0] imm_B,
output [31:0] imm_UI,
output MemReq,
output [1:0] OpA,
output [2:0] OpB,
output [5:0] AluOp,
output [31:0] AluResult
);

//PC and InstrMem wires
wire [31:0] Instr = CurInstr;
reg [31:0] ToPC;
wire PCEN;

//Register file wires
wire [4:0] RA1 = Instr[19:15];
wire [4:0] RA2 = Instr[24:20];
wire [4:0] WA = Instr[11:7];
wire RfWE;
wire [31:0] RfRD1;
wire [31:0] RfRD2;
reg [31:0] RfWD;

assign RFWD = RfWD;
assign RFWA = WA;

assign MemWD = RfRD2;

//Alu wires
reg [31:0] OperandA;
reg [31:0] OperandB;
wire [5:0] Operation;
wire [31:0] Result;
wire ComparisonResult;

assign MemA = Result;

//Immediates
wire [31:0] ImmI;
wire [31:0] ImmS;
wire [31:0] ImmJ;
wire [31:0] ImmB;
wire [31:0] UImm;

assign ImmI = { {20{Instr[31]}} , {Instr[31:20]}};
assign ImmS = { {20{Instr[31]}} , Instr[31:25], Instr[11:7]};
assign ImmJ = { {11{Instr[31]}} , Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0};
assign ImmB = { {19{Instr[31]}} , Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};

assign imm_I = ImmI;
assign imm_S = ImmS;
assign imm_J = ImmJ;
assign imm_B = ImmB;

assign UImm[31:12] = Instr[31:12];
assign UImm[11:0] = 12'b0;

assign imm_UI = UImm;

//decode wires
wire [1:0] OperatorASelector;
wire [2:0] OperatorBSelector;
wire RFWSSelector;
wire IsBranch;
wire IsJal;
wire IsJarl;

assign jump = IsJal;
assign branch = IsBranch;

//Interface
assign ReadData1 = RfRD1;
assign ReadData2 = RfRD2;
assign IsError = PCEN;

//Other wires
reg [31:0] NextInstr;
wire BranchSelector = IsBranch & ComparisonResult;
assign branch_selector = BranchSelector;
wire JumpSelector = IsJal | BranchSelector;
assign jump_selector = JumpSelector;



PC ProgC(
.EN(!PCEN),
.RESET(RESET),
.CLK(CLK), 
.IN(ToPC),
.OUT(FromPC)
 );
 
 register_file RF(
 .RESET(RESET),
 .CLK(CLK),
 .WE(RfWE),
 .WDA(WA),
 .RDA1(RA1),
 .RDA2(RA2),
 .WD(RfWD),
 .RD1(RfRD1),
 .RD2(RfRD2)
 );
 
assign RFRS1 = RfRD1;
assign RFRS1A = RA1;
assign RFRS2 = RfRD2;
assign RFRS2A = RA2;
 
 myriscv_alu ALU(
.operator_i(Operation),
.operand_a_i(OperandA),
.operand_b_i(OperandB),
.result_o(Result),
.comparison_result_o(ComparisonResult)
);

assign AluOp = Operation;
assign AluResult = Result;
riscv_decode MainDecoder(
.fetched_instr_i(Instr), //Instruction
.ex_op_a_sel_o(OperatorASelector), // Alu operand a
.ex_op_b_sel_o(OperatorBSelector), //Alu operand b
.alu_op_o(Operation), //Alu operation
.mem_req_o(MemReq), //I don't give a fuck what is it
.mem_we_o(MemWE), //Data memory WE
.mem_size_o(MemSize), //Data memory size selector
.gpr_we_a_o(RfWE), //Register file WE
.wb_src_sel_o(RFWSSelector), //Register file WS
.illegal_instr_o(PCEN), //Error
.branch_o(IsBranch), //Branch if condition
.jal_o(IsJal), //Jump and link with immediate
.jarl_o(IsJarl) //Jump and link with register data
);

reg [31:0] BoJImm;

assign RFWS = RFWSSelector;
assign RFWE = RfWE;

assign OpA = OperatorASelector;
assign OpB = OperatorBSelector;

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

if(IsJal == 1 & ImmJ == 0 ) begin
	IsEnd <= 1;
end
else begin
	IsEnd <= 0;
end

end
 
 endmodule