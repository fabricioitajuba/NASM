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

    mov rax, 0
    mov [offset], rax

tst_insere:

    ; move o ponteiro para o início do arquivo
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

    cmp byte [buffer_read+3], '*'
    je create_inserer

    cmp rax, 0
    je create_inserer2

    mov rax, [offset]
    add rax, reg_max-1
    mov [offset], rax
    jmp tst_insere

create_inserer:

    ; move o ponteiro para o início do arquivo
    mov rdi, [fd]
    call file_pointer_begin
    
    ; Posiciona o ponteiro para um local específico do arquivo
    mov rdi, [fd]
    mov rsi, [offset]
    call file_pointer_set

create_inserer2:

    ; calcula o ID
    mov rax, [offset]
    xor rdx, rdx
    mov rbx, 63
    div rbx
    inc rax
    call hexa2decimal

    ; insere ID
    mov rcx, 3
    lea rsi, [digitos+5]
    lea rdi, [REG_ID]
    call move_bytes 

    ; escreve no arquivo
    mov rdi, [fd]
    mov rsi, REG_ID
    mov rdx, reg_max-1
    call file_write

msg_inserido:

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
