# 算术逻辑单元ALU的设计与实现

# 一．	实验目的

1.掌握全加器和行波进位加法器的结构；
2.熟悉加减法运算及溢出的判断方法；
3.掌握算术逻辑单元（ALU）的结构；
4.熟练使用SystemVerilog HDL的行为建模和结构化建模方法对ALU进行描述实现；
5.为“单周期MIPS处理器的设计与实现”打下基础。
    
# 二．	实验内容

1.基于SystemVerilog设计并实现一个4位ALU单元。整个工程的顶层模块如图2-1所示。右侧连接一个七段数码管动态扫描电路，已经实现完毕。

<img width="331" height="222" alt="image" src="https://github.com/user-attachments/assets/d0ac6447-7ae6-46c1-956f-c75a7e8528aa" />

图2-1 实验顶层模块示意图

2.本实验的输入/输出端口如表2-1所示，ALU运算单元所支持的运算功能如表2-2所示。注意，顶层模块由两个子模块组成，其中一个是ALU单元，另一个是7段数码管动态显示扫描单元。

<img width="720" height="506" alt="image" src="https://github.com/user-attachments/assets/ec95151b-1b57-4cd0-8c01-0d937bc45a5a" />

<img width="725" height="705" alt="image" src="https://github.com/user-attachments/assets/3f92d14a-c7b4-4116-83fa-094386d4baba" />

# 三．实验原理与步骤（注：步骤不用写工具的操作步骤，而是设计步骤）

## 1. 画出实现加/减法运算的逻辑电路原理图，并说明为什么加/减法可以只使用一个加法器进行实现？

本实验的加减法电路原理图如图3-1所示。A，B是4位宽的输入端，Cin是进位输入端，Sout和Cout为组合成的输出端。

<img width="942" height="958" alt="image" src="https://github.com/user-attachments/assets/118c9c4d-0f46-4519-8ee0-eb7bff9888e8" />

图3-1(a) 四位进位加法器

图3-1(a)是本实验所使用的4位加法器的原理图。FADD1是1位进位加法器，其原理图如图3-2(b)所示。使用了若干基本逻辑门实现，输入和输出端口的含义与四位加法器相同。

<img width="914" height="389" alt="image" src="https://github.com/user-attachments/assets/05e2460c-bcb3-414f-b1ce-b49ab857574f" />

图3-1(b) 一位进位加法器
由图可知，若要实现A + B，只要输入加数A、B，初始时Cin设置为0（A + B + 0）即可；若要实现A - B，也就是A + (~B + 1)，只要输入加数A、~B，初始时Cin设置为1即可。所以加减法都可用这个元件实现。

## 2. 给出有符号数加/减法溢出的判断规则。

在SV程序中，使用了行为建模方式。如果两个正数相加得到的结果为负数，或两个负数相加得到正数，则说明溢出。

<img width="887" height="132" alt="image" src="https://github.com/user-attachments/assets/346afa04-0f8c-4399-adc7-16f0926bac7b" />

图3-2 溢出判断

如图3-2所示，即为溢出判断的伪代码模块。结果的最高位为1即为负数，最高位为0即为正数，直接引用作为OF标志位。

## 3. 给出ALU单元的SystemVerilog HDL代码。
```
module alu(
  input [3 : 0] A,
  input [3 : 0] B,
  input [3 : 0] aluop,
  output logic [7 : 0] alures,
  output logic ZF,
  output logic OF
);
logic mark;
logic [3 : 0] a;
logic [3 : 0] b;
logic Cout;
logic [3: 0] S;
rca adder(a, b, 0, Cout, S);
always @(*) begin
    ZF=0;  
    OF=0;
    alures=0;
    case (aluop)
        4'b0000: alures[3:0]=A&B;
        4'b0001: alures[3:0]=A|B;
        4'b0010: alures[3:0]=A^B;
        4'b0011: alures[3:0]=~(A&B);
        4'b0100: alures[3:0]=~A;
        4'b0101: alures[3:0]=A<<B[2:0];
        4'b0110: alures[3:0]=A>>B[2:0];
        4'b0111: alures[3:0]=$signed(A)>>>B[2:0];
        4'b1000: alures=A*B;
        4'b1001: begin
            mark=0;
            if(A[3]==1) begin
                a=~A+1;
                mark=~mark;
            end
            else a=A;
            if(B[3]==1)begin
                b=~B+1;
                mark=~mark;
            end
            else b=B;
            alures=a*b;
            if(mark==1) alures=~alures+1;
        end
        4'b1010:begin
            a=A;
            b=B;
            alures={4'b0000,S};
            OF=Cout;
        end
        4'b1011:begin
            a=A;
            b=B;
            alures={4'b0000,S};
        end
        4'b1100:begin
            a=A;
            b=~B+1;
            alures={4'b0000,S};
            OF=Cout;
        end
        4'b1101: begin
            a=A;
            b=B;
            alures={4'b0000, S};
        end
        4'b1110: begin
            mark=A[3]^B[3];
            if(mark==0) alures=(A<B)?1:0;
            else alures=(A[3]==1)?1:0;
        end
        4'b1111:alures=(A<B)?1:0;
    endcase
    ZF=(alures==0);
end
endmodule
```

# 四．仿真与实验结果（注：仿真需要给出波形图截图，截图要清晰，如果波形过长，可以分段截取；实验结果为远程FPGA硬件云平台的截图）

## 1.给出具有自动化测试功能的仿真程序和对应的波形图截图，并说明为什么选取这些测试向量？

使用Vivado进行仿真测试。操作系统：Windows 10；开发环境：Xilinx Vivado 2018.2。得到的波形图如图4-1所示。

<img width="982" height="415" alt="image" src="https://github.com/user-attachments/assets/48ef8a84-b155-4124-a087-8770cdea7047" />

图4-1(a) 实验仿真波形图1

<img width="963" height="331" alt="image" src="https://github.com/user-attachments/assets/f4a155ae-bd85-42ac-833d-a5aeac9fc851" />

图4-1(b) 实验仿真波形图2

选取这些测试向量的原因是：本实验实现了ALU，它支持多种运算，所以需要使用多种运算符均能体现功能的测试用例。此外，由于ZF，OF等标志位的实现与否也需要验证，所以加减法也有采用会导致溢出的测试向量。

## 2.远程FPGA测试结果

<img width="879" height="427" alt="image" src="https://github.com/user-attachments/assets/193b7d6a-ba9b-41db-a6cf-e4bc2471cdba" />

图4-2 远程FPGA烧写模型图

在FPGA平台导入已经提供的epl文件和自己生成的bin文件，作上板模拟。烧写后运行实验，选取一个典型样例进行验证。

如图4-2所示，设定A=4’b1010，B=4’b1000，aluop=4’b1010即ALU做加法运算。结果发生溢出，ov标志位的LED灯发亮，四位数码管输出为“02”，此即被进位后的数值。
