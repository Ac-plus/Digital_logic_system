`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/26 10:14:53
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
    input [4: 0]  I,
    output        led
    );
    
    logic [3: 0] out_139;
    logic [7: 0] out0_138, out1_138, out2_138, out3_138;
    dec_74LS139 D24(.S(1'b0), .D(I[1: 0]), .Y(out_139));/////
    //initial #200;
    //logic [2:0] I1=I[4:2];
    //always_comb I1={I[4:2]};
    dec_74LS138 D38_0(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[0]), .Y(out0_138));
    dec_74LS138 D38_1(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[1]), .Y(out1_138));
    dec_74LS138 D38_2(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[2]), .Y(out2_138));
    dec_74LS138 D38_3(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[3]), .Y(out3_138));
    //logic led_00, led_01, led_10, led_11;
    logic [3 : 0] led_seg;  //led_seg[x]表示前两位为x的小项
    assign led_seg[0] = ~out0_138[7];
    assign led_seg[1] = ~out1_138[3] | ~out1_138[5] | ~out1_138[6] | ~out1_138[7];
    assign led_seg[2] = ~out2_138[3] | ~out2_138[5] | ~out2_138[6] | ~out2_138[7];
    assign led_seg[3] = |(~out3_138[7: 1]);
    
    
    assign led = |(led_seg[3: 0]);
    //assign led=led_seg[3]|led_seg[2]|led_seg[1]|led_seg[0];
    
endmodule