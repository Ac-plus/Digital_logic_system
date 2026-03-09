`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TJU
// Engineer: CMJ
// 
// Create Date: 2022/06/24 18:59:36
// Design Name: 
// Module Name: clken
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


module clken(
    input    sys_clk,
    input    sys_rst_n,
    output logic clk_flag 
    );
        localparam max=25000;
        int count;
        always_ff @(posedge sys_clk) begin
            if(!sys_rst_n) count<=0;
            else if(count==max-1)count<=0; 
            else count<=count+1;
        end
        always_ff @(posedge sys_clk)begin
            if(!sys_rst_n)clk_flag<=0;
            else if(count==max-1)clk_flag<=1;
            else clk_flag<=0;
        end
endmodule
