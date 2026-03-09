`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/25 20:55:44
// Design Name: 
// Module Name: voter5
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


module voter5(
    input   [4: 0]  I,
    output          led
    );
    
    logic led;
    always_comb begin 
        int cnt;  
        cnt=0;
        for (int i=0; i<5; i++)
            if (I[i]==1) cnt++;
        led=(cnt>=3)? 1: 0;
    end
    
endmodule