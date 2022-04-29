
.include "globals.h.s"
.include "common.h.s"

.area _DATA
.area _CODE

MON_INIT::
                LD	      HL, #MON_WELCOME
				CALL	  MON_PRINT
                
MON_LOOP::
        		LD	      HL, #MON_PRMPT
				CALL	  MON_PRINT
				CALL	  MON_GET_CHAR
				LD		  H,A
				RST		  8	  
				CALL	  MON_OPTIONS
				JP		  MON_LOOP

MON_OPTIONS:	CP        #'B'
				CALL	  Z, BASIC_INIT
				CP		  #'M'
				CALL	  Z, MEMORY_DUMP_COMMAND
				CP		  #'R'
				CALL	  Z, RECEIVE_HEX_COMMAND
				CP		  #'G'
				CALL	  Z, MON_GO_COMMAND
				CP		  #'?'
				CALL	  Z, MON_HELP
				RET

MON_GO_COMMAND:
                CALL MON_NEW_LINE
                LD  A,#'*'
                RST 8
                ; Get Address to write
			    CALL GET_HEX_WORD
			    JP (HL)

RECEIVE_HEX_COMMAND:
			CALL MON_NEW_LINE
			LD  A,#'*'
			RST 8

WAIT_BEGIN: CALL	MON_GET_CHAR
			CP  	#ESCAPE
			RET 	Z
			CP		#':'
			JR 		NZ, WAIT_BEGIN

			; Get length of data
			CALL GET_HEX_BYTE
			LD (MON_HEX_LEN), A
	
			LD A, #' '
			RST 8

			; Get Address to write
			CALL GET_HEX_WORD
			LD (MON_HEX_ADDR), HL

			LD A, #' '
			RST 8
			
			; Get record type: 0 = Data, 1 = End of file
			CALL GET_HEX_BYTE
			CP #1
			RET Z

			LD A, #' '
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
			
			LD A, #' '
			RST 8

			POP BC	
			DJNZ HEX_READ_DATA 
			
			CALL MON_NEW_LINE
			JP RECEIVE_HEX_COMMAND

			RET


MEMORY_DUMP_COMMAND:
			LD 		HL, #MON_MDUMP_PRMPT			;Print some messages 
			CALL    MON_PRINT
			CALL    GET_HEX_WORD		;HL now points to databyte location	
			PUSH	HL					;Save HL that holds databyte location on stack
			
			CALL    MON_NEW_LINE
			
			POP		HL					;Restore HL that holds databyte location on stack
			LD		C,#11				;Register C holds counter of dump lines to print
MEMORY_DUMP_LINE:	
			LD		B, #10				;Register B holds counter of dump bytes to print
			CALL	PRINT_HEX_WORD		;Print dump line address in hex form
			LD		A,#' '				;Print spacer
			RST		8
			DEC		C					;Decrement C to keep track of number of lines printed
MEMORY_DUMP_BYTES:
			LD		A,(HL)				;Load Acc with databyte HL points to
			CALL	PRINT_HEX_BYTE		;Print databyte in HEX form 
			LD		A,#' '				;Print spacer
			RST		8		
			INC 	HL					;Increase HL to next address pointer
			DJNZ	MEMORY_DUMP_BYTES	;Print 16 bytes out since B holds 16
			LD		B,C					;Load B with C to keep track of number of lines printed
			CALL    MON_NEW_LINE		;Get ready for next dump line
			DJNZ	MEMORY_DUMP_LINE	;Print 10 line out since C holds 10 and we load B with C
			LD		A,#0xFF				;Load $FF into Acc so MON_COMMAND finishes
			RET


BASIC_INIT:    LD        A,(MON_BASIC_STARTED) ; Check the BASIC STARTED flag
               CP        #'Y'             ; to see if this is power-up
               JR        NZ, COLDSTART    ; If not BASIC started then always do cold start
               LD        HL, #MON_BASIC_START_MSG
               CALL      MON_PRINT
CORW:
               CALL     MON_GET_CHAR
               CP       #'C'
               JR       NZ, CHECKWARM
               RST      8               
               CALL     MON_NEW_LINE
               
