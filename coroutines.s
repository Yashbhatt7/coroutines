format ELF64 executable

; segment readable executable

SYS_write = 1
STDOUT = 1
SYS_exit = 60

print:
    mov     r9, -3689348814741910323
    sub     rsp, 40
    mov     BYTE [rsp+31], 10
    lea     rcx, [rsp+30]
.L2:
    mov     rax, rdi
    lea     r8, [rsp+32]
    mul     r9
    mov     rax, rdi
    sub     r8, rcx
    shr     rdx, 3
    lea     rsi, [rdx+rdx*4]
    add     rsi, rsi
    sub     rax, rsi
    add     eax, 48
    mov     BYTE [rcx], al
    mov     rax, rdi
    mov     rdi, rdx
    mov     rdx, rcx
    sub     rcx, 1
    cmp     rax, 9
    ja      .L2
    lea     rax, [rsp+32]
    mov     edi, 1
    sub     rdx, rax
    xor     eax, eax
    lea     rsi, [rsp+32+rdx]
    mov     rdx, r8
    mov     rax, 1
    syscall
    add     rsp, 40
    ret

counter:
    push rbp
    mov rbp, rsp
    sub rsp, 8

    mov QWORD [rbp - 8], 0
.again:
    cmp QWORD [rbp - 8], 10
    jge .over

    mov rdi, [rbp - 8]        ; no need to write QWORD because you're copying the value in
                              ; rdi register which is also already 64 bit in size
    call print

    inc QWORD [rbp - 8]
    jmp .again
.over:
    mov rsp, rbp
    pop rbp
    ret

entry main
main:
    call counter

    ; mov rdi, 56655
    ; call print

    mov rax, SYS_exit
    mov rdi, 0
    syscall

msg: db "hello world", 10, 0
msg_len = $-msg

