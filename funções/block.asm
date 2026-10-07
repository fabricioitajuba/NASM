;**************************************************************
; move_bytes - Move bytes
;
; Entradas:
; rsi - ponteiro do primeiro bloco
; rdi - ponteiro do segundo bloco
; rcx - número de bytes
;**************************************************************
move_bytes:
    CLD
    rep movsb
    ret