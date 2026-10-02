; Ex05 - Conversões envolvendo String e Hexadecimal
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 hello.asm
; Linkeditar
; $ ld -s -o hello hello.o
; ou:
; $ make

;Constantes
section .data
    num db '12345', '$'
    digitos times 5 db '$'   ; Cria 5 bytes, inicializados com '$'

;Variáveis
section .bss
    ;digitos resb 5          ; Cria 5 bytes, não inicializados

;Programa principal
section .text

global _start

_start:
	
    mov esi, num
    call string2hexa    ;Converte uma String para Hexadecimal

    ;mov eax, 0FFFFH
    call hexa2decimal   ;Converte um número Hexadecimal para String

    ;Imprime String
    mov eax, 0x4
    mov ebx, 0x1
    mov ecx, digitos
    mov edx, 5
    int 0x80

	;Retorna ao sistema operacional
	mov eax, 0x1		; Serviço 1: sys_exit
	mov ebx, 0x0		; Código de retorno 0 (sucesso)
	int 0x80			; Chama o kernel do Linux

%include "../funções/string2hexa.asm"
%include "../funções/hexa2decimal.asm"

