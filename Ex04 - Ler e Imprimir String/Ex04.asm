; Ex04 - Leitura e Impressão de String
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 hello.asm
; Linkeditar
; $ ld -s -o hello hello.o
; ou:
; $ make

section .bss
	buffer resb 50		; Reserva 50 bytes de espaço para o texto do usuário

;Programa principal
section .text

global _start

_start:
	
    ;Leitura da String
    mov eax, 0x3		; Serviço 3: sys_read
    mov ebx, 0x80		; Entrada padrão: teclado (stdin)
    mov ecx, buffer		; Endereço onde o texto digitado será guardado
    mov edx, 50			; Tamanho máximo que aceitamos ler (50 bytes)
    int 0x80			; O programa pausa aqui. O usuário digita e aperta Enter.

    ; EAX possui a quantidade real de bytes que o usuário digitou!
    ; Vamos guardar esse valor no EDX para usar no passo de escrita.
    mov edx, eax                    

    ;Impressão da String
    mov eax, 0x4		; Serviço 4: sys_write
    mov ebx, 0x1		; Saída padrão: tela (stdout)
    mov ecx, buffer		; Endereço do nosso texto guardado
    ; mov edx, edx		; (Opcional) Já está com o tamanho exato retornado pelo sys_read
    int 0x80			; Imprime o texto de volta na tela

	;Retorna ao sistema operacional
	mov eax, 0x1		; Serviço 1: sys_exit
	mov ebx, 0x0		; Código de retorno 0 (sucesso)
	int 0x80			; Chama o kernel do Linux
