# HW1

## PB19000362钟书锐

## Answer

### Q1.1:如果在命令行下执行``` gcc -DNEG -E sample.c -o sample.i ```生成的sample.i 与之前的有何区别？
- ```gcc -DNEG``` 等价 ```#define NEG```,所以预处理后的sample.i中宏引用（第8行）M用-4替代。

### Q1.2:请对比sample-32.s和sample.s，简要说明它们核心汇编代码的区别以及产生这些区别的原因。

1. pushl vs pushq
- sample-32.s％中ebp指的是esp寄存器，这是一个32位的寄存器，pushl压栈双字(32位)。
- sample.s％rbp中是rbp寄存器，6
位寄存器，是x86_64上的帧指针，pushq压栈64位。

2. rbp,rsp vs ebp,esp
- x86中，rbp和rsp只是32位ebp和esp寄存器的64位等效。
- 产生原因：位数不同的汇编

3. ```movl %esp, %ebp``` vs ```mmovq    %rsp, %rbp```
- 同上 pushl pushqs

