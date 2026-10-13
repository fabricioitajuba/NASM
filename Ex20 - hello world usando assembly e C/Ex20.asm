section .data
    ; Mensagem terminada em nulo (\0). O 10 é o caractere de nova linha (\n)
    msg: db "Hello, World!", 10, 0

section .text
    extern printf           ; Declara a função do C como externa
    global main             ; Define o ponto de entrada exigido pela libc

main:
    push rbp                ; Alinha a pilha em 16 bytes e preserva o base pointer
    mov rbp, rsp            ; Configura o stack frame

    ; Preparação dos argumentos para o printf de acordo com a ABI x86_64
    ; printf(rdi = string)
    mov rdi, msg            ; Passa o endereço da string como 1º argumento

    xor eax, eax            ; AL = 0, indicando que nenhum float (XMM) foi passado
    call printf             ; Chama a função printf do C

    ; Finalização segura do programa
    mov eax, 0              ; Código de retorno 0 (sucesso)
    mov rsp, rbp            ; Restaura o ponteiro da pilha
    pop rbp                 ; Restaura o rbp original
    ret                     ; Retorna para o inicializador da libc
