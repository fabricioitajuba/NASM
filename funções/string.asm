;**************************************************************
; print_string - Imprime na tela uma string
;
; Entradas:
; rsi - ponteiro da string
; rdx - tamanho da string
;**************************************************************
print_string:
    mov rax, 1
    mov rdi, 1
    syscall
    ret

;**************************************************************
; read_string - Lê uma string
;
; Entradas:
; rsi - ponteiro do buffer de teclado
; rdx - tamanho máximo de caracteres a ser digitado
;
; Saídas:
; rax - número exato de caracteres digitados incluíndo a tecla
;       ENTER(0x0A) no final
;**************************************************************
read_string:
    mov rax, 0
    mov rdi, 0
    syscall
    ret