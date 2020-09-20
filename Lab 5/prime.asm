ORG 100h

.DATA

QUES DB 'Enter a 3 digit number (9 -> 009)',10,13,'$'
ANS1 DB 10,10,13,'It is a PRIME number!','$'  
ANS2 DB 10,10,13,'IT is NOT a prime number!','$'
TEN DB 10

BUFFER DB 0 DUP(3)

.CODE

MOV AX,@DATA
MOV DS,AX

MOV DX, OFFSET QUES           ;Display question
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

MOV AL,BUFFER
MOV AH,0
MOV CX,AX
MOV BX,AX

SUB CX,1

label1:                       ;Check if it is divisble by any number
                              ;other than itself and one
    CMP CL,01h
    JE label3:
    DIV CL
    CMP AH,00h
    JE label2
    MOV AX,BX
    LOOP label1 
   
label2:                       ;Print NOT Prime

    MOV DX,OFFSET ANS2
    MOV AH, 09h
    int 21h
    MOV AH,4Ch
    int 21h 
    
label3:                       ;Print Prime

    MOV DX,OFFSET ANS1
    MOV AH, 09h
    int 21h
    MOV AH,4Ch
    int 21h   
    
looper2:                      ;Multiplied powers of 10 to the digit
        MUL TEN 
        loop looper2
        JMP looper3
        