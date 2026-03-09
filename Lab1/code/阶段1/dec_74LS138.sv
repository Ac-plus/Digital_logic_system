`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/26 10:14:53
// Design Name: 
// Module Name: dec_74LS138
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


module dec_74LS138(
    input [2: 0]  D,
    input         G,
    input         G_2A,
    input         G_2B,
    output [7: 0] Y
    );
    
    logic [7: 0] Y;
    always_comb begin 
        if (!(G==1'b1 && G_2A==1'b0 && G_2B==1'b0))
            Y=8'b11111111;
        else if (G==1'b1 && G_2A==1'b0 && G_2B==1'b0) 
        begin 
            Y=8'b11111111;
            Y[D]=1'b0;
        end
    end
    
endmodule
