                .data

v1:             .byte   2, 6, -3, 11, 9, 18, -13, 16, 5, 1
v2:             .byte   4, 2, -13, 3, 9, 9, 7, 16, 4, 7
v3:             .space  10      ; alloca 10 byte = 10 elementi * 1 byte ciascuno
flag1:          .byte 0
flag2:          .byte 0
flag3:          .byte 0

                .text
main:
    daddi R1, R0, 0     ; R1 = offset rispetto al indirizzo di v1
    daddi R2, R0, 0     ; R2 = offset rispetto al indirizzo di v2
    daddi R3, R0, 0     ; R3 = offset rispetto al indirizzo di v3 (ancora vuoto)
    daddi R4, R0, 10    ; R4 = 10 numero elementi di v1
    daddi R5, R0, 10    ; R5 = 10 numero elementi di v2
    daddi R9, R0, 0

loop1: ; ciclo su v1
    beq R4, R0, flags
    lb R6, v1(R1)       ; R6 = elemento di v1
    daddi R1, R1, 1     ; Incrementa R1 per il prossimo elemento di v1
    daddi R4, R4, -1    ; Decrementa R4 per contare i cicli rimasti
    daddi R5, R0, 10    ; R5 = 10 numero elementi di v2
    daddi R2, R0, 0
    j loop2             ; Vai al ciclo interno per confrontare con v2

loop2:  ; ciclo su v2 (interno)
    beq R5, R0, loop1   ; Se abbiamo esaurito v2, torna a loop1
    lb R7, v2(R2)       ; R7 = elemento di v2
    beq R7, R6, right   ; Se elemento di v1 e v2 sono uguali, vai a right
    daddi R2, R2, 1     ; Incrementa R2 per il prossimo elemento di v2
    daddi R5, R5, -1    ; Decrementa R5 per contare i cicli rimasti in v2
    j loop2             ; Continua il ciclo su v2

right:
    daddi R9, R0, 1
    sb R6, v3(R3)       ; Memorizza elemento corrispondente in v3
    daddi R3, R3, 1     ; Incrementa R3 per il prossimo spazio in v3
    daddi R2, R0, 0     ; Reset di R2 per il prossimo ciclo su v2
    daddi R5, R0, 10    ; Reset di R5 per il prossimo ciclo su v2
    j loop1             ; Ritorna a loop1 per il prossimo elemento di v1


flags:
    beq R9, R0, flag1_rout
    lb R8, v3(R0)
    daddi R17, R0, 1
    lb R10, v3(R17)
    beq R8, R10, end
    slt R11, R10, R8; R11 = 1 se R10 < R8, perciò caso flag3
    daddi R12, R0, 1
    daddi R3, R3, -1
    daddi R13, R0, 0    ; indice di v3
    beq R11, R12, flag3_rout
    j flag2_rout
    

flag1_rout: ; flag1 = 1 se vuoto
    daddi R19, R0, 1
    sb R19, flag1(R0)
    j end

flag2_rout:
    beq R13, R3, flag2_confirm
    lb R14, v3(R13)
    daddi R18, R13, 1
    lb R15, v3(R18)
    slt R16, R15, R14
    beq R16, R12, end
    daddi R13, R13, 1
    j flag2_rout

flag3_rout:
    beq R13, R3, flag3_confirm
    lb R14, v3(R13)
    daddi R18, R13, 1
    lb R15, v3(R18)
    slt R16, R15, R14
    bne R16, R12, end
    daddi R13, R13, 1
    j flag3_rout

flag2_confirm:
    sb R9, flag2(R0)
    j end

flag3_confirm:
    sb R9, flag3(R0)
    j end

end:
    ; fine
    nop