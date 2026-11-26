	.file	"forward_kinematics.c"
	.text
	.globl	create_matrix
	.type	create_matrix, @function
create_matrix:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -16(%rbp)
	movl	-24(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	-20(%rbp), %eax
	imull	-24(%rbp), %eax
	cltq
	movl	$8, %esi
	movq	%rax, %rdi
	call	calloc@PLT
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	create_matrix, .-create_matrix
	.globl	free_matrix
	.type	free_matrix, @function
free_matrix:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rax, %rax
	movl	$0, %edx
	movq	%rcx, %rdx
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	free_matrix, .-free_matrix
	.section	.rodata
	.align 8
.LC0:
	.string	"Need matrix of same size for matrix_multiply"
	.text
	.globl	matrix_multiply
	.type	matrix_multiply, @function
matrix_multiply:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, %rax
	movq	%rsi, %r8
	movq	%rax, %rsi
	movl	$0, %edi
	movq	%r8, %rdi
	movq	%rsi, -64(%rbp)
	movq	%rdi, -56(%rbp)
	movq	%rdx, -80(%rbp)
	movq	%rcx, -72(%rbp)
	movl	-60(%rbp), %edx
	movl	-80(%rbp), %eax
	cmpl	%eax, %edx
	je	.L5
	leaq	.LC0(%rip), %rax
	movq	%rax, %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	errx@PLT
.L5:
	movl	-80(%rbp), %edx
	movl	-60(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	create_matrix
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movl	$0, -36(%rbp)
	jmp	.L6
.L11:
	movl	$0, -32(%rbp)
	jmp	.L7
.L10:
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L8
.L9:
	movq	-56(%rbp), %rdx
	movl	-60(%rbp), %eax
	imull	-36(%rbp), %eax
	movl	%eax, %ecx
	movl	-28(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm1
	movq	-72(%rbp), %rdx
	movl	-76(%rbp), %eax
	imull	-28(%rbp), %eax
	movl	%eax, %ecx
	movl	-32(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	addl	$1, -28(%rbp)
.L8:
	movl	-60(%rbp), %eax
	cmpl	%eax, -28(%rbp)
	jl	.L9
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %eax
	imull	-36(%rbp), %eax
	movl	%eax, %ecx
	movl	-32(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movsd	-24(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -32(%rbp)
.L7:
	movl	-76(%rbp), %eax
	cmpl	%eax, -32(%rbp)
	jl	.L10
	addl	$1, -36(%rbp)
.L6:
	movl	-64(%rbp), %eax
	cmpl	%eax, -36(%rbp)
	jl	.L11
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	matrix_multiply, .-matrix_multiply
	.globl	get_euler_angles
	.type	get_euler_angles, @function
get_euler_angles:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rax
	movsd	(%rax), %xmm0
	movq	-24(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	atan2@PLT
	movq	%xmm0, %rax
	movq	-32(%rbp), %rdx
	movq	%rax, (%rdx)
	movq	-24(%rbp), %rax
	addq	$48, %rax
	movsd	8(%rax), %xmm1
	movq	-24(%rbp), %rax
	addq	$48, %rax
	movsd	8(%rax), %xmm0
	mulsd	%xmm0, %xmm1
	movq	-24(%rbp), %rax
	addq	$48, %rax
	movsd	16(%rax), %xmm2
	movq	-24(%rbp), %rax
	addq	$48, %rax
	movsd	16(%rax), %xmm0
	mulsd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	pxor	%xmm3, %xmm3
	cvtsd2ss	%xmm0, %xmm3
	movd	%xmm3, %eax
	movd	%eax, %xmm0
	call	sqrtf@PLT
	pxor	%xmm2, %xmm2
	cvtss2sd	%xmm0, %xmm2
	movq	-24(%rbp), %rax
	addq	$48, %rax
	movsd	(%rax), %xmm0
	movq	.LC2(%rip), %xmm1
	xorpd	%xmm1, %xmm0
	movq	%xmm0, %rax
	movq	-32(%rbp), %rdx
	leaq	8(%rdx), %rbx
	movapd	%xmm2, %xmm1
	movq	%rax, %xmm0
	call	atan2@PLT
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movq	-24(%rbp), %rax
	addq	$48, %rax
	movsd	16(%rax), %xmm0
	movq	-24(%rbp), %rax
	addq	$48, %rax
	movq	8(%rax), %rax
	movq	-32(%rbp), %rdx
	leaq	16(%rdx), %rbx
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	atan2@PLT
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	get_euler_angles, .-get_euler_angles
	.section	.rodata
.LC3:
	.string	"%.5f "
	.text
	.globl	print_matrix
	.type	print_matrix, @function
print_matrix:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, %rax
	movq	%rsi, %rcx
	movq	%rax, %rax
	movl	$0, %edx
	movq	%rcx, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L15
.L18:
	movl	$0, -4(%rbp)
	jmp	.L16
.L17:
	movq	-24(%rbp), %rdx
	movl	-28(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, %ecx
	movl	-4(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$3, %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	leaq	.LC3(%rip), %rdx
	movq	%rax, %xmm0
	movq	%rdx, %rdi
	movl	$1, %eax
	call	printf@PLT
	addl	$1, -4(%rbp)
.L16:
	movl	-32(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L17
	movl	$10, %edi
	call	putchar@PLT
	addl	$1, -8(%rbp)
.L15:
	movl	-28(%rbp), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L18
	movl	$10, %edi
	call	putchar@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	print_matrix, .-print_matrix
	.globl	rotation
	.type	rotation, @function
rotation:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, -20(%rbp)
	movsd	%xmm0, -32(%rbp)
	movq	%rsi, -40(%rbp)
	cmpl	$2, -20(%rbp)
	je	.L20
	cmpl	$2, -20(%rbp)
	jg	.L25
	cmpl	$0, -20(%rbp)
	je	.L22
	cmpl	$1, -20(%rbp)
	je	.L23
	jmp	.L25
.L22:
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rdx)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	.LC2(%rip), %xmm0
	movq	%rax, %xmm1
	xorpd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movq	-40(%rbp), %rax
	movsd	%xmm0, 8(%rax)
	movq	-40(%rbp), %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 16(%rax)
	movq	-40(%rbp), %rax
	leaq	24(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movq	-40(%rbp), %rax
	leaq	24(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	%rax, 8(%rbx)
	movq	-40(%rbp), %rax
	addq	$24, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 16(%rax)
	movq	-40(%rbp), %rax
	addq	$48, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	addq	$48, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 8(%rax)
	movq	-40(%rbp), %rax
	addq	$48, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, 16(%rax)
	jmp	.L24
.L23:
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	-40(%rbp), %rdx
	movq	%rax, (%rdx)
	movq	-40(%rbp), %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 8(%rax)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	-40(%rbp), %rdx
	movq	%rax, 16(%rdx)
	movq	-40(%rbp), %rax
	addq	$24, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	addq	$24, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, 8(%rax)
	movq	-40(%rbp), %rax
	addq	$24, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 16(%rax)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	-40(%rbp), %rdx
	addq	$48, %rdx
	movq	.LC2(%rip), %xmm0
	movq	%rax, %xmm2
	xorpd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	movsd	%xmm0, (%rdx)
	movq	-40(%rbp), %rax
	addq	$48, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 8(%rax)
	movq	-40(%rbp), %rax
	leaq	48(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	%rax, 16(%rbx)
	jmp	.L24
.L20:
	movq	-40(%rbp), %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 8(%rax)
	movq	-40(%rbp), %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, 16(%rax)
	movq	-40(%rbp), %rax
	addq	$24, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	leaq	24(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	%rax, 8(%rbx)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	-40(%rbp), %rdx
	addq	$24, %rdx
	movq	.LC2(%rip), %xmm0
	movq	%rax, %xmm3
	xorpd	%xmm0, %xmm3
	movapd	%xmm3, %xmm0
	movsd	%xmm0, 16(%rdx)
	movq	-40(%rbp), %rax
	addq	$48, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	leaq	48(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	%rax, 8(%rbx)
	movq	-40(%rbp), %rax
	leaq	48(%rax), %rbx
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	%rax, 16(%rbx)
	jmp	.L24
.L25:
	nop
.L24:
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	rotation, .-rotation
	.section	.rodata
.LC7:
	.string	"Z: %.5f, Y: %.5f, X: %.5f\n"
	.text
	.globl	rotation_matrix
	.type	rotation_matrix, @function
rotation_matrix:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movsd	%xmm0, -56(%rbp)
	movsd	%xmm1, -64(%rbp)
	movsd	%xmm2, -72(%rbp)
	movsd	%xmm3, -80(%rbp)
	movsd	%xmm4, -88(%rbp)
	movsd	%xmm5, -96(%rbp)
	movsd	-56(%rbp), %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movsd	-64(%rbp), %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	movsd	-72(%rbp), %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	-32(%rbp), %xmm0
	movq	-40(%rbp), %rax
	leaq	.LC7(%rip), %rdx
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	movq	%rdx, %rdi
	movl	$3, %eax
	call	printf@PLT
	movl	$4, %esi
	movl	$4, %edi
	call	create_matrix
	movq	%rax, -16(%rbp)
	movq	%rdx, -8(%rbp)
	movq	-8(%rbp), %rax
	testq	%rax, %rax
	jne	.L27
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	jmp	.L29
.L27:
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	-8(%rbp), %rax
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movapd	%xmm0, %xmm6
	mulsd	-104(%rbp), %xmm6
	movsd	%xmm6, -104(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, -104(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movsd	%xmm0, -112(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	-112(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movq	-8(%rbp), %rax
	addq	$8, %rax
	movsd	-104(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movapd	%xmm0, %xmm7
	mulsd	-104(%rbp), %xmm7
	movsd	%xmm7, -104(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, -104(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movsd	%xmm0, -112(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	mulsd	-112(%rbp), %xmm0
	movq	-8(%rbp), %rax
	addq	$16, %rax
	addsd	-104(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movapd	%xmm0, %xmm4
	mulsd	-104(%rbp), %xmm4
	movsd	%xmm4, -104(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, -104(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -112(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	mulsd	-112(%rbp), %xmm0
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	addsd	-104(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movapd	%xmm0, %xmm2
	mulsd	-104(%rbp), %xmm2
	movsd	%xmm2, -104(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, -104(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -112(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movsd	-112(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movsd	-104(%rbp), %xmm0
	subsd	%xmm1, %xmm0
	movsd	%xmm0, (%rax)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	-8(%rbp), %rdx
	movl	-12(%rbp), %ecx
	addl	%ecx, %ecx
	movslq	%ecx, %rcx
	salq	$3, %rcx
	addq	%rcx, %rdx
	movq	.LC2(%rip), %xmm0
	movq	%rax, %xmm3
	xorpd	%xmm0, %xmm3
	movapd	%xmm3, %xmm0
	movsd	%xmm0, (%rdx)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-32(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -104(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	mulsd	-104(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rax
	addq	$24, %rax
	movsd	-96(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	addq	$3, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movsd	-88(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	addq	$3, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movsd	-80(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rcx
	movl	-12(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	salq	$3, %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rcx
	movl	-12(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	addq	$1, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rcx
	movl	-12(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	addq	$2, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-8(%rbp), %rcx
	movl	-12(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	addq	$3, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, (%rax)
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
.L29:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	rotation_matrix, .-rotation_matrix
	.globl	get_link_matrix
	.type	get_link_matrix, @function
get_link_matrix:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 3, -24
	movsd	%xmm0, -40(%rbp)
	movsd	%xmm1, -48(%rbp)
	movsd	%xmm2, -56(%rbp)
	movsd	%xmm3, -64(%rbp)
	movl	$4, %esi
	movl	$4, %edi
	call	create_matrix
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rax
	testq	%rax, %rax
	jne	.L31
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
	jmp	.L33
.L31:
	movq	-24(%rbp), %rbx
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	.LC2(%rip), %xmm0
	movq	%rax, %xmm4
	xorpd	%xmm0, %xmm4
	movsd	%xmm4, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	-24(%rbp), %rax
	addq	$8, %rax
	mulsd	-72(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movsd	%xmm0, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	-24(%rbp), %rax
	addq	$16, %rax
	mulsd	-72(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	-24(%rbp), %rdx
	addq	$24, %rdx
	movq	%rax, %xmm0
	mulsd	-40(%rbp), %xmm0
	movsd	%xmm0, (%rdx)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	leaq	(%rax,%rdx), %rbx
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movsd	%xmm0, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	mulsd	-72(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	.LC2(%rip), %xmm0
	movq	%rax, %xmm5
	xorpd	%xmm0, %xmm5
	movsd	%xmm5, -72(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	mulsd	-72(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-64(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	-24(%rbp), %rdx
	movl	-28(%rbp), %ecx
	movslq	%ecx, %rcx
	addq	$3, %rcx
	salq	$3, %rcx
	addq	%rcx, %rdx
	movq	%rax, %xmm0
	mulsd	-40(%rbp), %xmm0
	movsd	%xmm0, (%rdx)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	addq	$1, %rdx
	salq	$3, %rdx
	leaq	(%rax,%rdx), %rbx
	movq	-48(%rbp), %rax
	movq	%rax, %xmm0
	call	sin@PLT
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	addq	$2, %rdx
	salq	$3, %rdx
	leaq	(%rax,%rdx), %rbx
	movq	-48(%rbp), %rax
	movq	%rax, %xmm0
	call	cos@PLT
	movq	%xmm0, %rax
	movq	%rax, (%rbx)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	addq	$3, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movsd	-56(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	movq	-24(%rbp), %rcx
	movl	-28(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	salq	$3, %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-24(%rbp), %rcx
	movl	-28(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	addq	$1, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-24(%rbp), %rcx
	movl	-28(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	addq	$2, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, (%rax)
	movq	-24(%rbp), %rcx
	movl	-28(%rbp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	cltq
	addq	$3, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, (%rax)
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rdx
.L33:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	get_link_matrix, .-get_link_matrix
	.section	.rodata
.LC18:
	.string	"matrix, %d\n"
	.text
	.globl	forward_kinematics
	.type	forward_kinematics, @function
forward_kinematics:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$472, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -472(%rbp)
	movq	%rsi, -480(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -224(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -216(%rbp)
	movsd	.LC8(%rip), %xmm0
	movsd	%xmm0, -208(%rbp)
	movq	-472(%rbp), %rax
	movsd	(%rax), %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -200(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -192(%rbp)
	movsd	.LC9(%rip), %xmm0
	movsd	%xmm0, -184(%rbp)
	movsd	.LC10(%rip), %xmm0
	movsd	%xmm0, -176(%rbp)
	movq	-472(%rbp), %rax
	addq	$8, %rax
	movsd	(%rax), %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -168(%rbp)
	movsd	.LC11(%rip), %xmm0
	movsd	%xmm0, -160(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -152(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -144(%rbp)
	movq	-472(%rbp), %rax
	addq	$16, %rax
	movsd	(%rax), %xmm1
	movsd	.LC12(%rip), %xmm0
	addsd	%xmm0, %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -136(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -128(%rbp)
	movsd	.LC13(%rip), %xmm0
	movsd	%xmm0, -120(%rbp)
	movsd	.LC14(%rip), %xmm0
	movsd	%xmm0, -112(%rbp)
	movq	-472(%rbp), %rax
	addq	$24, %rax
	movsd	(%rax), %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -104(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -96(%rbp)
	movsd	.LC13(%rip), %xmm0
	movsd	%xmm0, -88(%rbp)
	movsd	.LC15(%rip), %xmm0
	movsd	%xmm0, -80(%rbp)
	movq	-472(%rbp), %rax
	addq	$32, %rax
	movsd	(%rax), %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -72(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -64(%rbp)
	movsd	.LC9(%rip), %xmm0
	movsd	%xmm0, -56(%rbp)
	movsd	.LC16(%rip), %xmm0
	movsd	%xmm0, -48(%rbp)
	movq	-472(%rbp), %rax
	addq	$40, %rax
	movsd	(%rax), %xmm0
	movsd	.LC12(%rip), %xmm2
	movapd	%xmm0, %xmm1
	subsd	%xmm2, %xmm1
	movsd	.LC5(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC6(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movl	$0, -456(%rbp)
	jmp	.L35
.L36:
	movl	-456(%rbp), %eax
	cltq
	salq	$5, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$184, %rax
	movsd	(%rax), %xmm2
	movl	-456(%rbp), %eax
	cltq
	salq	$5, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$192, %rax
	movsd	(%rax), %xmm1
	movl	-456(%rbp), %eax
	cltq
	salq	$5, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$200, %rax
	movsd	(%rax), %xmm0
	movl	-456(%rbp), %eax
	cltq
	salq	$5, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$208, %rax
	movq	(%rax), %rax
	movl	-456(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	leaq	-16(%rdx), %rbx
	leaq	(%rbx,%rbp), %rdx
	leaq	-400(%rdx), %rbx
	movapd	%xmm2, %xmm3
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	get_link_matrix
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	addl	$1, -456(%rbp)
.L35:
	cmpl	$5, -456(%rbp)
	jle	.L36
	cmpq	$0, -480(%rbp)
	je	.L37
	movq	-480(%rbp), %rax
	pxor	%xmm0, %xmm0
	movss	%xmm0, (%rax)
	movq	-480(%rbp), %rax
	pxor	%xmm0, %xmm0
	movss	%xmm0, 4(%rax)
	movq	-480(%rbp), %rax
	pxor	%xmm0, %xmm0
	movss	%xmm0, 8(%rax)
.L37:
	movq	-416(%rbp), %rax
	movq	-408(%rbp), %rdx
	movq	%rax, -320(%rbp)
	movq	%rdx, -312(%rbp)
	movl	$1, -452(%rbp)
	jmp	.L38
.L39:
	movl	-452(%rbp), %eax
	leal	-1(%rax), %ecx
	movl	-452(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	leaq	-304(%rax), %rbx
	movl	-452(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$400, %rax
	movq	8(%rax), %rdx
	movq	(%rax), %rax
	movslq	%ecx, %rcx
	salq	$4, %rcx
	leaq	-16(%rcx), %rsi
	leaq	(%rsi,%rbp), %rcx
	subq	$304, %rcx
	movq	(%rcx), %rdi
	movq	8(%rcx), %rsi
	movq	%rdx, %rcx
	movq	%rax, %rdx
	call	matrix_multiply
	movq	%rax, (%rbx)
	movq	%rdx, 8(%rbx)
	addl	$1, -452(%rbp)
.L38:
	cmpl	$5, -452(%rbp)
	jle	.L39
	cmpq	$0, -480(%rbp)
	je	.L40
	movl	$1, -448(%rbp)
	jmp	.L41
.L42:
	movl	-448(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$296, %rax
	movq	(%rax), %rax
	addq	$24, %rax
	movsd	(%rax), %xmm0
	movl	-448(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdx
	movq	-480(%rbp), %rax
	addq	%rdx, %rax
	cvtsd2ss	%xmm0, %xmm0
	movss	%xmm0, (%rax)
	movl	-448(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$296, %rax
	movq	(%rax), %rax
	movl	-448(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	leaq	-16(%rdx), %rbx
	leaq	(%rbx,%rbp), %rdx
	subq	$300, %rdx
	movl	(%rdx), %edx
	movslq	%edx, %rdx
	addq	$3, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movl	-448(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdx
	movq	-480(%rbp), %rax
	addq	%rdx, %rax
	cvtsd2ss	%xmm0, %xmm0
	movss	%xmm0, 4(%rax)
	movl	-448(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$296, %rax
	movq	(%rax), %rax
	movl	-448(%rbp), %edx
	movslq	%edx, %rdx
	salq	$4, %rdx
	leaq	-16(%rdx), %rbx
	leaq	(%rbx,%rbp), %rdx
	subq	$300, %rdx
	movl	(%rdx), %edx
	addl	%edx, %edx
	movslq	%edx, %rdx
	addq	$3, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movsd	(%rax), %xmm0
	movl	-448(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdx
	movq	-480(%rbp), %rax
	addq	%rdx, %rax
	cvtsd2ss	%xmm0, %xmm0
	movss	%xmm0, 8(%rax)
	addl	$1, -448(%rbp)
.L41:
	cmpl	$5, -448(%rbp)
	jle	.L42
.L40:
	movq	-240(%rbp), %rax
	movq	-232(%rbp), %rdx
	movq	%rax, -432(%rbp)
	movq	%rdx, -424(%rbp)
	movl	$0, -444(%rbp)
	jmp	.L43
.L44:
	movl	-444(%rbp), %eax
	leal	1(%rax), %edx
	leaq	.LC18(%rip), %rax
	movl	%edx, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-444(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$304, %rax
	movq	(%rax), %rdx
	movq	8(%rax), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	print_matrix
	addl	$1, -444(%rbp)
.L43:
	cmpl	$5, -444(%rbp)
	jle	.L44
	leaq	.LC18(%rip), %rax
	movl	$7, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-432(%rbp), %rdx
	movq	-424(%rbp), %rax
	movq	%rdx, %rdi
	movq	%rax, %rsi
	call	print_matrix
	movl	$0, -440(%rbp)
	jmp	.L45
.L46:
	movl	-440(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$296, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	addl	$1, -440(%rbp)
.L45:
	cmpl	$4, -440(%rbp)
	jle	.L46
	movl	$1, -436(%rbp)
	jmp	.L47
.L48:
	movl	-436(%rbp), %eax
	cltq
	salq	$4, %rax
	leaq	-16(%rax), %rax
	addq	%rbp, %rax
	subq	$392, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free@PLT
	addl	$1, -436(%rbp)
.L47:
	cmpl	$5, -436(%rbp)
	jle	.L48
	movq	-432(%rbp), %rax
	movq	-424(%rbp), %rdx
	movq	-24(%rbp), %rcx
	subq	%fs:40, %rcx
	je	.L50
	call	__stack_chk_fail@PLT
.L50:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	forward_kinematics, .-forward_kinematics
	.section	.rodata
	.align 16
.LC2:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC4:
	.long	0
	.long	1072693248
	.align 8
.LC5:
	.long	1413754136
	.long	1074340347
	.align 8
.LC6:
	.long	0
	.long	1080459264
	.align 8
.LC8:
	.long	0
	.long	1079361536
	.align 8
.LC9:
	.long	1413754136
	.long	1073291771
	.align 8
.LC10:
	.long	0
	.long	1079525376
	.align 8
.LC11:
	.long	0
	.long	1081180160
	.align 8
.LC12:
	.long	0
	.long	1079410688
	.align 8
.LC13:
	.long	1413754136
	.long	-1074191877
	.align 8
.LC14:
	.long	0
	.long	1077510144
	.align 8
.LC15:
	.long	0
	.long	1080791040
	.align 8
.LC16:
	.long	0
	.long	1079083008
	.ident	"GCC: (GNU) 16.1.1 20260430"
	.section	.note.GNU-stack,"",@progbits
