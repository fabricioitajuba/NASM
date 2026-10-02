;****************************************************************
; hexa2decimal - Essa rotina, converte um número em hexadecimal
; de 16 bits em decimal colocando o valor em 5 posições de memória
;
; Entrada:   AX - de 16 bits
; Saída:     DIGITOS - String
;****************************************************************

hexa2decimal:   push    rax
                push    rbx
                push    rcx
                push    rdx
                push    rdi

                ;Zera as posições de DIGITOS
                mov     dl, '0'
                mov     [digitos], dl
                mov     [digitos+1], dl
                mov     [digitos+2], dl
                mov     [digitos+3], dl
                mov     [digitos+4], dl

                mov     ebx, 10
                lea     edi, [digitos]
                add     edi, 4

hexa2decimal_loop:
                xor     edx, edx
                div     ebx    
                mov     cl, dl
                add     cl, 30H
                mov     [edi], cl
                dec     edi   
                cmp     eax, 0
                jne     hexa2decimal_loop

                pop     rdi
                pop     rdx
                pop     rcx
                pop     rbx
                pop     rax

                ret
                