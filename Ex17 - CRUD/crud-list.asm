;******************************************************
; Listar registros
;******************************************************

section .data

    msg_list_reg db LF, CR, "- Digite a quantidade de registros a listar por tela (1-20): "
    msg_list_reg_len equ $-msg_list_reg

    msg_list_reg2 db LF, CR, "# Pressione qualquer tecla para continuar... ", LF, CR
    msg_list_reg2_len equ $-msg_list_reg2

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

    cmp rax, 0
    jbe crud_list
    cmp rax, 20
    ja crud_list    

    ;Guarda o número do registro a ser listado
    mov [nreg2], rax

    mov rax, 0
    mov [offset], rax
    mov [cont], rax

list_loop2:

    ; Limpa a tela
    call clear_screean

    ; Imprime o cabeçalho da listagem
    mov rsi, list_cabecalho
    mov rdx, list_cabecalho_len
    call print_string

    ; Limpa o buffer de leitura
    ;call clear_buffer_read

list_loop:

    mov rax, [cont]
    cmp rax, [nreg2]
    je list_loop1

    ; move o ponteiro para o início do registro
    mov rdi, [fd]
    call file_pointer_begin

    mov rax, [offset]

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

    ; Imprime o registro lido
    mov rsi, buffer_read
    mov rdx, reg_max-1
    call print_string

    mov rax, [offset]
    add rax, reg_max-1
    mov [offset], rax

    inc qword [cont]

    jmp list_loop

list_loop1:

    ; Imprime a mensagem "Pressione qualquer tecla para continuar..."
    mov rsi, msg_list_reg2
    mov rdx, msg_list_reg2_len
    call print_string

    mov rsi, caracter
    mov rdx, 2    
    call read_string

    mov rax, 0
    mov [cont], rax

    jmp list_loop2

list_end:

    ; Imprime a mensagem "Pressione qualquer tecla para continuar..."
    mov rsi, msg_list_reg2
    mov rdx, msg_list_reg2_len
    call print_string
    
    mov rsi, caracter
    mov rdx, 2    
    call read_string

    ret