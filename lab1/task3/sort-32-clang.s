        .text
        .file   "sort.c"
        .globl  main                    # -- Begin function main
        .p2align        4, 0x90
        .type   main,@function
main:                                   # @main
# %bb.0:
        pushl   %ebp                    #保存基址寄存器ebp
        movl    %esp, %ebp              #把栈顶寄存器的值存入
        subl    $8024, %esp             # imm = 0x1F58
                                        #在栈顶分配8024字节的空间
        movl    $0, -4(%ebp)
        movl    $0, -8(%ebp)            #对变量number赋值0
        movl    $0, -12(%ebp)           #对变量i赋值0
        leal    .L.str, %eax            #将源操作数的地址传到目的操作数中,.L,str:"%d"
        movl    %eax, (%esp)            #传给栈顶寄存器esp所指位置
        leal    -8(%ebp), %eax
        movl    %eax, 4(%esp)
        calll   __isoc99_scanf          #调用scanf函数
        movl    $0, -12(%ebp)           #对变量i赋值0
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
        movl    -12(%ebp), %eax
        cmpl    -8(%ebp), %eax
        jge     .LBB0_4
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
        movl    -12(%ebp), %eax
        shll    $2, %eax
        leal    -8012(%ebp), %ecx
        addl    %eax, %ecx
        leal    .L.str, %eax
        movl    %eax, (%esp)
        movl    %ecx, 4(%esp)
        calll   __isoc99_scanf
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
        movl    -12(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -12(%ebp)
        jmp     .LBB0_1
.LBB0_4:
        leal    -8012(%ebp), %eax
        movl    -8(%ebp), %ecx
        movl    %ecx, (%esp)
        movl    %eax, 4(%esp)
        calll   sort
        movl    $0, -12(%ebp)
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
        movl    -12(%ebp), %eax
        cmpl    -8(%ebp), %eax
        jge     .LBB0_8
# %bb.6:                                #   in Loop: Header=BB0_5 Depth=1
        movl    -12(%ebp), %eax
        movl    -8012(%ebp,%eax,4), %eax
        leal    .L.str.1, %ecx
        movl    %ecx, (%esp)
        movl    %eax, 4(%esp)
        calll   printf
# %bb.7:                                #   in Loop: Header=BB0_5 Depth=1
        movl    -12(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -12(%ebp)
        jmp     .LBB0_5
.LBB0_8:
        xorl    %eax, %eax
        addl    $8024, %esp             # imm = 0x1F58
        popl    %ebp
        retl
.Lfunc_end0:
        .size   main, .Lfunc_end0-main
                                        # -- End function
        .globl  sort                    # -- Begin function sort
        .p2align        4, 0x90
        .type   sort,@function
sort:                                   # @sort
# %bb.0:
        pushl   %ebp
        movl    %esp, %ebp
        subl    $12, %esp
        movl    12(%ebp), %eax
        movl    8(%ebp), %ecx
        movl    $0, -4(%ebp)
.LBB1_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
        movl    -4(%ebp), %eax
        movl    8(%ebp), %ecx
        subl    $1, %ecx
        cmpl    %ecx, %eax
        jge     .LBB1_10
# %bb.2:                                #   in Loop: Header=BB1_1 Depth=1
        movl    -4(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -8(%ebp)
.LBB1_3:                                #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
        movl    -8(%ebp), %eax
        cmpl    8(%ebp), %eax
        jge     .LBB1_8
# %bb.4:                                #   in Loop: Header=BB1_3 Depth=2
        movl    12(%ebp), %eax
        movl    -4(%ebp), %ecx
        movl    (%eax,%ecx,4), %eax
        movl    12(%ebp), %ecx
        movl    -8(%ebp), %edx
        cmpl    (%ecx,%edx,4), %eax
        jle     .LBB1_6
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
        movl    %eax, (%ecx,%edx,4)
.LBB1_6:                                #   in Loop: Header=BB1_3 Depth=2
        jmp     .LBB1_7
.LBB1_7:                                #   in Loop: Header=BB1_3 Depth=2
        movl    -8(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -8(%ebp)
        jmp     .LBB1_3
.LBB1_8:                                #   in Loop: Header=BB1_1 Depth=1
        jmp     .LBB1_9
.LBB1_9:                                #   in Loop: Header=BB1_1 Depth=1
        movl    -4(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -4(%ebp)
        jmp     .LBB1_1
.LBB1_10:
        addl    $12, %esp
        popl    %ebp
        retl
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