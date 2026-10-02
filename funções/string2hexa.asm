;****************************************************************
; string2hexa - Essa rotina, converte uma STRING de números em
; valor hexadecimal para usar em cálculos
;
; Entrada:   esi - Ponteiro da string
; Saída:     ax - Valor do número
;****************************************************************

string2hexa:
            push    rbx
            push    rcx
            push    rsi

            xor     ax, ax
            xor     cx, cx

string2hexa_loop:
            ;mov     cl, byte [esi]
            mov     cl, [esi]
            cmp     cl, '$'
            je      string2hexa_end
            sub     cl, '0'         
            mov     bx, 10
            mul     bx
            add     ax, cx   
            inc     esi
            jmp     string2hexa_loop
string2hexa_end:

            pop     rsi
            pop     rcx
            pop     rbx
            
            ret   