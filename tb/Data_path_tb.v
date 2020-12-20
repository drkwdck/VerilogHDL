`timescale 1ns/1ps

module Data_path_tb();
	reg  clk;
	reg  rst;

	Data_path Data_path_dut(clk, rst);
	
	integer i;
	task Data_path_task;		
		begin
			clk = 0;
			rst = 1;
			#10;
			clk = ~clk;
			#10;
			clk = ~clk;
			#10
			
			rst = 0;
			for(i = 0; i < 1000; i = i + 1) begin
				#10;
				clk = ~clk;
				#10;
				clk = ~clk;
			end
			$stop;
		end
	endtask

	initial begin
		#20;
		Data_path_task();
		#20;
	end	
endmodule