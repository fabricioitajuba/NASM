;**************************************************************
; string_data - Data do sistema (Ex13.asm)
;
; Entradas:
; section .data
;    clear_screen db 0x1b, '[2J', 0x1b, '[H'
;    clear_len    equ $ - clear_screen
;**************************************************************
clear_screean:
    mov rax, 1
    mov rdi, 1
    mov rsi, clear_screen
    mov rdx, clear_len
    syscall
	ret


;**************************************************************
; exit_system - Retorna ao sistema operacional
;**************************************************************
exit_system:
    mov rax, 60
    mov rdi, 0
    syscall
