; Ex07 - Cálculo da média
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 hello.asm
; Linkeditar
; $ ld -s -o hello hello.o
; ou:
; $ make
; Status: Falta implementar o arquivo hexa2string.asm

default abs

;Constantes
section .data
	LF equ 10  ; Line Feed
	CR equ 13  ; Carrie return

    linha db LF, CR
	linha_len equ $-linha

	msg1 db LF, CR, "- Digite a nota 1: "
	tam1 equ $-msg1

	msg2 db LF, CR, "- Digite a nota 2: "
	tam2 equ $-msg2    

	msg3 db LF, CR, "- A média é (o número é no formado 0000,0): "
	tam3 equ $-msg3

;Variáveis
section .bss
    nota1 resb 4    ; 3bytes + 1 0x0A
    nota2 resb 4    ; 3bytes + 1 0x0A

    n1 resw 1
    n2 resw 1

    digitos resb 5      ; Cria 5 bytes, não inicializados

;Programa principal
section .text

global _start

_start:
	
    ;Nota 1
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, tam1
    syscall

    ;Leitura da nota1
    mov rax, 0
    mov rdi, 0
    mov rsi, nota1
    mov rdx, 4
    syscall

    ;Converte a nota1 para hexadecimal
    mov rsi, nota1
    call string2hexa  

    mov bx, 10
    mul bx          ;Multiplica AX por 10 para colocar a vírgula no lugar correto
    mov [n1], ax    ;Guarda o valor convertido em n1

    ;Nota 2
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, tam2
    syscall

    ;Leitura da nota2
    mov rax, 0
    mov rdi, 0
    mov rsi, nota2
    mov rdx, 4
    syscall

    ;Converte a nota2 para hexadecimal
    mov rsi, nota2
    call string2hexa  
    
    mov bx, 10
    mul bx          ;Multiplica AX por 10 para colocar a vírgula no lugar correto
    mov [n2], ax    ;Guarda o valor convertido em n2

    ;Calcula a média
    mov ax, [n1]
    add ax, [n2]
    mov bx, 2
    div bx          ;AX tem o valor da média

    ;Converte a média para string decimal
    call hexa2decimal

    ;Resultado
    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, tam3
    syscall

    ;Resultado
    mov rax, 1
    mov rdi, 1
    mov rsi, digitos
    mov rdx, 5
    syscall

    ;Pula linha
    mov rax, 1
    mov rdi, 1
    mov rsi, linha
    mov rdx, linha_len
    syscall

	;Retorna ao sistema operacional
	mov rax, 60
	mov rdi, 0
	syscall

%include "../funções/string2hexa.asm"
%include "../funções/hexa2decimal.asm"


