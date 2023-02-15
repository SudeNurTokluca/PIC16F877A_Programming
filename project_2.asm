LIST 	P=16F877
	INCLUDE	P16F877.INC
	__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF 
	radix	dec	
	
DATSEC1	udata
x	res	1		; 1 byte value
y	res	1		; 1 byte value
box	res	1		; 1 byte value	

TEXT	CODE	
org 0
main

MOVLW	d'8'		    
MOVWF	x    ; x = WREG
MOVLW	d'2'		    
MOVWF	y    ; y = WREG  
    
CHECK_IF_x_NEG
BTFSS x,7   ; Is x negative;
GOTO CHECK_IF_x_G11

IF_LABEL
    MOVLW d'255'
    MOVWF box
    GOTO NEXT_STATEMENT

CHECK_IF_x_G11 
;x>11     
MOVF x,W
SUBLW d'11'  
BTFSS STATUS,C
GOTO  IF_LABEL     

CHECK_IF_y_NEG    
BTFSC y,7   ; Is y negative;  
GOTO  IF_LABEL 

CHECK_IF_y_G10 
;y>10
MOVF y,W
SUBLW d'10'
BTFSS STATUS,C
GOTO  IF_LABEL
    
ELSE_IF_LABEL_1
;x<=3   3<x
MOVF x,W
SUBLW d'3'
BTFSS STATUS,C	    ;	IF x<=3,then C must be set 
GOTO  ELSE_IF_LABEL_2  
    
IF_LABEL_1
;y<=1
MOVF y,W
SUBLW d'1'
BTFSS STATUS,C	    ;	IF 1<x,then C must not be set
;box=3
GOTO  ELSE_IF_LABEL_1.1   
MOVLW d'3'
MOVWF box
GOTO NEXT_STATEMENT      
       
ELSE_IF_LABEL_1.1
;y<=4
MOVF y,W
SUBLW d'4'
BTFSS STATUS,C	    ;	IF 4<x,then C must not be set
;box=2
GOTO  ELSE_LABEL_1  
MOVLW d'2'
MOVWF box
GOTO NEXT_STATEMENT      
        
ELSE_LABEL_1 
;box=1    
MOVLW d'1'
MOVWF box
GOTO NEXT_STATEMENT           
      
ELSE_IF_LABEL_2    
;x<=7
MOVF x,W
SUBLW d'7'
BTFSS STATUS,C	    ;	IF 7<x,then C must be set
GOTO  ELSE_LABEL
 
IF_LABEL_2
;y<=5
MOVF y,W
SUBLW d'5'
BTFSS STATUS,C	    ;	IF 5<x,then C must not be set
;box=5
GOTO  ELSE_LABEL_2  
MOVLW d'5'
MOVWF box
GOTO NEXT_STATEMENT     
    
ELSE_LABEL_2     
MOVLW d'4'
MOVWF box
GOTO NEXT_STATEMENT       
        
ELSE_LABEL
        
IF_LABEL_3
;y<=2
MOVF y,W
SUBLW d'2'
BTFSS STATUS,C	    ;	IF 2<x,then C must not be set
;box=9
GOTO  ELSE_IF_LABEL_3.1
MOVLW d'9'
MOVWF box
GOTO NEXT_STATEMENT       
    
ELSE_IF_LABEL_3.1
;y<=6
MOVF y,W
SUBLW d'6'
BTFSS STATUS,C	    ;	IF 6<x,then C must not be set
;box=8
GOTO  ELSE_IF_LABEL_3.2
MOVLW d'8'
MOVWF box
GOTO NEXT_STATEMENT 
    
ELSE_IF_LABEL_3.2  
;y<=8
MOVF y,W
SUBLW d'8'
BTFSS STATUS,C	    ;	IF 8<x,then C must not be set
;box=7
GOTO  ELSE_LABEL_3
MOVLW d'7'
MOVWF box
GOTO NEXT_STATEMENT 
    
ELSE_LABEL_3
;box=6   
MOVLW d'6'
MOVWF box    
   
NEXT_STATEMENT   
BSF	STATUS, RP0	    ; Select Bank1
CLRF	TRISD		    ; Make all pins on PORTD as output
	
BCF	STATUS, RP0	    ; Select Bank0
MOVF box,W
MOVWF PORTD

LOOP	GOTO $		; Infinite loop
    END			; End of the program