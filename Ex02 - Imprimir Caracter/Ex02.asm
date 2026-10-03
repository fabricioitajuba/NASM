; Ex02 - Impressão de Caracter
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 hello.asm
; Linkeditar
; $ ld -s -o hello hello.o
; ou:
; $ make

;Variáveis e constantes
section .data
	caracter db 'A'

;Programa principal
section .text

global _start

_start:
	;Imprime Caracter
    mov rax, 1
    mov rdi, 1
    mov rsi, caracter
    mov rdx, 1
    syscall	

	;Retorna ao sistema operacional
	mov rax, 60
	mov rdi, 0
	syscall 
