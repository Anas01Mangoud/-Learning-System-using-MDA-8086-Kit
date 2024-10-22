code segment
Assume cs:code ,DS:code ,ES:code ,SS:code


command 	    equ	    00h    ; Command register for LCD
stat	        equ     02h    ; Status register for checking LCD busy status
data	        equ	    04h    ; Data register for LCD

key             equ     01h    ; Input from key (or keypad)

control         equ     1Fh    ; Control port for output device
porta           equ     19h    ; Output port A

control_Dot     equ     1EH    ; Control for dot matrix display
portc           equ     1CH    ; Output port C
portR           equ     18H    ; Output port R
portg           equ     1AH    ; Output port G

org 1000h       ; Code segment starts at 1000h




;----------code----------    

		
		call init   
		mov si,offset str
		 call start 
		 call timer 
		 mov AL, 10000000b
		 out control,al 

    	 mov al ,10000000b
         out Control_Dot,Al  
         mov al ,11111111b
         out PORTR,Al  
         mov al ,11111111b
         out PORTG,Al  
         
         
         
 main:  
        
        call Scan    
      
        cmp al,00h 
        jne number1 
                call clear 
        Mov si,offset str0
        call start 
        mov al,index0
        out porta ,al 
         MOV SI, OFFSET MATRIX0
         call even0 
        jmp exit  
        
       number1: 
        cmp al,01h
        jne number2 
                call clear 
        Mov si,offset str1
        call start 
        mov al,index1
        out porta ,al
        MOV SI, OFFSET MATRIX1
        call odd  
        jmp exit
           
       number2:  
        cmp al,02h
        jne number3  
                 call clear 
         Mov si,offset str2
        call start  
        mov al,index2
        out porta ,al  
          MOV SI, OFFSET MATRIX2
         call even0
        jmp exit  
          
       number3:   
        cmp al,03h
        jne number4 
                call clear 
        Mov si,offset str3
        call start  
        mov al,index3
        out porta ,al 
         MOV SI, OFFSET MATRIX3
        call odd
        jmp exit
          
       number4:   
        cmp al,04h
        jne number5  
       
                 call clear   
         Mov si,offset str4
        call start  
        mov al,index4
        out porta ,al
         MOV SI, OFFSET MATRIX4
         call even0 
        jmp exit
        
        number5:  
        cmp al,05h
        jne number6 
                 call clear  
         Mov si,offset str5
        call start 
        mov al,index5
        out porta ,al  
         MOV SI, OFFSET MATRIX5
        call odd
        jmp exit 
        
        number6:  
        cmp al,06h
        jne number7   
                 call clear 
        Mov si,offset str6
        call start 
        mov al,index6
        out porta ,al 
         MOV SI, OFFSET MATRIX6
         call even0  
        jmp exit
        
        number7:  
        cmp al,07h
        jne number8   
                 call clear 
          Mov si,offset str7
        call start  
        mov al,index7
        out porta ,al     
         MOV SI, OFFSET MATRIX7
        call odd
        jmp exit
         
        number8:  
        cmp al,08h
        jne number9  
                 call clear 
        Mov si,offset str8
        call start  
        mov al,index8
        out porta ,al   
         MOV SI, OFFSET MATRIX8
         call even0
        jmp exit
         
         number9:
        cmp al,09h
        jne charA   
                 call clear 
         Mov si,offset str9
        call start
        mov al,index9
        out porta ,al 
         MOV SI, OFFSET MATRIX9
        call odd 
        jmp exit 
               
       charA:          
        cmp al,0Ah
        jne charB 
                 call clear  
        mov si ,offset strA 
        call start
        call nextline 
        mov si ,offset strA1 
        call start
        mov al,index1
        out porta ,al   
         MOV SI, OFFSET MATRIXa
        call odd
        jmp exit 
      
        charB:        
        cmp al,0Bh
        jne charC  
                 call clear 
         mov si ,offset strb 
        call start
        call nextline
        mov si ,offset strb1 
        call start
        mov al,index2
        out porta ,al 
         MOV SI, OFFSET MATRIXb
         call even0 
        jmp exit  
        
       charC: 
        cmp al,0Ch
        jne charD  
                 call clear 
        mov si ,offset strc 
        call start
        call nextline
        mov si ,offset strc1 
        call start
        mov al,index3
        out porta ,al 
         MOV SI, OFFSET MATRIXc
        call odd
        jmp exit
        
       charD: 
        cmp al,0Dh
        jne charE 
                 call clear 
        mov si ,offset strD 
        call start
        call nextline
        mov si ,offset strD1 
        call start
        mov al,index4
        out porta ,al
         MOV SI, OFFSET MATRIXd
         call even0
        jmp exit 
        
       charE: 
        cmp al,0Eh
        jne charF 
                 call clear 
         mov si ,offset stre 
        call start
        call nextline
        mov si ,offset stre1
        call start
        mov al,index5
        out porta ,al  
         MOV SI, OFFSET MATRIXe
        call odd
        
        jmp exit
        
       charF: 
        cmp al,0fh 
        jne exit 
        call clear 
        mov si ,offset strf 
        call start
        call nextline
        mov si ,offset strf1 
        call start
        mov al,index6
        out porta ,al  
         MOV SI, OFFSET MATRIXf
         call even0
        jmp exit  
 exit:    
         
                        
 jmp main  
  hlt                                                              
