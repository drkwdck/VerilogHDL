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
wire IsEnd;

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

riscv_cpu dut(
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
.IsEnd(IsEnd),
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

DataMemory data(
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
//AluOps
localparam ALU_ADD = 6'b011000; //сложение
localparam ALU_SUB = 6'b011001; //вычитание

localparam ALU_XOR = 6'b101111; //исключающее или
localparam ALU_OR = 6'b101110; // или
localparam ALU_AND = 6'b010101; // и

localparam ALU_SRA = 6'b100100; //арифметический сдвиг вправо
localparam ALU_SRL = 6'b100101; //логичкеский сдвиг вправо
localparam ALU_SLL = 6'b100111; //сдвиг влево

localparam ALU_LTS = 6'b000000; //знаковое меньше
localparam ALU_LTU = 6'b000001; //беззнаковое меньше
localparam ALU_GES = 6'b001010; //знаковое больше или равно
localparam ALU_GEU = 6'b001011; //беззнаковое больше или равно

localparam ALU_SLTS = 6'b000010; //знаковое меньше
localparam ALU_SLTU = 6'b000011; //беззнаковое меньше

localparam ALU_EQ = 6'b001100; //равно
localparam ALU_NE = 6'b001101; //не равно


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

task InstrState;
begin
$display("Opcode is %b", opcode);
$display("RD is %b", rd);
$display("Funct3 is %b", funct3);
$display("RS1 is %b", rs1);
$display("RS2 is %b", rs2);
$display("Funct7 is %b", funct7);
end
endtask

task InstrType;
begin
case(opcode)
	RegReg: begin
				case(funct3) // Selection of operation
					3'h0: begin 
							if(funct7 == 7'h00) begin
									$display("ADDition RF[%d] = RF[%d] + RF[%d]", rd, rs1, rs2);
							end
							else if(funct7 == 7'h20) begin
									$display("SUBtraction RF[%d] = RF[%d] + RF[%d]", rd, rs1, rs2);
							end
							else begin
									$display("Illegal instruction");
							end
							end
					3'h1: begin
							if(funct7 == 7'h00) begin
									$display("Shift left logical RF[%d] = RF[%d] << RF[%d]", rd, rs1, rs2);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h2: begin
							if(funct7 == 7'h00) begin
									$display("Set less than RF[%d] = (RF[%d] < RF[%d]) ? 1 : 0", rd, rs1, rs2);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h3: begin
							if(funct7 == 7'h00) begin
								$display("Set less than unsigned RF[%d] = (RF[%d] < RF[%d]) ? 1 : 0", rd, rs1, rs2);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h4: begin
							if(funct7 == 7'h00) begin
								$display("eXclusiveOR RF[%d] = RF[%d] ^ RF[%d]", rd, rs1, rs2);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h5: begin 
							if(funct7 == 7'h00) begin
									$display("Shift right logical RF[%d] = RF[%d] >> RF[%d]", rd, rs1, rs2);
							end
							else if(funct7 == 7'h20) begin
									$display("Shift right arithmetical RF[%d] = RF[%d] >>> RF[%d]", rd, rs1, rs2);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h6: begin
							if(funct7 == 7'h00) begin
								$display("OR RF[%d] = RF[%d] || RF[%d]", rd, rs1, rs2);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h7: begin
							if(funct7 == 7'h00) begin
								$display("AND RF[%d] = RF[%d] && RF[%d]", rd, rs1, rs2);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					default: begin 
								$display("Illegal instruction");
								end
				endcase
				end
	RegImm: begin
				case(funct3) // Selection of operation
					3'h0: begin 
									$display("ADDition immediate RF[%d] = RF[%d] + %d", rd, rs1, II);
							end
					3'h1: begin
							if(funct7 == 7'h00) begin
								$display("Shift left logical immediate RF[%d] = RF[%d] << %d", rd, rs1, II);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h2: begin
								$display("Set less than immediate RF[%d] = (RF[%d] < %d) ? 1 : 0", rd, rs1, II);
							end
					3'h3: begin
								$display("Set less than immediate unsigned RF[%d] = (RF[%d] < %d) ? 1 : 0", rd, rs1, II);
							end
					3'h4: begin
								$display("eXclusiveOR immediate RF[%d] = RF[%d] ^ %d", rd, rs1, II);
							end
					3'h5: begin 
							if(funct7 == 7'h00) begin
									$display("Shift right logical immediate RF[%d] = RF[%d] >> %d", rd, rs1, II);
							end
							else if(funct7 == 7'h20) begin
									$display("Shift right arithmetical immediate RF[%d] = RF[%d] >>> %d", rd, rs1, II);
							end
							else begin
								$display("Illegal instruction");
							end
							end
					3'h6: begin
								$display("OR immediate RF[%d] = RF[%d] || %d", rd, rs1, II);
							end
					3'h7: begin
								$display("AND immediate RF[%d] = RF[%d] && %d", rd, rs1, II);
							end
					default: begin 
								$display("Illegal instruction");
								end
				endcase
				end
	Load: begin		
			if((funct3 >= 3'h0 & funct3 <= 3'h2) || funct3 == 3'h4 || funct3 == 3'h5) begin
				case(funct3)
					3'h0: begin $display("Load byte (RF[%d] = MEM[RF[%d] + %d])", rd, rs1, II); end
					3'h1: begin $display("Load half (RF[%d] = MEM[RF[%d] + %d])", rd, rs1, II); end
					3'h2: begin $display("Load word (RF[%d] = MEM[RF[%d] + %d])", rd, rs1, II); end
					3'h4: begin $display("Load unsigned byte (RF[%d] = MEM[RF[%d] + %d])", rd, rs1, II); end
					3'h5: begin $display("Load unsigned half (RF[%d] = MEM[RF[%d] + %d])", rd, rs1, II); end
				endcase
			end
			else begin
				$display("Illegal instruction");
			end
			end
	Store: begin
			if(funct3 >= 3'h0 & funct3 <= 3'h2) begin
				case(funct3)
					3'h0: begin $display("Store byte (MEM[RF[%d] + %d] = RF[%d])", rs1, IS, rs2); end
					3'h1: begin $display("Store half (MEM[RF[%d] + %d] = RF[%d])", rs1, IS, rs2); end
					3'h2: begin $display("Store word (MEM[RF[%d] + %d] = RF[%d])", rs1, IS, rs2); end
					endcase
			end
			else begin
				$display("Illegal instruction");
			end
			end
	Jal: begin
				$display("Jump and link (PC = %d  + %d, RF[%d] = %d + 4). Jump is gona be at %d", FromPC, IJ, rd, FromPC, FromPC + IJ);
			end
	Jalr: begin
			if(funct3 == 3'h0 /*&& ImmI < 64*/) begin
					$display("Jump and link register (PC = RF[%d]  + %d, RF[%d] = %d + 4)", rs1, II, rd, FromPC);
			end
			else begin
				$display("Illegal instruction");
			end
			end
	Branch: begin
			case(funct3)
				3'h0: begin $display("Branch if RF[%d] equal RF[%d] PC = %d + %d. If true jump on %d", rs1, rs2, FromPC, IB, FromPC + IB); end
				3'h1: begin $display("Branch if RF[%d] not equal RF[%d] PC = %d + %d. If true jump on %d", rs1, rs2, FromPC, IB, FromPC + IB); end
				3'h4: begin $display("Branch if RF[%d] less RF[%d] PC = %d + %d. If true jump on %d", rs1, rs2, FromPC, IB, FromPC + IB); end
				3'h5: begin $display("Branch if RF[%d] greater RF[%d] PC = %d + %d. If true jump on %d", rs1, rs2, FromPC, IB, FromPC + IB); end
				3'h6: begin $display("Branch if RF[%d] less RF[%d] PC = %d + %d (unsigned). If true jump on %d", rs1, rs2, FromPC, IB, FromPC + IB); end
				3'h7: begin $display("Branch if RF[%d] greater RF[%d] PC = %d + %d (unsigned). If true jump on %d", rs1, rs2, FromPC, IB, FromPC + IB); end
				default: begin 
							$display("Illegal instruction");
							end
			endcase
			end
	Lui: begin
			$display("Load uper immediate RF[%d] = %d", rd, UI);
			end
	Auipc: begin
			$display("ADD uper immediate to PC RF[%d] = %d + %d", rd, FromPC, UI);
			end
	MiscMem: begin
			$display("Empty instruction");
				end
	System: begin
			$display("Empty instruction");
				end
	default: begin 
			$display("Illegal instruction");
			end	
endcase

end
endtask

task AluState;
begin

case(OpA)
	2'b00: begin $display("Alu operand A is %d from RF addr %d", $signed(RFRS1), RFRS1A); end
	2'b01: begin $display("Alu operand A is %d from PC", FromPC); end
	2'b10: begin $display("Alu operand A is zero"); end
endcase

case(OpB)
	3'd0: begin $display("Alu operand B is %d from RF addr %d", $signed(RFRS2), RFRS2A); end
	3'd1: begin $display("Alu operand B is %d from ImmI", imm_I); end
	3'd2: begin $display("Alu operand B is %d from ImmUI", imm_UI); end
	3'd3: begin $display("Alu operand B is %d from ImmS", imm_S); end
	3'd4: begin $display("Alu operand B is constant 4"); end
endcase

case(AluOp)
	ALU_ADD: begin $display("Alu operation is ADD"); end
	ALU_SUB: begin $display("Alu operation is SUB"); end
	
	ALU_XOR: begin $display("Alu operation is XOR"); end
	ALU_OR: begin $display("Alu operation is OR"); end
	ALU_AND: begin $display("Alu operation is AND"); end
		
	ALU_SRA: begin $display("Alu operation is SRA"); end
	ALU_SRL: begin $display("Alu operation is SRL"); end
	ALU_SLL: begin $display("Alu operation is SLL"); end
		
	ALU_LTS: begin $display("Alu operation is LTS"); end
	ALU_LTU: begin $display("Alu operation is LTU"); end
	ALU_GES: begin $display("Alu operation is GES"); end
	ALU_GEU: begin $display("Alu operation is GEU"); end
		
	ALU_SLTS: begin $display("Alu operation is SLTS"); end
	ALU_SLTU: begin $display("Alu operation is SLTU"); end
		
	ALU_EQ: begin $display("Alu operation is EQ"); end
	ALU_NE: begin $display("Alu operation is NE"); end
endcase

$display("Alu result is %d\n", AluResult);
end
endtask

task RFState;
begin

$display("RF read 1 is %d from %d", RFRS1, RFRS1A);
$display("RF read 2 is %d from %d\n", RFRS2, RFRS2A);

if(RFWE) begin
$display("RF writing");
$display("RF WD is %d", RfWD);
$display("RF AD is %d\n", RfWA);
end
end
endtask

task RAMState;
begin

if(MemReq) begin
	if(MemWE) begin
		$display("RAM writing");
		$display("Memory WD is %d", MemWD);
		$display("Memory AD is %d\n", MemA);
	end 
	else begin
		$display("RAM reading");
		$display("Memory RD is %d", MemRD);
		$display("Memory AD is %d\n", MemA);
	end
	end
	end
endtask

task InstructionState;
begin
$display("Current PC is %d", FromPC);
$display("Current instruction is %b", Instruction);
InstrType();
$display("");
end
endtask

task CurState;
begin
$display("\n======================================");
InstructionState();
RAMState();
RFState();
AluState();
$display("======================================\n");
end
endtask

integer i;
integer steps;
task Execute;
begin
steps = 0;
i = 0;

if(IsError) begin
$display("Error in instruction %h", Instruction);
InstrState();
end
while(!(IsError || IsEnd))
begin
CurState();
CLK = 0; #1;
CLK = 1; #1;
steps = steps + 1;

if(Instruction == 32'h00402183 || rd == 5'b00011) begin
Result = MemRD;
end
end

$display("\n\nResult is %d",Result);
$display("Steps: %d", steps);
$display("IsEnd = %b", IsEnd);

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