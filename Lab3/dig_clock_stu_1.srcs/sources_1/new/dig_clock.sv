`timescale 1ns/1ps

module dig_clock(
    input                   sys_clk,
    input                   sys_rst_n,
    input                   i,
    output logic [3 : 0]    an,
    output logic [7 : 0]    a_to_g
    );
    
    logic        clk_1MS;
    logic        start_flag;
    logic [7 : 0]    min, sec, bcd_min, bcd_sec;
    logic [3 : 0]    data;

    clken clken( 
        .sys_clk    (sys_clk)   ,
        .sys_rst_n  (sys_rst_n) ,
        .clk_flag   (clk_1MS)
    );

    edge_detect detect(
        .sys_clk    (sys_clk)   ,
        .sys_rst_n  (sys_rst_n) ,
        .i   (i),
        .start_flag (start_flag)
    );

    timer timer(
        .sys_clk    (sys_clk),
        .sys_rst_n    (sys_rst_n),
        .start_flag    (start_flag),
        .min    (min),
        .sec    (sec)
    );

    bin2bcd_0 bcd1(
        .bin    (min),
        .bcd    (bcd_min)
    );
    bin2bcd_0 bcd2(
        .bin    (sec),
        .bcd    (bcd_sec)
    );

    x7seg_scan scan(
        .sys_clk    (sys_clk)   ,
        .sys_rst_n  (sys_rst_n) ,
        .clk_flag   (clk_1MS)   ,
        .min        (bcd_min)       ,
        .sec        (bcd_sec)       ,
        .data       (data),
        .an         (an)
    );
    
    x7seg_dec dec(
        .D      (data),
        .a_to_g (a_to_g)    
    );
endmodule
