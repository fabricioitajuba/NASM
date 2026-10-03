; Ex03 - Leitura e Impressão de Caracter
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
	LF equ 10  ; Line Feed
	CR equ 13  ; Carrie return

    linha db LF, CR
	linha_len equ $-linha

section .bss
    caracter resb 1     ; Reserva 1 byte na memória para o caractere

;Programa principal
section .text

global _start

_start:
	
	;Lê Caracter
    mov rax, 0
    mov rdi, 0
    mov rsi, caracter
    mov rdx, 1
    syscall

	;Imprime Caracter
    mov rax, 1
    mov rdi, 1
    mov rsi, caracter
    mov rdx, 1
    syscall	

    ;Pula linha
    mov rax, 1
    mov rdi, 1
    mov rsi, linha
    mov rdx, linha_len
    syscall

	mov rax, 60
	mov rdi, 0
	syscall  