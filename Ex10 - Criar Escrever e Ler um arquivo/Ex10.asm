; Ex10 - Criar, escrever e ler um arquivo
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 Ex10.asm
; Linkeditar
; $ ld -s -o Ex10 Ex10.o
; ou:
; $ make

section .data
    filename db "exemplo_64bit.txt", 0
    texto    db "Mensagem gravada e lida via Assembly!", 10
    tam_txt  equ $ - texto

section .bss
    buffer   resb 128          ; Reserva 128 bytes para ler o arquivo de volta
    fd       resq 1            ; Reserva 8 bytes (quadword) para salvar o File Descriptor

section .text
    global _start

_start:
    ; 1. ABRIR / CRIAR O ARQUIVO
    mov rax, 2                 ; syscall: sys_open
    mov rdi, filename          ; caminho do arquivo
    mov rsi, 0102o             ; flags: O_RDWR (2) | O_CREAT (0100o)
    mov rdx, 0644o             ; permissões padrão (rw-r--r--)
    syscall
    
    mov [fd], rax              ; salva o File Descriptor retornado em RAX

    ; 2. ESCREVER NO ARQUIVO
    mov rax, 1                 ; syscall: sys_write
    mov rdi, [fd]              ; File Descriptor do nosso arquivo
    mov rsi, texto             ; ponteiro para a mensagem
    mov rdx, tam_txt           ; tamanho da mensagem
    syscall

    ; 3. MOVER O PONTEIRO PARA O INÍCIO (SEEK_SET)
    mov rax, 8                 ; syscall: sys_lseek
    mov rdi, [fd]              ; File Descriptor
    mov rsi, 0                 ; mover 0 bytes
    mov rdx, 0                 ; 0 = SEEK_SET (início do arquivo)
    syscall

    ; 4. LER O CONTEÚDO DO ARQUIVO
    mov rax, 0                 ; syscall: sys_read
    mov rdi, [fd]              ; File Descriptor
    mov rsi, buffer            ; local onde o texto lido será guardado
    mov rdx, 128               ; ler no máximo 128 bytes
    syscall
    
    mov rbx, rax               ; guarda em RBX a quantidade real de bytes lidos

    ; 5. EXIBIR O CONTEÚDO LIDO NA TELA (STDOUT)
    mov rax, 1                 ; syscall: sys_write
    mov rdi, 1                 ; 1 = stdout (tela)
    mov rsi, buffer            ; ponteiro para o buffer preenchido
    mov rdx, rbx               ; quantidade de bytes lidos no passo anterior
    syscall

    ; 6. FECHAR O ARQUIVO
    mov rax, 3                 ; syscall: sys_close
    mov rdi, [fd]              ; File Descriptor
    syscall

    ; 7. FINALIZAR O PROGRAMA (EXIT)
    mov rax, 60                ; syscall: sys_exit
    mov rdi, 0                 ; código de retorno 0 (sem erros)
    syscall
