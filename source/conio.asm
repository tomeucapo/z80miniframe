;;
;; conio.asm
;; Console routines
;;

include "globals.inc"

        extern TO_UPPER, CHAR_ISHEX
        extern VDP_PUTCHAR, UART_WRITE, BUFF_CKINCHAR, BUFF_GETC
        extern PSG_BEEP
        extern PPI_SND_BYTE

;; CON_PRINT - Print string to console (TTY/VDP) until end of string character 0
;;      HL = Address of begin of string

CON_PRINT::          
		LD       A,(HL)          
		OR       A               
        RET      Z               
        RST      08H         
        INC      HL              
        JR       CON_PRINT       
        RET

;; CON_NL - Print line feed and CR

CON_NL::
        PUSH    AF
		LD		A,CR			
		RST		8
		LD		A,LF
		RST 	8
        POP     AF
		RET

;; CON_CLR - Sends character 12 to console (Clear Screen)

CON_CLR::
        PUSH    AF
		LD		A,CS			
		RST		8
        POP     AF
		RET

;; CON_PUTC - Prints a character to console
;;      A = Character to print

CON_PUTC:: 
        ifndef VDP_DISABLE
          DI               
          CALL     VDP_PUTCHAR            
          EI 
        endif
        
        CALL       UART_WRITE                     
		RET

;; CON_CKINCHAR - Check if exists any character into input buffer

CON_CKINCHAR::
        CALL BUFF_CKINCHAR
        RET

;; CON_GETCHAR - Get available character from buffer
;;      Returns readed character to upper into A

CON_GETCHAR::
        CALL BUFF_GETC           
		RET 
				
;; GETHEXBYTE
;;      Return HEX byte into A

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
			
;; GETHEXWORD
;;      Return two HEX bytes into HL

GETHEXWORD::
			PUSH    AF
            CALL    GETHEXBYTE		;Get high byte
            LD		H,A
            CALL    GETHEXBYTE    	;Get low byte
            LD      L,A
            POP     AF
            RET
						
;; PRHEXBYTE - Print two hex digit value to console
;;     A = Value to print

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
			
;; PRHEXWORD - Prints the four hex digits of a word to the console from HL
;;      HL = Value to print

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

;; GET_HEX_NIB - Translates char to HEX nibble in bottom 4 bits of A
;;      Return lower 4 bits into A

GET_HEX_NIB:      
			CALL	CON_GETCHAR
			CP		ESCAPE
            RET     Z			

            CALL    CHAR_ISHEX      	;Is it a hex digit?
            JP      NC,GET_HEX_NIB  	;Yes - Jump / No - Continue
			CALL    CON_PUTC
            
			CP      '9' + 1         	;Is it a digit less or equal '9' + 1?
            JP      C,GET_HEX_NIB_1 	;Yes - Jump / No - Continue
            SUB     $07             	;Adjust for A-F digits
GET_HEX_NIB_1:                
			SUB     '0'             	;Subtract to get nib between 0->15
            AND     $0F             	;Only return lower 4 bits
            RET	            


;; PRINT_HEX_NIB - Prints a low nibble in hex notation from A to console
;;      A = Value to print

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