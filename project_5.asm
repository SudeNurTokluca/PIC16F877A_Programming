LIST 	P=16F877A
	INCLUDE	P16F877.INC
	__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
	radix	dec
	
; Code section
TEXT	CODE		
; Reset Vector	
	ORG 0
	BANKSEL TRISD
	CLRF TRISD
	BANKSEL TRISB
	CLRF TRISB
	
	BANKSEL PORTB
	MOVLW 0X00
	MOVWF PORTB
	
	MOVE_LEFT      EQU	0X20
	MOVE_RIGHT     EQU      0X21
	dir		EQU	0X22	
	val		EQU	0X23
	count		EQU	0x24
		
main 	
	CLRF MOVE_LEFT
	MOVLW d'1'
	MOVWF MOVE_RIGHT
	MOVF MOVE_LEFT,W
	MOVWF dir
	MOVLW 0x1
	MOVWF val
	MOVLW 0x0
	MOVWF count

	    
	LOOP
	
	    MOVF val,W
	    MOVWF PORTD
	    CALL Delay  
	    INCF count,F
   
	    equal_15 	    ;if(count==15)
		MOVLW d'15'
		SUBWF count,W
		BTFSS STATUS,Z
		GOTO _else
	    
		CLRF PORTD
		CALL Delay
		
		MOVLW 0xFF
		MOVWF PORTD
		CALL Delay
		
		CLRF PORTD
		CALL Delay
		
		MOVLW 0xFF
		MOVWF PORTD
		CALL Delay
		
		CLRF PORTD
		CALL Delay
		
		MOVLW 0X1
		MOVWF val
		CLRF count
		MOVF MOVE_LEFT,W
		MOVWF dir
		GOTO next_sta
	    _else	
		if_equal_val ;if(val==0x80)
		    MOVLW 0X80
		    SUBWF val,W
		    BTFSS STATUS , Z
		    GOTO if_equal_dir
		    MOVF MOVE_RIGHT,W
		    MOVWF dir
		  
		if_equal_dir  ;if(dir==MOVE_LEFT)    
		    MOVF MOVE_LEFT,W
		    SUBWF dir,W
		    BTFSS STATUS,Z
		    GOTO else_equal_dir
		    BCF	  STATUS, C
		    RLF val,F
		    GOTO next_sta
		else_equal_dir
		    BCF	  STATUS, C
		    RRF val,F
    next_sta
	GOTO LOOP

Delay
#if 0
    ;250 ms
	i	EQU	    0x70		    ; Use memory slot 0x70
	j	EQU	    0x71		    ; Use memory slot 0x71
	MOVLW	    d'250'		    ; 
	MOVWF	    i			    ; i = 250
    Delay250ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
    Delay250ms_InnerLoop	
	NOP
	DECFSZ	    j, F		    ; j--
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay250ms_OuterLoop    
	RETURN
#else		
    ;500 ms
    i	EQU	    0x70
    j	EQU	    0x71
    k	EQU	    0x72
	    MOVLW	    d'2'
	    MOVWF	    i			    ; i = 2
    Delay500ms_Loop1_Begin
	    MOVLW	    d'250'
	    MOVWF	    j			    ; j = 250
    Delay500ms_Loop2_Begin	
	    MOVLW	    d'250'
	    MOVWF	    k			    ; k = 250
    Delay500ms_Loop3_Begin	
	    NOP				    ; Do nothing
	    DECFSZ	    k, F		    ; k--
	    GOTO	    Delay500ms_Loop3_Begin

	    DECFSZ	    j, F		    ; j--
	    GOTO	    Delay500ms_Loop2_Begin

	    DECFSZ	    i, F		    ; i?
	    GOTO	    Delay500ms_Loop1_Begin    
	    RETURN
#endif

    GOTO	$
END


