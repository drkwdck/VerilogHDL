`timescale 1ns / 10ps
 module processor_tb();
 
 
reg 				clk;
reg				reset;
reg 	[31:0]		SW ;
wire	[31:0]	HEX;

all DUT(
	.clk   ( clk   ),
	.rst ( reset ),
	.SW	 ( SW    ),
	.HEX ( HEX   )
);

initial SW = 32'd30;

initial begin
reset = 1;
#20;
reset = 0;
#20;
end

initial begin
  clk = 1'b0;

  forever begin
  #15 clk = ~clk;
    $display("%b", HEX);
  end 
end



endmodule