;------------------------  
                
             

;---------------Display initialization procedure--------
init:	call busy      	    ;Check if KIT is busy
		mov al,38h          ;8-bits mode, two line & 5x7 dots
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,0ch          ;Turn the display and cursor ON, and set cursor to blink
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,06h          ;cursor is to be moved to right
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,02           ;Return cursor to home
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,01           ;Clear the display
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		ret
		

nextLine:
   call busy
   mov al,192
   out command,al
   call busy
   ret
   
   
clear:
   call busy
   mov al,01h
   out command,al
   call busy
   ret

;-----------------display ready procedure------------		
busy:	IN AL,Stat
		test AL,10000000b
		jnz busy
		ret

;------------------scan-------------------------------
Scan: IN Al,Key
      test AL,10000000b
      jnz Scan   
      And al,00011111b
      out key,al  
      ret   
;---------------timer------------------  
 TIMER: 
        MOV CX,1
  TIMER1: 
      NOP
      NOP
      NOP
      NOP
   LOOP TIMER1   
          MOV CX,1
  TIMER2: 
      NOP
      NOP
      NOP
      NOP
   LOOP TIMER2
     RET
;-----------------out--------------------      
 start:
       	mov al,[si]
		cmp al,00
		je  l0
		out data,al
		call busy
		inc si
		jmp start   
	l0:
	    ret	 
;---------------------Martrix(0)-----------------  

matrix0:
       DB 11111111B 
       DB 11111111B
       DB 00000000b
       DB 01111110B
       DB 01111110B
       DB 00000000B
       DB 11111111B
       DB 11111111B	
          	    
;---------------------Martrix(1)-----------------

matrix1:
       DB 11111111B 
       DB 11111111B
       DB 11011111B
       DB 10111110B
       DB 00000000B
       DB 11111110B
       DB 11111111B
       DB 11111111B   
       
 ;---------------------Martrix(2)-----------------    

matrix2:
       DB 11111111B 
       DB 11111111B
       DB 01100000B
       DB 01101110B
       DB 01101110B
       DB 00001110B
       DB 11111111B
       DB 11111111B       

;---------------------Martrix(3)-----------------
matrix3:
       DB 11111111B 
       DB 11111111B
       DB 10110110B
       DB 10110110B
       DB 10110110b
       DB 10000000b
       DB 11111111B
       DB 11111111B      
       
 ;---------------------Martrix(4)-----------------    


matrix4:
       DB 11111111B 
       DB 11111111B
       DB 10000011B
       DB 11111011B
       DB 11111011B
       DB 10000000B
       DB 11111111B
       DB 11111111B
;---------------------Martrix(5)-----------------
matrix5:
       DB 11111111B 
       DB 11111111B
       DB 10000110B
       DB 10110110B
       DB 10110110B
       DB 10110000B
       DB 11111111B
       DB 11111111B              
;---------------------Martrix(1)-----------------  

matrix6: 
       DB 11111111B     
       DB 11111111B 
       DB 10000001B
       DB 10101101B
       DB 10101101B
       DB 10100001B
       DB 11111111B
       DB 11111111B
 ;---------------------Martrix(7)-----------------
matrix7:
       DB 11111111B 
       DB 11111111B
       DB 01110110B
       DB 01110011B
       DB 01100111B
       DB 00110111B
       DB 11111111B
       DB 11111111B  
;---------------------Martrix(8)-----------------  

