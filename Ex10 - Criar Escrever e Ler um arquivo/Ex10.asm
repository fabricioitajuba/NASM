; Ex10 - Criar, escrever e ler um arquivo
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 hello.asm
; Linkeditar
; $ ld -s -o hello hello.o
; ou:
; $ make

default abs

;Constantes
section .data
    filename db "exemplo.txt", 0        ; Caminho do arquivo (precisa terminar em 0)
    texto    db "Aprender Assembly!", 10 ; Texto com quebra de linha
    len_text equ $ - texto               ; Tamanho do texto

;Variáveis
section .bss
    fd      resq 1                      ; Reserva 8 bytes (quadword) para o File Descriptor
    buffer  resb 100                     ; Buffer para ler o texto de volta

;Programa principal
section .text
    global _start

_start:
    ; --- 1. ABRIR / CRIAR O ARQUIVO ---
    mov rax, 2          ; sys_open
    mov rdi, filename   ; nome do arquivo
    mov rsi, 65         ; Flags: O_WRONLY (1) | O_CREAT (64) = 65 (Escrita + Criação)
    mov rdx, 0644o      ; Permissão octal se criado: rw-r--r-- (o sufixo 'o' define octal)
    syscall
    
    ; O Linux retorna o File Descriptor em RAX. Vamos salvá-lo.
    mov [fd], rax

    ; --- 2. ESCREVER NO ARQUIVO ---
    mov rax, 1          ; sys_write
    mov rdi, [fd]       ; Passa o nosso "ponteiro de arquivo" (FD)
    mov rsi, texto      ; O que escrever
    mov rdx, len_text   ; Quantos bytes escrever
    syscall

    ; --- 3. REBOBINAR O CURSOR (Mover Ponteiro para o Início) ---
    ; Como escrevemos, o cursor está no fim do arquivo. Para ler, precisamos voltar pro início.
    ; O registrador RDX define de onde começar a contar o deslocamento (RSI):
    ; 0 (SEEK_SET): Conta a partir do início do arquivo.
    ; 1 (SEEK_CUR): Conta a partir da posição atual do cursor.
    ; 2 (SEEK_END): Conta a partir do fim do arquivo.

    mov rax, 8          ; sys_lseek
    mov rdi, [fd]       ; Nosso FD
    mov rsi, 0          ; Deslocamento: 0 bytes
    mov rdx, 0          ; Modo: SEEK_SET (A partir do início)
    syscall

    ; --- 4. LER DO ARQUIVO ---
    mov rax, 0          ; sys_read
    mov rdi, [fd]       ; Nosso FD
    mov rsi, buffer     ; Buffer onde o texto lido vai ficar
    mov rdx, 100        ; Quantidade máxima de bytes para ler
    syscall
    
    ; Guardamos a quantidade de bytes realmente lidos (que voltou em RAX) em R12 para uso futuro
    mov r12, rax

    ; --- 5. EXIBIR O CONTEÚDO NA TELA (stdout) ---
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout (tela)
    mov rsi, buffer     ; buffer lido do arquivo
    mov rdx, r12        ; número de bytes que o sys_read retornou
    syscall

    ; --- 6. FECHAR O ARQUIVO ---
    mov rax, 3          ; sys_close
    mov rdi, [fd]       ; O arquivo que queremos fechar
    syscall

    ; --- 7. SAIR DO PROGRAMA ---
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; status code 0
    syscall
