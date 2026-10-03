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

;Constantes
section .data

;Variáveis
section .bss
    digitos resb 4      ; Cria 4 bytes, não inicializados

;Programa principal
section .text

global _start

_start:
	
    mov eax, 0ABCDH
    call hexa2string    ;Converte um número Hexadecimal para String

    ;Imprime String
    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, digitos
    mov edx, 4
    int 0x80

	;Retorna ao sistema operacional
	mov eax, 0x1		; Serviço 1: sys_exit
	mov ebx, 0x0		; Código de retorno 0 (sucesso)
	int 0x80			; Chama o kernel do Linux

%include "../funções/hexa2string.asm"


