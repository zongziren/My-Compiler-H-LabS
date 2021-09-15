main:
        pushl   %ebp            #保存基址寄存器ebp
        movl    %esp, %ebp      #把栈顶寄存器的值存入ebp
        subl    $16, %esp       #在栈顶分配16字节的空间
        movl    $4, -4(%ebp)    #把立即数4存入局部变量a
        cmpl    $0, -4(%ebp)    #比较a是否为0
        je      .L2             #是则跳转到.L2
        addl    $4, -4(%ebp)    #不是，则执行a=a+4
        jmp     .L3             #跳转到.L3
.L2:
        sall    $2, -4(%ebp)    #将a左移2，相当于a=a*4
.L3:
        movl    $0, %eax        #将返回值0保存到寄存器eax
        leave                     #相当于movl %ebp,%esp; popl %ebp
        ret                     #返回（修改eip）