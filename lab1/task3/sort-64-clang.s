        .text
        .file   "sort.c"
        .globl  main                    # -- Begin function main
        .p2align        4, 0x90
        .type   main,@function
main:                                   # @main
        .cfi_startproc
# %bb.0:
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset %rbp, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register %rbp
        subq    $8032, %rsp             # imm = 0x1F60
        movl    $0, -4(%rbp)
        movabsq $.L.str, %rdi
        leaq    -8(%rbp), %rsi
        movb    $0, %al
        callq   __isoc99_scanf
        movl    $0, -8020(%rbp)
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
        movl    -8020(%rbp), %eax
        cmpl    -8(%rbp), %eax
        jge     .LBB0_4
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
        movslq  -8020(%rbp), %rax
        shlq    $2, %rax
        leaq    -8016(%rbp), %rcx
        addq    %rax, %rcx
        movabsq $.L.str, %rdi
        movq    %rcx, %rsi
        movb    $0, %al
        callq   __isoc99_scanf
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
        movl    -8020(%rbp), %eax
        addl    $1, %eax
        movl    %eax, -8020(%rbp)
        jmp     .LBB0_1
.LBB0_4:
        leaq    -8016(%rbp), %rsi
        movl    -8(%rbp), %edi
        callq   sort
        movl    $0, -8020(%rbp)
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
        movl    -8020(%rbp), %eax
        cmpl    -8(%rbp), %eax
        jge     .LBB0_8
# %bb.6:                                #   in Loop: Header=BB0_5 Depth=1
        movslq  -8020(%rbp), %rax
        movl    -8016(%rbp,%rax,4), %esi
        movabsq $.L.str.1, %rdi
        movb    $0, %al
        callq   printf
# %bb.7:                                #   in Loop: Header=BB0_5 Depth=1
        movl    -8020(%rbp), %eax
        addl    $1, %eax
        movl    %eax, -8020(%rbp)
        jmp     .LBB0_5
.LBB0_8:
        xorl    %eax, %eax
        addq    $8032, %rsp             # imm = 0x1F60
        popq    %rbp
        .cfi_def_cfa %rsp, 8
        retq
.Lfunc_end0:
        .size   main, .Lfunc_end0-main
        .cfi_endproc
                                        # -- End function
        .globl  sort                    # -- Begin function sort
        .p2align        4, 0x90
        .type   sort,@function
sort:                                   # @sort
        .cfi_startproc
# %bb.0:
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset %rbp, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register %rbp
        movl    %edi, -4(%rbp)
        movq    %rsi, -16(%rbp)
        movl    $0, -20(%rbp)
.LBB1_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
        movl    -20(%rbp), %eax
        movl    -4(%rbp), %ecx
        subl    $1, %ecx
        cmpl    %ecx, %eax
        jge     .LBB1_10
# %bb.2:                                #   in Loop: Header=BB1_1 Depth=1
        movl    -20(%rbp), %eax
        addl    $1, %eax
        movl    %eax, -24(%rbp)
.LBB1_3:                                #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
        movl    -24(%rbp), %eax
        cmpl    -4(%rbp), %eax
        jge     .LBB1_8
# %bb.4:                                #   in Loop: Header=BB1_3 Depth=2
        movq    -16(%rbp), %rax
        movslq  -20(%rbp), %rcx
        movl    (%rax,%rcx,4), %edx
        movq    -16(%rbp), %rax
        movslq  -24(%rbp), %rcx
        cmpl    (%rax,%rcx,4), %edx
        jle     .LBB1_6
# %bb.5:                                #   in Loop: Header=BB1_3 Depth=2
        movq    -16(%rbp), %rax
        movslq  -20(%rbp), %rcx
        movl    (%rax,%rcx,4), %edx
        movl    %edx, -28(%rbp)
        movq    -16(%rbp), %rax
        movslq  -24(%rbp), %rcx
        movl    (%rax,%rcx,4), %edx
        movq    -16(%rbp), %rax
        movslq  -20(%rbp), %rcx
        movl    %edx, (%rax,%rcx,4)
        movl    -28(%rbp), %edx
        movq    -16(%rbp), %rax
        movslq  -24(%rbp), %rcx
        movl    %edx, (%rax,%rcx,4)
.LBB1_6:                                #   in Loop: Header=BB1_3 Depth=2
        jmp     .LBB1_7
.LBB1_7:                                #   in Loop: Header=BB1_3 Depth=2
        movl    -24(%rbp), %eax
        addl    $1, %eax
        movl    %eax, -24(%rbp)
        jmp     .LBB1_3
.LBB1_8:                                #   in Loop: Header=BB1_1 Depth=1
        jmp     .LBB1_9
.LBB1_9:                                #   in Loop: Header=BB1_1 Depth=1
        movl    -20(%rbp), %eax
        addl    $1, %eax
        movl    %eax, -20(%rbp)
        jmp     .LBB1_1
.LBB1_10:
        popq    %rbp
        .cfi_def_cfa %rsp, 8
        retq
.Lfunc_end1:
        .size   sort, .Lfunc_end1-sort
        .cfi_endproc
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