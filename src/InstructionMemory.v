module InstructionMemory(
input [31:0] A,
output [31:0] Instr
);

reg [31:0] RAM [0:63];

initial begin
    $readmemh("Task.txt", RAM);
end

assign Instr = RAM[A[7:2]];

endmodule
