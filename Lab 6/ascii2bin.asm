.STACK 100H
.DATA
    INPUT DB '23', '$'
    RES DB 10 DUP ('$')
    WSP DB ' ', '$'
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
    CALL Asciiconv

    ; exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP

Asciiconv PROC

    MOV DI, OFFSET INPUT    ; Load address of first char of input string to DI
FOR1:
    MOV AX, [DI]            ; Move char at pointer DI to AX
    CMP AL, '$'             ; Check if last character
    JE LABEL1               ; If last character we are done
    LEA SI, RES             ; If not load address to store binary for current char at
    CALL Binchar            ; Convert current character to binary
    DISPLAY RES             ; Display converted value
    DISPLAY WSP             ; Print whitespace and proceed to next value
    INC DI                  ; Increment pointer to next character
    JMP FOR1                ; Loop

LABEL1:                     
    ret                     ; Procedure complete return
Asciiconv ENDP

Binchar PROC
    MOV AH, 0               ; Clear high bit of ax
    SUB AL, 30H             ; Then subtract 0x30 or 41, number is now decimal
    MOV CX, 0               ; Set binary digit position counter
    MOV BX, 2               ; Load 2 to BX as base = 2

convert:
    MOV DX, 0               ; Clear remainder
    DIV BX                  ; Divide number by 2
    ADD DL, 30H             ; Convert remainder to ascii by adding 0x30 or 41
    PUSH DX                 ; push to stack
    INC CX                  ; increment digit counter
    CMP AX, 1               ; Compare remaining number to 1
    JG convert              ; If number is greater than 1 try for next digit

    ADD AL, 30H             ; Convert last number to ascii
    MOV [SI], AL            ; and add it to output string

format:
    POP AX                  ; Get next digit out of stack
    INC SI                  ; move to next digit pos    
    MOV [SI], AL            ; Add current digit to string
    LOOP format             ; loop until no digits remain
    INC SI                  ; Since we reuse RES for every digit,
    MOV [SI], '$'           ; Set null terminator at correct location
    ret                     ; Return to continue
Binchar ENDP
END MAIN