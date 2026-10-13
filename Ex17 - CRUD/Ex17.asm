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
; Read   - Concluído
; Update - Concluído
; Delete - Concluído
; Lista  - Concluído
; 
; Status - Concluído

default abs

;************************************************
;Variáveis inicializadas
;************************************************
section .data

    LF equ 10
    CR equ 13

    reg_max equ 64

    filename db "registro.txt", 0

    msg_ini1 db '---------------------------------',CR,LF
            db '### CRUD versao 1.0, 07/10/2026',CR,LF
            db '---------------------------------',CR,LF
    msg_ini1_len equ $-msg_ini1

    n_reg db "# Registros salvos: "
    n_reg_len equ $-n_reg

    msg_ini2 db CR,LF,CR,LF,'- O que Voce deseja?',CR,LF,CR,LF
            db 'C - Criar um registro;',CR,LF
            db 'R - Ler um registro;',CR,LF
            db 'U - Atualizar um registro;',CR,LF
            db 'D - Deletar um registro;',CR,LF
            db 'L - Listar todos os registros;',CR,LF
            db 'Q - Sair;',CR,LF
            db '>> '
    msg_ini2_len equ $-msg_ini2

    msg_create db LF, CR, "# Criar um registro: ", LF, CR
    msg_create_len equ $-msg_create

    msg_read db LF, CR, "# Ler um registro: ", LF, CR
    msg_read_len equ $-msg_read

    msg_update db LF, CR, "# Atualizar um registro: ", LF, CR
    msg_update_len equ $-msg_update

    msg_delete db LF, CR, "# Deletar um registro: ", LF, CR
    msg_delete_len equ $-msg_delete

    msg_list db LF, CR, "# Listar todos os registros: ", LF, CR
    msg_list_len equ $-msg_list

    msg_nome db LF, CR, "- Digite o nome: "
    msg_nome_len equ $-msg_nome

    msg_idade db LF, CR, "- Digite a idade: "
    msg_idade_len equ $-msg_idade  

    nome db LF, CR, "- Nome: "
    nome_len equ $-nome

    idade db LF, CR, "- Idade: "
    idade_len equ $-idade             

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
    REG_LF      resb 1
    REG_CR      resb 1

    buffer_teclado resb 35
    buffer_read resb reg_max

    nreg resq 1         ; Reserva 1 bloco de 64 bits (Quadword) na memória
    nreg2 resq 1         ; Reserva 1 bloco de 64 bits (Quadword) na memória

    caracter resb 2

    offset resq 1
    cont resq 1    

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

inicio:
    call clear_screean

    mov rsi, msg_ini1
    mov rdx, msg_ini1_len
    call print_string

    mov rsi, n_reg
    mov rdx, n_reg_len
    call print_string

    ;calcula o número de registros salvos
    mov rdi, [fd]
    call file_pointer_end
    xor rdx, rdx
    mov rbx, 63
    div rbx
    call hexa2decimal
    mov rsi, digitos+5
    mov rdx, 3
    call print_string

    mov rsi, msg_ini2
    mov rdx, msg_ini2_len
    call print_string

    mov rsi, caracter
    mov rdx, 2
    call read_string

    mov al, [caracter]

    cmp al, 'C'
    je create
    cmp al, 'R'
    je read
    cmp al, 'U'
    je update    
    cmp al, 'D'
    je delete
    cmp al, 'L'
    je list    
    cmp al, 'Q'
    je exit    
    jmp inicio

create:
    mov rsi, msg_create
    mov rdx, msg_create_len
    call print_string

    call crud_create
    jmp inicio

read:
    mov rsi, msg_read
    mov rdx, msg_read_len    
    call print_string

    call crud_read
    jmp inicio

update:
    mov rsi, msg_update
    mov rdx, msg_update_len
    call print_string

    call crud_update
    jmp inicio

delete:
    mov rsi, msg_delete
    mov rdx, msg_delete_len
    call print_string

    call crud_delete
    jmp inicio

list:
    mov rsi, msg_list
    mov rdx, msg_list_len
    call print_string

    call crud_list
    jmp inicio

    ; fecha o arquivo e retorna ao sistema operacional
exit:

    mov rdi, [fd]
    call file_close

    jmp exit_system

;******************************************************
; Limpa o buffer de registro
;******************************************************
clear_reg:
    lea rsi, [REG_ID]
    mov rcx, reg_max
    mov al, ' '
clear_reg_loop:    
    mov byte [rsi], al
    inc rsi
    loop clear_reg_loop
    mov al, LF
    mov [REG_LF], al
    mov al, CR
    mov [REG_CR], al
    ret

;******************************************************
; Limpa o buffer de leitura
;******************************************************
clear_buffer_read:
    lea rsi, [buffer_read]
    mov rcx, reg_max
    mov al, ' '
clear_buffer_read_loop:    
    mov byte [rsi], al
    inc rsi
    loop clear_buffer_read_loop

    ret

%include "./crud-create.asm"
%include "./crud-read.asm"
%include "./crud-update.asm"
%include "./crud-delete.asm"
%include "./crud-list.asm"

%include "../funções/string.asm"
%include "../funções/block.asm"
%include "../funções/file.asm"
%include "../funções/string2hexa.asm"
%include "../funções/hexa2decimal.asm"
%include "../funções/time.asm"
%include "../funções/system.asm"
