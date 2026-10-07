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

hexa2decimal:   
    push rax
    push rbx
    push rcx
    push rdx
    push rdi

    ;Zera as posições de DIGITOS
    lea rsi, [digitos]
    mov rcx, 8
    mov dl, '0'

hexa2decimal_loop1:    
    mov byte [rsi], dl
    inc rsi
    loop hexa2decimal_loop1

    mov rbx, 10
    lea rdi, [digitos]
    add rdi, 7

hexa2decimal_loop2:
    xor rdx, rdx
    div rbx    
    mov cl, dl
    add cl, 30H
    mov [rdi], cl
    dec rdi   
    cmp rax, 0
    jne hexa2decimal_loop2

    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

; ---------------------------------------------------------
; Rotina: Converte número de 2 dígitos (00-99) para ASCII
; ---------------------------------------------------------
int_to_ascii_2dig:
    xor rdx, rdx
    mov rbx, 10
    div rbx             ; RAX = dezena, RDX = unidade
    add al, '0'
    add dl, '0'
    mov [rdi], al
    mov [rdi+1], dl
    ret

; ---------------------------------------------------------
; Rotina: Converte número de 4 dígitos (AAAA) para ASCII
; ---------------------------------------------------------
int_to_ascii_4dig:

    ; Divide por 100 para separar os dois primeiros dígitos dos dois últimos
    xor rdx, rdx
    mov rbx, 100
    div rbx                 ; RAX = primeiros 2 dígitos (ex: 20), RDX = últimos 2 (ex: 26)
    
    push rdx                ; Salva os últimos 2 dígitos na pilha
    call int_to_ascii_2dig  ; Converte e escreve os primeiros 2 no endereço RDI
    
    pop rax                 ; Recupera os últimos 2 dígitos
    add rdi, 2              ; Avança o ponteiro da string em 2 bytes
    call int_to_ascii_2dig  ; Converte e escreve os últimos 2
    ret