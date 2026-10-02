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

	msg db "Hello World!", LF, CR
	tam equ $- msg

;Programa principal
section .text

global _start

_start:
	;Imprime String
	mov eax, 0x4	; Serviço 4: sys_write
	mov ebx, 0x1	; Saída padrão: tela
	mov ecx, msg	; Endereço da mensagem
	mov edx, tam	; Tamanho da mensagem
	int 0x80	; Chama o kernel do Linux

	;Retorna ao sistema operacional
	mov eax, 0x1	; Serviço 1: sys_exit
	mov ebx, 0x0	; Código de retorno 0 (sucesso)
	int 0x80	; Chama o kernel do Linux
