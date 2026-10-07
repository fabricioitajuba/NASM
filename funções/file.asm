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
    mov rax, 2
    mov rsi, 0102o
    mov rdx, 0644o
    syscall
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
    mov rax, 8
    mov rsi, 0
    mov rdx, 2
    syscall
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
    mov rax, 1
    syscall
    ret

;**************************************************************
; file_close - Fecha o arquivo
;
; Entradas:
; rax - file descriptor
;**************************************************************
file_close:
    mov rax, 3
    mov rdi, [fd]
    syscall
    ret