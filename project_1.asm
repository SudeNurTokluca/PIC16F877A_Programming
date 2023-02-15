	LIST 	P=16F877A
	INCLUDE	P16F877.INC
	radix	dec
	__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
  

    org 0x00
    
    BSF    STATUS, RP0
    CLRF   TRISB
    CLRF   TRISD
    BCF    STATUS, RP0
    CLRF   PORTB
    CLRF   PORTD
    
main
    
tmp	EQU	0x20	; A temporary variable
x	EQU	0x21
y	EQU	0x22
z	EQU	0x23
r1	EQU	0x24
r2	EQU	0x25
r3	EQU	0x26
r4	EQU	0x27
r	EQU	0x28
tmpz	EQU	0x29

   
;r1
    MOVLW   d'5'	; WREG = 5
    MOVWF   x		; x = WREG
    MOVLW   d'6'	; WREG = 6
    MOVWF   y		; y = WREG
    MOVLW   d'7'	; WREG = 7
    MOVWF   z		; y = WREG
    
    MOVF  x,W		; WREG = x
    ADDWF x,W		;	2x
    ADDWF x,W		;	3x
    ADDWF x,W	    	;	4x
    ADDWF x,W		;	5x
    
    MOVWF   tmp		; tmp = WREG   
    
    MOVF    y, W	; WREG = y
    ADDWF   y, W	; WREG = WREG + y = y + y = 2*y
    SUBWF   tmp, W	; WREG = tmp - WREG ==> WREG = 5x-2y
    
    MOVWF   tmp		; tmp = WREG
    
    MOVF    z,W		; WREG = z
    ADDWF   tmp, W	; WREG = tmp + WREG ==> WREG = 5x-2y+z
    
    MOVWF   tmp		; tmp = WREG
    
    MOVLW   d'3'        ; WREG = 5
    SUBWF   tmp,W       ; WREG = tmp - WREG ==> WREG = 5x-2y+z-3
    
    MOVWF   r1		; r1 = WREG   
    
    MOVF  r1,W		; WREG = r1
    ADDWF r1,W		;	2r1
    ADDWF r1,W		;	3r1
    
    MOVWF  r		; r = WREG   
    
    
;r2
    
    
    CLRW	        ; WREG = 0
    
    MOVLW   d'5'        ; WREG = 5
    ADDWF   x, W	; WREG = 5 + x
    MOVWF   tmp		; tmp = WREG  
    ADDWF   tmp, W	; WREG = tmp + WREG ==> WREG = 2*(5+x)
    ADDWF   tmp, W	; WREG = tmp + WREG ==> WREG = 3*(5+x)
    ADDWF   tmp, W	; WREG = tmp + WREG ==> WREG = 4*(5+x)
  
        
    MOVWF   tmp		; tmp = WREG
    
    MOVF  y,W		; WREG = y
    ADDWF y,W		;	2y
    ADDWF y,W		;	3y
    SUBWF   tmp,W       ; WREG = tmp - WREG ==> WREG = 4*(5+x)-3*y
    
    MOVWF   tmp		; tmp = WREG
    
    MOVF    z,W		; WREG = z
    ADDWF   tmp, W	; WREG = tmp + WREG ==> WREG = 4*(5+x)-3*y+z
    
    MOVWF   r2		; r2 = WREG 
    
    MOVF  r2,W		; WREG = r1
    ADDWF r2,W		;	2r1
    ADDWF r, W	; WREG = tmp + WREG 
    MOVWF r		; r = WREG   
    
;r3
     
    CLRW	        ; WREG = 0
    MOVF  x,W		; WREG = x
    BCF	  STATUS, C	; Clear the Carry bit of the STATUS register
    RRF x,W		; x = x/2
    
    MOVWF   tmp		; tmp = WREG
    
    MOVF  y,W	        ; WREG = y
    BCF	  STATUS, C	; Clear the Carry bit of the STATUS register
    RRF y,W		; WREG = y/2
    ADDWF   tmp, W	; WREG = tmp + WREG ==> WREG = x/2+y/2
    
    MOVWF   tmp		; tmp = WREG
    
    
    MOVF  z,W		; WREG = z
    MOVWF   tmpz	; tmpz = WREG
    
    BCF	  STATUS, C	; Clear the Carry bit of the STATUS register
    RRF   tmpz,F		; WREG = z/2
    BCF	  STATUS, C	; Clear the Carry bit of the STATUS register
    RRF   tmpz,F		; WREG = z/4
    MOVF  tmpz,W		; WREG = tmpz
    ADDWF   tmp, W	; WREG = tmp + WREG ==> WREG = x/2+y/2+z/4
    
    MOVWF   r3		; r3 = WREG 
    
    MOVF  r3,W		; WREG = r3
    BCF	  STATUS, C	; Clear the Carry bit of the STATUS register
    RRF r3,W		; WREG = r3/2
    SUBWF r, W		; WREG = r - WREG 
    MOVWF r		; r = WREG   

    
;r4
    
    MOVF  x,W		; WREG = x
    ADDWF x,W		;	2x
    ADDWF x,W		;	3x
    
    MOVWF   tmp		; tmp = WREG
    
    MOVF    y, W	; WREG = y
    SUBWF   tmp, W	; WREG = tmp - WREG ==> WREG = 3x-y
    
    MOVWF   tmp		; tmp = WREG
    
    MOVF  z,W		; WREG = z
    ADDWF z,W		;	2z
    ADDWF z,W		;	3z
    SUBWF   tmp, W	; WREG = tmp - WREG ==> WREG = 3x-y-3z
    
    MOVWF   tmp		; tmp = WREG
    
    MOVF  tmp,W		; WREG = tmp
    ADDWF tmp,W		;	2tmp
    
    MOVWF   tmp		; tmp = WREG
    
    MOVLW   d'30'        ; WREG = 30
    SUBWF   tmp,W       ; WREG = tmp - WREG ==> WREG = 2*(3x-y-3z)-30
    
    MOVWF   r4		; r4 = WREG 
    
    MOVF  r4,W		; WREG = r4
    SUBWF r, W		; WREG = r - WREG 
    MOVWF r		; r = WREG   

    MOVWF PORTD
    
LOOP	GOTO $		; Infinite loop


    END			; End of the program
   
 