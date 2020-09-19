.STACK 100H
.DATA
    INPUT DW 12345
    ARRY DB 10 DUP (0)
    TEMP DW ?
    OUTPUT1 DB 'True', '$'
    OUTPUT2 DB 'False', '$'

.CODE

Main PROC FAR
    ; load data
    MOV AX, @DATA
    MOV DS, AX

    ; Call procedure
    CALL Palindrome

    ; exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP

Palindrome PROC
    LEA SI, ARRY        ; load effective address to store digits
    MOV AX, INPUT       ; Bring value to accumulator

REVERSE:
    MOV DX, 0
    MOV BX, 10          ; Load to bx to perform divisions
    DIV BX              ; divide ax with bx
    MOV ARRY[SI],DL     ; Move remainder to array
    MOV TEMP,AX         ; value comparison workaround
    MOV AX,DX           ; value comparison workaround 2
    INC SI              ; Increment array pointer
    MOV AX,TEMP         ; value comparison workaround 3
    CMP TEMP,0          ; Check if stored value wasnt 0
    JG REVERSE          ; If it wasnt loop again
    LEA DI, ARRY        ; else load the mem addrs of the array to DI
    DEC SI

LOOP1:
    CMP SI, DI          ; Check if left pointer went ahead of right
    JL TRUE             ; if yes then all checks passed. ret true
    MOV AL, ARRY[SI]    ; Bring right pointer value to ax
    MOV BL, ARRY[DI]    ; Bring left pointer value to bx
    CMP AL, Bl          ; Compare values
    JNE FALSE           ; if not same, ret false
    DEC SI              ; move right pointer back
    INC DI              ; move left pointer forward
    JMP LOOP1           ; perform next check

TRUE:
    ; print true
    LEA DX, OUTPUT1
    MOV AH, 09H
    INT 21H
    ret

FALSE:
    ; print false
    LEA DX, OUTPUT2
    MOV AH, 09H
    INT 21H
    ret
END MAIN

