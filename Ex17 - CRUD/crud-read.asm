;******************************************************
; Ler registro
;******************************************************

section .data

    msg_read_reg db LF, CR, "- Qual registro deseja ler? "
    msg_read_reg_len equ $-msg_read_reg

section .bss

section .text

crud_read:

    call clear_buffer_read

    ; imprime a string de qual registro deseja ler
    mov rsi, msg_read_reg
    mov rdx, msg_read_reg_len
    call print_string

    ; Lê qual registro deseja ler
    mov rsi, buffer_teclado
    mov rdx, 4
    call read_string

    ; Converte a string para hexa
    mov rsi, buffer_teclado
    call string2hexa

    ; Calcula o registro a ser lido
    dec rax
    mov rbx, reg_max-1
    mul rbx      ;rax contém o ponteiro do registro a ser lido
    mov [offset], rax

    ; move o ponteiro para o início do registro
    mov rdi, [fd]
    call file_pointer_begin

    ; Posiciona o ponteiro para um local específico do arquivo
    mov rdi, [fd]
    mov rsi, [offset]
    call file_pointer_set

    ; Le o registro no local específico do arquivo
    mov rdi, [fd]
    mov rsi, buffer_read
    mov rdx, reg_max-1
    call file_read

    ; Imprime o registro lido <---------------teste
    ;mov rsi, buffer_read
    ;mov rdx, reg_max-1
    ;call print_string

    ; Imprime o nome
    mov rsi, nome
    mov rdx, nome_len
    call print_string

    mov rsi, buffer_read+24
    mov rdx, 34
    call print_string

    ; Imprime a idade
    mov rsi, idade
    mov rdx, idade_len
    call print_string

    mov rsi, buffer_read+59
    mov rdx, 3
    call print_string

crud_read_end:
    mov rsi, caracter
    mov rdx, 2    
    call read_string

    ret
