# 实验4. 自动贩售机的设计与实现

## 1．实验目的

1. 掌握有限状态机的设计方法；
2. 能够使用 SystemVerilog 进行三段式状态机的建模。

## 2．实验内容

采用有限状态机，基于 SystemVerilog HDL 设计并实现一个报纸自动贩售机。整个工程的顶层模块如图 2-1 所示，输入/输出端口如表 4-1 所示。使用 4 个七段数码管实时显示已付款和找零情况。其中，两个数码管对应“已付款”，另两个数码管对应“找零”，单位为分。通过 1 个拨动开关对数字钟进行复位控制。使用两个按键模拟投币，其中一个按键对应 5 分，另一个按键对应 1 角。使用 1 个 LED 灯标识出售是否成功，灯亮表示出售成功，否则表示已付款不够，出售失败。

<img width="884" height="253" alt="image" src="https://github.com/user-attachments/assets/38098717-29c0-4dbb-be6d-79def993c7d0" />

图 2-1 报纸自动贩售机顶层模块

假设报纸价格为 15 分，合法的投币组合包括：

- 1 个 5 分的硬币和 1 个 1 角的硬币，不找零；
- 3 个 5 分的硬币，不找零；
- 1 个 1 角的硬币和 1 个 5 分的硬币，不找零；
- 两个 1 角的硬币是合法的，找零 5 分。

当投入硬币的组合为上面 4 种之一时，则购买成功，LED 灯亮。购买成功后，LED 灯持续亮 10 秒，然后自动熄灭，同时 4 个数码管也恢复为 0。

报纸自动贩售机由 4 部分构成：

- 第一部分是计时器模块，该模块又由 3 个子模块构成，分别是计数器电路、使能时钟生成电路和边沿检测电路。
- 第二部分是整个自动贩售机电路的核心——贩售机状态机。状态机根据投币情况产生“已付款”和“找零”输出。此外，如果已付款超过 15 分，则将 LED 灯点亮，表示出售成功。
- 第三部分是两个 8 位二进制转 BCD 模块，分别将二进制的“已付款”和“找零”值转化为 BCD 编码，即十进制数。本实验中，该模块不需要实现，由教师直接提供 IP 使用。
- 第四部分是 7 段数码管动态扫描显示模块，它实现“已付款”和“找零”值的最终显示。

表 2-1 端口设计

<img width="777" height="478" alt="image" src="https://github.com/user-attachments/assets/0477bda4-c7b1-4505-8441-a983f3148638" />


用于计时的时钟频率为 25 MHz（40 ns）。

由于 7 段数码管扫描周期是 1 ms，购买成功后需要等待 10 s，从而造成仿真时间过长。为了加快仿真速度，可以在仿真的时候使用较大的计时单位和扫描速度。

完成上述分秒数字钟的设计，需要有以下几点需要注意：

1. 7 段数码管动态扫描必须采用使能时钟实现，扫描频率为 1 kHz（1 ms）。
2. 必须通过边沿检测电路识别“5 分”和“1 角”键按下产生的上升沿，以用于后续处理。

## 3．实验原理与步骤

> 注：步骤不用写工具的操作步骤，而是设计步骤。

### （一）实验原理

有限状态机分为 Moore 型状态机和 Mealy 型状态机。前者，状态机的输出仅由当前状态决定，如图 3-1 所示，在状态转换图的绘制中，输出信息标在状态（圆圈）中。后者，状态机的输出由当前时刻状态和输入共同决定，如图 3-2 所示，在状态转换图的绘制中，输出信息标在状态转换箭头之上。

<img width="789" height="241" alt="image" src="https://github.com/user-attachments/assets/1da49e2b-8e83-46b4-ac94-9aa8434a9380" />

图 3-1 Moore 型状态机

<img width="775" height="253" alt="image" src="https://github.com/user-attachments/assets/9e347f3b-1968-4977-bc7c-8f4037e6caa5" />

图 3-2 Mealy 型状态机

