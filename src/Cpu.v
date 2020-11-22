module Cpu(
input clk,
input reset,
output [31:0] pcLastState,
input [31:0] currentInstrucntion,
// input [31:0] dataMemoryOutput,
output [31:0] dataMemoryOut,
output [31:0] dataMemoryAdress,
output [2:0] MemSize,
output MemWE,
output IsError
);

//PC and InstrMem wires
wire [31:0] Instr = currentInstrucntion;
reg [31:0] ToPC;

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

assign dataMemoryOut = RfRD2;

reg [31:0] OperandA;
reg [31:0] OperandB;
wire [5:0] Operation;
wire [31:0] Result;
wire ComparisonResult;

assign dataMemoryAdress = Result;

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

wire [1:0] OperatorASelector;
wire [2:0] rigthOperand;
wire RFWSSelector;
wire IsBranch;
wire IsJal;
wire IsJarl;

assign jump = IsJal;
assign branch = IsBranch;

assign ReadData1 = RfRD1;
assign ReadData2 = RfRD2;
assign IsError = PCEN;

reg [31:0] NextInstr;
wire BranchSelector = IsBranch & ComparisonResult;
assign branch_selector = BranchSelector;
wire JumpSelector = IsJal | BranchSelector;
assign jump_selector = JumpSelector;

reg [31:0] PC;
assign pcLastState = PC;
always @ (posedge clk or posedge reset)
begin

	if(reset) begin
		PC <= 32'b00000000000000000000000000000000;
	end
	else begin
	PC <= ToPC;
	end
end



 register_file RF(
 .reset(reset),
 .clk(clk),
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
.fetched_instr_i(Instr),
.ex_op_a_sel_o(OperatorASelector),
.ex_op_b_sel_o(rigthOperand),
.alu_op_o(Operation),
.mem_req_o(MemReq),
.mem_we_o(MemWE),
.mem_size_o(MemSize),
.gpr_we_a_o(RfWE),
.wb_src_sel_o(RFWSSelector),
.illegal_instr_o(PCEN),
.branch_o(IsBranch),
.jal_o(IsJal),
.jarl_o(IsJarl)
);

reg [31:0] BoJImm;

assign RFWS = RFWSSelector;
assign RFWE = RfWE;

assign OpA = OperatorASelector;
assign OpB = rigthOperand;

wire [31:0] dataMemoryOutput;

DM data(
.clk(clk),
.WE(MemWE),
.size(MemSize),
.WD(dataMemoryOut),
.A(dataMemoryAdress),
.RD(dataMemoryOutput)
);



always @(*) begin
	case(IsJarl)
		0: begin ToPC <= NextInstr + pcLastState; end
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
		2'd1: begin OperandA <= pcLastState; end
		2'd2: begin OperandA <= 32'b0; end
	endcase

	case(rigthOperand)
		3'd0: begin OperandB <= RfRD2; end
		3'd1: begin OperandB <= ImmI; end
		3'd2: begin OperandB <= UImm; end
		3'd3: begin OperandB <= ImmS; end
		3'd4: begin OperandB <= 32'h00000004; end
	endcase

	case(RFWSSelector)
		0: begin RfWD <= Result; end
		1: begin RfWD <= dataMemoryOutput; end
	endcase
end
 
endmodule