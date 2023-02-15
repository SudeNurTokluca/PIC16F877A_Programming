LIST 	P=16F877
	INCLUDE	P16F877.INC
	__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF 
	radix	dec	
DATSEC1	udata
zib0	res	1		; 1 byte value
zib1	res	1		; 1 byte value
zib	res	1		; 1 byte value	
i	res	1		; 1 byte value
N	res	1		; 1 byte value	

TEXT	CODE	
org 0
	BSF	    STATUS, RP0	; Select Bank 1
	CLRF	    TRISD	; All pins of PORTD output
	BCF	    STATUS, RP0	; Select Bank 0
	CLRF	    PORTB	; All LEDs off	
	CLRF	    PORTD	; All LEDs off	
	
main
	MOVLW d'1'
	MOVWF zib0
	
	MOVLW d'2'
	MOVWF zib1
	
	MOVLW d'2'
	MOVWF i
	
	MOVLW d'13'
	MOVWF N
	
	loop_begin
	
	BTFSC PORTB, 3
	GOTO loop_begin
	
	;if(i>N) goto loop_end
	MOVF i,W
	SUBWF N,W
	BTFSS STATUS,C
	GOTO loop_end
	
	loop_body
	;zib=zib0|0x05
	MOVF zib0,W
	IORLW 0x05
	MOVWF zib
	CLRF zib0
	
	;zib0=zib1
	MOVF zib1,W
	MOVWF zib0

	;zib+=zib1 & 0x3F
	MOVF zib1,W
	ANDLW 0x3F
	ADDWF zib,W
	MOVWF zib
	
	;zib1=zib
	MOVF zib,W
	MOVWF zib1
	
	MOVF zib,W
	MOVWF PORTD
	
	DELAY:
	k	EQU	    0x70		    ; Use memory slot 0x70
	j	EQU	    0x71		    ; Use memory slot 0x71
		MOVLW	    d'250'		    ; 
		MOVWF	    k			    ; k = 250
	Delay250ms_OuterLoop
		MOVLW	    d'250'
		MOVWF	    j			    ; j = 250
	Delay250ms_InnerLoop	
		NOP
		DECFSZ	    j, F		    ; j--
		GOTO	    Delay250ms_InnerLoop

		DECFSZ	    k, F		    ; k?
		GOTO	    Delay250ms_OuterLoop		
		
	;i++
	INCF i
	GOTO loop_begin
	
	loop_end
	MOVF zib,W
	MOVWF PORTD
		
LOOP	GOTO $		; Infinite loop
    END			; End of the program