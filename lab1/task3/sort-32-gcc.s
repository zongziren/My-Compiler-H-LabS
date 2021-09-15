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
        leal    4(%esp), %ecx
        .cfi_def_cfa 1, 0
        andl    $-16, %esp
        pushl   -4(%ecx)
        pushl   %ebp
        .cfi_escape 0x10,0x5,0x2,0x75,0
        movl    %esp, %ebp
        pushl   %ecx
        .cfi_escape 0xf,0x3,0x75,0x7c,0x6
        subl    $8020, %esp
        movl    %gs:20, %eax
        movl    %eax, -12(%ebp)
        xorl    %eax, %eax
        subl    $8, %esp
        leal    -8020(%ebp), %eax
        pushl   %eax
        pushl   $.LC0
        call    __isoc99_scanf
        addl    $16, %esp
        movl    $0, -8016(%ebp)
        jmp     .L2
.L3:
        leal    -8012(%ebp), %eax
        movl    -8016(%ebp), %edx
        sall    $2, %edx
        addl    %edx, %eax
        subl    $8, %esp
        pushl   %eax
        pushl   $.LC0
        call    __isoc99_scanf
        addl    $16, %esp
        addl    $1, -8016(%ebp)
.L2:
        movl    -8020(%ebp), %eax
        cmpl    %eax, -8016(%ebp)
        jl      .L3
        movl    -8020(%ebp), %eax
        subl    $8, %esp
        leal    -8012(%ebp), %edx
        pushl   %edx
        pushl   %eax
        call    sort
        addl    $16, %esp
        movl    $0, -8016(%ebp)
        jmp     .L4
.L5:
        movl    -8016(%ebp), %eax
        movl    -8012(%ebp,%eax,4), %eax
        subl    $8, %esp
        pushl   %eax
        pushl   $.LC1
        call    printf
        addl    $16, %esp
        addl    $1, -8016(%ebp)
.L4:
        movl    -8020(%ebp), %eax
        cmpl    %eax, -8016(%ebp)
        jl      .L5
        movl    $0, %eax
        movl    -12(%ebp), %ecx
        xorl    %gs:20, %ecx
        je      .L7
        call    __stack_chk_fail
.L7:
        movl    -4(%ebp), %ecx
        .cfi_def_cfa 1, 0
        leave
        .cfi_restore 5
        leal    -4(%ecx), %esp
        .cfi_def_cfa 4, 4
        ret
        .cfi_endproc
.LFE0:
        .size   main, .-main
        .globl  sort
        .type   sort, @function
sort:
.LFB1:
        .cfi_startproc
        pushl   %ebp
        .cfi_def_cfa_offset 8
        .cfi_offset 5, -8
        movl    %esp, %ebp
        .cfi_def_cfa_register 5
        subl    $16, %esp
        movl    $0, -12(%ebp)
        jmp     .L9
.L13:
        movl    -12(%ebp), %eax
        addl    $1, %eax
        movl    %eax, -8(%ebp)
        jmp     .L10
.L12:
        movl    -12(%ebp), %eax
        leal    0(,%eax,4), %edx
        movl    12(%ebp), %eax
        addl    %edx, %eax
        movl    (%eax), %edx
        movl    -8(%ebp), %eax
        leal    0(,%eax,4), %ecx
        movl    12(%ebp), %eax
        addl    %ecx, %eax
        movl    (%eax), %eax
        cmpl    %eax, %edx
        jle     .L11
        movl    -12(%ebp), %eax
        leal    0(,%eax,4), %edx
        movl    12(%ebp), %eax
        addl    %edx, %eax
        movl    (%eax), %eax
        movl    %eax, -4(%ebp)
        movl    -12(%ebp), %eax
        leal    0(,%eax,4), %edx
        movl    12(%ebp), %eax
        addl    %eax, %edx
        movl    -8(%ebp), %eax
        leal    0(,%eax,4), %ecx
        movl    12(%ebp), %eax
        addl    %ecx, %eax
        movl    (%eax), %eax
        movl    %eax, (%edx)
        movl    -8(%ebp), %eax
        leal    0(,%eax,4), %edx
        movl    12(%ebp), %eax
        addl    %eax, %edx
        movl    -4(%ebp), %eax
        movl    %eax, (%edx)
.L11:
        addl    $1, -8(%ebp)
.L10:
        movl    -8(%ebp), %eax
        cmpl    8(%ebp), %eax
        jl      .L12
        addl    $1, -12(%ebp)
.L9:
        movl    8(%ebp), %eax
        subl    $1, %eax
        cmpl    -12(%ebp), %eax
        jg      .L13
        nop
        leave
        .cfi_restore 5
        .cfi_def_cfa 4, 4
        ret
        .cfi_endproc
.LFE1:
        .size   sort, .-sort
        .ident  "GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609"
        .section        .note.GNU-stack,"",@progbits