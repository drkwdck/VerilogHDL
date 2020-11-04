`timescale 1ns/1ps

module MainTest();
    reg  clk;
    reg  rst;
    reg [31:0] SW;
    wire  [31:0] HEX;

    Prog_device Prog_device_dut(clk, rst, SW, HEX);

    integer i;
    task Prog_device_task;
        input [31:0] SW_tb;

        begin
            SW = SW_tb;
            clk = 0;
            rst = 1;
            for(i = 0; i < 3; i = i + 1) begin
                #10;
                clk = ~clk;
                #10;
                clk = ~clk;
            end
            rst = 0;
            for(i = 0; i < 1000; i = i + 1) begin
                #10;
                clk = ~clk;
                #10;
                clk = ~clk;
            end
            $display("Minor bit equal to 0 in number %b is: %d\n", SW_tb, HEX);
            #10;
            clk = ~clk;
            #10;
            clk = ~clk;
        end
    endtask

    initial begin
        #10;
        Prog_device_task(32'b10111011);
        #10;
        Prog_device_task(32'b111000);
        #10;
        Prog_device_task(32'b101111111111);
        #10;
        Prog_device_task(32'b1111111111111111);
        #10;
        Prog_device_task(32'hef);
        $stop;
    end
endmodule
