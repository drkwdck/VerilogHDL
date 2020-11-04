`timescale 1ms / 1ns

module MainTest();

reg clk;
reg reset;
reg [31:0] SW ;
wire [31:0] HEX;

Main MainUnitTest(
  .clk (clk),
  .reset (reset),
  .SW (SW),
  .HEX (HEX)
);

initial SW = 32'd30;

initial begin
  reset = 1;
  #2000000000;
  reset = 0;
  #2000000000;
end

initial begin
  clk = 1'b0;

  forever begin
    #1500000000
    clk = ~clk;
    $display("%d", HEX);
  end 
end
endmodule