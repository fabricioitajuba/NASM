;**************************************************************
; string_data - Data do sistema (Ex13.asm)
;
; Entradas:
;
; %include "../funções/hexa2decimal.asm"
;
; Saídas:
;
; section .data
;    date_str: db "00/00/0000"
;
; section .bss
;    timespec:
;        .tv_sec:  resq 1    ; Segundos (64-bit)
;        .tv_nsec: resq 1    ; Nanossegundos (64-bit)
;**************************************************************

string_data:

    mov rax, 228
    mov rdi, 0
    mov rsi, timespec
    syscall

    mov rax, [timespec.tv_sec]
    sub rax, 10800

    xor rdx, rdx
    mov rbx, 86400
    div rbx

    add rax, 719468
    
    xor rdx, rdx
    mov rbx, 146097
    div rbx
    mov r8, rax
    
    mov rax, rdx
    xor rdx, rdx
    mov rbx, 36524
    div rbx

    cmp rax, 4
    jne .not_4_century
    mov rax, 3

.not_4_century:

    imul r8, 400
    imul rax, 100
    add r8, rax
    
    mov rax, rdx
    xor rdx, rdx
    mov rbx, 1461
    div rbx
    imul rax, 4
    add r8, rax
    
    mov rax, rdx
    xor rdx, rdx
    mov rbx, 365
    div rbx
    cmp rax, 4
    jne .not_4_year
    mov rax, 3

.not_4_year:
    add r8, rax
    mov r11, rdx

    imul rax, r11, 5
    add rax, 2
    mov rbx, 153
    xor rdx, rdx
    div rbx
    mov r9, rax
    
    imul rax, 153
    add rax, 2
    mov rbx, 5
    xor rdx, rdx
    div rbx
    sub r11, rax
    add r11, 1

    mov rax, r9
    cmp rax, 10
    jl .mes_normal
    sub rax, 9
    add r8, 1
    jmp .salva_mes

.mes_normal:
    add rax, 3

.salva_mes:
    mov r10, rax

    mov rax, r11
    mov rdi, date_str
    call int_to_ascii_2dig

    mov rax, r10
    mov rdi, date_str + 3
    call int_to_ascii_2dig


    mov rax, r8
    mov rdi, date_str + 6
    call int_to_ascii_4dig

    ret


;**************************************************************
; string_hora - Hora do sistema  (Ex12.asm)
;
; Entradas:
;
; %include "../funções/hexa2decimal.asm"
;
; Saídas:
;
; section .data
;    time_str: db "00:00:00"
;
;**************************************************************

string_hora:

    mov rax, 201
    xor rdi, rdi
    syscall

    xor rdx, rdx
    mov rbx, 86400
    div rbx
    
    mov rax, rdx

    xor rdx, rdx
    mov rbx, 60
    div rbx
    mov r8, rdx

    xor rdx, rdx
    mov rbx, 60
    div rbx
    sub rax, 3
    mov r9, rdx
    mov r10, rax

    mov rax, r10
    mov rdi, time_str
    call int_to_ascii_2dig

    mov rax, r9
    mov rdi, time_str + 3
    call int_to_ascii_2dig

    mov rax, r8
    mov rdi, time_str + 6
    call int_to_ascii_2dig

    ret
