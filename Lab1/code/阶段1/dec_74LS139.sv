`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/26 10:14:53
// Design Name: 
// Module Name: dec_74LS139
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

module dec_74LS139(
    input          S,
    input  [1: 0]  D,
    output [3: 0]  Y
    );
    
    logic [1: 0]  D;
    logic [3: 0]  Y;
    always_comb begin
        if (S==1'b1) Y=4'b1111;
        else if(S==1'b0) begin 
            Y=4'b1111;
            Y[D]=1'b0;
        end
    end
    
endmodule
