`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/24 19:01:41
// Design Name: 
// Module Name: 
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

module timer(
        input sys_clk,
        input sys_rst_n,
        input start_flag,
        output logic [7 : 0]    min,
        output logic [7 : 0]    sec
    );  
    localparam max = 25000000;
    int count;
    logic flag;
  always_ff @(posedge sys_clk)begin
        if(!sys_rst_n)begin
            min<=0;
            sec<=0;
            count<=0;
        end 
        else if(start_flag)begin
            sec<=sec;
            min<=min;
            count<=count;
        end      
        else if(count==max-1)begin
            count<=0;
            if(sec==59)begin
                sec<=0;
                min<=min+1;
            end
            else if(sec<59)sec<=sec+1;
            else if(min==59)begin 
                min<=0;
                sec<=0;
            end
        end       
        else begin
            count<=count+1;
        end   
    end
endmodule