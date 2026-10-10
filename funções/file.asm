;**************************************************************
; file_open_create - Abre o arquivo para escrita e leitura.
; cria o arquivo caso não exista.
;
; Entradas:
; rdi - ponteiro do nome do arquivo
;
; Saídas:
; rax - file descriptor
;**************************************************************
file_open_read_write_create:

    push rdx
    push rsi

    mov rax, 2
    mov rsi, 0102o
    mov rdx, 0644o
    syscall

    pop rsi
    pop rdx

    ret

;**************************************************************
; file_pointer_begin - Move o ponteiro do arquivo para o inicio
;
; Entradas:
; rdi - file descriptor
;**************************************************************
file_pointer_begin:

    push rax
    push rdx
    push rsi
    push rdi

    mov rax, 8
    mov rsi, 0
    mov rdx, 0
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rax

    ret

;**************************************************************
; file_pointer_set - Move o ponteiro do arquivo para um
;                    ponto específico.
; Entradas:
; rdi - file descriptor
; rsi - posição
;**************************************************************
file_pointer_set:

    push rax
    push rdx
    push rsi
    push rdi

    mov rax, 8
    mov rdx, 1
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rax

    ret

;**************************************************************
; file_pointer_end - Move o ponteiro do arquivo para o final
;
; Entradas:
; rdi - file descriptor
;
; Saídas:
; RAX - Quantidade de bytes do arquivo
;**************************************************************
file_pointer_end:

    push rdx
    push rsi
    push rdi

    mov rax, 8
    mov rsi, 0
    mov rdx, 2
    syscall

    pop rdi
    pop rsi
    pop rdx

    ret

;**************************************************************
; file_write - Escreve no arquivo
; 
; Entradas:
; rdi - file descriptor
; rsi - ponteiro do buffer
; rdx - quantidade e bytes 
;**************************************************************
file_write:

    push rax
    push rdx
    push rsi
    push rdi

    mov rax, 1
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rax

    ret

;**************************************************************
; file_read - Lê o arquivo
; 
; Entradas:
; rdi - file descriptor
; rsi - ponteiro do buffer
; rdx - quantidade e bytes 
;**************************************************************
file_read:

    push rax
    push rdx
    push rsi
    push rdi

    mov rax, 0
    syscall

    pop rdi
    pop rsi
    pop rdx
    pop rax

    ret
    
;**************************************************************
; file_close - Fecha o arquivo
;
; Entradas:
; rax - file descriptor
;**************************************************************
file_close:

    push rax
    push rdi

    mov rax, 3
    mov rdi, [fd]
    syscall

    pop rdi
    pop rax

    ret
