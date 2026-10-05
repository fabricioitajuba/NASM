; Ex11 - Deletar um arquivo
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 Ex11.asm
; Linkeditar
; $ ld -s -o Ex11 Ex11.o
; ou:
; $ make

section .data
    LF equ 10  ; Line Feed
    CR equ 13  ; Carrie return

    msg1 db "Arquivo deletado com sucesso!", LF, CR   ;String a ser impressa
    tam1 equ $- msg1                                  ;Tamanho da String

    msg2 db "O Arquivo não existe!", LF, CR           ;String a ser impressa
    tam2 equ $- msg2                                  ;Tamanho da String    

    arquivo_alvo db "arquivo.txt", 0  ; Nome do arquivo terminado em 0

section .text
    global _start

_start:
    mov rax, 87                ; Código da syscall sys_unlink
    mov rdi, arquivo_alvo      ; Ponteiro para o nome do arquivo
    syscall                    ; Executa a deleção

    ; O retorno em RAX será:
    ; 0  = Sucesso total
    ; <0 = Código de erro negativo (ex: se o arquivo não existir)

    cmp rax, 0
    je arquivo_deletado

    ;Imprime String
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, tam2
    syscall 
    jmp end

arquivo_deletado:
    ;Imprime String
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, tam1
    syscall 

end:
    ; Finaliza o programa (sys_exit)
    mov rax, 60
    mov rdi, 0
    syscall
