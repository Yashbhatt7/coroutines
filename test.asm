	.file	"test.c"
	.intel_syntax noprefix
	.text
	.p2align 4
	.globl	"print"
	.type	"print", @function
"print":
.LFB11:
	.cfi_startproc
	sub	rsp, 56
	.cfi_def_cfa_offset 64
	test	edi, edi
	je	.L2
	jle	.L17
	mov	QWORD PTR 48[rsp], rbx
	.cfi_offset 3, -16
	mov	r9, rsp
	mov	rdx, rsp
	mov	r10, rsp
	xor	r11d, r11d
	mov	ebx, 3435973837
	.p2align 6
	.p2align 4
	.p2align 3
.L6:
	mov	eax, edi
	mov	ecx, edi
	mov	esi, r11d
	add	r10, 1
	imul	rax, rbx
	lea	r11d, 1[r11]
	shr	rax, 35
	lea	r8d, [rax+rax*4]
	add	r8d, r8d
	sub	ecx, r8d
	add	ecx, 48
	mov	BYTE PTR -1[r10], cl
	mov	ecx, edi
	mov	edi, eax
	cmp	ecx, 9
	jg	.L6
	mov	BYTE PTR [rsp+r11], 10
	test	esi, esi
	je	.L18
	mov	eax, esi
	lea	r10d, 2[rsi]
	mov	ecx, esi
	add	rax, r9
	.p2align 6
	.p2align 4
	.p2align 3
.L10:
	movzx	edi, BYTE PTR [rdx]
	movzx	r8d, BYTE PTR [rax]
	sub	ecx, 1
	add	rdx, 1
	sub	rax, 1
	mov	BYTE PTR -1[rdx], r8b
	mov	BYTE PTR 1[rax], dil
	mov	edi, esi
	sub	edi, ecx
	cmp	ecx, edi
	jg	.L10
	mov	rbx, QWORD PTR 48[rsp]
	.cfi_restore 3
	jmp	.L8
	.p2align 4,,10
	.p2align 3
.L2:
	mov	eax, 2608
	mov	r9, rsp
	mov	WORD PTR [rsp], ax
.L5:
	mov	r10d, 2
.L8:
	mov	rdx, r10
	mov	rsi, r9
	mov	edi, 1
	call	"write"@PLT
	add	rsp, 56
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L17:
	.cfi_restore_state
	mov	BYTE PTR [rsp], 10
	mov	r10d, 1
	mov	r9, rsp
	jmp	.L8
.L18:
	.cfi_offset 3, -16
	mov	rbx, QWORD PTR 48[rsp]
	.cfi_restore 3
	jmp	.L5
	.cfi_endproc
.LFE11:
	.size	"print", .-"print"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	"main"
	.type	"main", @function
"main":
.LFB12:
	.cfi_startproc
	sub	rsp, 8
	.cfi_def_cfa_offset 16
	mov	edi, 20350
	call	"print"
	xor	eax, eax
	add	rsp, 8
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE12:
	.size	"main", .-"main"
	.ident	"GCC: (GNU) 16.1.1 20260430"
	.section	.note.GNU-stack,"",@progbits
