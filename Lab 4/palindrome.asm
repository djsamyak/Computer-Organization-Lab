.MODEL SMALL 
.STACK 100H 
.DATA 

; The string to be printed 
STRING DB 'acba', '$'
STRING1 DB 'Sequence is palindrome', '$'
STRING2 DB 'Sequence is not palindrome', '$'

.CODE 

MOV AX, @DATA 
MOV DS, AX 

; load the starting address 
; of the string 
MOV SI,OFFSET STRING 

; traverse to the end of; 
;the string 
LOOP1: 
	MOV AX, [SI] 
	CMP AL, '$'
	JE LABEL1 
	INC SI 
	JMP LOOP1 

;load the starting address; 
;of the string 
LABEL1: 
    MOV DI,OFFSET STRING 
    DEC SI 
  
    ; check if the string is plaindrome; 
    ;or not 
    LOOP2: 
     CMP SI, DI 
     JG CHKR1
     JE CHKR2   
     
     CHKR2: 
     MOV AX,[SI] 
     MOV BX, [DI] 
     CMP AL, BL 
     JE OUTPUT1
     
     CHKR1: 
     MOV AX,[SI] 
     MOV BX, [DI] 
     CMP AL, BL 
     JNE OUTPUT2 
      
  
    DEC SI 
    INC DI 
    JMP LOOP2 

OUTPUT1: 
	;load address of the string 
	LEA DX,STRING1 

	; output the string; 
	;loaded in dx 
	MOV AH, 09H 
	INT 21H  
	
	MOV AH,4Ch 
	INT 21H

OUTPUT2: 
	;load address of the string 
	LEA DX,STRING2 

	; output the string 
	; loaded in dx 
	MOV AH,09H 
	INT 21H 
	
	MOV AH,4Ch 
	INT 21H