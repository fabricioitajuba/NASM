; Ex18 - Exemplo de menu
; Autor Eng. Fabrício Ribeiro
;
; Pressione uma tecla em seguida pressione ENTER
; Compilar:
; $ nasm -f elf64 Ex18.asm
; Linkeditar
; $ ld -s -o Ex18 Ex18.o
; ou:
; $ make


;************************************************
;Variáveis inicializadas
;************************************************
section .data

    LF equ 10
    CR equ 13

    msg_ini db CR,LF,'- O que Voce deseja?',CR,LF,CR,LF
            db '1 - Mensagem 1;',CR,LF
            db '2 - Mensagem 2;',CR,LF
            db 'Q - Sair;',CR,LF
            db '>> '
    msg_ini_len equ $-msg_ini

    msg1 db LF, CR, "# Essa é a mensagem 1 ", LF, CR
    msg1_len equ $-msg1

    msg2 db LF, CR, "# Essa é a mensagem 2 ", LF, CR
    msg2_len equ $-msg2


;************************************************
;Variáveis não inicializadas
;************************************************
section .bss

    caracter resb 2

;************************************************
; Programa principal
;************************************************
section .text
    global _start

_start:

    mov rsi, msg_ini
    mov rdx, msg_ini_len
    call print_string  

    mov rsi, caracter
    mov rdx, 2    
    call read_string

    mov al, [caracter]

    cmp al, '1'
    je show_msg1
    cmp al, '2'
    je show_msg2
    cmp al, 'Q'
    je exit    
    jmp _start

show_msg1:
    mov rsi, msg1
    mov rdx, msg1_len    
    call print_string
    jmp _start

show_msg2:
    mov rsi, msg2
    mov rdx, msg2_len    
    call print_string
    jmp _start

    ; retorna ao sistema operacional
exit:
    mov rax, 60
    mov rdi, 0
    syscall

%include "../funções/string.asm"
