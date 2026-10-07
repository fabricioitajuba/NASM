;****************************************************************
; hexa2decimal - Essa rotina, converte um número em hexadecimal
; de 16 bits em decimal colocando o valor em 5 posições de memória
;
; Entradas:   AX - de 16 bits
;
; section .bss
;    digitos resb 5
;
; Saídas:     DIGITOS - String
;****************************************************************

hexa2decimal:   push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rdi

                ;Zera as posições de DIGITOS
                lea rsi, [digitos]
                mov rcx, 8
                mov dl, '0'
hexa2decimal_loop1:    
                mov byte [rsi], dl
                inc rsi
                loop hexa2decimal_loop1

                mov     rbx, 10
                lea     rdi, [digitos]
                add     rdi, 7

hexa2decimal_loop2:
                xor     rdx, rdx
                div     rbx    
                mov     cl, dl
                add     cl, 30H
                mov     [rdi], cl
                dec     rdi   
                cmp     rax, 0
                jne     hexa2decimal_loop2

                pop     rdi
                pop     rdx
                pop     rcx
                pop     rbx
                pop     rax

                ret
                