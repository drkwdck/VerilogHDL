module DM(
input clk,
input WE,
input [2:0] size,
input [31:0] WD,
input [31:0] A,
output [31:0] RD
);
//=======Extends
reg [15:0] U16In;
reg [15:0] S16In;
reg [7:0] U8In;
reg [7:0] S8In;

wire [31:0] U16Out;
assign U16Out[15:0] = U16In;
assign U16Out[31:16] = {16'b0};

wire [31:0] S16Out;
assign S16Out[15:0] = S16In;
assign S16Out[31:16] = {16{S16In[15]}};

wire [31:0] U8Out;
assign U8Out[7:0] = U8In;
assign U8Out[31:8] = {24'b0};

wire [31:0] S8Out;
assign S8Out[7:0] = S8In;
assign S8Out[31:8] = {24{S8In[7]}};

wire [31:0] WOut;
//=======Data
reg [7:0] Byte0 [0:63];
reg [7:0] Byte1 [0:63];
reg [7:0] Byte2 [0:63];
reg [7:0] Byte3 [0:63];

integer i;
initial begin
for (i = 0; i < 64; i = i + 1) begin
	Byte0[i] = 8'd0;
	Byte1[i] = 8'd0;
	Byte2[i] = 8'd0;
	Byte3[i] = 8'd0;
end
$readmemb("load_consts.txt", Byte0);
end

//=======Interface params
localparam SigByte = 3'd0;
localparam SigHalf = 3'd1;
localparam Word = 3'd2;
localparam UnByte = 3'd4;
localparam UnHalf = 3'd5;
	
//=======Logic
//read word
assign WOut[31:24] = Byte3[A[7:2]];
assign WOut[23:16] = Byte2[A[7:2]];
assign WOut[15:8] = Byte1[A[7:2]];
assign WOut[7:0] = Byte0[A[7:2]];

SizeSelector sizeSelector(
.selector(size),
.S8(S8Out),
.S16(S16Out),
.W(WOut),
.U8(U8Out),
.U16(U16Out),
.out(RD)
);


always @(posedge clk)
begin
	if(WE) begin
		case(size)
			SigByte: begin 
						case(A[1:0])
							2'b00: begin Byte0[A[7:2]] <= WD[7:0]; end
							2'b01: begin Byte1[A[7:2]] <= WD[7:0]; end
							2'b10: begin Byte2[A[7:2]] <= WD[7:0]; end
							2'b11: begin Byte3[A[7:2]] <= WD[7:0]; end
						endcase
					end
			SigHalf: begin
						case(A[1:0])
							2'b00: begin
										Byte0[A[7:2]] <= WD[7:0];
										Byte1[A[7:2]] <= WD[15:8];
										end
							2'b01: begin 
										Byte1[A[7:2]] <= WD[7:0];
										Byte2[A[7:2]] <= WD[15:8];
										end
							2'b10: begin 
										Byte2[A[7:2]] <= WD[7:0];
										Byte3[A[7:2]] <= WD[15:8];
										end
						endcase
					end
			Word: begin
						Byte0[A[7:2]] <= WD[7:0];
						Byte1[A[7:2]] <= WD[15:8];
						Byte2[A[7:2]] <= WD[23:16];
						Byte3[A[7:2]] <= WD[31:24];
					end
		endcase
	end
	
	case(size)
		SigByte: begin
					case(A[1:0])
						2'b00: begin S8In <= Byte0[A[7:2]]; end
						2'b01: begin S8In <= Byte1[A[7:2]]; end
						2'b10: begin S8In <= Byte2[A[7:2]]; end
						2'b11: begin S8In <= Byte3[A[7:2]]; end
					endcase
				end
		SigHalf: begin
					case(A[1:0])
							2'b00: begin
										S16In[7:0] <= Byte0[A[7:2]];
										S16In[15:8] <= Byte1[A[7:2]];
										end
							2'b01: begin 
										S16In[7:0] <= Byte1[A[7:2]];
										S16In[15:8] <= Byte2[A[7:2]];
										end
							2'b10: begin 
										S16In[7:0] <= Byte2[A[7:2]];
										S16In[15:8] <= Byte3[A[7:2]];
										end
						endcase
				end
					
		UnByte: begin
					case(A[1:0])
						2'b00: begin U8In <= Byte0[A[7:2]]; end
						2'b01: begin U8In <= Byte1[A[7:2]]; end
						2'b10: begin U8In <= Byte2[A[7:2]]; end
						2'b11: begin U8In <= Byte3[A[7:2]]; end
					endcase
				end
		UnHalf: begin
					case(A[1:0])
							2'b00: begin
										U16In[7:0] <= Byte0[A[7:2]];
										U16In[15:8] <= Byte1[A[7:2]];
										end
							2'b01: begin 
										U16In[7:0] <= Byte1[A[7:2]];
										U16In[15:8] <= Byte2[A[7:2]];
										end
							2'b10: begin 
										U16In[7:0] <= Byte2[A[7:2]];
										U16In[15:8] <= Byte3[A[7:2]];
										end
						endcase
				end
	endcase
	$display(Byte0[64'd0]);
end


endmodule