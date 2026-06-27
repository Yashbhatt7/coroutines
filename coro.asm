format ELF64 executable

SYS_exit = 60

MAX_COROUTINES = 10
COROUTINE_STACK_CAPACITY = 4 * 1024

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

    mov rdi, [rbp - 8]
    call print

    call coroutine_yield

    inc QWORD [rbp - 8]
    jmp .again

.over:
    mov rsp, rbp
    pop rbp
    ret

coroutine_init:
    cmp QWORD [contexts_count], MAX_COROUTINES
    jge its_over

    inc QWORD [contexts_count]

    pop rax

    jmp rax


coroutine_go:
    cmp QWORD [contexts_count], MAX_COROUTINES
    jge its_over

    mov rbx, [contexts_count]

    inc QWORD [contexts_count]

    mov rax, [stack_end]
    sub rax, 8

    sub QWORD [stack_end], COROUTINE_STACK_CAPACITY

    mov [contexts_rsp + rbx * 8], rax               ;; rbx * 8 shows which index you're storing on
    mov QWORD [contexts_rbp + rbx * 8], 0
    mov [contexts_rip + rbx * 8], rdi

    ret


coroutine_yield:
    mov rbx, [current_context]

    pop rax

    mov [contexts_rsp + rbx * 8], rsp
    mov [contexts_rbp + rbx * 8], rbp
    mov [contexts_rip + rbx * 8], rax

    inc rbx
    xor rcx, rcx
    cmp rbx, [contexts_count]
    cmovge rbx, rcx

    mov [current_context], rbx

    mov rsp, [contexts_rsp + rbx * 8]
    mov rbp, [contexts_rbp + rbx * 8]
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

    call its_over

its_over:
    mov rax, SYS_exit            ;; 60 means SYS_exit syscall number
    mov rdi, 0
    syscall


segment readable writable
stack_end: dq stacks + MAX_COROUTINES * COROUTINE_STACK_CAPACITY
current_context: dq 0


stacks: rb MAX_COROUTINES * COROUTINE_STACK_CAPACITY
contexts_rsp: rq MAX_COROUTINES
contexts_rbp: rq MAX_COROUTINES
contexts_rip: rq MAX_COROUTINES
contexts_count: rq 1

