;******************************************************
; Deletar registro
;******************************************************

section .data

    msg_delete_reg db LF, CR, "- Qual registro deseja deletar? "
    msg_delete_reg_len equ $-msg_delete_reg

    msg_delete2 db LF, CR, LF, CR, "# Deseja realmente deletar o registro? (Y/N)"
    msg_delete2_len equ $-msg_delete2

    msg_reg_msg_delete2 db LF, CR, "# Registro deletado!"
    msg_reg_msg_delete2_len equ $-msg_reg_msg_delete2

    msg_reg_msg_delete3 db LF, CR, "# Registro não deletado!"
    msg_reg_msg_delete3_len equ $-msg_reg_msg_delete3     

section .bss


section .text

crud_delete:

    call clear_buffer_read

    ; imprime a string de qual registro deseja deletar
    mov rsi, msg_delete_reg
    mov rdx, msg_delete_reg_len
    call print_string

    ; Lê qual registro deseja deletar
    mov rsi, buffer_teclado
    mov rdx, 4
    call read_string

    ; Converte a string para hexa
    mov rsi, buffer_teclado
    call string2hexa

    ;Guarda o número do registro a ser deletado
    mov [nreg2], rax

    ; Calcula o registro a ser deletado
    dec rax
    mov rbx, reg_max-1
    mul rbx      ;rax contém o ponteiro do registro a ser deletado
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

crud_delete_loop1:

    ; imprime a string se deseja realmente deletar
    mov rsi, msg_delete2
    mov rdx, msg_delete2_len
    call print_string

    mov rsi, caracter
    mov rdx, 2    
    call read_string

    mov al, [caracter]

    cmp al, 'Y'
    je crud_delete_insere
    cmp al, 'N'
    je crud_delete_ninsere
    jmp crud_delete_loop1

crud_delete_insere:

    call clear_reg

    ; move o ponteiro para o início do registro
    mov rdi, [fd]
    call file_pointer_begin

    ; Posiciona o ponteiro para um local específico do arquivo
    mov rdi, [fd]
    mov rsi, [offset]
    call file_pointer_set

    ; escreve no arquivo
    mov rdi, [fd]
    mov rsi, REG_ID
    mov rdx, reg_max-3
    call file_write

    ; imprime a string "# Registro deletado!"
    mov rsi, msg_reg_msg_delete2
    mov rdx, msg_reg_msg_delete2_len
    call print_string

    jmp create_fim

crud_delete_ninsere:

    ; imprime a string "# Registro não deletado!"
    mov rsi, msg_reg_msg_delete3
    mov rdx, msg_reg_msg_delete3_len
    call print_string

crud_delete_end:
    mov rsi, caracter
    mov rdx, 2    
    call read_string

    ret
