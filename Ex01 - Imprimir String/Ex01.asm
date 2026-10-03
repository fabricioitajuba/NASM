; Ex01 - Impressão de String (Hello World!)
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
	LF equ 10  ; Line Feed
	CR equ 13  ; Carrie return

	msg db "Hello World!", LF, CR	;String a ser impressa
	tam equ $- msg					;Tamanho da String

;Programa principal
section .text

global _start

_start:
	;Imprime String
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, tam
    syscall	

	;Retorna ao sistema operacional
	mov rax, 60
	mov rdi, 0
	syscall    
