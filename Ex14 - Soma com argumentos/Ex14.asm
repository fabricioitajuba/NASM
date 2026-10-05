; Ex14 - Soma com argumentos
; Autor Eng. Fabrício Ribeiro
;
; Ex de uso: 
; $ soma 2 3
; 5
;
; Compilar:
; $ nasm -f elf64 Ex14.asm
; Linkeditar
; $ ld -s -o Ex14 Ex14.o
; ou:
; $ make

section .data
    newline: db 0xA
    msg_erro: db "Erro: Passe exatamente 2 numeros como argumentos.", 0xA
    ERRO_LEN: equ $ - msg_erro

section .bss
    ; Buffer para guardar o texto do resultado (suporta até 20 dígitos)
    res_str: resb 24

section .text
    global _start

_start:
    ; 1. Verificar se o usuário passou a quantidade correta de argumentos
    ; [rsp] contém o argc (número de argumentos)
    ; O nome do programa conta como 1, então precisamos de 1 + 2 = 3 argumentos.
    mov rax, [rsp]
    cmp rax, 3
    jne .mostrar_erro

    ; 2. Pegar os ponteiros dos argumentos na pilha
    ; [rsp + 8]  -> Ponteiro para o nome do programa
    ; [rsp + 16] -> Ponteiro para o Primeiro Número (Texto)
    ; [rsp + 24] -> Ponteiro para o Segundo Número (Texto)
    
    mov rdi, [rsp + 16] ; RDI = endereço da string do primeiro número
    call ascii_to_int   ; Converte texto para número
    mov r12, rax        ; Salva o primeiro número em R12

    mov rdi, [rsp + 24] ; RDI = endereço da string do segundo número
    call ascii_to_int   ; Converte texto para número
    mov r13, rax        ; Salva o segundo número em R13

    ; 3. Realizar a SOMA
    add r12, r13        ; R12 = R12 + R13

    ; 4. Converter o resultado numérico de volta para string
    mov rax, r12        ; RAX = valor numérico da soma
    mov rdi, res_str    ; RDI = onde salvar a string
    call int_to_ascii

    ; 5. Exibir o resultado formatado na tela
    ; O retorno de int_to_ascii nos dá o tamanho da string em RDX
    mov rsi, res_str    ; Endereço da string
    mov rax, 1          ; syscall sys_write
    mov rdi, 1          ; stdout
    syscall

    ; Quebra de linha final
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Sair com sucesso (status 0)
    jmp .sair_sucesso

.mostrar_erro:
    mov rax, 1          ; syscall sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg_erro
    mov rdx, ERRO_LEN
    syscall

.sair_sucesso:
    mov rax, 60         ; syscall sys_exit
    xor rdi, rdi        ; status 0
    syscall

; ---------------------------------------------------------
; Rotina: Converte String ASCII para Inteiro (64 bits)
; Entrada: RDI = Ponteiro para a string (terminada em byte 0)
; Saída:   RAX = Número inteiro correspondente
; ---------------------------------------------------------
ascii_to_int:
    xor rax, rax        ; Zera o resultado
.loop_conv:
    movzx rcx, byte [rdi] ; Lê um caractere (1 byte)
    cmp cl, 0           ; É o fim da string (null terminator)?
    je .fim_conv
    cmp cl, 0xA         ; É uma quebra de linha?
    je .fim_conv
    
    sub cl, '0'         ; Converte caractere ASCII para número (ex: '5' -> 5)
    
    ; Multiplica o acumulador por 10 e soma o novo dígito
    imul rax, 10
    add rax, rcx
    
    inc rdi             ; Avança para o próximo caractere da string
    jmp .loop_conv
.fim_conv:
    ret

; ---------------------------------------------------------
; Rotina: Converte Inteiro (64 bits) para String ASCII
; Entrada: RAX = Número, RDI = Ponteiro do buffer de destino
; Saída:   RDX = Tamanho da string gerada
; ---------------------------------------------------------
int_to_ascii:
    mov rbx, 10         ; Base decimal
    mov r11, rdi        ; Salva o início do buffer para calcular o tamanho depois
    
    ; Se o número for 0, trata separadamente
    cmp rax, 0
    jne .div_loop
    mov byte [rdi], '0'
    mov rdx, 1
    ret

.div_loop:
    cmp rax, 0
    je .inverter
    xor rdx, rdx
    div rbx             ; Divide RDX:RAX por 10. Resto em RDX, Quociente em RAX
    add dl, '0'         ; Converte o resto em caractere ASCII
    mov [rdi], dl       ; Salva temporariamente invertido no buffer
    inc rdi
    jmp .div_loop

.inverter:
    ; Como os dígitos foram salvos de trás para frente, precisamos invertê-los
    mov rdx, rdi        ; RDX aponta para o fim da string gerada
    sub rdx, r11        ; RDX = Tamanho total da string (Saída da função)
    
    mov r8, r11         ; R8 = Início da string
    mov r9, rdi
    dec r9              ; R9 = Fim da string
.invert_loop:
    cmp r8, r9
    jge .fim_int
    mov al, [r8]
    mov bl, [r9]
    mov [r8], bl
    mov [r9], al
    inc r8
    dec r9
    jmp .invert_loop
.fim_int:
    ret
