   LIST 	P=16F877A
    INCLUDE	P16F877.INC
    radix	dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

    DATSEC1	udata
    LUT	res	16	
; Static global variable
NO_ITERATIONS	  EQU	  0x20  
fi		  EQU	  0X21  	  
digit0		  EQU	  0X70
digit1		  EQU	  0X71 
  		  	    
; Reset vector
    org	    0x00
    BSF	    STATUS, RP0		; Select Bank1
    CLRF    TRISA		; PortA --> Output
    CLRF    TRISD		; PortD --> Output
    BCF	    STATUS, RP0		; Select Bank0
    CLRF    PORTD		; PORTD = 0
    CLRF    PORTA		; Deselect all SSDs

main
    MOVLW d'90'
    MOVWF NO_ITERATIONS
    CLRF digit0
    CLRF digit1
    CLRF fi
    LOOP    
	for_loop
	    MOVF NO_ITERATIONS,W
	    SUBWF fi,W
	    BTFSC STATUS,C
	    GOTO end_loop
	
	    BSF	    PORTA, 5		
	    BCF    PORTA, 4
	    MOVF    digit0,W
	    CALL    GetCode
	    MOVWF   PORTD
	    CALL Delay5ms
	    
	    BCF   PORTA, 5		
	    BSF    PORTA, 4
	    MOVF    digit1,W
	    CALL    GetCode		 
	    MOVWF   PORTD 
	    CALL Delay5ms
	    INCF fi,F
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
    next_sta
            CLRF fi
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
	    
Delay5ms
	i	EQU	    0x72		
	j	EQU	    0x73		  
	MOVLW	    d'5'		    ; 
	MOVWF	    i			    ; i = 5
Delay5ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay5ms_InnerLoop	
	NOP
	DECFSZ	    j, F		    ; --j == 0?
	GOTO	    Delay5ms_InnerLoop

	DECFSZ	    i, F		    ; --i == 0?
	GOTO	    Delay5ms_OuterLoop
	RETURN  	
END