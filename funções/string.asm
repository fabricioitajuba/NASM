;**************************************************************
; print_string - Imprime na tela uma string
;
; Entradas:
; rsi - ponteiro da string
; rdx - tamanho da string
;**************************************************************
print_string:

    push rax
    push rdx
    push rsi
    push rdi

    mov rax, 1
    mov rdi, 1
    syscall
    
    pop rdi
    pop rsi
    pop rdx
    pop rax
    
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

    push rdx
    push rsi
    push rdi

    mov rax, 0
    mov rdi, 0
    syscall
    
    pop rdi
    pop rsi
    pop rdx
    
    ret
    
;**************************************************************
; print_string2 - Imprime na tela uma string terminada em "0"
;
; Entrada: rsi = Ponteiro para a string (terminada em byte 0)
;**************************************************************
print_string2:
   
    mov al, byte [rsi]
    cmp al, 0
    je print_string2_end
    
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall    
        
    inc rsi
    jmp print_string2

print_string2_end:
    ret
