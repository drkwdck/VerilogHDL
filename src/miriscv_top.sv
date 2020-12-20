module miriscv_top
#(
  parameter RAM_SIZE      = 256, // bytes
  parameter RAM_INIT_FILE = ""
)
(
  // clock, reset
  input clk_i,
  input rst_n_i
);

  wire  [31:0]  instr_rdata_core;
  wire  [31:0]  instr_addr_core;

  wire          data_gnt_core;
  wire          data_rvalid_core;
  wire  [31:0]  data_rdata_core;
  wire          data_req_core;
  wire          data_we_core;
  wire  [3:0]   data_be_core;
  wire  [31:0]  data_addr_core;
  wire  [31:0]  data_wdata_core;

  wire          data_gnt_ram;
  wire          data_rvalid_ram;
  wire  [31:0]  data_rdata_ram;
  wire          data_req_ram;
  wire          data_we_ram;
  wire  [3:0]   data_be_ram;
  wire  [31:0]  data_addr_ram;
  wire  [31:0]  data_wdata_ram;

  wire  data_mem_valid;
  assign data_mem_valid = (data_addr_core >= RAM_SIZE) ?  1'b0 : 1'b1;

  assign data_gnt_core    = (data_mem_valid) ? data_gnt_ram : 1'b0;
  assign data_rvalid_core = (data_mem_valid) ? data_rvalid_ram : 1'b0;
  assign data_rdata_core  = (data_mem_valid) ? data_rdata_ram : 1'b0;
  assign data_req_ram     = (data_mem_valid) ? data_req_core : 1'b0;
  assign data_we_ram      =  data_we_core;
  assign data_be_ram      =  data_be_core;
  assign data_addr_ram    =  data_addr_core;
  assign data_wdata_ram   =  data_wdata_core;

  riscv_cpu core (
    .clk_i   ( clk_i   ),
    .arstn_i ( rst_n_i ),

    .instr_rdata_i ( instr_rdata_core ),
    .instr_addr_o  ( instr_addr_core  ),

    .data_gnt_i    ( data_gnt_core    ),
    .data_rvalid_i ( data_rvalid_core ),
    .data_rdata_i  ( data_rdata_core  ),
    .data_req_o    ( data_req_core    ),
    .data_we_o     ( data_we_core     ),
    .data_be_o     ( data_be_core     ),
    .data_addr_o   ( data_addr_core   ),
    .data_wdata_o  ( data_wdata_core  )
  );

  miriscv_ram
  #(
    .RAM_SIZE      (RAM_SIZE),
    .RAM_INIT_FILE (RAM_INIT_FILE)
  ) ram (
    .clk_i   ( clk_i   ),
    .rst_n_i ( rst_n_i ),

    .instr_rdata_o ( instr_rdata_core ),
    .instr_addr_i  ( instr_addr_core  ),

    .data_gnt_o    ( data_gnt_ram    ),
    .data_rvalid_o ( data_rvalid_ram ),
    .data_rdata_o  ( data_rdata_ram  ),
    .data_req_i    ( data_req_ram    ),
    .data_we_i     ( data_we_ram     ),
    .data_be_i     ( data_be_ram     ),
    .data_addr_i   ( data_addr_ram   ),
    .data_wdata_i  ( data_wdata_ram  )
  );


endmodule
