;******************************************************
; Listar registros
;******************************************************

section .data

    msg_list_reg db LF, CR, "- Digite a quantidade de registros a listar por tela: "
    msg_list_reg_len equ $-msg_list_reg

    list_cabecalho db '-------------------------------------------------------------------',CR,LF
                   db 'ID |   DATA   |  HORA  |              NOME                | IDADE  ',CR,LF
                   db '-------------------------------------------------------------------',CR,LF
    list_cabecalho_len equ $-list_cabecalho

section .bss

section .text

crud_list:

    mov rsi, msg_list_reg
    mov rdx, msg_list_reg_len
    call print_string

    ; Lê qual registro deseja listar
    mov rsi, buffer_teclado
    mov rdx, 4
    call read_string

    ; Converte a string para hexa
    mov rsi, buffer_teclado
    call string2hexa

    ;Guarda o número do registro a ser listado
    mov [nreg2], rax

    ; Limpa a tela
    call clear_screean

    ; Imprime o cabeçalho da listagem
    mov rsi, list_cabecalho
    mov rdx, list_cabecalho_len
    call print_string

    ; Limpa o buffer de leitura
    call clear_buffer_read

    mov rax, 0
    mov [offset], rax
    mov [cont], rax

list_loop:

    mov rax, [offset]

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

    cmp rax, 0
    je list_end

    ; Imprime o registro lido <---------------teste
    mov rsi, buffer_read
    mov rdx, reg_max-1
    call print_string

    mov rax, [offset]
    add rax, reg_max-1
    mov [offset], rax

    jmp list_loop

list_end:
    mov rsi, caracter
    mov rdx, 2    
    call read_string

    ret