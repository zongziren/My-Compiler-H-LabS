# HW1

## PB19000362 钟书锐

## Answer

### Q3.1 说明不同汇编命令的含义、源程序中的变量、中间结果、函数调用参数的传递和使用在汇编码中的对应。

- 为 clang 编译出的 sort.s 添加注释

```
        .text
        .file   "sort.c"
        .globl  main                    # -- Begin function main
        .p2align        4, 0x90
        .type   main,@function
main:                                   # @main
# %bb.0:
        pushl   %ebp                    # 保存基址寄存器ebp
        movl    %esp, %ebp              # 把栈顶寄存器的值存入
        subl    $8024, %esp             # imm = 0x1F58
                                        # 在栈顶分配8024字节的空间
        movl    $0, -4(%ebp)
        movl    $0, -8(%ebp)            # 对变量number赋值0
        movl    $0, -12(%ebp)           # 对变量i赋值0
        leal    .L.str, %eax            # 将源操作数的地址传到目的操作数中,.L,str:"%d"
        movl    %eax, (%esp)            # 传给栈顶寄存器esp所指位置,给scanf函数用
        leal    -8(%ebp), %eax          # 加载有效地址指令,即把变量number地址传入%eax
        movl    %eax, 4(%esp)           # 把number的地址传给sanf函数使用
        calll   __isoc99_scanf          # 调用scanf函数，赋值给number
        movl    $0, -12(%ebp)           # 对变量i赋值0
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
        movl    -12(%ebp), %eax
        cmpl    -8(%ebp), %eax          # 比较i和number
        jge     .LBB0_4                 # 如果i大于等于number,跳转到LBB0_4
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
        movl    -12(%ebp), %eax
        shll    $2, %eax
        leal    -8012(%ebp), %ecx
        addl    %eax, %ecx              # 计算arry[i]的地址
        leal    .L.str, %eax            # 将源操作数的地址传到目的操作数中,.L,str:"%d"
        movl    %eax, (%esp)            # 传给栈顶寄存器esp所指位置,给scanf函数用
        movl    %ecx, 4(%esp)           # 把arry[i]的地址传给sanf函数使用
        calll   __isoc99_scanf          # 调用scanf函数
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
        movl    -12(%ebp), %eax         # 把i的值传给eax
        addl    $1, %eax                # %eax++
        movl    %eax, -12(%ebp)         # i++
        jmp     .LBB0_1                 # 跳转到LBB0_1
.LBB0_4:
        leal    -8012(%ebp), %eax
        movl    -8(%ebp), %ecx
        movl    %ecx, (%esp)            # 把number参数传给sort函数
        movl    %eax, 4(%esp)           # 把arry参数传给sort函数
        calll   sort                    # 调用sort函数
        movl    $0, -12(%ebp)           # 变量i置0
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
        movl    -12(%ebp), %eax
        cmpl    -8(%ebp), %eax
        jge     .LBB0_8                 # 比较i和number,如果i大于等于number，跳转到LBB0_8
# %bb.6:                                #   in Loop: Header=BB0_5 Depth=1
        movl    -12(%ebp), %eax
        movl    -8012(%ebp,%eax,4), %eax
        leal    .L.str.1, %ecx
        movl    %ecx, (%esp)            # 把L.str.1("%d ")传给printf函数
        movl    %eax, 4(%esp)           # 把arry[i]传给printf函数
        calll   printf                  # 调用printf函数
# %bb.7:                                #   in Loop: Header=BB0_5 Depth=1
        movl    -12(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -12(%ebp)         # i++
        jmp     .LBB0_5                 # 跳转到LBB0_5
.LBB0_8:
        xorl    %eax, %eax              # %eax清0
        addl    $8024, %esp             # imm = 0x1F58
        popl    %ebp                    # 释放arry,number,i的空间
        retl
.Lfunc_end0:
        .size   main, .Lfunc_end0-main
                                        # -- End function
        .globl  sort                    # -- Begin function sort
        .p2align        4, 0x90
        .type   sort,@function
sort:                                   # @sort
# %bb.0:
        pushl   %ebp                    # 保存基址寄存器ebp
        movl    %esp, %ebp              # 把栈顶寄存器的值存入
        subl    $12, %esp               # 在栈顶分配12字节的空间
        movl    12(%ebp), %eax          # 调用时传入的参数int *a
        movl    8(%ebp), %ecx           # 调用时传入的参数int l
        movl    $0, -4(%ebp)            # 变量i清0
.LBB1_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
        movl    -4(%ebp), %eax
        movl    8(%ebp), %ecx
        subl    $1, %ecx
        cmpl    %ecx, %eax              # 比较l-1和i
        jge     .LBB1_10                # 如果l-1大于等于i跳转到LBB1_10
# %bb.2:                                #   in Loop: Header=BB1_1 Depth=1
        movl    -4(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -8(%ebp)          # j=i+1
.LBB1_3:                                #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
        movl    -8(%ebp), %eax
        cmpl    8(%ebp), %eax           #  比较l和j
        jge     .LBB1_8                 # 如果i大于等于j跳转到LBB1_8
# %bb.4:                                #   in Loop: Header=BB1_3 Depth=2
        movl    12(%ebp), %eax          # 数组a的地址传入%eax
        movl    -4(%ebp), %ecx          # i传入%ecx
        movl    (%eax,%ecx,4), %eax     # a[i]传入%eax
        movl    12(%ebp), %ecx
        movl    -8(%ebp), %edx
        cmpl    (%ecx,%edx,4), %eax     # 比较a[i]和a[j]
        jle     .LBB1_6                 # 如果a[i]小于等于a[j]跳转到LBB1_6
# %bb.5:                                #   in Loop: Header=BB1_3 Depth=2
        movl    12(%ebp), %eax
        movl    -4(%ebp), %ecx
        movl    (%eax,%ecx,4), %eax
        movl    %eax, -12(%ebp)
        movl    12(%ebp), %eax
        movl    -8(%ebp), %ecx
        movl    (%eax,%ecx,4), %eax
        movl    12(%ebp), %ecx
        movl    -4(%ebp), %edx
        movl    %eax, (%ecx,%edx,4)
        movl    -12(%ebp), %eax
        movl    12(%ebp), %ecx
        movl    -8(%ebp), %edx
        movl    %eax, (%ecx,%edx,4)     # 以上断交换a[i]和a[j]的值
.LBB1_6:                                #   in Loop: Header=BB1_3 Depth=2
        jmp     .LBB1_7                 # 无条件跳转LBB1_7
.LBB1_7:                                #   in Loop: Header=BB1_3 Depth=2
        movl    -8(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -8(%ebp)          # j++
        jmp     .LBB1_3                 # 无条件跳转LBB1_3
.LBB1_8:                                #   in Loop: Header=BB1_1 Depth=1
        jmp     .LBB1_9                 # 无条件跳转LBB1_9
.LBB1_9:                                #   in Loop: Header=BB1_1 Depth=1
        movl    -4(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -4(%ebp)          # i++
        jmp     .LBB1_1                 # 无条件跳转LBB1_1
.LBB1_10:
        addl    $12, %esp               # 释放变量i,j,v
        popl    %ebp
        retl                            #返回
.Lfunc_end1:
        .size   sort, .Lfunc_end1-sort
                                        # -- End function
        .type   .L.str,@object          # @.str
        .section        .rodata.str1.1,"aMS",@progbits,1
.L.str:
        .asciz  "%d"
        .size   .L.str, 3

        .type   .L.str.1,@object        # @.str.1
.L.str.1:
        .asciz  "%d "
        .size   .L.str.1, 4

        .ident  "clang version 10.0.1 "
        .section        ".note.GNU-stack","",@progbits
        .addrsig
        .addrsig_sym __isoc99_scanf
        .addrsig_sym sort
        .addrsig_sym printf
```

