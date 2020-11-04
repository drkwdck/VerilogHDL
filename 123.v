module Instuction_Memory #(parameter SIZE = 8)
(
    input [31:0] adr,
    output [31:0] Instr
);

reg [31:0] IM [SIZE:0];
assign Instr = IM[adr];

initial $readmemb("instruction_samples.txt", IM);

endmodule