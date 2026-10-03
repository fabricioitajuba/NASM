; Ex06 - Impressão em hexadecimal
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
;Variáveis
section .bss
    digitos resb 2      ; Cria 2 bytes, não inicializados

;Programa principal
section .text

global _start

_start:
	
    mov al, 0FAH
    call hexa2string    ;Converte um número Hexadecimal para String

    ;Imprime String
    mov rax, 1
    mov rdi, 1
    mov rsi, digitos
    mov rdx, 2
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

%include "../funções/hexa2string.asm"