### Q3.2 不同编译选项（-O2,-O0）下输出的汇编文件的区别，并简要说明编译器进行了什么优化。

- -O2 选项使用后,m,n,x,y 汇编在后面的出现中全部用立即数 4,8,32,2 实现。

```
int m = 4;
int n = 8;
int x = m * n;
int y = n / m;
```

- 对于`int c = a - b`;`int d = a - b + y;-O2`选项使用后变为`subs r4, r0, r1`和`adds r5, r4, #2`即 d = c + 2,将 a-b 直接用
  变量 c 替代

- 函数 cpp 2 个条件分支都恒为非,函数恒返回 1,在-O2 优化开启后,直接返回 1。

```
        movs    r0, #1
        bx      lr
```

- 函数 squre 中 `a[i] = i;`
  `str r3, [r2, #4]!`将 r3 中的值（即 i 的值）存到 r2 所指定的地址中,同时先更新 r2=r2+4。即 a[i]中的 i 和赋值用的 i 实现实际上分离。

- 函数 squre 中 `return num * num + a[num]`,在-O2 优化后,使用`mla r0, r0, r0, r3`即 `r0=ro * ro + r3`。且`ldr r3, [sp, r0, lsl #2]`不同于未优化的`ldr r3, [r3, r1, lsl #2]`,从 sp 开始直接访问 a[num]。
