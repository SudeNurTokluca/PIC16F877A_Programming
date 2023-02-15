LIST 	P=16F877A
	INCLUDE	P16F877.INC
	__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
	radix	dec
	
x	    EQU	    0X20		; 1 byte value
y	    EQU	    0X21		; 1 byte value
N	    EQU	    0X22		; 1 byte value	
p	    EQU     0x23		; 2 byte value	    
i	    EQU	    0x25		; 1 byte value
count	    EQU	    0X26		; 1 byte value
tmp	    EQU	    0x27		; 1 byte value	
noElements  EQU	    0X28		; 1 byte value	
sum	    EQU	    0x29		; 1 byte value	 
z	    EQU	    0x30		; 2 byte value			
Gen_tmp	    EQU	    0X33
Q	    EQU	    0x34	    
k	    EQU	    0x35		  
l	    EQU	    0x36		
A	    EQU	    0X37		
		
Multiply_Para		EQU	0X78	; 2 byte value	  
GenerateNumbers_Para	EQU	0X7A	; 3 byte value	 	
DisplayNumbers_Para	EQU	0X7D	; 1 byte value
AddNumbers_Para		EQU	0X7E	; 1 byte value	
	

; Code section
TEXT	CODE		
; Reset Vector	
	ORG 0
main
	MOVLW d'112'
	MOVWF x
	MOVWF GenerateNumbers_Para
	MOVLW d'100'
	MOVWF y
	MOVWF GenerateNumbers_Para+1
	MOVLW d'125'
	MOVWF N
	MOVWF GenerateNumbers_Para+2
	
	CALL GenerateNumbers	
	MOVWF noElements
	
	MOVF noElements,W
	MOVWF AddNumbers_Para
	CALL AddNumbers
	MOVWF sum
	MOVWF DisplayNumbers_Para
	CALL DisplayNumbers
	GOTO	$
	
Multiply
	CLRF z
	CLRF z+1
	CLRF p+1
	CLRF p
	Mult8x8_Loop:
	    MOVF Multiply_Para+1,W
	    BTFSC STATUS,Z 
	    GOTO Mul_Ret 
	    
	    MOVF Multiply_Para,W
	    BTFSC STATUS,Z 
	    GOTO Mul_Ret 
	    
	    MOVF  Multiply_Para,W
	    ADDWF z,F
	    BTFSC STATUS,C
	    INCF z+1,F
	 
	    Mult8x8_Next:
		DECFSZ Multiply_Para+1,F
		GOTO Mult8x8_Loop
	Mul_Ret:
		MOVF z,W
		MOVWF p
		MOVF z+1,W
		MOVWF p+1
		
                BCF STATUS,C
		RLF p,W
		ADDWF p+1,W
		RETURN
	    
AddNumbers
	    CLRF sum
	    MOVF AddNumbers_Para,W
	    MOVWF i
	    DECF i,F
	    MOVLW A	
	    MOVWF FSR
	    add_loop_begin:
		MOVF i,W
		BTFSC STATUS,Z 
		GOTO add_loop_end
		
		add_loop_start:
		    MOVF INDF ,W
		    ADDWF sum,F
		    INCF FSR,F
		    DECFSZ i,F
		    GOTO add_loop_start
		    
	    add_loop_end:
		MOVF	sum, W		    ; WREG = sum
		RETURN
		
GenerateNumbers	
		CLRF count
		check_x:
		MOVF GenerateNumbers_Para+2,W
		SUBWF GenerateNumbers_Para,W 
		BTFSC STATUS,C
		GOTO check_y
		
		gen_loop:
		    MOVF GenerateNumbers_Para,W
		    ADDWF GenerateNumbers_Para+1,W
		    MOVWF Gen_tmp
		    BTFSS Gen_tmp ,0
		    GOTO gen_else
		    
		    MOVLW A
		    ADDWF count,W
		    MOVWF FSR
		    MOVF GenerateNumbers_Para,W
		    MOVWF Multiply_Para
		    MOVF GenerateNumbers_Para+1,W
		    MOVWF Multiply_Para+1
		    CALL Multiply
		    MOVWF INDF
		    INCF count,F
		    INCF GenerateNumbers_Para,F
		    GOTO gen_loop
		  
		gen_else:
		    MOVLW A
		    ADDWF count,W
		    MOVWF FSR
    
		    MOVF GenerateNumbers_Para,W
		    ADDWF GenerateNumbers_Para+1,W
		    MOVWF tmp
		    		    
		    CLRF    Q			; Q = 0
			Divide_Loop
			    MOVLW   d'3'		; WREG = 3
			    SUBWF   tmp, W		; WREG = X - WREG
			    BTFSS   STATUS, C		; Was the result of the previous subtraction less than 0?	
			    GOTO    Division_End	; If (X < Y) we are done.

			    ; If we are here, it means that X >= Y
			    INCF    Q, F		; Q++
			    MOVWF   tmp			; X = WREG
			    GOTO    Divide_Loop

			Division_End

		    MOVF Q,W 
		    MOVWF INDF
		    INCF count,F
		    MOVLW d'3'
		    ADDWF GenerateNumbers_Para+1,F
		    GOTO check_x
		    
		check_y:
		MOVF GenerateNumbers_Para+2,W
		SUBWF GenerateNumbers_Para+1,W 
		BTFSS STATUS,C
		GOTO gen_loop    
	
		gen_loop_end:
		MOVF	count, W		    ; WREG = count
		RETURN
		
DisplayNumbers
	
	BSF	    STATUS, RP0	; Select Bank 1
	CLRF	    TRISD	; All pins of PORTD output
	MOVLW	    0xFF
	MOVWF	    TRISB
	BCF	    STATUS, RP0	; Select Bank 0
	CLRF	    PORTB	; All LEDs off	
	CLRF	    PORTD 	; All LEDs off

	
	MOVF DisplayNumbers_Para,W
	MOVWF PORTD
	
	wait
	BTFSC PORTB, 3
	GOTO wait
	BCF PORTB,3
	
	CLRF i
	MOVLW A
	MOVWF FSR
	loop_begin
	    MOVLW d'5'
	    SUBWF i,W
	    BTFSC STATUS,C
	    GOTO end_loop
	loop_start
		BTFSC PORTB, 3
		GOTO loop_start
		MOVF INDF,W
		MOVWF PORTD
		
		Delay250ms:
 
			MOVLW	    d'250'		   
			MOVWF	    k			   
		Delay250ms_OuterLoop
			MOVLW	    d'250'
			MOVWF	    l			    
		Delay250ms_InnerLoop	
			NOP
			DECFSZ	    l, F		    
			GOTO	    Delay250ms_InnerLoop

			DECFSZ	    k, F		   
			GOTO	    Delay250ms_OuterLoop    
	INCF i,F
	INCF FSR
	GOTO loop_begin
	end_loop
	RETURN
END