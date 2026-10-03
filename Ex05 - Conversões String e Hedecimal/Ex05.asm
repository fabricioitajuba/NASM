; Ex05 - Conversões envolvendo String e Hexadecimal
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

    num db '12345', LF

;Variáveis
section .bss
    digitos resb 5          ; Cria 5 bytes, não inicializados

;Programa principal
section .text

global _start

_start:
	
    mov rsi, num
    call string2hexa    ;Converte uma String para Hexadecimal

    ;mov eax, 0FFFFH
    call hexa2decimal   ;Converte um número Hexadecimal para String

    ;Imprime String
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

