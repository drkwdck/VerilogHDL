module miriscv_lsu(  
  
input clk_i,
input arstn_i,
  
// memory protocol   
input data_gnt_i,
input data_rvalid_i,
input [31 :0] data_rdata_i,

output data_req_o,
output data_we_o,
output reg [3:0] data_be_o,
output [31 :0] data_addr_o,
output reg [31 :0] data_wdata_o,

// core protocol   
input [31 :0] lsu_addr_i,   
input lsu_we_i,
input [2:0] lsu_size_i,
input [31 :0] lsu_data_i,
input lsu_req_i,
input lsu_kill_i,

output reg lsu_stall_req_o,
output reg [31 :0] lsu_data_o
);

assign data_addr_o = {lsu_addr_i[31:2], 2'b00};

reg [7:0] SB;
wire [31:0] LB = {{24{SB[7]}},SB};
wire [31:0] LBU = {24'b0 , SB};

reg [15:0] SH;
wire [31:0] LH = {{16{SH[15]}},SH};
wire [31:0] LHU = {16'b0 ,SH};

assign data_req_o = lsu_req_i;
assign data_we_o = lsu_we_i;

always @(*)
begin

if(arstn_i) begin
	lsu_stall_req_o <= 0;
end
else begin
	lsu_stall_req_o <= 0;
	
		if(data_gnt_i === 1) begin
			lsu_stall_req_o <= 1;
			if(data_rvalid_i === 1) begin
				lsu_stall_req_o <= 0;
			end
		end
		
		if(lsu_we_i) begin
			lsu_data_o <= data_rdata_i;
			case(lsu_size_i)
				3'd0: begin 
							case(lsu_addr_i[1:0])
								2'b00: begin
											data_be_o <= 4'b0001; 
											data_wdata_o <= {24'b0, lsu_data_i[7:0]};
										end
								2'b01: begin 
											data_be_o <= 4'b0010; 
											data_wdata_o <= {16'b0, lsu_data_i[7:0], 8'b0};
										end
								2'b10: begin
											data_be_o <= 4'b0100; 
											data_wdata_o <= {8'b0, lsu_data_i[7:0], 16'b0};
										end
								2'b11: begin
											data_be_o <= 4'b1000; 
											data_wdata_o <= {lsu_data_i[7:0], 24'b0};
										end
							endcase
						end
				3'd1: begin 
							case(lsu_addr_i[1:0])
								2'b00: begin 
											data_be_o <= 4'b0011; 
											data_wdata_o <= {16'b0, lsu_data_i[15:0]};
										end
								2'b10: begin 
											data_be_o <= 4'b1100; 
											data_wdata_o <= {lsu_data_i[15:0], 16'b0};
										end
								default: begin data_be_o <= 4'b1001; end //Error
							endcase
						end
				3'd2: begin 
							data_be_o <= 4'b1111; 
							data_wdata_o <= lsu_data_i;
						end
				default: begin data_be_o <= 4'b1001; end //Error
			endcase
		end
		else begin
			case(lsu_size_i)
				3'd0: begin //Signed byte
							lsu_data_o <= LB;
							case(lsu_addr_i[1:0])
								2'b00: begin SB <= data_rdata_i[7:0]; end
								2'b01: begin SB <= data_rdata_i[15:8]; end
								2'b10: begin SB <= data_rdata_i[23:16]; end
								2'b11: begin SB <= data_rdata_i[31:24]; end
							endcase
						end
				3'd1: begin //Signed half
							lsu_data_o <= LH;
							case(lsu_addr_i[1:0])
								2'b00: begin SH <= data_rdata_i[15:0]; end
								2'b10: begin SH <= data_rdata_i[31:16]; end
							endcase
						end
				3'd2: begin //Word
							lsu_data_o <= data_rdata_i;
						end
				3'd4: begin //Unsigned byte
							lsu_data_o <= LBU;
							case(lsu_addr_i[1:0])
								2'b00: begin SB <= data_rdata_i[7:0]; end
								2'b01: begin SB <= data_rdata_i[15:8]; end
								2'b10: begin SB <= data_rdata_i[23:16]; end
								2'b11: begin SB <= data_rdata_i[31:24]; end
							endcase
						end
				3'd5: begin //Unsigned half
							lsu_data_o <= LHU;
							case(lsu_addr_i[1:0])
								2'b00: begin SH <= data_rdata_i[15:0]; end
								2'b10: begin SH <= data_rdata_i[31:16]; end
							endcase
						end
			endcase
		
	end
end

end



endmodule