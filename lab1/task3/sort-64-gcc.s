        .file   "sort.c"
        .section        .rodata
.LC0:
        .string "%d"
.LC1:
        .string "%d "
        .text
        .globl  main
        .type   main, @function
main:
.LFB0:
        .cfi_startproc
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register 6
        subq    $8032, %rsp
        movq    %fs:40, %rax
        movq    %rax, -8(%rbp)
        xorl    %eax, %eax
        leaq    -8024(%rbp), %rax
        movq    %rax, %rsi
        movl    $.LC0, %edi
        movl    $0, %eax
        call    __isoc99_scanf
        movl    $0, -8020(%rbp)
        jmp     .L2
.L3:
        leaq    -8016(%rbp), %rax
        movl    -8020(%rbp), %edx
        movslq  %edx, %rdx
        salq    $2, %rdx
        addq    %rdx, %rax
        movq    %rax, %rsi
        movl    $.LC0, %edi
        movl    $0, %eax
        call    __isoc99_scanf
        addl    $1, -8020(%rbp)
.L2:
        movl    -8024(%rbp), %eax
        cmpl    %eax, -8020(%rbp)
        jl      .L3
        movl    -8024(%rbp), %eax
        leaq    -8016(%rbp), %rdx
        movq    %rdx, %rsi
        movl    %eax, %edi
        call    sort
        movl    $0, -8020(%rbp)
        jmp     .L4
.L5:
        movl    -8020(%rbp), %eax
        cltq
        movl    -8016(%rbp,%rax,4), %eax
        movl    %eax, %esi
        movl    $.LC1, %edi
        movl    $0, %eax
        call    printf
        addl    $1, -8020(%rbp)
.L4:
        movl    -8024(%rbp), %eax
        cmpl    %eax, -8020(%rbp)
        jl      .L5
        movl    $0, %eax
        movq    -8(%rbp), %rcx
        xorq    %fs:40, %rcx
        je      .L7
        call    __stack_chk_fail
.L7:
        leave
        .cfi_def_cfa 7, 8
        ret
        .cfi_endproc
.LFE0:
        .size   main, .-main
        .globl  sort
        .type   sort, @function
sort:
.LFB1:
        .cfi_startproc
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register 6
        movl    %edi, -20(%rbp)
        movq    %rsi, -32(%rbp)
        movl    $0, -12(%rbp)
        jmp     .L9
.L13:
        movl    -12(%rbp), %eax
        addl    $1, %eax
        movl    %eax, -8(%rbp)
        jmp     .L10
.L12:
        movl    -12(%rbp), %eax
        cltq
        leaq    0(,%rax,4), %rdx
        movq    -32(%rbp), %rax
        addq    %rdx, %rax
        movl    (%rax), %edx
        movl    -8(%rbp), %eax
        cltq
        leaq    0(,%rax,4), %rcx
        movq    -32(%rbp), %rax
        addq    %rcx, %rax
        movl    (%rax), %eax
        cmpl    %eax, %edx
        jle     .L11
        movl    -12(%rbp), %eax
        cltq
        leaq    0(,%rax,4), %rdx
        movq    -32(%rbp), %rax
        addq    %rdx, %rax
        movl    (%rax), %eax
        movl    %eax, -4(%rbp)
        movl    -12(%rbp), %eax
        cltq
        leaq    0(,%rax,4), %rdx
        movq    -32(%rbp), %rax
        addq    %rax, %rdx
        movl    -8(%rbp), %eax
        cltq
        leaq    0(,%rax,4), %rcx
        movq    -32(%rbp), %rax
        addq    %rcx, %rax
        movl    (%rax), %eax
        movl    %eax, (%rdx)
        movl    -8(%rbp), %eax
        cltq
        leaq    0(,%rax,4), %rdx
        movq    -32(%rbp), %rax
        addq    %rax, %rdx
        movl    -4(%rbp), %eax
        movl    %eax, (%rdx)
.L11:
        addl    $1, -8(%rbp)
.L10:
        movl    -8(%rbp), %eax
        cmpl    -20(%rbp), %eax
        jl      .L12
        addl    $1, -12(%rbp)
.L9:
        movl    -20(%rbp), %eax
        subl    $1, %eax
        cmpl    -12(%rbp), %eax
        jg      .L13
        nop
        popq    %rbp
        .cfi_def_cfa 7, 8
        ret
        .cfi_endproc
.LFE1:
        .size   sort, .-sort
        .ident  "GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
        .section        .note.GNU-stack,"",@progbits