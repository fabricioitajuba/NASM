; Ex19 - Soma em ponto flutuante
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 Ex18.asm
; Linkeditar
; $ ld -s -o Ex18 Ex18.o
; ou:
; $ make
; $ make clean - limpa a compilação
; fonte: https://www.youtube.com/watch?v=FAKJset0qtw&t=1s


;************************************************
;Variáveis inicializadas
;************************************************
section .data
    ; Define os dois números em ponto flutuante (32 bits / single-precision)
    num1:    dd 5.75
    num2:    dd 3.50

    ; String de formato para o printf (o caractere 10 equivale ao '\n')
    formato: db "Resultado da soma: %f", 10, 0

;************************************************
; Programa principal
;************************************************
section .text
    global main
    extern printf

main:
    ; Alinhamento da pilha antes de chamadas de funções C em 64 bits
    push rbp
    mov rbp, rsp

    ; 1. Carrega os números nos registradores de ponto flutuante XMM
    movss xmm0, [num1]      ; Carrega o primeiro float (32 bits) em xmm0
    movss xmm1, [num2]      ; Carrega o segundo float (32 bits) em xmm1

    ; 2. Realiza a soma de precisão simples (Scalar Single-precision)
    addss xmm0, xmm1        ; xmm0 = xmm0 + xmm1

    ; 3. Preparação para chamar a função printf:
    ; O printf espera floats de precisão dupla (double de 64 bits). 
    ; Portanto, convertemos o resultado de precisão simples para dupla.
    cvtss2sd xmm0, xmm0     ; Converte de float para double (resultado fica em xmm0)

    ; Passa o formato de texto no registrador rdi (padrão System V AMD64 ABI)
    mov rdi, formato        

    ; rax deve conter o número de registradores vetoriais (XMM) passados por argumento.
    ; Como estamos passando apenas 1 argumento flutuante (xmm0), definimos rax = 1.
    mov rax, 1              

    ; Chama a função externa printf
    call printf

    ; Restaura a pilha e finaliza o programa com código de retorno 0
    mov rax, 0
    mov rsp, rbp
    pop rbp
    ret
