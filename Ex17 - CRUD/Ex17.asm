; Ex17 - CRUD - CREATE, READ, UPDATE, DELETE Usando arquivo .txt
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 Ex17.asm
; Linkeditar
; $ ld -s -o Ex17 Ex17.o
; ou:
; $ make
;
; Etapas: 
; Create - Concluído
; Read   - não Concluído
; Update - não Concluído
; Delete - nãa Concluído
; Lista  - não Concluído
; 
; Status - Problema no menu inicial

default abs

;************************************************
;Variáveis inicializadas
;************************************************
section .data
    LF equ 10
    CR equ 13

    reg_max equ 64

    filename db "registro.txt", 0

    clear_screen db 0x1b, '[2J', 0x1b, '[H'
    clear_len    equ $ - clear_screen

    msg_ini db '---------------------------------',CR,LF
            db '### CRUD versao 1.0, 07/10/2026',CR,LF
            db '---------------------------------',CR,LF
            db CR,LF,'- O que Voce deseja?',CR,LF,CR,LF
            db 'C - Criar um registro;',CR,LF
            db 'R - Ler um registro;',CR,LF
            db 'U - Atualizar um registro;',CR,LF
            db 'D - Deletar um registro;',CR,LF
            db 'L - Listar todos os registros;',CR,LF
            db 'Q - Sair;',CR,LF
            db '>> '
    msg_ini_len equ $-msg_ini

    msg_create db LF, CR, "- Criar um registro: "
    msg_create_len equ $-msg_create

    msg_read db LF, CR, "- Ler um registro: "
    msg_read_len equ $-msg_read

    msg_nome db LF, CR, "- Digite o nome: "
    msg_nome_len equ $-msg_nome

    msg_idade db LF, CR, "- Digite a idade: "
    msg_idade_len equ $-msg_idade    

    date_str: db "00/00/0000"
    time_str: db "00:00:00"

;************************************************
;Variáveis não inicializadas
;************************************************
section .bss
    fd       resq 1     ; Reserva 8 bytes (quadword) para salvar o File Descriptor

    ;Buffer de registro
    REG_ID      resb 3
                resb 1
    REG_DATA    resb 10
                resb 1
    REG_HORA    resb 8
                resb 1
    REG_NOME    resb 34
                resb 1
    REG_IDADE   resb 3
                resb CR
                resb LF

    buffer_teclado resb 35

    nreg resq 1         ; Reserva 1 bloco de 64 bits (Quadword) na memória

    digitos resb 8

    timespec:
        .tv_sec:  resq 1
        .tv_nsec: resq 1

    caracter resb 2

;************************************************
; Programa principal
;************************************************
section .text
    global _start

_start:

    ; Abre o arquivo para leitura e/ou escrita, cria-o caso não exista
    mov rdi, filename
    call file_open_read_write_create
    mov [fd], rax

    ; calcula o número de bytes do arquivo
    mov rdi, [fd]
    call file_pointer_end
    ;rax possui o tamanho exato de bytes

    ;calcula o número de registros salvos
    xor rdx, rdx
    mov rbx, 64
    div rbx
    mov [nreg], rax

inicio:
    call clear_screean

    mov rsi, msg_ini
    mov rdx, msg_ini_len
    call print_string  

    mov rsi, caracter
    mov rdx, 1    
    call read_string

    mov al, [caracter]

    cmp al, 'C'
    je create
    cmp al, 'R'
    je read
    cmp al, 'Q'
    je exit    
    jmp inicio

create:
    mov rsi, msg_create
    mov rdx, msg_create_len    
    call print_string

    mov rsi, caracter
    mov rdx, 1    
    call read_string
    jmp inicio

read:
    mov rsi, msg_read
    mov rdx, msg_read_len    
    call print_string

    mov rsi, caracter
    mov rdx, 1    
    call read_string
    jmp inicio

    call crud_create

exit:
    jmp inicio

    ; retorna ao sistema operacional
    jmp exit_system


;******************************************************
; Cria registro
;******************************************************
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
    dec rax                     ;desconsidera o último byte "0x0A"
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
    dec rax                     ;desconsidera o último byte "0x0A"
    mov rcx, rax
    lea rsi, [buffer_teclado]
    lea rdi, [REG_IDADE]
    call move_bytes

    ; insere ID
    mov rax, [nreg]
    inc rax
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



    ; move o ponteiro do arquivo para o final
    mov rdi, [fd]
    call file_pointer_end

    ; escreve no arquivo
    mov rdi, [fd]
    mov rsi, REG_ID
    mov rdx, reg_max
    call file_write

    ; fecha o arquivo
    mov rdi, [fd]
    call file_close

    ret

;******************************************************
; Limpa o buffer de registro
;******************************************************
clear_reg:
    lea rsi, [REG_ID]
    mov rcx, reg_max-2
    mov al, ' '
clear_reg_loop:    
    mov byte [rsi], al
    inc rsi
    loop clear_reg_loop
    inc rsi
    mov al, LF
    mov byte [rsi], al
    inc rsi
    mov al, CR
    mov byte [rsi], al
    ret


%include "../funções/string.asm"
%include "../funções/block.asm"
%include "../funções/file.asm"
%include "../funções/hexa2decimal.asm"
%include "../funções/time.asm"
%include "../funções/system.asm"
