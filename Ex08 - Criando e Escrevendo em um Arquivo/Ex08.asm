; Ex08 - Criando e Escrevendo em um Arquivo
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 hello.asm
; Linkeditar
; $ ld -s -o hello hello.o
; ou:
; $ make

default abs

;Constantes
section .data
    filename db "exemplo.txt", 0
    conteudo db "Ola! Escrevendo em arquivo via Assembly no Linux x64.", 10
    conteudo_len equ $-conteudo

;Variáveis
section .bss
    fd_arquivo resq 1   ; Reserva 8 bytes (quadword) para guardar o File Descriptor

;Programa principal
section .text
    global _start

_start:

    ; 1. ABRIR / CRIAR O ARQUIVO (sys_open)    
    mov rax, 2              ; código da syscall sys_open
    mov rdi, filename       ; nome do arquivo
    mov rsi, 65             ; Flags: O_WRONLY (1) + O_CREAT (64) = 65 (Escrita + Cria se não existir)
    mov rdx, 0o644          ; Permissões em octal (rw-r--r--)
    syscall

    ; Salva o File Descriptor retornado em RAX na nossa variável
    mov [fd_arquivo], rax

    ; 2. ESCREVER NO ARQUIVO (sys_write)
    mov rax, 1              ; código da syscall sys_write    
    mov rdi, [fd_arquivo]   ; passa o File Descriptor salvo
    mov rsi, conteudo       ; endereço da mensagem
    mov rdx, conteudo_len   ; tamanho da mensagem
    syscall

    ; 3. FECHAR O ARQUIVO (sys_close)
    mov rax, 3              ; código da syscall sys_close
    mov rdi, [fd_arquivo]   ; passa o File Descriptor
    syscall

    ; 4. ENCERRAR O PROGRAMA (sys_exit)
    mov rax, 60             ; código da syscall sys_exit
    mov rdi, 0              ; status de saída 0 (sem erros)
    syscall