采用硬件描述语言进行状态机建模时，建议使用 3 段式。第一段描述状态的转换（即对状态机中的寄存器进行建模），采用时序逻辑实现；第二段描述状态转换条件和规律（即对状态机中的次态逻辑进行建模），采用组合逻辑实现；第三段描述输出逻辑，根据实际设计需要可采用组合逻辑或时序逻辑实现。

三段式状态机建模的模板如下所示。

<img width="827" height="708" alt="image" src="https://github.com/user-attachments/assets/4ccb2b6a-8458-4df5-9904-4f53ec206057" />


### （二）设计步骤

#### 1. 画出自动贩售机的状态转换图

<img width="589" height="516" alt="image" src="https://github.com/user-attachments/assets/3db241bc-369d-4e83-9cbb-2b7ccc936767" />


图 3-3 自动贩售机 FSM 图

#### 2. 画出自动贩售机电路的原理图（模块级别即可，如使能时钟模块、检测模块等）

如图 3-4，为使能时钟模块 clken。

<img width="991" height="229" alt="image" src="https://github.com/user-attachments/assets/e926687b-9935-4f50-a2b3-d916861eddd4" />

图 3-4 使能时钟模块


如图 3-5，为边沿检测模块 edge_detect。

<img width="903" height="257" alt="image" src="https://github.com/user-attachments/assets/a85bbd83-a3e6-4808-8671-a1a25d3c68e7" />

图 3-5 边沿检测模块

如图 3-6，为计时器模块 timer，由两个边沿检测模块和一个使能时钟组成。

<img width="697" height="558" alt="image" src="https://github.com/user-attachments/assets/b0d3fb77-f214-48a2-bfc7-a3ba69654a7d" />

图 3-6 计时器模块

如图 3-7，是七段数码管扫描模块。该模块和计时器内部同样需要 MUX、Register 等结构，实现时序逻辑。

<img width="978" height="794" alt="image" src="https://github.com/user-attachments/assets/b12502e7-7ee3-40ac-93dd-92dc4ec015ff" />

图 3-7 七段数码管扫描模块

如图 3-8，为七段数码管转换电路图。需要注意的是，在 case 结构中如果没有写 default 语句，则会模拟出 LATCH 锁存器结构，可能对电路造成一些影响。

<img width="612" height="289" alt="image" src="https://github.com/user-attachments/assets/25385920-e0f7-45d1-b79f-fc15cc851d28" />

图 3-8 七段数码管转换模块

如图 3-9 所示，为整体电路的顶层模块设计图。使用一个计时器模块、一个 fsm 模块、两个二进制转 BCD 编码模块、一个七段数码管扫描模块和一个七段数码管转换模块组成。

<img width="999" height="251" alt="image" src="https://github.com/user-attachments/assets/b152ee7d-cd00-432f-a5d2-225574a301cf" />

图 3-9 整体结构设计

#### 3. 写出报纸自动贩售机的 SystemVerilog 代码

```systemverilog
module vend(
    input           sys_clk, sys_rst_n,
    input           coin5, coin10,
    output  [3 : 0]   an,
    output  [7 : 0]   a_to_g,
    output          open
    );
    logic           clk_flag, coin5_flag, coin10_flag;
    logic  [7 : 0]    change, price;
    logic  [7 : 0]    bcd_change, bcd_price; 
    logic  [3 : 0]    x7seg_data;
    timer timer (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .coin5(coin5),
        .coin10(coin10),
        .coin5_flag(coin5_flag),
        .coin10_flag(coin10_flag),
        .clk_flag(clk_flag)
    );

    fsm fsm (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .coin5_flag(coin5_flag),
        .coin10_flag(coin10_flag),
        .change(change),
        .price(price),
        .open(open)
    );

    bin2bcd_0 bcdchange(
        .bin(change),
        .bcd(bcd_change)
    );

    bin2bcd_0 bcdprice(
        .bin(price),
        .bcd(bcd_price)
    );

    x7seg_scan scan(
        .sys_clk(sys_clk),
        .clk_flag(clk_flag),
        .bcd_change(bcd_change),
        .bcd_price(bcd_price),
        .data(x7seg_data),
        .an(an)
    );

    x7seg_dec dec(
        .data(x7seg_data),
        .a_to_g(a_to_g)
    );
endmodule
```

