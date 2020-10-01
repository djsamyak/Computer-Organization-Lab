.STACK 100H
.DATA
    NUM DW 0
    STATEMENT DB 'a + b + c = ', '$'
    RES DB 10 DUP ('$')
.CODE

DISPLAY MACRO string
    MOV AH, 9
    LEA DX, string
    INT 21H
ENDM

Main PROC FAR
    ; load data
    MOV AX, @DATA     
    MOV DS, AX

    ; Call procedure
    CALL Sum

    ; exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP

Sum PROC

    MOV AX, 0               ; Load a to accumulator
    LEA SI, RES             ; load address for string buffer for number
    
    CALL Inputval           ; Input a           
    ADD NUM, BX             ; add a
    CALL Inputval           ; Input b
    ADD NUM, BX             ; add b
    CALL Inputval           ; Input c
    ADD NUM, BX             ; add c
    
    DISPLAY STATEMENT       ; Display 'X = '
    MOV AX, NUM
    CALL Hexconv            ; Conver output to string and store in buffer
    DISPLAY RES             ; Display number as string
    ret

Sum ENDP

Inputval PROC
    MOV BX, 0
    MOV CX, 10
readnext:
    MOV AH, 1h
    INT 21h
    CMP AL, 13
    JE exit
    SUB AL, 30H
    MOV AH, 0
    MOV DX, AX
    MOV AX, BX        
    MUL CL
    MOV BX, AX
    ADD BX, DX
    JMP readnext
    
exit:
    MOV AH, 0H
    MOV AL, 3H
    INT 10H
    ret
Inputval ENDP

Hexconv PROC
    MOV CX, 0               ; Set digit position counter
    MOV BX, 10              ; Load 10 to BX as base = 10

convert:
    MOV DX, 0               ; Clear remainder
    DIV BX                  ; Divide number by 10
    ADD DL, 30H             ; Convert remainder to ascii by adding 0x30
    PUSH DX                 ; push to stack
    INC CX                  ; increment digit counter
    CMP AX, 9               ; Compare remaining number to 9
    JG convert              ; If number is greater than 9 try for next digit

    ADD AL, 30H             ; Convert remaining number to ascii
    MOV [SI], AL            ; and add it to output string

format:
    POP AX                  ; Get next digit out of stack
    INC SI                  ; move to next digit pos    
    MOV [SI], AL            ; Add current digit to string
    LOOP format             ; loop until no digits remain
    INC SI                  ; Since we reuse RES for every digit,
    MOV [SI], '$'           ; Set null terminator at correct location
    ret
Hexconv ENDP
END MAIN