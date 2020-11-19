`timescale 10ns/1ns


module CPUtestbench();
//CPU control
reg CLK;
reg RESET;
//Execution
wire [31:0] FromPC;
wire [31:0] CurInstr;
//Memory
wire [31:0] MemRD;
wire [31:0] MemWD;
wire [31:0] MemA;
wire [2:0] MemSize;
wire MemWE;
//Runtime state
wire IsError;

//debug
wire [31:0] RfWD;
wire [4:0] RfWA;
wire [31:0] RFRS1;
wire [4:0] RFRS1A;
wire [31:0] RFRS2;
wire [4:0] RFRS2A;
wire RFWS;
wire RFWE;
wire [31:0] imm_I;
wire [31:0] imm_S;
wire [31:0] imm_J;
wire [31:0] imm_B;
wire [31:0] imm_UI;
wire MemReq;
wire [1:0] OpA;
wire [2:0] OpB;
wire [5:0] AluOp;
wire [31:0] AluResult;

Cpu dut(
.CLK(CLK),
.RESET(RESET),
.FromPC(FromPC),
.CurInstr(CurInstr),
.MemRD(MemRD),
.MemWD(MemWD),
.MemA(MemA),
.MemSize(MemSize),
.MemWE(MemWE),
.IsError(IsError),
//debug
.RFWD(RfWD),
.RFWA(RfWA),
.RFRS1(RFRS1),
.RFRS1A(RFRS1A),
.RFRS2(RFRS2),
.RFRS2A(RFRS2A),
.RFWS(RFWS),
.RFWE(RFWE),
.imm_I(imm_I),
.imm_S(imm_S),
.imm_J(imm_J),
.imm_B(imm_B),
.imm_UI(imm_UI),
.MemReq(MemReq),
.OpA(OpA),
.OpB(OpB),
.AluOp(AluOp),
.AluResult(AluResult)
);

DM data(
.CLK(CLK),
.WE(MemWE),
.I(MemSize),
.WD(MemWD),
.A(MemA),
.RD(MemRD)
);

InstructionMemory Instructions(
.A(FromPC), 
.Instr(CurInstr)
);



wire [31:0] Instruction = CurInstr;
integer Result;
//Instr params
wire [6:0] opcode = Instruction[6:0];
wire [4:0] rd = Instruction[11:7];
wire [2:0] funct3 = Instruction[14:12];
wire [4:0] rs1 = Instruction[19:15];
wire [4:0] rs2 = Instruction[24:20];
wire [6:0] funct7 = Instruction[31:25];
//Instr Immediates
wire [31:0] II = imm_I;
wire [31:0] IS = imm_S;
wire [31:0] IJ = imm_J;
wire [31:0] IB = imm_B;
wire [31:0] UI = imm_UI; 

integer i;
integer steps;
task Execute;
begin
steps = 0;
i = 0;

if(IsError) begin
end
while(!IsError)
begin
CLK = 0; #1;
CLK = 1; #1;
steps = steps + 1;
end
end
endtask

initial begin
RESET = 1; #1;
CLK = 0; #1;
CLK = 1; #1;
RESET = 0; #1;
CLK = 0; #1;
CLK = 1; #1;
Execute();
end

endmodule