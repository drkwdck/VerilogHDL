module InstructionMemory 
#(
  parameter WIDTH_ADDR = 4,
  parameter WIDTH_DATA = 32
)
(
 input clk,
 input [WIDTH_DATA -1:0]  adress,   // address
 input [WIDTH_DATA -1:0]  writeData,  // Write Data
 input writeEnable,  // Write Enable
);

integer i;
initial $readmemb ("File_mem.txt",RAM);

reg [WIDTH_DATA -1:0] RAM [0:WIDTH_DATA -1];

assign RD_o =  ((adress >= 32'h63000000) && (adress <= 32'h630000fc)) ? RAM[adress[31:2]] : 0; 
             
always @(posedge clk) begin
	if((writeEnable)&&((adress >= 32'h63000000) && (adress <= 32'h630000fc))) RAM[adress[31:2]]<=writeData;	
end	

 
 endmodule 