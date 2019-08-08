

# 操作系统实验
&nbsp;
&nbsp;

     
## 简介

这是中山大学数据科学与计算机学院凌应标老师的操作系统实验课的实验内容，目标是实现一个简单的操作系统，实验之间有先后关系，后面的实验项目是在之前的实验的基础上做出的扩展。实验用到的工具主要有：

- Notepad++：编写程序时使用的编辑器
- WinHex：可以以多种进制的方式打开并编辑文件
- NASM：可以将汇编代码编译成对应的二进制代码（用于用户程序）
- TASM：可以将汇编代码编译成对应的二进制代码（用于内核）
- TCC：可以将代码编译成对应的二进制代码
- TLINK：将多个.obj文件链接成.com文件
- VMware：创建虚拟环境运行我们的操作系统

我实现的是16位实模式，使用 `TASM + TCC + TLINK `这套工具，实际上这套工具的年龄比我还大，估计后面也不怎么会用到了，使用时有很多不方便的地方，比如只能使用块注释，文件名不能超过7个字符等等，实验做到半途，遇到了很多奇怪的BUG都是因为TCC太老了，要换的话前面的内容必须得重做，不换又不知道会碰到什么奇怪的问题，实在是痛苦，所以建议一开始就使用 `GCC + NASM`，虽然可能会碰到其他问题，但至少不是这些毫无价值的问题。
  
&nbsp;
&nbsp;
  


## 实验目录

实验1~6应该没什么问题，实验7、8有bug，仅供参考！

| 序号 | 名称                                                         | 简介                                                         |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 1    | [接管裸机的控制](https://github.com/noobonzv/Simple-Operating-System/tree/master/实验1) | 在裸机上运行自己的程序                                       |
| 2    | [加载用户程序的监控程序](https://github.com/noobonzv/Simple-Operating-System/tree/master/实验2) | 实现监控程序，执行用户程序这一项基本功能                     |
| 3    | [开发独立内核的操作系统](https://github.com/noobonzv/Simple-Operating-System/tree/master/实验3) | 用C和汇编实现操作系统内核，并增加批处理能力                  |
| 4    | [异步事件编程技术](https://github.com/noobonzv/Simple-Operating-System/tree/master/实验4) | 改写时钟中断和键盘中断，实现”风火轮“和按键显示"OUCH"         |
| 5    | [实现系统调用](https://github.com/noobonzv/Simple-Operating-System/tree/master/%E5%AE%9E%E9%AA%8C5) | 封装一些系统调用，利用DOS批处理简化编译过程                  |
| 6    | [二状态进程模型](https://github.com/noobonzv/Simple-Operating-System/tree/master/实验6) | 实现多进程并发执行，并采用时间片轮转调度算法，是比较关键的实验 |
| 7    | [进程控制与通信](https://github.com/noobonzv/Simple-Operating-System/tree/master/实验7) | 五状态进程模型，实现fork、wait 和 exit系统调用               |
| 8    | [进程同步机制](https://github.com/noobonzv/Simple-Operating-System/tree/master/实验8) | 用信号量实现多进程合作完成某些任务                           |
  
  

&nbsp;
&nbsp;



## 部分实验结果

最终版本进入系统时的界面：

![1565268793397](https://github.com/noobonzv/Simple-Operating-System/blob/master/pic/FINAL.png)

&nbsp;



实验5及之前的所有内容：

![test_lab5](https://github.com/noobonzv/Simple-Operating-System/blob/master/pic/test_lab5.gif)

&nbsp;

实验6，为方便展示多进程并发执行的效果，换了4个动态的用户程序:
![test_lab6](https://github.com/noobonzv/Simple-Operating-System/blob/master/pic/test_lab6.gif)

&nbsp;

实验7，父子进程分别计算字符串中的字母个数：

![test_lab7](https://github.com/noobonzv/Simple-Operating-System/blob/master/pic/test_lab7.gif)



更加详细的结果请查看对应实验的实验报告。
&nbsp;

另外要说一下的就是，之前没有养成良好的编码习惯，所以部分代码可能不是那么的方便阅读，主要是有些变量命名不够规范和有些地方没有写注释，一些问题可以在实验报告中找到答案。越是到课程后期，越能体会代码可读性的重要性。如果做类似的实验，**请一定要注意代码的规范**，这也算是我从这门课得到的收获之一。

如果不想花大量的时间在复制粘贴二进制代码、手动生成软盘文件上，可以先学一学**DOS批处理**，我在**实验5**中的实验报告中写了一些我用的的批处理指令，将部分编译工作自动化，强烈建议先阅读学会这些东西，这会节约大量的时间，也能方便修改完善我们的操作系统，不然做一点改动就要重新手动生成软盘文件，这是非常痛苦的。

每个实验的软盘文件(.flp)可以利用 VMware创建虚拟机打开，此外，因为实验报告是用word写好转的PDF，里面的内容也比较详细，故没有再给每个实验写详细的说明，实验的具体内容见实验报告。

按照老师的说法，实验1、3、6是相对来说难一点的，实际上从实验6开始都比较难，只要前面的工作没做好，就容易出问题，也很难DEBUG，当时临近期末，实验7、8存在的BUG也没有彻底解决。