```systemverilog
module clken (
    input      sys_clk,
    input      sys_rst_n,
    output logic clk_flag 
    );
        localparam max = 25000;
        int count;

        always_ff @(posedge sys_clk) begin
            if(!sys_rst_n) count <= 0;
            else if(count == max - 1) count <= 0; 
            else count <= count + 1;
        end

        always_ff @(posedge sys_clk) begin
            if (!sys_rst_n) clk_flag <= 0;
            else if(count == max - 1) clk_flag <= 1;
            else clk_flag <= 0;
        end
endmodule
```

```systemverilog
module edge_detect (
    input                   sys_clk,
    input                   i_btn,
    output  logic           posedge_flag
    ); 

    logic a;
    logic b;

    always_ff @(posedge sys_clk) begin
        a <= i_btn;
        b <= a;
    end    

    assign posedge_flag = a & (~b);
endmodule
```

```systemverilog
module timer (
    input                   sys_clk,
    input                   sys_rst_n,
    input                   coin5,
    input                   coin10,
    output                  coin5_flag,
    output                  coin10_flag,
    output   logic          clk_flag
    );

    clken clken (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .clk_flag(clk_flag)
    );

    edge_detect edcoin5 (
        .sys_clk(sys_clk),
        .i_btn(coin5),
        .posedge_flag(coin5_flag)
    );

    edge_detect edcoin10 (
        .sys_clk(sys_clk),
        .i_btn(coin10),
        .posedge_flag(coin10_flag)
    );
endmodule
```

```systemverilog
module fsm #(parameter SYS_CLK_FREQ = 25_000_000_0, TARGET_CLK_FREQ = 1) (
    input                   sys_clk,
    input                   sys_rst_n,
    input                   coin5_flag,
    input                   coin10_flag,
    output logic [7 : 0]    change,
    output logic [7 : 0]    price,
    output logic            open
    );

    logic  [2 : 0]          current_state;
    logic  [2 : 0]          next_state;
    logic                   hold_state = 1;
    int                     count = 0;
    localparam max = 250000000;

    always_ff @(posedge sys_clk) begin
        if (!(current_state == 3'b011 || current_state == 3'b100)) begin
            count <= 0;
            hold_state <= 1;
        end
        else if (count == max - 1) begin
            count <= 0;
            hold_state <= 0;
        end
        else count <= count + 1;
    end

    always_comb begin
        case(current_state)
            3'b000: if ({coin5_flag, coin10_flag} == 2'b10)
                        next_state = 3'b001;
                    else if ({coin5_flag, coin10_flag} == 2'b01)
                        next_state = 3'b010;
                    else
                        next_state = 3'b000;

            3'b001: if ({coin5_flag, coin10_flag} == 2'b10)
                        next_state = 3'b010;
                    else if ({coin5_flag, coin10_flag} == 2'b01)
                        next_state = 3'b100;
                    else
                        next_state = 3'b001;

            3'b010: if ({coin5_flag, coin10_flag} == 2'b10)
                        next_state = 3'b100;
                    else if ({coin5_flag, coin10_flag} == 2'b01)
                        next_state = 3'b011;
                    else
                        next_state = 3'b010;

            3'b011: if ({coin5_flag, coin10_flag} == 2'b10)
                        next_state = 3'b001;
                    else if ({coin5_flag, coin10_flag} == 2'b01)
                        next_state = 3'b010;
                    else if (hold_state)
                        next_state = 3'b011; 
                    else
                        next_state = 3'b000;

            3'b100: if ({coin5_flag, coin10_flag} == 2'b10)
                        next_state = 3'b001;
                    else if ({coin5_flag, coin10_flag} == 2'b01)
                        next_state = 3'b010;
                    else if (hold_state)
                        next_state = 3'b100; 
                    else
                        next_state = 3'b000;

            default: next_state = 3'b000;
        endcase
    end

    always_ff @(posedge sys_clk) begin
        if(!sys_rst_n)
            current_state <= 0;
        else
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            3'b000: begin
                open = 0;
                change = 0;
                price = 0;
            end

            3'b001: begin
                open = 0;
                change = 0;
                price = 4'b0101; // 5
            end

            3'b010: begin
                open = 0;
                change = 0;
                price = 4'b1010; // 10
            end

            3'b011: begin
                open = 1;
                change = 4'b0101; // 5
                price = 5'b10100; // 20
            end

            3'b100: begin
                open = 1;
                change = 0;
                price = 4'b1111; // 15
            end

            default: begin
                open = 0;
                change = 0;
                price = 0;
            end
        endcase
    end
endmodule
```

