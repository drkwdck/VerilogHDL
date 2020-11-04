module Main 
#(
	parameter HIGHT = 8
)
(
 input   clk_i,
 input   rst_i,
 input   [31:0] SW,
 output  [31:0] HEX
);

wire  B;
wire  C;
wire  WE;
wire [1:0]  WS ;
wire [7:0]  const;
reg  [31:0] PC;
wire [31:0] current_instruction;
wire [31:0] SE_SW;
reg  [31:0] count;

//Алу
wire [31:0] RD_1; // left    RD1_o
wire [31:0] RD_2; // right    RD2_o
wire [31:0] operation_result; // result
wire comparison_result_operation; // comparison

//Регистровый файл
reg [31:0] WD3;

RF rigster_file_instnc (
	.clk ( clk_i ),
	.reset ( rst_i ),
	.A1 ( current_instruction[22:18] ),
	.A2 ( current_instruction[17:13] ),
	.A3 ( current_instruction[12:8] ),
	.WD3 ( WD3 ),
	.WE ( current_instruction[29] ),
	.RD1 ( RD_1 ),
	.RD2 ( RD_2 )
); 

InstructionMemory instruction_memory_instnc (
.adress ( PC ),
.RD ( current_instruction )
);

ALU alu_instnc (
.operator ( current_instruction[26:23] ),
.left ( RD_1 ),
.right ( RD_2 ),
.result ( operation_result ),
.comparison ( comparison_result_operation )
);

integer i;

//производим знакорасширение
assign const = current_instruction[7:0];
assign SE    = {{24{const[7]} }, const};

//реализация WS
always @ (*) begin
	case (WS)
		2'b00 : WD3 <= SE;
		2'b01 : WD3 <= SE_SW; 
		2'b10 : WD3 <= operation_result;
		2'b11 : WD3 <= 32'b0;
	endcase
end

//
always @ ( posedge clk_i ) begin
	if ( rst_i ) begin
	  PC    	<= 32'b0;
	  count <= 32'b0;
	end 

	if (current_instruction[31] == 1) PC <= PC + const;
	else begin 
	  if ((current_instruction[30] == 1) && (comparison_result_operation == 1)) PC <= PC + const;
     else PC <= PC + 32'd1;
   end
end

endmodule 