matrix8:
       DB 11111111B 
       DB 11111111B
       DB 10000000B
       DB 10110110B
       DB 10110110B
       DB 10000000B
       DB 11111111B
       DB 11111111B
;---------------------Martrix(9)-----------------
matrix9:
       DB 11111111B 
       DB 11111111B
       DB 11001110B
       DB 10110110B
       DB 10110110B
       DB 11000001B
       DB 11111111B
       DB 11111111B  
;---------------------Martrix(A)-----------------
matrixA:
       DB 11111111B 
       DB 11000000B
       DB 10111011B
       DB 01111011B
       DB 10111011B
       DB 11000000B
       DB 11111111B
       DB 11111111B                         
;---------------------Martrix(B)-----------------   

matrixB:
       DB 11111111B 
       DB 10001000B
       DB 10110110B
       DB 10110110B
       DB 10110110B
       DB 11001001B
       DB 11111111B
       DB 11111111B     
;---------------------Martrix(C)-----------------         
matrixC:
       DB 11111111B 
       DB 11111111B
       DB 11000011B
       DB 10111101B
       DB 10111101B
       DB 10111101B
       DB 11111111B
       DB 11111111B    
;---------------------Martrix(D)-----------------  
matrixD:
       DB 11111111B 
       DB 11111111B
       DB 00000000B
       DB 01111110B
       DB 10111101B
       DB 11000011B
       DB 11111111B
       DB 11111111B    
;---------------------Martrix(E)-----------------         
matrixE:
       DB 11111111B 
       DB 11111111B
       DB 10000000B
       DB 10110110B
       DB 10110110B
       DB 10110110B
       DB 11111111B
       DB 11111111B   
;---------------------Martrix(F)-----------------    
     
matrixF:
       DB 11111111B 
       DB 11111111B
       DB 10000000B
       DB 10110111B
       DB 10110111B
       DB 10110111B
       DB 11111111B
       DB 11111111B    
;------------------even--------------------------
even0:
        mov al ,00000000b
        out portg, al
        mov al ,11111111b
        out portr, al 
        
        MOV AH, 000000001B 
        
rteven: MOV AL, BYTE PTR CS:[SI]
      OUT PORTG, AL  
      MOV AL,11111111B
      OUT PORTC,AL
      MOV AL, AH
      OUT portR, AL
      CALL TIMER 
      INC SI
      CLC
      ROL AH, 1 
      JNC rteven
      JMP even1

even1:
CALL TIMER
ret       

;------------------old--------------------------
odd:
        mov al ,00000000b
        out portr, al
        mov al ,11111111b
        out portg, al 
        
        MOV AH, 00000001B 
         mov cx,8  
      
     rtodd: MOV AL, BYTE PTR CS:[SI]
      OUT PORTr, AL  
      MOV AL,11111111B
      OUT PORTC,AL
      MOV AL, AH
      OUT portg, AL
      CALL TIMER 
      INC SI
      CLC
      ROL AH, 1 
      JNC rtodd
      JMP odd1

odd1:
CALL TIMER
ret       
                                                        		
;-----------------Keys vars----------------------  

  str  db "Learning System!",00 
  str0 db "this is num 0",00 
  
  str1 db "this is num 1",00  
  
  str2 db "this is num 2",00  
  
  str3 db "this is num 3",00 
  
  str4 db "this is num 4",00 
  
  str5 db "this is num 5",00  
  
  str6 db "this is num 6",00  
  
  str7 db "this is num 7",00  
  
  str8 db "this is num 8",00  
  
  str9 db "this is num 9",00 
  
  strA db "this is A char",00
  strA1 db "A is Apple",00   
  
  strB db "this is B char",00
  strB1 db "B is Badr",00
    
  strc db "this is c char",00
  strc1 db "C is Cat",00 
  
  strd db "this is D char",00
  strd1 db "D is dog",00  
  
  stre db "this is E char",00
  stre1 db "E is Elephent",00 
   
  strf db "this is F char",00
  strf1 db "F is Fish",00

 ;--------------------seven Segment var----------
 index0 db 11000000b ;0
 index1 db 11111001b ;1
 index2 db 10100100b ;2
 index3 db 10110000b ;3
 index4 db 10011001b ;4
 index5 db 10010010b ;5
 index6 db 10000010b ;6
 index7 db 11111000b ;7
 index8 db 10000000b ;8
 index9 db 10010000b ;9
       
 		
CODE	ENDS
	END