COLDSTART:     LD        A,#'Y'           ; Set the BASIC STARTED flag
               LD        (MON_BASIC_STARTED),A
               JP        ROM_BASIC_COLD_ADDR           ; Start BASIC COLD
CHECKWARM:
               CP        #'W'
               JR        NZ, CORW
               RST       8
               CALL      MON_NEW_LINE
               JP        ROM_BASIC_WARM_ADDR           ; Start BASIC WARM

MON_HELP:		LD	 HL, #MON_MENU
				CALL MON_PRINT
				RET

MON_PRINT:      LD       A,(HL)          ; Get character
                OR       A               ; Is it $00 ?
                RET      Z               ; Then RETurn on terminator
                RST      8               ; Print it 
                INC      HL              ; Next Character
                JR       MON_PRINT       ; Continue until $00
                RET

MON_GET_CHAR:
                RST     0x10
                RET

;;
;; GET_HEX_WORD
;;  Function: Gets two HEX bytes into HL
;;
GET_HEX_WORD:
			PUSH    AF
            CALL    GET_HEX_BYTE		;Get high byte
            LD		H,A
            CALL    GET_HEX_BYTE    	;Get low byte
            LD      L,A
            POP     AF
            RET

;;
;; GET_HEX_BTYE
;;  Function: Gets HEX byte into A
;;
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

;;
;; GET_HEX_NIBBLE
;;  Function: Translates char to HEX nibble in bottom 4 bits of A
;;
GET_HEX_NIB:      
			CALL	MON_GET_CHAR
			CP		#ESCAPE
			JP		Z, MON_LOOP

            CALL    CHAR_ISHEX      	;Is it a hex digit?
            JP      NC,GET_HEX_NIB  	;Yes - Jump / No - Continue
			RST		8
			CP      #'9' + 1         	;Is it a digit less or equal '9' + 1?
            JP      C,GET_HEX_NIB_1 	;Yes - Jump / No - Continue
            SUB     #7               	;Adjust for A-F digits
GET_HEX_NIB_1:                
			SUB     #'0'             	;Subtract to get nib between 0->15
            AND     #0x0F             	;Only return lower 4 bits
            RET	


;;
;; PRINT_HEX_NIB
;;  Function: Prints a low nibble in hex notation from Acc to the serial line.
;;
PRINT_HEX_NIB:
			PUSH 	AF
            AND     #0x0F             	;Only low nibble in byte
            ADD     A,#'0'             	;Adjust for char offset
            CP      #'9' + 1         	;Is the hex digit > 9?
            JP      C,PRINT_HEX_NIB_1	;Yes - Jump / No - Continue
            ADD     A,#'A' - #'0' - #0x0A 	;Adjust for A-F
PRINT_HEX_NIB_1:
			RST 	8	        		;Print the nibble
			POP		AF
			RET
				
;;
;; PRINT_HEX_BYTE
;;  Function: Prints a byte in hex notation from Acc to the serial line.
;;
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
			
;;
;; PRINT_HEX_WORD
;;  Function: Prints the four hex digits of a word to the serial line from HL
;;
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

MON_NEW_LINE:
                LD		A,#CR			
                RST		8
		        LD		A,#LF
		        RST 	8
		        RET

MON_PRMPT:		.BYTE   CR,LF,">",0

MON_MDUMP_PRMPT:
     			.db CR, LF
	   			.ascii "Address location: "
                .db 0
MON_MENU:		.db	CR,LF
                .ascii "Monitor v1.1"
                .db CR, LF, CR, LF
				.ascii	"B - Z80 BASIC"
                .db CR,LF
				.ascii	"M - Dump memory"
                .db CR,LF
				.ascii  "R - Receive HEX"
                .db CR,LF
				.ascii  "G - Go"
                .db CR,LF
				.ascii	"? - This help"
                .db CR,LF, 0

MON_BASIC_START_MSG:
                .db CR, LF
                .ascii "Cold or warm start (C or W)? "
                .db 0

MON_WELCOME:
    .db 12
    .ascii     "Z80 Miniframe v2.0"
    .db 0x0a, 0x0d, 0
