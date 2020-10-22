`timescale 1ns / 1ps

module registr_file_tb();
reg 	   	   clk;
reg  		   reset;
reg  [4:0] 	   A1;
reg  [4:0]	   A2;
reg  [4:0]     A3;
reg  [31:0]    WD3;
reg  		   WE;
wire [31:0]    RD1;
wire [31:0]    RD2;

rf registr_file_inst(
    .clk(clk), 
    .reset(reset), 
    .A1(A1), 
    .A2(A2), 
    .A3(A3),
    .WD3(WD3),
    .WE(WE),
    .RD1(RD1),
    .RD2(RD2)
);

initial begin
	clk = 1'b0;
	forever begin	
		#5 clk = ~clk;
	end
end


task registr_file_test;
	input integer A1_;
	input integer A2_;
	input integer A3_;
	input integer write_data;
	input integer WE_3;
	input integer RES;
	
	begin
		A1 = A1_;
		A2 = A2_;
		A3 = A3_;
		WD3 = write_data;
		WE = WE_3;
		reset = RES;

		#10;
		$display("a1\t= %d\n", A1, "a2\t= %d\n", A2,"a3\t= %d\n", A3, "we3\t= %d\n", WE_3, "reset\t= %d\n", RES, "rd1\t= %d\n", RD1, "rd2\t= %d\n", RD2);
	end 
endtask

initial begin
	registr_file_test(5'b11111, 5'b11111, 5'b00111, 32'hAAAAAAAA, 1, 0); // we = 1; reset = 0;
	#10;
	registr_file_test(5'b00111, 5'b11111, 5'b00110, 32'h0000FFFF, 1, 0); // we = 1; reset = 0;
	#10;
	registr_file_test(5'b00111, 5'b00110, 5'b00111, 32'h111105FA, 1, 0); // we = 1; reset = 0;
	#10;
	registr_file_test(5'b00111, 5'b00110, 5'b00111, 32'h11111111, 0, 1); // we = 0; reset = 1;
	#10;
	registr_file_test(5'b00111, 5'b00110, 5'b00111, 32'h11111111, 1, 0); // we = 1; reset = 0;
	#10;
	$stop;
end
endmodule
									  