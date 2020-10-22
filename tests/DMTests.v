`timescale 1ns/1ps
module data_memory_tb (
);
		reg 	   	  clk;
		reg  [31:0]	  A;
		reg  [31:0]   WD;
		reg 		     WE;
		
		wire [31:0]    RD;
		
DM DUT(
	.clk    ( clk    ),
	.A      ( A      ),
	.WD     ( WD     ),
	.WE     ( WE     ),
	.RD     ( RD     )
);

task dm_test;
	input integer adress_tb;
	input integer wd_tb;
	input integer we_tb;
	begin
		A  = adress_tb;
		WD = wd_tb;
		WE = we_tb;
		#20;
		$display("adres\t= %d\n", adress_tb, "wd\t= %d\n", wd_tb, "we\t= %d\n", we_tb);
	end
endtask


initial begin
    clk = 1'b0;
    forever begin
		#20 clk = ~clk;
	 end
end

initial begin
	dm_test(32'h10000000, 32'h11111111, 1); //Wrong Adress, we=1
	#30;
	dm_test(32'h10000000, 32'h11111111, 0); //Wrong Adress, we=0
	#30;
	dm_test(32'h47000011, 32'h11111111, 1); //Suitable Adress, we=1
	#30;
	dm_test(32'h47000011, 32'h11111111, 0); //Suitable Adress, we=0
	#30;
	dm_test(32'h00000101, 32'h11111111, 1); //Wrong Adress, we=1
	#30;
	dm_test(32'h10000101, 32'h11111111, 0); //Wrong Adress, we=0
	#30;
	dm_test(32'h47000000, 32'h11111111, 1); //Suitable Adress, we=1
	#30;
	dm_test(32'h47000000, 32'h11111111, 0); //Suitable Adress, we=0
	$stop;
end

endmodule