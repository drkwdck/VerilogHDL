`timescale 1ns/1ps

module Register_file_tb();
	reg  clk;
	reg  WE3;
	reg  rst;
	reg  [4:0]  A1;
	reg  [4:0]  A2;
	reg  [4:0]  A3;
	wire [31:0] RD1;
	wire [31:0] RD2;
	reg  [31:0] WD3;
	Register_file Register_file_dut(clk, WE3, rst, A1, A2, A3, RD1, RD2, WD3);

	reg [31:0] Input_data [0:31];
	
	task Register_file_task;
	
		input clk_tb;
		input WE3_tb;
		input rst_tb;
		input [4:0] A1_tb;
		input [4:0] A2_tb;
		input [4:0] A3_tb;
		input [31:0] WD3_tb;
		input [31:0] comp;
		
		begin
			clk = clk_tb;
			WE3 = WE3_tb;
			rst = rst_tb;
			A1 = A1_tb;
			A2 = A2_tb;
			A3 = A3_tb;
			WD3 = WD3_tb;
			#10;
			clk = ~clk;
			#10;
			clk = ~clk;
			case(WE3)
			
				0: begin
					$display("A number was read at address 0x%h: %d", A1, $signed(RD1));
					if (RD1 == comp) $display("good\n");
					else $error("bad\n");
					end
			
				1: $display("A number was wrote at address 0x%h: %d\n", A3, $signed(WD3));
				
			endcase
		end
	endtask

	integer i, X0, X1, a, c, m;
	initial begin
		X0 = 44;
		a = 3;
		c = 177;
		m = 201;
		Input_data[0] <= 0;
		for(i = 1; i < 32; i = i + 1) begin
			X1 = (a*X0 + c)%m;
			X0 = X1;
			Input_data[i] <= X1; 
		end
		for(i = 0; i < 32; i = i + 1) begin
			$display("%d", Input_data[i]);
			Register_file_task(0, 1, 0, 0, 0, i, Input_data[i], 0);
		end
		for(i = 0; i < 32; i = i + 1) 
			Register_file_task(0, 0, 0, i, i, 0, 0, Input_data[i]);
	end	
endmodule