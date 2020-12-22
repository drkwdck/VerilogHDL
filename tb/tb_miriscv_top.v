`timescale 1ns / 1ps

module tb_miriscv_top();

  parameter     HF_CYCLE = 2.5;       // 200 MHz clock
  parameter     RST_WAIT = 10;         // 10 ns reset
  parameter     RAM_SIZE = 512;       // in 32-bit words

  // clock, reset
  reg clk;
  reg rst;

  miriscv_top #(
    .RAM_SIZE       ( RAM_SIZE           ),
    .RAM_INIT_FILE  ( "/home/drkwdck/VerilogHDL/ram_samples.txt" )
  ) dut (
    .clk_i    ( clk ),
    .rst_n_i  ( rst )
  );

	integer i;
	task miriscv_top_task;		
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
		miriscv_top_task();
		#20;
	end	

initial begin
	$dumpfile("/home/drkwdck/VerilogHDL/tb.vcd");
   $dumpvars(0,tb_miriscv_top);

end

endmodule
