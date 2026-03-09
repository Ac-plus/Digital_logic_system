`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 19:01:41
// Design Name: 
// Module Name: edge_detect
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


module edge_detect(
        input  sys_clk,
        input sys_rst_n,
        input i,
        output logic start_flag
    );
    
        logic a;
        logic b;
        logic startEdge;
        always_ff @(posedge sys_clk)begin
          if(!sys_rst_n)begin
            a<=0;
            b<=0;
          end
          else begin
            a<=i; 
            b<=a;
          end 
        end    
        assign startEdge=(a&(~b));
        always_ff @(posedge sys_clk)begin
            if(!sys_rst_n)begin
                start_flag<=0;
            end
            else if(startEdge)begin
                start_flag<=~start_flag;
            end
            else start_flag<=start_flag;
        end
endmodule
