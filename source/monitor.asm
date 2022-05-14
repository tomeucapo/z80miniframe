;****************************************************************************
; Monitor 
; Simple monitor firmware for Z80
; Tomeu Capó 2019
;****************************************************************************

include "globals.inc"

				extern PAUSE, TO_UPPER, BUFF_GETC

MON_HELP:		LD	 HL, MON_MENU
				CALL MON_PRINT
				RET
				
MON_LOOP::		LD	      HL, MON_PRMPT
				CALL	  MON_PRINT
				CALL	  MON_GETCHAR
				LD		  H,A
				RST		  8	  
				CALL	  MON_OPTIONS
				JP		  MON_LOOP
						
 MON_OPTIONS:	
				CP        'B'
 				CALL	  Z, BASIC_INIT
; 				CP		  'C'
; 				CALL	  Z, BOOT_CPM
; 				CP		  'M'
; 				CALL	  Z, MEMORY_DUMP_COMMAND
; 				CP		  'R'
; 				CALL	  Z, RECEIVE_HEX_COMMAND
; 				CP		  'G'
; 				CALL	  Z, GO_COMMAND
; 				CP		  'T'
; 				CALL	  Z, MON_TEST
; 				CP		  'F'
; 				CALL	  Z, DSK_INIT
 				CP		  '?'
				CALL	  Z, MON_HELP
				RET


;**************************************************************************************
; Decide if start BASIC in Warm or Cold start mode
;**************************************************************************************

BASIC_INIT:    LD        A,(basicStarted); Check the BASIC STARTED flag
               CP        'Y'             ; to see if this is power-up
               JR        NZ,COLDSTART    ; If not BASIC started then always do cold start
               LD        HL, BASICSTARTMSG
               CALL      MON_PRINT
CORW:
               ;CALL      RXA
               ;AND       11011111b       ; lower to uppercase
               
               CALL     MON_GETCHAR
               CP        'C'
               JR        NZ, CHECKWARM
               RST       08H               
               CALL     MON_NEW_LINE
               
COLDSTART:     LD        A,'Y'           ; Set the BASIC STARTED flag
               LD        (basicStarted),A
               JP        BASIC_COLD           ; Start BASIC COLD
CHECKWARM:
               CP        'W'
               JR        NZ, CORW
               RST       08H
               CALL      MON_NEW_LINE

               JP        BASIC_WARM           ; Start BASIC WARM


GO_COMMAND:
			CALL MON_NEW_LINE
			LD  A,'*'
			RST 8

			; Get Address to write
			CALL GET_HEX_WORD
			JP (HL)


RECEIVE_HEX_COMMAND:
			CALL MON_NEW_LINE
			LD  A,'*'
			RST 8

WAIT_BEGIN: CALL	MON_GETCHAR
			CP  	ESCAPE
			RET 	Z
			CP		':'
			JR 		NZ, WAIT_BEGIN

			; Get length of data
			CALL GET_HEX_BYTE
			LD (MON_HEX_LEN), A
	
			LD A, ' '
			RST 8

			; Get Address to write
			CALL GET_HEX_WORD
			LD (MON_HEX_ADDR), HL

			LD A, ' '
			RST 8
			
			; Get record type: 0 = Data, 1 = End of file
			CALL GET_HEX_BYTE
			CP 1
			RET Z

			LD A, ' '
			RST 8
			
			LD A, (MON_HEX_LEN)
			LD B, A
HEX_READ_DATA:	
			PUSH BC
			CALL GET_HEX_BYTE

			LD HL, (MON_HEX_ADDR) 
			LD (HL), A
			INC HL
			LD (MON_HEX_ADDR), HL 
			
			LD A, ' '
			RST 8

			POP BC	
			DJNZ HEX_READ_DATA 
			
			CALL MON_NEW_LINE
			JP RECEIVE_HEX_COMMAND

			RET


MEMORY_DUMP_COMMAND:
			LD 		HL,MDC_1			;Print some messages 
			CALL    MON_PRINT
			CALL    GET_HEX_WORD		;HL now points to databyte location	
			PUSH	HL					;Save HL that holds databyte location on stack
			
			CALL MON_NEW_LINE
			
			POP		HL					;Restore HL that holds databyte location on stack
			LD		C,11				;Register C holds counter of dump lines to print
