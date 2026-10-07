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
; Status: Não concluído

default abs

;************************************************
;Variáveis inicializadas
;************************************************
section .data
    LF equ 10
    CR equ 13

    reg_max equ 64

    filename db "registro.txt", 0

    msg_nome db LF, CR, "- Digite o nome: "
    msg_nome_len equ $-msg_nome

    msg_idade db LF, CR, "- Digite a idade: "
    msg_idade_len equ $-msg_idade    

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

    buffer_teclado times 35 resb 0x20

    nreg resq 1         ; Reserva 1 bloco de 64 bits (Quadword) na memória

    digitos resb 8    

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

    call create

    ; 7. FINALIZAR O PROGRAMA (EXIT)
    mov rax, 60
    mov rdi, 0
    syscall


;******************************************************
; Cria registro
;******************************************************
create:

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
    mov al, '.'
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