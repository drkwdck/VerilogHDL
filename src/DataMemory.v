module DataMemory(
input clk,
input WE,
input [2:0] size,
input [31:0] WD,
input [31:0] A,
output [31:0] RD
);
reg [15:0] unsigned16input;
reg [15:0] S16In;
reg [7:0] unsigned8input;
reg [7:0] signed8input;

wire [31:0] unsigned16ouput;
assign unsigned16ouput[15:0] = unsigned16input;
assign unsigned16ouput[31:16] = {16'b0};

wire [31:0] signed16Out;
assign signed16Out[15:0] = S16In;
assign signed16Out[31:16] = {16{S16In[15]}};

wire [31:0] unsigned8out;
assign unsigned8out[7:0] = unsigned8input;
assign unsigned8out[31:8] = {24'b0};

wire [31:0] signed8output;
assign signed8output[7:0] = signed8input;
assign signed8output[31:8] = {24{signed8input[7]}};

wire [31:0] WOut;

reg [7:0] zerByte [0:63];
reg [7:0] firtsByte [0:63];
reg [7:0] secondByte [0:63];
reg [7:0] thirdByte [0:63];

integer i;
reg [31:0] temporaryReader[0:15];
initial begin
	for (i = 0; i < 64; i = i + 1) begin
		zerByte[i] = 8'd0;
		firtsByte[i] = 8'd0;
		secondByte[i] = 8'd0;
		thirdByte[i] = 8'd0;
		temporaryReader[i] = 64'd0;
	end

	$readmemb("load_consts.txt", temporaryReader);

	for (i = 0; i < 64; i = i + 1) begin
		zerByte[i] = temporaryReader[i][7:0];
		firtsByte[i] = temporaryReader[i][15:8];
		secondByte[i] = temporaryReader[i][23:16];
		thirdByte[i] = temporaryReader[i][31:24];
	end
end

localparam SigByte = 3'd0;
localparam SigHalf = 3'd1;
localparam Word = 3'd2;
localparam UnByte = 3'd4;
localparam UnHalf = 3'd5;
	
assign WOut[31:24] = thirdByte[A[7:2]];
assign WOut[23:16] = secondByte[A[7:2]];
assign WOut[15:8] = firtsByte[A[7:2]];
assign WOut[7:0] = zerByte[A[7:2]];

reg [31:0] rdChanel;
assign RD = rdChanel;
always @(*) begin
case(size)
	3'd0: begin
		rdChanel <= signed8output; 
	end
	
	3'd1: begin
		rdChanel <= signed16Out;
	end

	3'd2: begin
		rdChanel <= WOut; 
	end

	3'd4: begin
		rdChanel <= unsigned8out; 
	end

	3'd5: begin
		rdChanel <= unsigned16ouput; 
	end
endcase
end

always @(posedge clk)
begin
	if(WE) begin
		case(size)
			SigByte: begin 
						case(A[1:0])
							2'b00: begin zerByte[A[7:2]] <= WD[7:0]; end
							2'b01: begin firtsByte[A[7:2]] <= WD[7:0]; end
							2'b10: begin secondByte[A[7:2]] <= WD[7:0]; end
							2'b11: begin thirdByte[A[7:2]] <= WD[7:0]; end
						endcase
					end
			SigHalf: begin
						case(A[1:0])
							2'b00: begin
										zerByte[A[7:2]] <= WD[7:0];
										firtsByte[A[7:2]] <= WD[15:8];
										end
							2'b01: begin 
										firtsByte[A[7:2]] <= WD[7:0];
										secondByte[A[7:2]] <= WD[15:8];
										end
							2'b10: begin 
										secondByte[A[7:2]] <= WD[7:0];
										thirdByte[A[7:2]] <= WD[15:8];
										end
						endcase
					end
			Word: begin
						zerByte[A[7:2]] <= WD[7:0];
						firtsByte[A[7:2]] <= WD[15:8];
						secondByte[A[7:2]] <= WD[23:16];
						thirdByte[A[7:2]] <= WD[31:24];
					end
		endcase
	end

	case(size)
		SigByte: begin
					case(A[1:0])
						2'b00: begin signed8input <= zerByte[A[7:2]]; end
						2'b01: begin signed8input <= firtsByte[A[7:2]]; end
						2'b10: begin signed8input <= secondByte[A[7:2]]; end
						2'b11: begin signed8input <= thirdByte[A[7:2]]; end
					endcase
				end
		SigHalf: begin
					case(A[1:0])
							2'b00: begin
										S16In[7:0] <= zerByte[A[7:2]];
										S16In[15:8] <= firtsByte[A[7:2]];
										end
							2'b01: begin 
										S16In[7:0] <= firtsByte[A[7:2]];
										S16In[15:8] <= secondByte[A[7:2]];
										end
							2'b10: begin 
										S16In[7:0] <= secondByte[A[7:2]];
										S16In[15:8] <= thirdByte[A[7:2]];
										end
						endcase
				end
					
		UnByte: begin
					case(A[1:0])
						2'b00: begin unsigned8input <= zerByte[A[7:2]]; end
						2'b01: begin unsigned8input <= firtsByte[A[7:2]]; end
						2'b10: begin unsigned8input <= secondByte[A[7:2]]; end
						2'b11: begin unsigned8input <= thirdByte[A[7:2]]; end
					endcase
				end
		UnHalf: begin
					case(A[1:0])
							2'b00: begin
										unsigned16input[7:0] <= zerByte[A[7:2]];
										unsigned16input[15:8] <= firtsByte[A[7:2]];
										end
							2'b01: begin 
										unsigned16input[7:0] <= firtsByte[A[7:2]];
										unsigned16input[15:8] <= secondByte[A[7:2]];
										end
							2'b10: begin 
										unsigned16input[7:0] <= secondByte[A[7:2]];
										unsigned16input[15:8] <= thirdByte[A[7:2]];
										end
						endcase
				end
		
	endcase
	$display({thirdByte[64'd0],secondByte[64'd0], firtsByte[64'd0], zerByte[64'd0]});
end
endmodule