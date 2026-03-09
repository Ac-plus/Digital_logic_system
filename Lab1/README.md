# 多数表决器的设计与实现
# 一．	实验目的
1. 掌握基于 Vivado 的数字逻辑电路设计流程； 
2. 熟练使用 SystemVerilog HDL 的行为建模方法对组合逻辑电路进行描述； 
3. 熟练使用 SystemVerilog HDL 的结构建模方法对组合逻辑电路进行描述； 
4. 掌握基于远程 FPGA 硬件云平台对数字逻辑电路进行功能验证的流程。

# 二．	实验内容
假如有五个举重裁判，举重选手完成比赛后，当有多数裁判认定成功时，则成功；否则失败。本次实验设计此举重裁决电路，即一个5输入的多数表决器。该电路的顶层模块如图1所示，输入/输出端口如表1所示。使用拨动开关来模拟裁判的裁定，使用LED灯来显示是否成功。

<img width="485" height="162" alt="image" src="https://github.com/user-attachments/assets/3e486cbc-97f0-4aa9-b0aa-837b3550d837" />

图1 多数表决器端口示意图                                 

<img width="501" height="194" alt="image" src="https://github.com/user-attachments/assets/4bc7cc37-82aa-4835-be7b-070e9e87a7b7" />

表1 

本实验分为两阶段任务，每个阶段均是完成一个5输入多数表决器的设计，但采用的设计方法不同。具体实验内容如下所示： 

阶段 1（基于集成电路模块）：
1. 采用行为建模方法，完成74LS138和74LS139两种译码器的设计；
2. 基于结构化建模方法，调用74LS138和74LS139两种译码器，以及若干基本逻辑门，完成5输入多数表决器电路的设计，并基于Vivado完成行为仿真、综合、实现、生成比特流文件等操作，最终在远程 FPGA 硬件云平台上完成功能验证。
   
阶段 2（基于行为建模）：不使用74LS138和74LS139芯片，直接使用行为建模完成5输入多数表决器电路的设计，并基于Vivado完成电路的行为仿真、综合、实现、生成比特流文件等操作，最终在远程FPGA硬件云平台上完成功能验证。

# 三．实验原理与步骤（注：步骤不用写工具的操作步骤，而是设计步骤）
1. 写出74LS138和74LS139的行为建模的SystemVerilog HDL代码。

（1）74LS138芯片
```
module dec_74LS138(
    input  [2: 0]  D,
    input          G,
    input          G_2A,
    input          G_2B,
    output [7: 0]  Y
    );
    logic [7: 0] Y;
    always_comb begin 
        if (!(G==1'b1 && G_2A==1'b0 && G_2B==1'b0))
            Y=8'b11111111;
        else begin 
            Y=8'b11111111;
            Y[D]=1'b0;
        end
end
endmodule
```

（2）74LS139芯片
```
module dec_74LS139(
    input          S,
    input  [1: 0]  D,
    output [3: 0]  Y
    );
    logic [1: 0]  D;
    logic [3: 0]  Y;
    always_comb begin
        if (S==1'b1) Y=4'b1111;
        else if (S==1'b0) begin 
            Y=4'b1111;
            Y[D]=1'b0;
        end
    end 
endmodule
```

2. 给出基于74LS138和74LS139的5输入多数表决器的设计方案，画出原理图（采用Visio画图）。

设计方案：首先将I的5位信号分成前两位和后三位，分别对应2-4译码器和3-8译码器。然后根据2-4译码器的四个输出端out24[3:0]的不同的值作为分别作为四个3-8译码器的使能端，即：将out24[0]到out24[3]分别连接至四个3-8译码器的G2B使能端口，并将G和G2A分别设为1和0。这样当I[1:0]=0,1,2,3时就可将I的前两位分别传递至四个3-8译码器的端口，则第k(k=0,1,2,3)个3-8译码器就可表示I[1:0]=k的I的最小项。最后将所有符合条件的I的最小项相加即可。

原理图：

<img width="964" height="840" alt="image" src="https://github.com/user-attachments/assets/767f890c-49bd-454a-8e98-fdf403fea099" />

