;******************************************************
; Atualizar registro
;******************************************************

section .data

    msg_update_reg db LF, CR, "- Qual registro deseja atualizar? "
    msg_update_reg_len equ $-msg_update_reg

    msg_update_reg_new db LF, CR, LF, CR, "# Entre com o novo registro: ", LF, CR
    msg_update_reg_new_len equ $-msg_update_reg_new

    msg_update2 db LF, CR, "# Deseja realmente atualizar o registro? (Y/N)"
    msg_update2_len equ $-msg_update2   

    msg_reg_msg_update2 db LF, CR, "# Registro atualizado!"
    msg_reg_msg_update2_len equ $-msg_reg_msg_update2

    msg_reg_msg_update3 db LF, CR, "# Registro não atualizado!"
    msg_reg_msg_update3_len equ $-msg_reg_msg_update3     

section .bss


section .text

crud_update:

    call clear_buffer_read

    ; imprime a string de qual registro deseja ler
    mov rsi, msg_update_reg
    mov rdx, msg_update_reg_len
    call print_string

    ; Lê qual registro deseja ler
    mov rsi, buffer_teclado
    mov rdx, 4
    call read_string

    ; Converte a string para hexa
    mov rsi, buffer_teclado
    call string2hexa

    ;Guarda o número do registro a ser lido
    mov [nreg2], rax

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

    ; imprime a string para entrar com os novos dados do registro
    mov rsi, msg_update_reg_new
    mov rdx, msg_update_reg_new_len
    call print_string
;-----------------------------------------------------------------------

    call clear_reg

    ; imprime a string do nome
    mov rsi, msg_nome
    mov rdx, msg_nome_len
    call print_string

    ; leitura do nome
    mov rsi, buffer_teclado
    mov rdx, 35    
    call read_string

    ; move o conteúdo do buffer para o registro
    dec rax
    mov rcx, rax
    lea rsi, [buffer_teclado]
    lea rdi, [REG_NOME]
    call move_bytes

    ; imprime a string da idade
    mov rsi, msg_idade
    mov rdx, msg_idade_len
    call print_string

    ; leitura da idade
    mov rsi, buffer_teclado
    mov rdx, 35    
    call read_string

    ; move o conteúdo do buffer para o registro
    dec rax
    mov rcx, rax
    lea rsi, [buffer_teclado]
    lea rdi, [REG_IDADE]
    call move_bytes

    ; insere ID
    mov rax, [nreg2]
    call hexa2decimal

     ; move o conteúdo do buffer para o registro
    mov rcx, 3
    lea rsi, [digitos+5]
    lea rdi, [REG_ID]
    call move_bytes    

    ; insere DATA
    call string_data

     ; move o conteúdo do buffer para o registro
    mov rcx, 10
    lea rsi, [date_str]
    lea rdi, [REG_DATA]
    call move_bytes 

    ; insere HORA
    call string_hora

     ; move o conteúdo do buffer para o registro
    mov rcx, 8
    lea rsi, [time_str]
    lea rdi, [REG_HORA]
    call move_bytes     

crud_update_loop1:

    ; imprime a string se deseja realmente inserir
    mov rsi, msg_update2
    mov rdx, msg_update2_len
    call print_string

    mov rsi, caracter
    mov rdx, 2    
    call read_string

    mov al, [caracter]

    cmp al, 'Y'
    je update_insere
    cmp al, 'N'
    je update_ninsere
    jmp crud_update_loop1

update_insere:

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

    ; imprime a string "# Registro atualizado!"
    mov rsi, msg_reg_msg_update2
    mov rdx, msg_reg_msg_update2_len
    call print_string

    jmp create_fim

update_ninsere:

    ; imprime a string "# Registro não atualizado!"
    mov rsi, msg_reg_msg_update3
    mov rdx, msg_reg_msg_update3_len
    call print_string

;-----------------------------------------------------------------------
crud_update_end:
    mov rsi, caracter
    mov rdx, 2    
    call read_string

    ret