```systemverilog
module x7seg_scan (
    input                     sys_clk,
    input                     clk_flag,
    input          [7 : 0]    bcd_change,
    input          [7 : 0]    bcd_price,
    output  logic   [3 : 0]   data,
    output  logic   [3 : 0]   an
);  

    logic [1 : 0] count = 0;

    always_ff @(posedge clk_flag) begin      
        if (count == 2'b11) count <= 0;
        else count <= count + 1;
    end

    always_comb begin
        case (count)
            2'b00: an = 4'b0001;
            2'b01: an = 4'b0010;
            2'b10: an = 4'b0100;
            2'b11: an = 4'b1000;
        endcase
    end

    always_comb begin
        case (count)
            2'b00: data = bcd_price[3 : 0];
            2'b01: data = bcd_price[7 : 4];
            2'b10: data = bcd_change[3 : 0];
            2'b11: data = bcd_change[7 : 4];
        endcase
    end
endmodule
```

```systemverilog
module x7seg_dec(
    input         [3 : 0]      data,
    output  logic [7 : 0]      a_to_g    
    );

    always_comb begin
        case(data)
            4'd0: a_to_g = 8'b11000000;
            4'd1: a_to_g = 8'b11111001;
            4'd2: a_to_g = 8'b10100100;
            4'd3: a_to_g = 8'b10110000;
            4'd4: a_to_g = 8'b10011001;
            4'd5: a_to_g = 8'b10010010;
            4'd6: a_to_g = 8'b10000010;
            4'd7: a_to_g = 8'b11111000;
            4'd8: a_to_g = 8'b10000000;
            4'd9: a_to_g = 8'b10010000;
            default: a_to_g = 8'b11000000;
        endcase
    end
endmodule
```

## 4．仿真与实验结果

> 注：仿真需要给出波形图截图，截图要清晰，如果波形过长，可以分段截取；实验结果为远程 FPGA 硬件云平台的截图。

### 1. 给出具有自动化测试功能的仿真程序和对应的波形图截图

#### （1）测试程序如下

```systemverilog
`define CLK_PERIOD 40

module vend_tb();
    logic         sys_clk, sys_rst_n;
    logic  [3 : 0] an;
    logic         coin5, coin10;
    logic  [7 : 0] a_to_g;
    logic         open;

    vend dut(
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .coin5(coin5),
        .coin10(coin10),
        .open(open),
        .an(an),
        .a_to_g(a_to_g)
    ); 

    initial begin
        sys_clk <= 1'b0;
        sys_rst_n <= 1'b0; 
        coin5 <= 0;
        coin10 <= 0;
        #5000;
        sys_rst_n <= 1'b1;

        for (int i = 0; i < 1000000000; i++) begin 
            coin5 <= 1;  coin10 <= 0;  #10000;
            coin5 <= 1;  coin10 <= 0;  #10000;
            coin5 <= 1;  coin10 <= 0;  #10000; 
            coin5 <= 0;  coin10 <= 0;  #10000;
            coin10 <= 1; coin5 <= 0;   #10000;
            coin10 <= 1; coin5 <= 0;   #10000;
            coin10 <= 0; coin5 <= 0;   #10000; 
        end
    end 

    always #(`CLK_PERIOD / 2) begin
        sys_clk <= ~sys_clk;
    end
