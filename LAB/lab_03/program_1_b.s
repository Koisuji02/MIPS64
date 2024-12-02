            .data
v1:         .double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
v2:         .double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
v3:         .double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
v4:         .space  256
v5:         .space  256
v6:         .space  256
m:          .word 1
b:          .double 2   ; a lo considero un registro in quanto inutile

            .text
main:
    ld R2, m(R0)        ; R2 = m = 1
    l.d F0, b(R0)       ; F0 = b
    daddi R1, R0, 248   ; R1 = i = posizione da decrementare di 8
    daddi R3, R0, 3     ; R3 = 3 per verificare multipli

loop1:
    ddiv R4, R1, R3     ; R4 = i/3
    dmul R5, R4, R3     ; R5 = R4*3 = (i/3)*3
    dsub R6, R1, R5     ; R6 = i - (i/3)*3 per controllare se multiplo
    beqz R6, multiplo3  ; se multiplo, altrimenti continuo sempre in questa sezione
    l.d F1, v1(R1)      ; F1 = elemento di v1; DELAY SLOT: load di v1[i], indipendentemente dal risultato del branch

    dmul R7, R2, R1     ; R7 = m*i
    ; CONVERSIONE
    mtc1 R7, F7         ; sposto m*i (R7->F7)
    cvt.d.l F7, F7      ; converto il valore di m*i in FP dentro F7
    ;
    mul.d F8, F1, F7    ; F8 = a = v1[i]*((double) m*i)
    ; RICONVERSIONE
    cvt.l.d F9, F8      ; converto il valore di a in int -> int(a)
    mfc1 R2, F9         ; sposto a dentro il registro di m, ovvero ho m = (int)a
    ;
    sd R2, m(R0)        ; assegno ad m il suo nuovo valore
    j loop2

multiplo3:
    dsllv R7, R2, R1    ; R7 = m << i [logic shift left]
    ; CONVERSIONE
    mtc1 R7, F7         ; sposto m*i (R7->F7)
    cvt.d.l F7, F7      ; converto il valore di m*i in FP dentro F7
    ;
    div.d F8, F1, F7    ; F8 = a = v1[i]/((double) m << i)
    ; RICONVERSIONE
    cvt.l.d F9, F8      ; converto il valore di a in int -> int(a)
    mfc1 R2, F9         ; sposto a dentro il registro di m, ovvero ho m = (int)a
    ;
    sd R2, m(R0)        ; assegno ad m il suo nuovo valore

loop2:
    mul.d F4, F8, F1    ; F4 = elemento di v4 = a*v1[i]-v2[i]
    l.d F2, v2(R1)      ; F2 = elemento di v2
    l.d F3, v3(R1)      ; F3 = elemento di v3
    sub.d F4, F4, F2
    div.d F5, F4, F3    ; F5 = elemento di v5
    s.d F4, v4(R1)
    sub.d F6, F4, F1    ; F6 = elemento di v6
    sub.d F5, F5, F0
    s.d F5, v5(R1)
    mul.d F6, F6, F5
    beqz R1, end
    s.d F6, v6(R1)
    j loop1
    daddi R1, R1, -8

end:
    halt