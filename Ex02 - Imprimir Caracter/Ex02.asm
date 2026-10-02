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
	mov eax, 0x4		; Serviço 4: sys_write
	mov ebx, 0x1		; Saída padrão: tela
	mov ecx, caracter	; Endereço do caracter
	mov edx, 1			; Tamanho em bytes
	int 0x80			; Chama o kernel do Linux

	;Retorna ao sistema operacional
	mov eax, 0x1		; Serviço 1: sys_exit
	mov ebx, 0x0		; Código de retorno 0 (sucesso)
	int 0x80			; Chama o kernel do Linux
