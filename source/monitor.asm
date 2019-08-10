;****************************************************************************
; Monitor 
; Simple monitor firmware for Z80
; Tomeu Capó 2019
;****************************************************************************

MON_PRMPT:		.BYTE   CR,LF,">",0

MON_MENU:		.BYTE	"Monitor 1.0",CR,LF,CR,LF
				.BYTE	"B - Z80 BASIC",CR,LF
				.BYTE	"M - Dump memory",CR,LF
				.BYTE	"R - Reset memory",CR,LF,0

MDC_1: 			.BYTE CR,LF,"Memory Dump Command",CR,LF
				.BYTE "Start location?",CR,LF,0

MON_HELP:		LD	 HL, MON_MENU
				CALL PRINT
				RET
				
MON_LOOP:		LD	      HL, MON_PRMPT
				CALL	  PRINT
				CALL	  GET_CHAR
				LD		  H,A
				CALL	  PRINT_CHAR
				CALL	  MON_OPTIONS
				JP		  MON_LOOP
						
MON_OPTIONS:	CP        'B'
				CALL	  Z, BASIC_INIT
				CP		  'M'
				CALL	  Z, MON_DUMP_CMD
				RET
				
MON_DUMP_CMD:	LD 		HL,MDC_1			;Print some messages 
				CALL    PRINT   
				CALL    GET_HEX_WORD		;HL now points to databyte location	
				PUSH	HL					;Save HL that holds databyte location on stack
				POP		HL					;Restore HL that holds databyte location on stack
				LD		C,10				;Register C holds counter of dump lines to print
MEMORY_DUMP_LINE:	
				LD		B,16				;Register B holds counter of dump bytes to print
				CALL	PRINT_HEX_WORD		;Print dump line address in hex form
				LD		A,' '				;Print spacer
				CALL	PRINT_CHAR
				DEC		C					;Decrement C to keep track of number of lines printed
MEMORY_DUMP_BYTES:
				LD		A,(HL)				;Load Acc with databyte HL points to
				CALL	PRINT_HEX_BYTE		;Print databyte in HEX form 
				LD		A,' '				;Print spacer
				CALL	PRINT_CHAR	
				INC 	HL					;Increase HL to next address pointer
				DJNZ	MEMORY_DUMP_BYTES	;Print 16 bytes out since B holds 16
				LD		B,C					;Load B with C to keep track of number of lines printed
				CALL    PRINT_NEW_LINE		;Get ready for next dump line
				DJNZ	MEMORY_DUMP_LINE	;Print 10 line out since C holds 10 and we load B with C
				LD		A,$FF				;Load $FF into Acc so MON_COMMAND finishes
				RET


CHAR_ISHEX:	CP      'F' + 1       		;(Acc) > 'F'? 
            RET     NC              	;Yes - Return / No - Continue
            CP      '0'             	;(Acc) < '0'?
            JP      NC,CHAR_ISHEX_1 	;Yes - Jump / No - Continue
            CCF                     	;Complement carry (clear it)
            RET
CHAR_ISHEX_1:       
			CP      '9' + 1         	;(Acc) < '9' + 1?
            RET     C               	;Yes - Return / No - Continue (meaning Acc between '0' and '9')
            CP      'A'             	;(Acc) > 'A'?
            JP      NC,CHAR_ISHEX_2 	;Yes - Jump / No - Continue
            CCF                     	;Complement carry (clear it)
            RET
CHAR_ISHEX_2:        
										;Only gets here if Acc between 'A' and 'F'
			SCF                     	;Set carry flag to indicate the char is a hex digit
            RET
			
;***************************************************************************
;GET_HEX_NIBBLE
;Function: Translates char to HEX nibble in bottom 4 bits of A
;***************************************************************************
GET_HEX_NIB:      
			CALL	GET_CHAR
            CALL    CHAR_ISHEX      	;Is it a hex digit?
            JP      NC,GET_HEX_NIB  	;Yes - Jump / No - Continue
			CALL    PRINT_CHAR
			CP      '9' + 1         	;Is it a digit less or equal '9' + 1?
            JP      C,GET_HEX_NIB_1 	;Yes - Jump / No - Continue
            SUB     $07             	;Adjust for A-F digits
GET_HEX_NIB_1:                
			SUB     '0'             	;Subtract to get nib between 0->15
            AND     $0F             	;Only return lower 4 bits
            RET	
				
;***************************************************************************
;GET_HEX_BTYE
;Function: Gets HEX byte into A
;***************************************************************************
GET_HEX_BYTE:
            CALL    GET_HEX_NIB			;Get high nibble
            RLC     A					;Rotate nibble into high nibble
            RLC     A
            RLC     A
            RLC     A
            LD      B,A					;Save upper four bits
            CALL    GET_HEX_NIB			;Get lower nibble
            OR      B					;Combine both nibbles
            RET				
			
;***************************************************************************
;GET_HEX_WORD
;Function: Gets two HEX bytes into HL
;***************************************************************************
GET_HEX_WORD:
			PUSH    AF
            CALL    GET_HEX_BYTE		;Get high byte
            LD		H,A
            CALL    GET_HEX_BYTE    	;Get low byte
            LD      L,A
            POP     AF
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
			CALL	PRINT_CHAR        		;Print the nibble
			POP		AF
			RET
				
;***************************************************************************
;PRINT_HEX_BYTE
;Function: Prints a byte in hex notation from Acc to the serial line.
;***************************************************************************		
PRINT_HEX_BYTE:
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
;Function: Prints the four hex digits of a word to the serial line from HL
;***************************************************************************
PRINT_HEX_WORD:     
			PUSH 	HL
            PUSH	AF
            LD		A,H
			CALL	PRINT_HEX_BYTE		;Print high byte
            LD		A,L
            CALL    PRINT_HEX_BYTE		;Print low byte
            POP		AF
			POP		HL
            RET			
			
.END
