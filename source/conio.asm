include "globals.inc"

        extern TO_UPPER, CHAR_ISHEX

CON_PRINT::          
		LD       A,(HL)          ; Get character
		OR       A               ; Is it $00 ?
        RET      Z               ; Then RETurn on terminator
        RST      08H             ; Print it
        INC      HL              ; Next Character
        JR       CON_PRINT       ; Continue until $00
        RET

CON_NL::
		LD		A,CR			
		RST		8
		LD		A,LF
		RST 	8
		RET

CON_CLR::
		LD		A,CS			
		RST		8
		RET

CON_PUTC::
		RST		8
		RET
        
CON_GETCHAR::
		RST   $10
		CALL  TO_UPPER          
		RET 
				
;***************************************************************************
;GET_HEX_BYTE
;   Return HEX byte into A
;***************************************************************************
GETHEXBYTE::
            CALL    GET_HEX_NIB			;Get high nibble
            RET		Z

            RLC     A					;Rotate nibble into high nibble
            RLC     A
            RLC     A
            RLC     A
            LD      B,A					;Save upper four bits
            CALL    GET_HEX_NIB			;Get lower nibble
            RET		Z

            OR      B					;Combine both nibbles
            RET				
			
;***************************************************************************
;GET_HEX_WORD
;Function: Gets two HEX bytes into HL
;***************************************************************************
GETHEXWORD::
			PUSH    AF
            CALL    GETHEXBYTE		;Get high byte
            LD		H,A
            CALL    GETHEXBYTE    	;Get low byte
            LD      L,A
            POP     AF
            RET
						
;***************************************************************************
;PRINT_HEX_BYTE
;Function: Prints a byte in hex notation from Acc to console
;***************************************************************************		
PRHEXBYTE::
			PUSH	AF					;Save registers
            PUSH    BC
            LD		B,A					;Save for low nibble
            RRCA						;Rotate high nibble into low nibble
			RRCA
			RRCA
			RRCA
            CALL    PRINT_HEX_NIB		;Print high nibble
            LD		A,B					;Restore for low nibble
            CALL    PRINT_HEX_NIB		;Print low nibble
            POP     BC					;Restore registers
            POP		AF
			RET
			
;***************************************************************************
;PRINT_HEX_WORD
;Function: Prints the four hex digits of a word to the console from HL
;***************************************************************************
PRHEXWORD::     
			PUSH 	HL
            PUSH	AF
            LD		A,H
			CALL	PRHEXBYTE		;Print high byte
            LD		A,L
            CALL    PRHEXBYTE		;Print low byte
            POP		AF
			POP		HL
            RET		        




;***************************************************************************
;GET_HEX_NIBBLE
;Function: Translates char to HEX nibble in bottom 4 bits of A
;***************************************************************************
GET_HEX_NIB:      
			CALL	CON_GETCHAR
			CP		ESCAPE
            RET     Z			

            CALL    CHAR_ISHEX      	;Is it a hex digit?
            JP      NC,GET_HEX_NIB  	;Yes - Jump / No - Continue
			RST		8
			CP      '9' + 1         	;Is it a digit less or equal '9' + 1?
            JP      C,GET_HEX_NIB_1 	;Yes - Jump / No - Continue
            SUB     $07             	;Adjust for A-F digits
GET_HEX_NIB_1:                
			SUB     '0'             	;Subtract to get nib between 0->15
            AND     $0F             	;Only return lower 4 bits
            RET	            


;***************************************************************************
;PRINT_HEX_NIB
;Function: Prints a low nibble in hex notation from Acc to the serial line.
;***************************************************************************
PRINT_HEX_NIB:
			PUSH 	AF
            AND     $0F             	;Only low nibble in byte
            ADD     A,'0'             	;Adjust for char offset
            CP      '9' + 1         	;Is the hex digit > 9?
            JP      C,PRINT_HEX_NIB_1	;Yes - Jump / No - Continue
            ADD     A,'A' - '0' - $0A 	;Adjust for A-F
PRINT_HEX_NIB_1:
			RST 	8	        		;Print the nibble
			POP		AF
			RET            