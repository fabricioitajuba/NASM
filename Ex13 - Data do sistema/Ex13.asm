; Ex13 - Data do sistema
; Autor Eng. Fabrício Ribeiro
;
; Compilar:
; $ nasm -f elf64 Ex13.asm
; Linkeditar
; $ ld -s -o Ex13 Ex13.o
; ou:
; $ make

section .data
    ; Buffer que guardará a string formatada "DD/MM/AAAA\n"
    date_str: db "00/00/0000", 0xA
    DATE_LEN: equ $ - date_str

section .bss
    ; Estrutura para receber os dados do clock_gettime (16 bytes)
    timespec:
        .tv_sec:  resq 1    ; Segundos (64-bit)
        .tv_nsec: resq 1    ; Nanossegundos (64-bit)

section .text
    global _start

_start:
    ; 1. Chamar sys_clock_gettime para obter o tempo do sistema
    mov rax, 228        ; syscall sys_clock_gettime
    mov rdi, 0          ; CLOCK_REALTIME (Hora/Data civil do sistema)
    mov rsi, timespec   ; Ponteiro para onde salvar o resultado
    syscall

    ; O registrador [timespec.tv_sec] agora tem o timestamp atual.
    ; Para exibir a data correta no fuso horário do Brasil (UTC-3),
    ; precisamos subtrair 3 horas (3 * 3600 segundos = 10800 segundos)
    mov rax, [timespec.tv_sec]
    sub rax, 10800      ; Ajuste para UTC-3 (Horário de Brasília)

    ; 2. Converter os segundos totais em dias desde 1970
    xor rdx, rdx
    mov rbx, 86400      ; Segundos em um dia
    div rbx             ; RAX = Total de dias completos desde 01/01/1970

    ; --- Algoritmo Simplificado de Calendário (Era Unix) ---
    ; Adiciona a diferença de dias até a era atual do ciclo de 400 anos
    add rax, 719468     ; Ajusta para contar a partir do ano 0 do calendário Gregoriano
    
    ; Calcular o Ano
    xor rdx, rdx
    mov rbx, 146097     ; Dias em um ciclo de 400 anos
    div rbx             ; RAX = Ciclos de 400 anos
    mov r8, rax         ; R8 guarda ciclos de 400 anos
    
    mov rax, rdx        ; RDX = dias restantes no ciclo atual
    xor rdx, rdx
    mov rbx, 36524      ; Dias em um ciclo de 100 anos
    div rbx
    ; Tratamento de borda para anos bissextos centenários
    cmp rax, 4
    jne .not_4_century
    mov rax, 3
.not_4_century:
    ; Acumula o cálculo do ano em R11
    imul r8, 400
    imul rax, 100
    add r8, rax         ; R8 tem a base de anos acumulados
    
    ; Continua o resto para ciclos de 4 anos e anos individuais
    mov rax, rdx
    xor rdx, rdx
    mov rbx, 1461       ; Dias em 4 anos (com bissexto)
    div rbx
    imul rax, 4
    add r8, rax         ; Soma os ciclos de 4 anos
    
    mov rax, rdx
    xor rdx, rdx
    mov rbx, 365        ; Dias em 1 ano comum
    div rbx
    cmp rax, 4
    jne .not_4_year
    mov rax, 3
.not_4_year:
    add r8, rax         ; R8 agora tem o ANO exato final!
    mov r11, rdx        ; R11 tem o dia do ano (0-365) restante

    ; Calcular Mês e Dia usando uma aproximação de inteiros estável
    ; Ajuste mágico de deslocamento para alinhar meses
    imul rax, r11, 5
    add rax, 2
    mov rbx, 153
    xor rdx, rdx
    div rbx             ; RAX = Mês ajustado (março = 0, fevereiro = 11)
    mov r9, rax         ; Guarda o mês temporário
    
    ; Encontra o dia do mês
    imul rax, 153
    add rax, 2
    mov rbx, 5
    xor rdx, rdx
    div rbx
    sub r11, rax
    add r11, 1          ; R11 = DIA DO MÊS final!

    ; Corrige o deslocamento dos meses e o ano
    mov rax, r9
    cmp rax, 10
    jl .mes_normal
    sub rax, 9          ; Janeiro ou Fevereiro
    add r8, 1           ; Ano avança
    jmp .salva_mes
.mes_normal:
    add rax, 3          ; Março a Dezembro
.salva_mes:
    mov r10, rax        ; R10 = MÊS final!

    ; --- 3. FORMATAR EM STRING ASCII ---
    
    ; Formatar o DIA (R11) -> date_str[0] e [1]
    mov rax, r11
    mov rdi, date_str
    call int_to_ascii_2dig

    ; Formatar o MÊS (R10) -> date_str[3] e [4]
    mov rax, r10
    mov rdi, date_str + 3
    call int_to_ascii_2dig

    ; Formatar o ANO (R8) -> date_str[6] até [9]
    mov rax, r8
    mov rdi, date_str + 6
    call int_to_ascii_4dig

    ; 4. Exibir a string resultante na tela (sys_write)
    mov rax, 1          ; syscall sys_write
    mov rdi, 1          ; stdout
    mov rsi, date_str
    mov rdx, DATE_LEN
    syscall

    ; 5. Finalizar programa (sys_exit)
    mov rax, 60
    xor rdi, rdi
    syscall

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
    div rbx             ; RAX = primeiros 2 dígitos (ex: 20), RDX = últimos 2 (ex: 26)
    
    push rdx            ; Salva os últimos 2 dígitos na pilha
    call int_to_ascii_2dig ; Converte e escreve os primeiros 2 no endereço RDI
    
    pop rax             ; Recupera os últimos 2 dígitos
    add rdi, 2          ; Avança o ponteiro da string em 2 bytes
    call int_to_ascii_2dig ; Converte e escreve os últimos 2
    ret
