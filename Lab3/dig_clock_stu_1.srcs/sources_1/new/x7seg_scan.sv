`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 19:20:07
// Design Name: 
// Module Name: x7seg_scan
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module x7seg_scan(
        input sys_clk ,
        input sys_rst_n,
        input  clk_flag,
        input [7 : 0] min,
        input [7 : 0] sec,
        output logic [3 : 0] data,
        output logic [3 : 0] an
    );
    int i;
    logic [1:0]state=0;
    always_ff @(posedge sys_clk)begin
        if(!sys_rst_n)begin
            data<=0;
            an<=0;
            state<=0;
        end else if(clk_flag)begin
                    state<=state+1;
                        for(i=0;i<4;i++)begin
                            if(state==i)begin
                                an[i]<=1;
                            end else begin
                                an[i]<=0;
                            end
                        end
                case(state)
                    0:data<=sec[3:0];
                    1:data<=sec[7:4];
                    2:data<=min[3:0];
                    3:data<=min[7:4];
                endcase
        end      
    end
endmodule
