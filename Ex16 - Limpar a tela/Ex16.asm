; Ex16 - Limpar a tela
; Autor Eng. Fabrício Ribeiro
; Compilar:
; $ nasm -f elf64 Ex16.asm
; Linkeditar
; $ ld -s -o Ex16 Ex16.o
; ou:
; $ make

section .data
    ; Sequência ANSI: \x1b é o caractere ESC (27 em decimal ou 1Bh em hex)
    clear_screen db 0x1b, '[2J', 0x1b, '[H'
    clear_len    equ $ - clear_screen

section .text
    global _start

_start:
    ; --- Chamada da Syscall sys_write (ID 1) ---
    mov rax, 1              ; ID da syscall sys_write no x86_64
    mov rdi, 1              ; File descriptor: 1 = stdout (tela)
    mov rsi, clear_screen   ; Ponteiro para a nossa string ANSI
    mov rdx, clear_len      ; Tamanho da string
    syscall                 ; Invoca o sistema operacional

    ; --- Chamada da Syscall sys_exit (ID 60) ---
    mov rax, 60             ; ID da syscall sys_exit
    mov rdi, 0              ; Código de retorno 0 (sem erros)
    syscall

; A sequência ANSI padrão para isso é ESC [ 2 J (limpa a tela) 
; combinada com ESC [ H (move o cursor para o topo esquerdo). 
; Em hexadecimal, essa string pode ser representada como \x1b[2J\x1b[H