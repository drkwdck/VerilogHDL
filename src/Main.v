module Main (
input         clk,
input			  rst,
//input 			WE,
input [31:0] SW,
output [31:0] HEX
);

reg  [31:0] PC;
reg [31:0] mux3in1;
wire [31:0] instr;
wire [31:0] RD1;
wire [31:0] RD2;
wire [31:0] aluresult;
wire comparison_result_o;
wire [31:0] SE;

InstructionMemory inst_datamemory(
	.clk(clk),
	.A(PC),
	.RD(instr),
	.WE(WE)
);

RF inst_regfile(
	.clk(clk),
	.reset(rst),
	.A1(instr[22:18]),
	.A2(instr[17:13]),
	.A3(instr[12:8]),
	.WD3(mux3in1),
	.WE(instr[29]),
	.RD1(RD1),
	.RD2(RD2)
);
	
ALU ALUop(
	.operator(instr[26:23]),
	.left(RD1),
	.right(RD2),
	.result(aluresult),
	.comparison(comparison_result_o)
);

SE se(
	.A(instr[7:0]),
	.result(SE)
);

assign HEX=RD1;
always @(*)
begin
		case(instr[28:27])
		2'b00: begin
			mux3in1<=SE[31:0];
		end
		2'b01: begin
			mux3in1<=SW[31:0];
		end
		2'b10: begin
			mux3in1<=aluresult;
		end
	endcase
end

always @(posedge clk)
 begin
	if (rst)
		PC <= 32'd0;
	else if ((instr[31:30]==0)||((instr[30]==1)&&(instr[31]==0)&&(comparison_result_o==0)))
		PC <= PC+32'd4 ; 
	else
		PC<=PC + (SE[31:0] << 2);
end






//
//always @(posedge clk) begin
//	if (rst)
//		PC <= 32'd0;
//	else
//	if (instr[31:30]<=0||(instr[]
//		PC <= PC+32'd4 ; 
//		
//end


//case(instr[31:30])
//	2'b00: begin 
//	PC<=PC+32'd4;
//	end
//	2'b01: begin
//	if (comparison_result_o==0)
//	PC<=PC+32'd4;
//	else
//	PC <= PC + (SE[31:0] << 2);
//	end
//	2'b10: begin 
//	PC <= PC + (SE[31:0] << 2);
//	end
//	2'b11: begin
//	if(comparison_result_o==0)
//	PC <= PC + (SE[31:0] << 2);	
//	end
//	endcase

endmodule
