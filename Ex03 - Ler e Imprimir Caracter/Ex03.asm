; Ex03 - Leitura e Impressão de Caracter
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 hello.asm
; Linkeditar
; $ ld -s -o hello hello.o
; ou:
; $ make

section .bss
    caracter resb 1     ; Reserva 1 byte na memória para o caractere

;Programa principal
section .text

global _start

_start:
	
	;Lê Caracter
 	mov eax, 0x3        ; Serviço 3: sys_read
    mov ebx, 0x0        ; Entrada padrão: teclado (stdin)
    mov ecx, caracter   ; Endereço de memória onde o caractere será salvo
    mov edx, 1          ; Quantidade de bytes a ler: 1 byte
    int 0x80            ; Chama o kernel do Linux

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
