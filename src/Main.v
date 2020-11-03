module Main 
#(
  parameter WIDTH_ADDR = 4,
  parameter WIDTH_DATA = 32
)
(
 input   clk_i,
 input   rst_i,
 input   [9:0] SW,
 output  [31:0] HEX0
);

wire  B;
wire  C;
wire  WE;
wire [1:0]  WS   ;
reg  [3:0]  ALUop; // operator_i
reg  [4:0]  RA1  ; // A1
reg  [4:0]  RA2  ; // A2
reg  [4:0]  WA   ; // A3
wire [7:0]  const;
reg  [31:0] PC;
wire [31:0] instr;
wire [31:0] SE_SW;
reg  [31:0] count;

//Алу  
wire [31:0] RD_1;      // operand_a_i    RD1_o
wire [31:0] RD_2;      // operand_b_i    RD2_o
wire [31:0] res_o;     // result_o
wire comp_res_o; // comparison_result_o

//Регистровый файл
reg [31:0] WD3;
wire clk, rst;

//Память инструкций
wire [31:0] wd;
wire we;

RF reg1 (
.clk ( clk  ),
.reset ( rst ),
.A1 ( RA1 ),
.A2 ( RA2 ),
.A3 ( WA ),
.WD3 ( WD3 ),
.WE ( WE ),
.RD1 ( RD_1 ),
.RD2 ( RD_2 )
); 

InstructionMemory mem1 (
.clk ( clk ),
.adress ( PC ),
.writeData    ( wd ),
.writeEnable    ( we ),
);

ALU miriscv_alu (
.operator ( ALUop ),
.left ( RD_1 ),
.right ( RD_2 ),
.result ( res_o ),
.comparison ( comp_res_o )
);

integer i;
/*
assign RD1 = A1 ? RAM[A1]:0;
assign RD2 = A2 ? RAM[A2]:0;

always @(posedge clk) begin
   
	
	if(reset)
	for (i = 0; i < 32; i = i + 1)
		RAM[i] <= 0;
	else if (we) RAM[A3]<=WD3;	
end
*/

/*
assign HEX0=rd_1;
assign OR          = AND | instr[31];
assign AND         = comparison_result_o & instr[30];
assign shift_const = {{22{instr[7]}}, instr[7:0], 2'b0};
*/
assign B     =  instr[31];
assign C     =  instr[30];
assign WS    =  instr[28:27];
assign const =  instr[7:0];

//реализация условного и безусловного перехода
/*always @ ( posedge clk_i ) begin
   if (B==1) PC <= PC + ( const << 2);
	else begin 
	  if ((C==1)&&(comp_res_o==1))PC <= PC + ( const << 2 );
     else PC <= PC + 32'd4;
   end	
	 /* if (C == 0) PC <= PC + 32'd4;   
	  else begin 
		    if (comp_res_o == 0) PC <= PC + 32'd4;
		     else PC <= PC + ( const << 2 );
		      end*/	
			

  /*case ( instr[31] ) 
		1'b0:   /*if (C == 0) begin
		          PC <= PC + 32'd4;   
		        end else begin 
		            if (comp_res_o == 0) PC <= PC + 32'd4;
		            else PC <= PC + ( const << 2 );
		          end	
			if ((C==1)&&(comp_res_o==1))PC <= PC + ( const << 2 );
         else PC <= PC + 32'd4;			
		
		1'b1: PC <= PC + ( const << 2);
  endcase
end*/

//if ((C==1)&&(comp_res_o==1))PC <= PC + ( const << 2 );
//производим знакорасширение
assign SE     = {{24{const[7]}},const};
assign SE_SW  = {{22{SW[9]}},SW[9:0]};

//реализация WS
always @ (*) begin
	case (WS)
		2'b00 : WD3 <= SE;
		2'b01 : WD3 <= SE_SW; 
		2'b10 : WD3 <= res_o;
		2'b11 : WD3 <= 32'b0;
	endcase
end

//
always @ ( posedge clk_i ) begin
	if ( rst_i ) begin
	  PC    <= 32'b0;
	  count <= 32'b0;
	end else begin
	  for (i = 9; i >=0; i = i - 1) begin
	    if (SE_SW[i] == 1) count <= count + 1;
	  end
	end
	
	  if (B==1) PC <= PC + ( const << 2);
	else begin 
	  if ((C==1)&&(comp_res_o==1))PC <= PC + ( const << 2 );
     else PC <= PC + 32'd4;
   end
	
end

endmodule 

