;****************************************************************
; hexa2string - Essa rotina mostra o conteúdo do registrador AL 
; em formato hexadecimal.
;
; Entrada:   AL - de 8 bits
; Saída:     DIGITOS - String
;****************************************************************

hexa2string:

    push rax
    push rcx

    push rax
    mov cl,4
    ror al,cl 
    call corrige_hexa1
    pop rax
    call corrige_hexa2
    
    pop rcx
    pop rax
    ret

corrige_hexa1:
    and al,0fh
    add al,'0'
    cmp al,39h
    ja corrige_ascii1
    mov [digitos], al
    ret
corrige_ascii1: 
    add al,07h
    mov [digitos], al
    ret

corrige_hexa2:
    and al,0fh
    add al,'0'
    cmp al,39h
    ja corrige_ascii2
    mov [digitos+1], al
    ret
corrige_ascii2: 
    add al,07h
    mov [digitos+1], al
    ret    