MEMORY_DUMP_LINE:	
			LD		B,10				;Register B holds counter of dump bytes to print
			CALL	PRINT_HEX_WORD		;Print dump line address in hex form
			LD		A,' '				;Print spacer
			RST		8
			DEC		C					;Decrement C to keep track of number of lines printed
MEMORY_DUMP_BYTES:
			LD		A,(HL)				;Load Acc with databyte HL points to
			CALL	PRINT_HEX_BYTE		;Print databyte in HEX form 
			LD		A,' '				;Print spacer
			RST		8		
			INC 	HL					;Increase HL to next address pointer
			DJNZ	MEMORY_DUMP_BYTES	;Print 16 bytes out since B holds 16
			LD		B,C					;Load B with C to keep track of number of lines printed
			CALL    MON_NEW_LINE		;Get ready for next dump line
			DJNZ	MEMORY_DUMP_LINE	;Print 10 line out since C holds 10 and we load B with C
			LD		A,$FF				;Load $FF into Acc so MON_COMMAND finishes
			RET
;***************************************************************************
;CHAR_ISHEX
;Function: Checks if value in A is a hexadecimal digit, C flag set if true
;***************************************************************************		
CHAR_ISHEX:         
										;Checks if Acc between '0' and 'F'
			CP      'F' + 1       		;(Acc) > 'F'? 
            RET     NC              	;Yes - Return / No - Continue
            CP      '0'             	;(Acc) < '0'?
            JP      NC,CHAR_ISHEX_1 	;Yes - Jump / No - Continue
            CCF                     	;Complement carry (clear it)
            RET
CHAR_ISHEX_1:       
										;Checks if Acc below '9' and above 'A'
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
			CALL	MON_GETCHAR
			CP		ESCAPE
			JP		Z, MON_LOOP

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
			RST 	8	        		;Print the nibble
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

; Test hardware routine

MON_TEST:		LD	 HL, MON_TEST_VID_MSG
				CALL MON_PRINT
				
				LD BC, 700
				CALL PAUSE

				LD B, 3			; Set text mode
				LD E, 0
				RST $20

				LD HL, MON_TST_VID_MODE0
				CALL MON_PRINT
				CALL MON_NEW_LINE

				LD BC, 700
				CALL PAUSE

				LD C, 0
				LD A, $F0
				LD B, 0

MON_TEST_COLOR:	
				OR C
				LD D, B
				LD B, 0
				RST $20
				INC C

				LD B, D

				PUSH BC

				LD BC, 900
				CALL PAUSE
				
				POP BC

				DJNZ MON_TEST_COLOR

				LD B, 0
				LD A, $F5
				RST $20

				RET	
			
MON_NEW_LINE:
		LD		A,CR			
		RST		8
		LD		A,LF
		RST 	8
		RET

MON_PRINT::          
		LD       A,(HL)          ; Get character
		OR       A               ; Is it $00 ?
        RET      Z               ; Then RETurn on terminator
        RST      08H             ; Print it
        INC      HL              ; Next Character
        JR       MON_PRINT       ; Continue until $00
        RET

MON_GETCHAR:
		CALL  BUFF_GETC
		CALL  TO_UPPER          
		RET 

MON_PRMPT:		.BYTE   CR,LF,">",0

MON_MENU:		.BYTE	CR,LF,"Monitor v1.0",CR,LF,CR,LF
				.BYTE	"B - Z80 BASIC",CR,LF
				.BYTE   "C - CP/M BOOT",CR,LF
				.BYTE	"M - Dump memory",CR,LF
				.BYTE   "R - Receive HEX",CR,LF
				.BYTE   "G - Go",CR,LF
				.BYTE   "T - Tests", CR, LF
				.BYTE	"? - This help", CR, LF, 0

BASICSTARTMSG: .BYTE     CR,LF
               .BYTE     "Cold or warm start (C or W)? ",0

MDC_1: 			.BYTE CR,LF,"Memory Dump Command",CR,LF
	   			.BYTE "Location to start in 4 digit HEX:",CR,LF,0

MON_TEST_SND_MSG:	.BYTE CR,LF," * Testing sound",CR,LF,0
MON_TEST_VID_MSG:	.BYTE " * Testing video",CR,LF,0
MON_TEST_KBD_MSG:	.BYTE " * Testing keyboard", CR,LF,0


MON_TST_VID_MODE0:	.BYTE "MODE 0",0
MON_DSK_INIT:		.BYTE "DISK INIT",0

.END
