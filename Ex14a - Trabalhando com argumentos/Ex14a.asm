; Ex14a - Trabalhando com argumentos
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 Ex14a.asm
; Linkeditar
; $ ld -s -o Ex14a Ex14a.o
; ou:
; $ make

default abs

section .data
    msg1: db "Número de argumentos: ", 0
    newline: db 0xA, 0

section .bss

section .text
    global _start

_start:

    ; Mostra a quantidade de argumentos passados para o programa
    mov rsi, msg1
    call print_string2

    mov rax, [rsp]          ; rsp contém a quantidade de argumentos passados para o programa
                            ; o primeiro argumento (argv[0]) é o nome do programa, então o 
                            ; valor de rax será 1 se nenhum argumento for passado.
    call hexa2decimal       ; Converte o valor de rax para string decimal

    mov rsi, digitos        ; ponteiro para o buffer de dígitos
    mov rdx, 8              ; tamanho da string em bytes
    call print_string       ; mostra a quantidade de argumentos passados para o programa

    ; Pula linha
    mov rsi, newline
    call print_string2

     ; Mostra os argumentos passados para o programa
    mov rcx, [rsp]        ; rcx = quantidade de argumentos (argc)
    lea rbx, [rsp + 8]    ; rbx apontará diretamente para o primeiro argumento (argv[0])

show_args:
    push rcx              ; Salva o contador do loop na pilha
    push rbx              ; Salva o ponteiro atual da lista de argumentos

    mov rsi, [rbx]        ; Copia o endereço da string atual para rsi
    call print_string2    ; Chama sua função de impressão (ela assume que o texto está em rsi)

    ; Pula linha
    mov rsi, newline
    call print_string2

    pop rbx               ; Recupera o ponteiro da lista de argumentos
    pop rcx               ; Recupera o contador do loop

    add rbx, 8            ; Avança para o próximo argumento (próximos 8 bytes)
    loop show_args        ; Decrementa rcx e repete se rcx > 0


    ; Retorna ao sistema operacional
    mov rax, 60
    xor rdi, rdi
    syscall

%include "../funções/hexa2decimal.asm"
%include "../funções/string.asm"