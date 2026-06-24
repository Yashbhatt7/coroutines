format ELF64 executable

STDIN_FILENO = 0
STDOUT_FILENO = 1
STDERR_FILENO = 2

SYS_write = 1
SYS_exit = 60

COROUTINES_CAPACITY = 11
STACK_CAPACITY = 4 * 1024

segment executable
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
    call coroutine_yield

    inc QWORD [rbp - 8]
    jmp .again
.over:
    mov rsp, rbp
    pop rbp
    ret

;rdi : procedure to start in a new coroutine
coroutine_go:
    cmp QWORD [contexts_count], COROUTINES_CAPACITY
    jge overflow_fail

    mov rbx, [contexts_count]   ;copying the current index of the context into rbx

    inc QWORD [contexts_count]

    mov rax, [stacks_end]       ;rax have the rsp of the new routine

    sub QWORD [stacks_end], STACK_CAPACITY

    mov [contexts_rsp + rbx * 8],       rax
    mov QWORD [contexts_rbp + rbx * 8], 0
    mov [contexts_rip + rbx * 8],       rdi

    ret


; ...[ret]
;         ^     ; that arrow is where now rsp is pointing after we do pop rax because pop rax will do this
                ; rax = [rsp]
                ; rsp += 8 as if coroutine_init was never called
coroutine_init:
    cmp QWORD [contexts_count], COROUTINES_CAPACITY
    jge overflow_fail

    mov rbx, [contexts_count]

    inc QWORD [contexts_count]

    pop rax                      ;return address is in rax now

    mov [contexts_rsp + rbx * 8], rsp
    mov [contexts_rbp + rbx * 8], rbp
    mov [contexts_rip + rbx * 8], rax

    jmp rax


; ...[ret]
;         ^
coroutine_yield:
    mov rbx, [contexts_current]

    pop rax                      ;return address is in rax now

    mov [contexts_rsp + rbx * 8], rsp
    mov [contexts_rbp + rbx * 8], rbp
    mov [contexts_rip + rbx * 8], rax

    inc rbx
    xor rcx, rcx
    cmp rbx, [contexts_count]
    cmovge rbx, rcx
    mov [contexts_current], rbx

    mov rsp,  [contexts_rsp + rbx * 8]
    mov rbp,  [contexts_rbp + rbx * 8]
    jmp QWORD [contexts_rip + rbx * 8]


entry main
main:
    call coroutine_init

    mov rdi, counter
    call coroutine_go

    mov rdi, counter
    call coroutine_go

    call coroutine_yield
    call coroutine_yield
    call coroutine_yield
    call coroutine_yield
    call coroutine_yield
    call coroutine_yield
    call coroutine_yield
    call coroutine_yield
    call coroutine_yield
    call coroutine_yield

    ; mov rdi, [stacks_end]
    ; call print
    ;
    ; sub QWORD [stacks_end], STACK_CAPACITY
    ; mov rbx, [stacks_end]
    ; mov rdi, rbx
    ; call print


    mov rdi, [contexts_count]
    call print

    mov rax, SYS_write
    mov rdi, STDOUT_FILENO
    mov rsi, ok
    mov rdx, ok_len
    syscall

    mov rax, SYS_exit
    mov rdi, 0
    syscall

overflow_fail:
    mov rax, SYS_write
    mov rdi, STDERR_FILENO
    mov rsi, too_many_coroutines_msg
    mov rdx, too_many_coroutines_msg_len
    syscall

    mov rax, SYS_exit
    mov rdi, 0
    syscall

segment readable
too_many_coroutines_msg: db "err: Too many coroutines!", 10, 0
too_many_coroutines_msg_len = $ - too_many_coroutines_msg
ok: db "ok", 10, 0
ok_len = $ - ok

segment readable writable
contexts_current: dq 0
stacks_end: dq stacks + COROUTINES_CAPACITY * STACK_CAPACITY
stacks: rb COROUTINES_CAPACITY * STACK_CAPACITY
contexts_rsp: rq COROUTINES_CAPACITY
contexts_rbp: rq COROUTINES_CAPACITY
contexts_rip: rq COROUTINES_CAPACITY

contexts_count: rq 1