endmodule
```

#### （2）使用 Vivado 进行 “Run simulation” 仿真测试

操作系统：Windows 10
开发环境：Xilinx Vivado 2018.2

得到的波形图如图 4-1 所示。

<img width="1000" height="201" alt="image" src="https://github.com/user-attachments/assets/aee7a5e0-cc33-47f3-a14b-fc9449b58427" />

(a)

<img width="1003" height="206" alt="image" src="https://github.com/user-attachments/assets/49250bd2-d2ad-47a3-8884-1a36386a25e2" />

(b)

<img width="982" height="196" alt="image" src="https://github.com/user-attachments/assets/e6edb04e-8c06-4872-8ce0-3924941fa64f" />

(c)

<img width="983" height="204" alt="image" src="https://github.com/user-attachments/assets/8147dcfb-ffc8-4343-809d-f734f5e060d2" />

(d)

图 4-1 Vivado 仿真波形图

如图 4-1，每张波形图从上至下显示的信号均为：sys_clk、sys_rst_n、an[3:0]、coin5、coin10、a_to_g[7:0] 和 open。由于测试程序设置的周期性变化，所以 open、data 等数值也会随着时间周期变化，即图 (a)～(d)。随着 clk、rst 和 coin 等信号的改变，当 a_to_g 显示为 c0 时，七段数码管一部变化为 0；当 a_to_g 显示为 92 时，七段数码管一部变化为 5；当 a_to_g 显示为 f9 时，七段数码管一部变化为 1。这些都是程序对硬币数量的变化做出的正确反应。

### 2. 远程 FPGA 测试结果

在 FPGA 平台导入已经提供的 epl 文件和自己生成的 bin 文件，作上板模拟。烧写后运行实验，选取 4 个典型样例进行验证。

<img width="898" height="389" alt="image" src="https://github.com/user-attachments/assets/6465a66d-29ea-47e4-99b8-d8b93ce2ff55" />

(a) 投入 5 分

<img width="900" height="394" alt="image" src="https://github.com/user-attachments/assets/2f105e9c-1ef9-47ae-a978-5e07cff86587" />

(b) 投入 10 分

<img width="910" height="374" alt="image" src="https://github.com/user-attachments/assets/207ca12f-3019-4cd5-bfd1-49e63ee57e2d" />

(c) 投入 15 分

<img width="924" height="408" alt="image" src="https://github.com/user-attachments/assets/bf8bcf9c-e26c-4866-aab5-9f51dce4df5d" />

(d) 投入 20 分

图 4-2 远程 FPGA 烧写模型图

如图 4-2 所示，投入 5 分、10 分后，LED 均能显示数额，但未满 15 分的单价，所以指示灯不亮。投入 15 分后，指示灯亮，可以出售。投入 20 分后，则需要找零 5 分，所以显示 0520。继续投入硬币，则又重复上述循环。

综上所述，本次实验大体成功。

## 5．实验中遇到的问题和解决办法

实验中遇到的问题和对应的解决方法如下：

1. 实验中，在进行完 Synthesis 测试后提示无法进行 Run Implementation 的报错，于是在网上进行查询，发现这是由于约束文件里注释不能和代码在同一行所致，按提示修改约束文件后问题得到解决。
2. 将第一阶段的模型图转化为 HDL 代码后，Vivado 仿真波形一直无法输出正确的值。为了解决这个问题，对其他模块都编写了测试程序，发现问题后进行修改，问题即得到解决。
3. 实验中在创建 design source 时发现把代码文件类型选错了。一开始没有发现，到后面检查时才发现文件尾缀不是 `.sv` 而是 `.v`。后来重新以 `.sv` 的类型重建该文件，并与其他文件相连接，问题得到解决。

总结：本实验进一步锻炼了我们处理 SV 建模的能力。在建模、编写代码和 debug 的过程中，我们的能力也得到了提升，尤其是一些课堂上没有完全掌握的东西，比如测试程序的编写，也通过实验得到了巩固。
