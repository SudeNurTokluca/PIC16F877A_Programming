LIST 	P=16F877A
  INCLUDE	P16F877.INC
  radix	dec
  __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
	 
DATSEC1	udata
LUT	res	16

counter EQU	    0X70
i	EQU	    0x71		    ; Use memory slot 0x71
j	EQU	    0x72		    ; Use memory slot 0x72	
	
  TEXT	CODE	
; Reset vector
    org 0x0
    BSF	    STATUS, RP0	    ; Select Bank1
    CLRF    TRISD	    ; All PORTD pins: Output
    CLRF    TRISA	    ; PortA --> Output
    MOVLW   0xFF
    MOVWF   TRISB	    ; TRISB3 = 1: Input
    
    BCF	    STATUS, RP0	    ; Select Bank 0
    CLRF    PORTD	    ; Turn off all LEDs
    BSF     PORTA, 5	    ; Deselect all SSDs

    main
    CLRF counter
	loopbegin
	    BTFSC PORTB, 3
	    GOTO if_label
	    GOTO loop2
	    loop2
		BTFSC PORTB, 4
		GOTO loop3
		GOTO else_if_label_1
		loop3
		    BTFSC PORTB, 5
		    GOTO next_sta
		    GOTO else_if_label_2
	if_label
		if_counter_equal_9
		MOVLW d'9'
		SUBWF counter,w
		BTFSS STATUS,Z
		GOTO else_equal_9
		CLRF counter
		GOTO delay_sta

		else_equal_9
		INCF counter,f
		GOTO delay_sta

    else_if_label_1
	    if_counter_equal_0
	    MOVF  counter,w
	    BTFSS STATUS,Z
	    GOTO else_equal_0
	    MOVLW d'9'
	    MOVWF counter
	    GOTO delay_sta
	    
	    else_equal_0
	    DECF counter,f
	    GOTO delay_sta
	
    else_if_label_2
	CLRF counter
	GOTO delay_sta

delay_sta
	CALL Delay100ms	
	
next_sta   
	MOVF counter,W
	CALL GetCode
	MOVWF PORTD 
	GOTO loopbegin
	

	    
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
    
	    
Delay100ms
	MOVLW	    d'250'		    ; 
	MOVWF	    i			    ; i = 100
Delay100ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay100ms_InnerLoop	
	NOP
	DECFSZ	    j, F		    ; j--
	GOTO	    Delay100ms_InnerLoop

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay100ms_OuterLoop    
	RETURN
	
END