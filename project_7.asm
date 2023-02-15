  LIST 	P=16F877A
  INCLUDE	P16F877.INC
  radix	dec
  __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

DATSEC1	udata
LUT	res	16	

NO_ITERATIONS	  EQU	  0x20	
i		  EQU	  0X21    
digit0		  EQU	  0X70
digit1		  EQU	  0X71 
message		  EQU	  0X72		  
fi	EQU	    0x73		
j	EQU	    0x74			  
  		  	    
; Reset vector
    org	    0x00
    BSF	    STATUS, RP0		; Select Bank1
    CLRF    TRISA		; PortA --> Output
    CLRF    TRISD		; PortD --> Output
    MOVWF   TRISD		; Make all pins of PORTD output
    CLRF    TRISE		; Make all ports of PORTE output
    BCF	    STATUS, RP0		; Select Bank0
    CLRF    PORTD		; PORTD = 0
    CLRF    PORTA		; Deselect all SSDs
    	
    MOVLW	0x03		; Choose RA0 analog input and RA3 reference input
    MOVWF	ADCON1		; Register to configure PORTA's pins as analog/digital <11> means, all but one are analog
    
    GOTO main
    #include <Delay.inc>	; Delay library (Copy the contents here)
    #include <LcdLib.inc>	; LcdLib.inc (LCD) utility routines

    main
    CALL	LCD_Initialize	; Initialize the LCD	
    MOVLW d'90'
    MOVWF NO_ITERATIONS
    CLRF digit0
    CLRF digit1
    CLRF i
    CLRF message
    LOOP    
	call	DisplayCounter	; Display the counter values
	for_loop
	    MOVF NO_ITERATIONS,W
	    SUBWF i,W
	    BTFSC STATUS,C
	    GOTO end_loop
	
	    BSF	    PORTA, 5		
	    BCF    PORTA, 4
	    MOVF    digit0,W
	    CALL    GetCode
	    MOVWF   PORTD
	    CALL Delay_5ms
	    
	    BCF   PORTA, 5		
	    BSF    PORTA, 4
	    MOVF    digit1,W
	    CALL    GetCode		 
	    MOVWF   PORTD 
	    CALL Delay_5ms
	    INCF i,F
	    GOTO for_loop
end_loop
 	    INCF digit0,F
	    if_digit_equ_10
		MOVLW d'10'
		SUBWF digit0,W
		BTFSS STATUS,Z
		GOTO if_digit0_and_digit1
		 
		CLRF digit0
		INCF digit1,F
	    
	    if_digit0_and_digit1
	        CLRF message
		MOVLW d'2'
		SUBWF digit1,W
		BTFSS STATUS ,Z 
		GOTO next_sta
		
		MOVLW d'1'
		SUBWF digit0,W
		BTFSS STATUS,Z
		GOTO next_sta
		
		CLRF digit0
		CLRF digit1	
		MOVLW d'1'
		MOVWF message
    next_sta
            CLRF i
	    GOTO LOOP
 
GetCode
    ADDWF   PCL, F		; Jump to the correct number. PCL is the program counter register
    RETLW   B'00111111'		; 0
    RETLW   B'00000110'		; 1
    RETLW   B'01011011'		; 2
    RETLW   B'01001111'		; 3
    RETLW   B'01100110'		; 4
    RETLW   B'01101101'		; 5
    RETLW   B'01111101'		; 6
    RETLW   B'00000111'		; 7
    RETLW   B'01111111'		; 8
    RETLW   B'01101111'		; 9 
	    
DisplayCounter
	call	LCD_Clear		; Clear the LCD screen
	movlw	'C'	
	call	LCD_Send_Char
	movlw	'o'	
	call	LCD_Send_Char
	movlw	'u'	
	call	LCD_Send_Char
	movlw	'n'	
	call	LCD_Send_Char
	movlw	't'	
	call	LCD_Send_Char
	movlw	'e'	
	call	LCD_Send_Char
	movlw	'r'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char
	movlw	'V'	
	call	LCD_Send_Char
	movlw	'a'	
	call	LCD_Send_Char
	movlw	'l'	
	call	LCD_Send_Char
	movlw	':'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char
DisplayDigit1
	MOVF	digit1, W ; WREG <- digit
	ADDLW	'0'	    ; Add '0' to the digit 
	CALL	LCD_Send_Char
DisplayDigit2
	MOVF	digit0, W   ; WREG <- digit
	ADDLW	'0'	    ; Add '0' to the digit 
	CALL	LCD_Send_Char
Move2SecondLine		
	call	LCD_MoveCursor2SecondLine   ; Move the cursor to the start of the second line

MOVF message,W	
BTFSS STATUS,Z
GOTO message_rolled
	
message_counting	
	movlw	'C'	    
	call	LCD_Send_Char
	movlw	'o'	    
	call	LCD_Send_Char
	movlw	'u'	
	call	LCD_Send_Char
	movlw	'n'	
	call	LCD_Send_Char
	movlw	't'	
	call	LCD_Send_Char
	movlw	'i'	
	call	LCD_Send_Char
	movlw	'n'	
	call	LCD_Send_Char
	movlw	'g'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char
	movlw	'u'	
	call	LCD_Send_Char
	movlw	'p'	
	call	LCD_Send_Char
	movlw	'.'	
	call	LCD_Send_Char
	movlw	'.'	
	call	LCD_Send_Char
	movlw	'.'	
	call	LCD_Send_Char
	RETURN
	
message_rolled	
	movlw	'R'	    
	call	LCD_Send_Char
	movlw	'o'	    
	call	LCD_Send_Char
	movlw	'o'	
	call	LCD_Send_Char
	movlw	'l'	
	call	LCD_Send_Char
	movlw	'e'	
	call	LCD_Send_Char
	movlw	'd'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char
	movlw	'o'	
	call	LCD_Send_Char
	movlw	'v'	
	call	LCD_Send_Char
	movlw	'e'	
	call	LCD_Send_Char
	movlw	'r'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char
	movlw	't'	
	call	LCD_Send_Char
	movlw	'o'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char
	movlw	'0'	
	RETURN
END