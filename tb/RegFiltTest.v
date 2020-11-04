`timescale 1ns / 1ps

module RegFiltTest();
reg 	   	   clk;
reg  		   reset;
reg  [4:0] 	   A1;
reg  [4:0]	   A2;
reg  [4:0]     A3;
reg  [31:0]    WD3;
reg  		   WE;
wire [31:0]    RD1;
wire [31:0]    RD2;

RF reg_file(
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


task unit_test_task;
	input integer A1_;
	input integer A2_;
	input integer A3_;
	input integer WD3_;
	input integer WE_;
	input integer reset_;	
	input integer expected_A1;
	input integer expected_A2;
	input integer expected_A3;
	input integer expected_RD1;
	input integer expected_RD2;

	begin
		A1    = A1_;
		A2    = A2_;
		A3    = A3_;
		WD3   = WD3_;
		WE    = WE_;
		reset = reset_;

		#10;
		$display("A1 = %d\n", A1, "A2 = %d\n", A2,"A3 = %d\n", A3, "WE = %d\n",
			WE, "WD = %d\n", WD3, "reset = %d\n", reset_, "RD1 = %d\n", RD1, "RD2 = %d", RD2);

		if ((A1 == expected_A1) && (A2 == expected_A2) && (A3 == expected_A3)) begin
			// если запись
			if (WE) begin
				$display("good");				
			end
			
			// если чтение, проверяем, что в RD1 и RD 2 лежат нужные данные
			else begin
				if ((RD1 == expected_RD1) && (RD2 == expected_RD2)) begin
					$display("good");
				end
				else
					$display("bad");
			end
		end

		else begin
			$display("bad");
		end
		$display("-------------\n");
	end 
endtask

initial begin
	// reset
	unit_test_task(7, 31, 6, 2, 0, 1, // input
		7, 31, 6, 0, 0); // expected
	#10;

	// Записал
	unit_test_task(7, 31, 6, 2, 1, 0, // input
		7, 31, 6, 1, 1); // expected
	#10;

 	// Считал
	unit_test_task(6, 31, 6, 2 , 0, 0, // input
	6, 31, 6, 1, 1); // expected	
	#10;

	// reset
	unit_test_task(7, 31, 6, 2, 1, 0, 
		7, 31, 6, 1, 1); // expected
	#10;

	// проверим, что RD1 сбросился
	unit_test_task(7, 31, 6, 2, 0, 0, 
		7, 31, 6, 0, 0); // expected

	// Запишем что-нибудь 
	unit_test_task(7, 31, 8, 2, 1, 0, 
		7, 31, 8, 0, 0); // expected

	// Считаем 
	unit_test_task(7, 8, 8, 2, 0, 0, 
		7, 8, 8, 0, 2); // expected
	
	$stop;
end
endmodule
									  