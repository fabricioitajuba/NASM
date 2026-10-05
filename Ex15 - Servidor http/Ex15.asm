; Ex15 - Servidor http
; Autor Eng. Fabrício Ribeiro
;
; Para testar, abra o navegador na porta 8080
; http://localhost:8080/
;
; Compilar:
; $ nasm -f elf64 Ex15.asm
; Linkeditar
; $ ld -s -o Ex15 Ex15.o
; ou:
; $ make

section .data
    ; Estrutura sockaddr_in (16 bytes no total para IPv4)
    ; sin_family (2 bytes) = AF_INET (2)
    ; sin_port   (2 bytes) = Porta 8080 em Network Byte Order (0x1F90)
    ; sin_addr   (4 bytes) = INADDR_ANY (0.0.0.0 -> aceita qualquer IP) (0)
    ; sin_zero   (8 bytes) = Apenas preenchimento (0)
    sockaddr_in:
        dw 2              ; AF_INET
        dw 0x901F         ; 8080 convertido para Big Endian (0x1F90 vira 0x901F)
        dd 0              ; INADDR_ANY
        dq 0              ; Preenchimento

    ; Resposta HTTP padrão (O texto obrigatório que o navegador precisa ler)
    http_response:
        db "HTTP/1.1 200 OK", 13, 10
        db "Content-Type: text/html; charset=utf-8", 13, 10
        db "Content-Length: 48", 13, 10
        db "Connection: close", 13, 10
        db 13, 10          ; Linha em branco obrigatória separando cabeçalho do corpo
        db "<html><body><h1>Hello de um Socket NASM!</h1></body></html>"
    http_len equ $ - http_response

    msg_start db "Servidor HTTP rodando na porta 8080...", 10
    msg_start_len equ $ - msg_start

section .bss
    server_fd resq 1      ; ID do socket principal (servidor)
    client_fd resq 1      ; ID do socket da conexão atual (cliente)

section .text
    global _start

_start:
    ; 1. Print informando que o servidor iniciou
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rsi, msg_start
    mov rdx, msg_start_len
    syscall

    ; 2. Criar o Socket (sys_socket = 41)
    mov rax, 41           
    mov rdi, 2            ; AF_INET
    mov rsi, 1            ; SOCK_STREAM (TCP)
    mov rdx, 0
    syscall
    mov [server_fd], rax

    ; 3. Vincular à Porta / BIND (sys_bind = 49)
    mov rax, 49           
    mov rdi, [server_fd]  ; ID do socket
    mov rsi, sockaddr_in  ; Ponteiro para a estrutura com a porta 8080
    mov rdx, 16           ; Tamanho da estrutura sockaddr_in
    syscall

    ; 4. Ouvir conexões / LISTEN (sys_listen = 50)
    mov rax, 50           
    mov rdi, [server_fd]
    mov rsi, 10           ; Backlog (fila de espera máxima)
    syscall

.loop_servidor:
    ; 5. Aceitar Conexão / ACCEPT (sys_accept = 43)
    ; Bloqueia a execução até alguém acessar o IP/porta no navegador
    mov rax, 43           
    mov rdi, [server_fd]
    mov rsi, 0            ; Não precisamos do endereço do cliente
    mov rdx, 0            ; Não precisamos do tamanho do endereço do cliente
    syscall
    mov [client_fd], rax  ; Retorna um novo ID específico para falar com esse cliente

    ; 6. Enviar a Resposta HTTP / WRITE (sys_write = 1)
    mov rax, 1            
    mov rdi, [client_fd]  ; Enviamos para o socket do cliente conectado
    mov rsi, http_response
    mov rdx, http_len
    syscall

    ; 7. Fechar a conexão com o cliente / CLOSE (sys_close = 3)
    mov rax, 3            
    mov rdi, [client_fd]
    syscall

    ; Retorna para o início para esperar o próximo clique ou requisição
    jmp .loop_servidor
