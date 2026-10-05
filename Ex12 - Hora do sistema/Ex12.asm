; Ex12 - Hora do sistema
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 Ex12.asm
; Linkeditar
; $ ld -s -o Ex12 Ex12.o
; ou:
; $ make

section .data
    ; Buffer que guardará a string formatada "HH:MM:SS\n"
    ; Inicializado com os caracteres ':' e a nova linha '\n' (0xA)
    time_str: db "00:00:00", 0xA
    TIME_LEN: equ $ - time_str

section .text
    global _start

_start:
    ; 1. Obter o Unix Timestamp (Segundos totais desde 1970)
    mov rax, 201        ; syscall sys_time
    xor rdi, rdi        ; rdi = 0
    syscall             ; rax agora tem os segundos totais

    ; 2. Calcular os segundos do dia atual
    ; 1 dia = 86400 segundos
    xor rdx, rdx        ; limpa rdx para a divisão
    mov rbx, 86400
    div rbx             ; rax = dias passados, rdx = segundos do dia atual
    
    mov rax, rdx        ; movemos os segundos do dia para rax para continuar os cálculos

    ; 3. Extrair os Segundos (Horário UTC)
    xor rdx, rdx
    mov rbx, 60
    div rbx             ; rax = minutos totais do dia, rdx = segundos atuais (0-59)
    mov r8, rdx         ; guarda segundos em r8

    ; 4. Extrair as Horas e Minutos
    xor rdx, rdx
    mov rbx, 60
    div rbx             ; rax = horas atuais (0-23), rdx = minutos atuais (0-59)
    sub rax, 3          ; horário de Brasília
    mov r9, rdx         ; guarda minutos em r9
    mov r10, rax        ; guarda horas em r10

    ; 5. Formatar os valores no buffer de texto
    ; Formatar Horas (r10) -> guarda em time_str[0] e time_str[1]
    mov rax, r10
    mov rdi, time_str
    call int_to_ascii

    ; Formatar Minutos (r9) -> guarda em time_str[3] e time_str[4]
    mov rax, r9
    mov rdi, time_str + 3
    call int_to_ascii

    ; Formatar Segundos (r8) -> guarda em time_str[6] e time_str[7]
    mov rax, r8
    mov rdi, time_str + 6
    call int_to_ascii

    ; 6. Exibir a string na tela usando sys_write (syscall 1)
    mov rax, 1          ; syscall sys_write
    mov rdi, 1          ; file descriptor 1 (stdout)
    mov rsi, time_str   ; ponteiro para o texto
    mov rdx, TIME_LEN   ; tamanho da string
    syscall

    ; 7. Sair do programa usando sys_exit (syscall 60)
    mov rax, 60         ; syscall sys_exit
    xor rdi, rdi        ; status de retorno 0
    syscall

; ---------------------------------------------------------
; Rotina auxiliar: Converte um número de 0 a 59 em 2 caracteres ASCII
; Entrada: RAX = número, RDI = ponteiro da memória para salvar
; ---------------------------------------------------------
int_to_ascii:
    xor rdx, rdx
    mov rbx, 10
    div rbx             ; divide por 10. RAX = dezena, RDX = unidade
    
    add al, '0'         ; converte dezena para caractere ASCII
    add dl, '0'         ; converte unidade para caractere ASCII
    
    mov [rdi], al       ; salva o primeiro dígito
    mov [rdi+1], dl     ; salva o segundo dígito
    ret
