            .data
v1:         .double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
v2:         .double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
v3:         .double 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32
v4:         .space  256
v5:         .space  256
v6:         .space  256

            .text
main:  
    daddi R1, R0, 248    ; R1 = posizione da decrementare di 8

loop:
    l.d F1, v1(R1)      ; F1 = elemento di v1
    l.d F2, v2(R1)      ; F2 = elemento di v2
    l.d F3, v3(R1)      ; F3 = elemento di v3
    mul.d F4, F1, F1    ; F4 = elemento di v4
    sub.d F4, F4, F2
    s.d F4, v4(R1)
    div.d F5, F4, F3    ; F5 = elemento di v5
    sub.d F5, F5, F2
    s.d F5, v5(R1)
    sub.d F6, F4, F1    ; F6 = elemento di v6
    mul.d F6, F6, F5
    s.d F6, v6(R1)
    beqz R1, end
    daddi R1, R1, -8
    j loop

end:
    halt