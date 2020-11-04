module Main (
	input clk,
	input reset,
	input [31:0] SW,
	output [31:0] HEX
);

reg [31:0] PC;
reg [31:0] writeData;
wire [31:0] current_instruction;
wire [31:0] RD1;
wire [31:0] RD2;
wire [31:0] aluResult;
wire [31:0] SE;
wire comparisonResultO;

InstructionMemory instructionMemory(
	.clk (clk),
	.A (PC),
	.RD (current_instruction),
	.WE (WE)
);

ALU aLU(
	.operator (current_instruction[26:23]),
	.left (RD1),
	.right (RD2),
	.result (aluResult),
	.comparison (comparisonResultO)
);

RF rF(
	.clk (clk),
	.rst (reset),
	.A1 (current_instruction[22:18]),
	.A2 (current_instruction[17:13]),
	.A3 (current_instruction[12:8]),
	.WD3 (writeData),
	.WE3 (current_instruction[29]),
	.RD1 (RD1),
	.RD2 (RD2)
);

assign SE = {{24{current_instruction[7]}}, current_instruction[7:0] };

assign HEX=RD1;
always @(*) begin
		case(current_instruction[28:27])
		2'b00: begin
			writeData <= SE[31:0];
		end

		2'b01: begin
			writeData <= SW[31:0];
		end

		2'b10: begin
			writeData <= aluResult;
		end
	endcase
end

always @(posedge clk) begin
	if (reset)
		PC <= 32'd0;
	else if (!((comparisonResultO && current_instruction[30]) || current_instruction[31]))
		PC <= PC + 32'd1 ; 
	else
		PC <= PC + (SE[31:0]);
end
endmodule
