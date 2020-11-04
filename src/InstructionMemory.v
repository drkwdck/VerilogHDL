module InstructionMemory 
  #(
    parameter HIGHT = 4
  )
  (
    input [31:0]  adress,
    output [31:0] RD
  );

  reg [31:0] RAM [HIGHT:0];
  assign RD = RAM[adress];
  initial $readmemb ("File_mem.txt", RAM);

endmodule 