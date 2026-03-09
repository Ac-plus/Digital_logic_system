`timescale 1s / 1ms

`define CLK_PERIOD 4
module dig_clock_tb();
    logic sys_clk, sys_rst_n, i;
    logic [3:0] an;
    logic [7:0] a_to_g;
    dig_clock dut(.sys_clk(sys_clk),
                  .sys_rst_n(sys_rst_n),
                  .i(i),
                  .an(an),
                  .a_to_g(a_to_g)
                  );
                  
    initial begin
        sys_clk=0;
        sys_rst_n=0;
        i=0;
        #100;
        sys_rst_n=1;   
    end
 
    always #(`CLK_PERIOD/2) sys_clk = ~ sys_clk;
    
    initial begin
        @(posedge sys_rst_n);    @(posedge sys_clk);
        @(posedge sys_clk); i=1;
        @(posedge sys_clk); i=0;
        @(posedge sys_clk); i=1;
        @(posedge sys_clk); i=0;
        # 2000000000; 
        $finish;
    end
    
endmodule
