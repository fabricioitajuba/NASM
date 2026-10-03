; Ex09 - Lendo e imprimindo um arquivo
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
    filename db "texto.txt", 0

;Variáveis
section .bss
    fd_arquivo resq 1       ; Reserva 8 bytes para salvar o File Descriptor
    buffer resb 512         ; Cria um buffer temporário de 512 bytes para leitura

;Programa principal    
section .text
    global _start

_start:
    ; 1. ABRIR O ARQUIVO EXISTENTE (sys_open)
    mov rax, 2              ; syscall número 2 (sys_open)
    mov rdi, filename       ; nome do arquivo
    mov rsi, 0              ; Flag: O_RDONLY (0 = Apenas Leitura)
    syscall

    ; Verifica se houve erro na abertura (se RAX for negativo)
    cmp rax, 0
    jl erro_sair            ; se menor que 0, desvia para o fim do programa

    mov [fd_arquivo], rax   ; Salva o File Descriptor retornado

ler_bloco:
    ; 2. LER O CONTEÚDO DO ARQUIVO (sys_read)
    mov rax, 0              ; syscall número 0 (sys_read)
    mov rdi, [fd_arquivo]   ; File Descriptor do arquivo aberto
    mov rsi, buffer         ; endereço do nosso buffer de memória
    mov rdx, 512            ; ler no máximo 512 bytes por vez
    syscall

    ; RAX agora contém o número real de bytes lidos com sucesso
    cmp rax, 0
    jle fechar_arquivo      ; Se for 0 (Fim do Arquivo / EOF) ou menor (Erro),
                            ; para de ler
    ; Guarda temporariamente a quantidade de bytes lidos em R12 para o
    ; sys_write
    mov r12, rax

    ; 3. IMPRIMIR O BUFFER NO TERMINAL (sys_write no stdout)
    mov rax, 1              ; syscall número 1 (sys_write)
    mov rdi, 1              ; File Descriptor 1 = stdout (Terminal)
    mov rsi, buffer         ; endereço do conteúdo que acabamos de ler
    mov rdx, r12            ; quantidade exata de bytes que foram lidos
    syscall

    jmp ler_bloco           ; Volta para ler o próximo bloco do arquivo (loop)

fechar_arquivo:
    ; 4. FECHAR O ARQUIVO (sys_close)
    mov rax, 3              ; syscall número 3 (sys_close)
    mov rdi, [fd_arquivo]
    syscall

erro_sair:
    ; 5. ENCERRAR O PROGRAMA (sys_exit)
    mov rax, 60             ; syscall número 60 (sys_exit)
    mov rdi, 0              ; status de retorno 0
    syscall