;******************************************************
; Cria registro
;******************************************************

section .data

    msg_inserir db LF, CR, "# Deseja realmente inserir o registro? (Y/N)"
    msg_inserir_len equ $-msg_inserir   

    msg_reg_inserir db LF, CR, "# Registro inserido!"
    msg_reg_inserir_len equ $-msg_reg_inserir

    msg_reg_ninserir db LF, CR, "# Registro não inserido!"
    msg_reg_ninserir_len equ $-msg_reg_ninserir        

section .text

crud_create:

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
    mov rax, [nreg]
    inc rax
    mov [nreg], rax
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

crud_create_loop1:

    ; imprime a string se deseja realmente inserir
    mov rsi, msg_inserir
    mov rdx, msg_inserir_len
    call print_string

    mov rsi, caracter
    mov rdx, 2    
    call read_string

    mov al, [caracter]

    cmp al, 'Y'
    je create_insere
    cmp al, 'N'
    je create_ninsere
    jmp crud_create_loop1

create_insere:

    ; move o ponteiro do arquivo para o final
    mov rdi, [fd]
    call file_pointer_end

    ; escreve no arquivo
    mov rdi, [fd]
    mov rsi, REG_ID
    mov rdx, reg_max-1
    call file_write

    ; imprime a string "# Registro inserido!"
    mov rsi, msg_reg_inserir
    mov rdx, msg_reg_inserir_len
    call print_string

    jmp create_fim

create_ninsere:

    ;Atualiza o número de registros
    mov rax, [nreg]
    dec rax
    mov [nreg], rax

    ; imprime a string "# Registro não inserido!"
    mov rsi, msg_reg_ninserir
    mov rdx, msg_reg_ninserir_len
    call print_string

create_fim:

    mov rsi, caracter
    mov rdx, 2    
    call read_string

    ret
