module MainMemory(
input CLK,
//Data interface
input REQ,
output reg GNT,
output reg ERR,
output reg VALID,
//Writing interface
input WE,
input [3:0] Bytes,
input [31:0] AD,
input [31:0] WD,
//Reading interface
output reg [31:0] RD,

//Instructions interface
input [31:0] AI,
output [31:0] RI
);

localparam RamSize = 1024;
reg [31:0] RAM [0:RamSize - 1];

assign RI = RAM[AI[31:2]];

always @(posedge CLK)
begin

//Invalid address error
if(AD > (RamSize - 1)|| AI > (RamSize - 1)) begin
	ERR <= 1;
end
else begin
	ERR <= 0;
end

//GNT - begining of request processing
if(REQ && !GNT) begin
	GNT <= 1;
end
else begin
	GNT <= 0;
end

if(ERR !== 1) begin
	RD <= RAM[AD[31:2]];
	if(WE) begin
		if(RD === RAM[AD[31:2]]) begin
			VALID = 1;
			case(Bytes)
				//Store byte
				4'b0001: begin RAM[AD[31:2]][7:0] <= WD[7:0]; end
				4'b0010: begin RAM[AD[31:2]][15:8] <= WD[7:0]; end
				4'b0100: begin RAM[AD[31:2]][23:16] <= WD[7:0]; end
				4'b1000: begin RAM[AD[31:2]][31:24] <= WD[7:0]; end
				//Store half
				4'b0011: begin RAM[AD[31:2]][15:0] <= WD[15:0]; end
				4'b0110: begin RAM[AD[31:2]][23:8] <= WD[15:0]; end
				4'b1100: begin RAM[AD[31:2]][31:16] <= WD[15:0]; end
				//Store word
				4'b1111: begin RAM[AD[31:2]] <= WD; end
				default: begin ERR <= 1; end
			endcase
		end
		else begin
		VALID = 0;
		end
	end
end
else begin
	VALID <= 0;
	ERR <= 0;
end

end
	

endmodule