如图2所示，右侧的几个或门表示由3-8译码器导出的若干小项逻辑相加（由于译码器输出的有效位为低电平，所以要在输出时先加上非门）；左侧输入信号的2-4位连到每个3-8译码器上，第0-1位连到2-4译码器上，然后将2-4译码器的输出分别连接上3-8译码器的G2B使能端。


3. 写出5输入多数表决器的结构化建模的SystemVerilog HDL代码。
```
module voter5(
    input   [4 : 0]  I,
    output         led
    );
    logic [3: 0] out_139;
    logic [7: 0] out0_138, out1_138, out2_138, out3_138;
    dec_74LS139 D24(.S(1'b0), .D(I[1: 0]), .Y(out_139));
    dec_74LS138 D38_0(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[0]), .Y(out0_138));
    dec_74LS138 D38_1(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[1]), .Y(out1_138));
    dec_74LS138 D38_2(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[2]), .Y(out2_138));
    dec_74LS138 D38_3(.D(I[4:2]), .G(1'b1), .G_2A(1'b0), .G_2B(out_139[3]), .Y(out3_138));
    
    logic [3 : 0] led_seg;  //led_seg[x]表示前两位为x的小项
    assign led_seg[0] = ~out0_138[7];
    assign led_seg[1] = ~out1_138[3] | ~out1_138[5] | ~out1_138[6] | ~out1_138[7];
    assign led_seg[2] = ~out2_138[3] | ~out2_138[5] | ~out2_138[6] | ~out2_138[7];
assign led_seg[3] = |(~out3_138[7: 1]);
assign led = |(led_seg[3: 0]); 
endmodule
```
4. 给出基于行为建模的5输入多数表决的SystemVerilog HDL代码。
```
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
```

# 四．仿真与实验结果（注：仿真需要给出波形图截图，截图要清晰，如果波形过长，可以分段截取；实验结果为远程FPGA硬件云平台的截图）
1. Vivado波形图仿真结果

<img width="934" height="138" alt="image" src="https://github.com/user-attachments/assets/f6dddbf3-c5a7-494a-90aa-5c4a038400a4" />

(a) 

<img width="936" height="126" alt="image" src="https://github.com/user-attachments/assets/3567a108-291d-4ba0-8259-846ac84ab5e8" />

(b) 

图3  Vivado仿真波形图

阶段一和阶段二的voter5波形图相同，均如图3(a)、图3(b)所示。由此可知当I的值从5’b00000(0x00)变化至5’b11111(0x1f)时，共出现16次高电平输出，分别在07、0b、0d、0e、0f、13、15、16、17、19、1a、1b、1c、1d、1e和1f的取值处，与表决器真值表核对后均为正确结果。

2. FPGA硬件平台测试结果

<img width="681" height="233" alt="image" src="https://github.com/user-attachments/assets/67a14ac7-4b71-4fcf-8f38-0a60fd74e19b" />

图4 用FPGA搭建的表决器模型图

在FPGA平台作上板模拟，烧写后运行程序得到多数表决器的模拟实物图。如图4所示，给出的是测试向量I=5'b01101的结果。可见当有三个裁判（I[0]、I[2]、I[3]）表决通过时，LED灯能按要求正常发亮。

# 五．实验中遇到的问题和解决办法

实验中遇到的问题和对应的解决方法如下：

1. 开始安装Vivado软件时插件少装了一个，后来重新卸载安装即解决了该问题。
2. 实验中，在进行完Synthesis测试后提示无法进行Run Implementation的报错，于是在网上进行查询，发现这是由于约束文件里注释不能和代码在同一行所致，按提示修改约束文件后问题得到解决。
3. 将第一阶段的电路图转化为voter5.sv代码后，Vivado仿真波形一直无法输出正确的值。为了解决这个问题，对2-4译码器和3-8译码器都编写了测试程序，发现均能正确输出结果，这说明问题出在多个译码器“拼接”的过程中。仔细检查代码，发现将2-4译码器的使能端误设成了1，导致后续输出无法进行。修改后问题即得到解决。

总结：本实验初步锻炼了我们处理sv建模的能力。在建模、编写代码和debug的过程中，我们的能力也得到了提升，尤其是一些课堂上没有完全掌握的东西，比如测试程序的编写，也通过实验得到了巩固。
