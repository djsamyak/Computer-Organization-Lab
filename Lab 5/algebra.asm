.STACK 100h

.DATA

QUES0 DB "X=Y+4",10,13,'$'
QUES1 DB 'ENTER THE VALUE OF Y IN 3 DIGITS (9 -> 009)',10,13,'$'
ANS DB 10,10,13,'VALUE OF X IS ','$'

TEN DB 10
HUND DB 100
BUFFER DB 0 DUP(3)


.CODE

MOV AX, @DATA                 ;Move Data in data segment
MOV DS, AX

MOV DX, OFFSET QUES0
MOV AH, 09h
int 21h 

MOV DX, OFFSET QUES1
MOV AH, 09h
int 21h

MOV CX,3
MOV BUFFER,0

looper1:                      ;Loop to enter each digit
                              
    MOV AH, 01h
    int 21h
    SUB AL,30h                ;Convert from ASCII to Decimal
    MOV BX,CX
    SUB CX,1
    
    CMP CX,0
    JG looper2
                              
    looper3:                  ;Adds the values to a buffer
  
        MOV CX,BX
        ADD BUFFER,AL
        LOOP looper1 

ADD BUFFER,4                  ;Add 4

MOV DX, OFFSET ANS
MOV AH, 09h
int 21h
                              
MOV AL,BUFFER                 ;Extract individual digits
MOV AH,0
DIV HUND
MOV BL,AH
ADD AL,30h
MOV AH, 06h
MOV DL,AL
int 21h 

MOV AL,BL
MOV AH,0
DIV TEN 
MOV BL,AH
ADD AL,30h
MOV AH, 06h
MOV DL,AL
int 21h 

MOV DL,BL
ADD DL,30h
MOV AH, 06h
int 21h

MOV AH,4Ch                    ;Exit sequence
int 21h


looper2:                      ;Multiplied powers of 10 to the digit
        MUL TEN 
        loop looper2
        JMP looper3 



