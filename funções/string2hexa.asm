;****************************************************************
; string2hexa - Essa rotina, converte uma STRING de números em
; valor hexadecimal para usar em cálculos
;
; Entrada:   rsi - Ponteiro da string
; Saída:     ax - Valor do número
;****************************************************************

string2hexa:
            push    rbx
            push    rcx
            push    rsi

            xor     rax, rax
            xor     rcx, rcx

string2hexa_loop:
            ;mov     cl, byte [rsi]
            mov     cl, [rsi]
            ;cmp     cl, '$'
            cmp     cl, 10
            je      string2hexa_end
            sub     cl, '0'         
            mov     rbx, 10
            mul     rbx
            add     rax, rcx   
            inc     rsi
            jmp     string2hexa_loop
string2hexa_end:

            pop     rsi
            pop     rcx
            pop     rbx
            
            ret   