;****************************************************************
; hexa2string - Essa rotina, converte um número em hexadecimal
; de 16 bits em decimal colocando o valor em 4 posições de memória
;
; Entrada:   AX - de 16 bits
; Saída:     DIGITOS - String
;****************************************************************

hexa2string:

    push rax
    push rcx

    push rax
    mov cl,4
    ror al,cl 
    call corrige_hexa
    pop rax
    call corrige_hexa
    
    pop rcx
    pop rax
    ret

corrige_hexa:
    and al,0fh
    add al,'0'
    cmp al,39h
    ja corrige_ascii
    call print_char
    ret
corrige_ascii:    
    add al,07h
    call print_char

    ret