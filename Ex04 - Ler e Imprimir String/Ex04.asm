; Ex04 - Leitura e Impressão de String
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
	buffer resb 50		; Reserva 50 bytes de espaço para o texto do usuário

;Programa principal
section .text

global _start

_start:
	
    ;Leitura da String
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 50
    syscall    
    ; OBS: O Enter é um caractere especial que também é lido e guardado no buffer. 
    ; Ele é o último caractere da String digitada. Seu código ASCII é 10 (LF - Line Feed).
    ; RAX possui a quantidade real de bytes que o usuário digitou!
    mov rcx, rax

    ;Impressão da String
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, rcx        ;rax possui a quantidade real de bytes que o usuário digitou!
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
