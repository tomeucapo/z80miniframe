;****************************************************************************
; Monitor 
; Simple monitor firmware for Z80
; Tomeu Capó 2019/22 (C)
;****************************************************************************

include "globals.inc"
include "svcroutine.inc"

				extern PAUSE, TO_UPPER, CHAR_ISHEX, BUFF_GETC
				extern CON_PRINT, CON_NL, CON_GETCHAR, GETHEXBYTE, GETHEXWORD, PRHEXWORD, PRHEXBYTE

MON_MAIN::				
MON_LOOP:		LD	      HL, MON_PRMPT
				CALL	  CON_PRINT
				CALL	  CON_GETCHAR
				LD		  H,A
				RST		  8	  
				CALL	  MON_OPTIONS
				JP		  MON_LOOP
						
 MON_OPTIONS:	
				CP        'B'
 				CALL	  Z, BASIC_INIT
 				CP		  'M'
 				CALL	  Z, MEMORY_DUMP_COMMAND
 				CP		  'R'
 				CALL	  Z, RECEIVE_HEX_COMMAND
 				CP		  'G'
 				CALL	  Z, GO_COMMAND
 				CP		  'T'
 				CALL	  Z, MON_TEST
 				CP		  '?'
				CALL	  Z, MON_HELP
				RET
MON_HELP:		LD	 HL, MON_MENU
				CALL CON_PRINT
				RET

MON_WELCOM::
  			    LD        HL,WELCOMEMSG  ; Print welcome message      
                CALL      CON_PRINT
				RET

;**************************************************************************************
; Decide if start BASIC in Warm or Cold start mode
;**************************************************************************************

BASIC_INIT::   LD        A,(basicStarted); Check the BASIC STARTED flag
               CP        'Y'             ; to see if this is power-up
               JR        NZ,COLDSTART    ; If not BASIC started then always do cold start
               LD        HL, BASICSTARTMSG
               CALL      CON_PRINT
CORW:              
               CALL     CON_GETCHAR
               CP       'C'
               JR       NZ, CHECKWARM
               RST      08H               
               CALL     CON_NL
               
COLDSTART:     LD        A,'Y'           ; Set the BASIC STARTED flag
               LD        (basicStarted),A
               JP        BASIC_COLD           ; Start BASIC COLD
CHECKWARM:
               CP        'W'
               JR        NZ, CORW
               RST       08H
               CALL      CON_NL
               JP        BASIC_WARM           ; Start BASIC WARM

GO_COMMAND:
			CALL CON_NL
			LD  A,'*'
			RST 8

			; Get Address to write
			CALL GETHEXWORD
			JP (HL)


RECEIVE_HEX_COMMAND:
			CALL CON_NL
			LD  A,'*'
			RST 8

WAIT_BEGIN: CALL	CON_GETCHAR
			CP  	ESCAPE
			RET 	Z
			CP		':'
			JR 		NZ, WAIT_BEGIN

			; Get length of data
			CALL GETHEXBYTE
			LD (MON_HEX_LEN), A
	
			LD A, ' '
			RST 8

			; Get Address to write
			CALL GETHEXBYTE
			LD (MON_HEX_ADDR), HL

			LD A, ' '
			RST 8
			
			; Get record type: 0 = Data, 1 = End of file
			CALL GETHEXBYTE
			CP 1
			RET Z

			LD A, ' '
			RST 8
			
			LD A, (MON_HEX_LEN)
			LD B, A
HEX_READ_DATA:	
			PUSH BC
			CALL GETHEXBYTE

			LD HL, (MON_HEX_ADDR) 
			LD (HL), A
			INC HL
			LD (MON_HEX_ADDR), HL 
			
			LD A, ' '
			RST 8

			POP BC	
			DJNZ HEX_READ_DATA 
			
			CALL CON_NL
			JP RECEIVE_HEX_COMMAND

			RET


MEMORY_DUMP_COMMAND:
			LD 		HL,MDC_1			;Print some messages 
			CALL    CON_PRINT
			CALL    GETHEXWORD		;HL now points to databyte location	
			PUSH	HL					;Save HL that holds databyte location on stack
			
			CALL CON_NL
			
			POP		HL					;Restore HL that holds databyte location on stack
			LD		C,11				;Register C holds counter of dump lines to print
MEMORY_DUMP_LINE:	
			LD		B,10				;Register B holds counter of dump bytes to print
			CALL	PRHEXWORD		;Print dump line address in hex form
			LD		A,' '				;Print spacer
			RST		8
			DEC		C					;Decrement C to keep track of number of lines printed
MEMORY_DUMP_BYTES:
			LD		A,(HL)				;Load Acc with databyte HL points to
			CALL	PRHEXBYTE		;Print databyte in HEX form 
			LD		A,' '				;Print spacer
			RST		8		
			INC 	HL					;Increase HL to next address pointer
			DJNZ	MEMORY_DUMP_BYTES	;Print 16 bytes out since B holds 16
			LD		B,C					;Load B with C to keep track of number of lines printed
			CALL    CON_NL				;Get ready for next dump line
			DJNZ	MEMORY_DUMP_LINE	;Print 10 line out since C holds 10 and we load B with C
			LD		A,$FF				;Load $FF into Acc so MON_COMMAND finishes
			RET

			


; Test hardware routine

MON_TEST::		
		LD	 HL, MON_TEST_VID_MSG
		CALL CON_PRINT

		LD BC, 700
		CALL PAUSE

		LD B, VDMODE			; Set text mode
		LD E, 0
		RST $20

		LD HL, MON_TST_VID_MODE0
		CALL CON_PRINT

		LD BC, 700
		CALL PAUSE

		LD C, 0
		LD A, $F0
		LD B, $F

MON_TEST_COLOR:	
		OR C
		LD D, B
		LD B, VDSETCOL
		RST $20
		INC C

		LD B, D

		PUSH BC

		LD BC, 900
		CALL PAUSE
		
		POP BC

		DJNZ MON_TEST_COLOR

		LD B, VDSETCOL
		LD A, $F5
		RST $20

		RET	
			


WELCOMEMSG:    .BYTE     CS
               .BYTE     "Z80MiniFrame 32K",CR,LF
               .BYTE     "Firmware v1.2 by Tomeu Capo",CR,LF,0


MON_PRMPT:		.BYTE   CR,LF,">",0

MON_MENU:		.BYTE	CR,LF,"Monitor v1.2",CR,LF,CR,LF
				.BYTE	"B - Z80 BASIC",CR,LF
				.BYTE	"M - Dump memory",CR,LF
				.BYTE   "R - Receive HEX",CR,LF
				.BYTE   "G - Go",CR,LF
				.BYTE   "T - Tests", CR, LF
				.BYTE	"? - This help", CR, LF, 0

BASICSTARTMSG: .BYTE     CR,LF
               .BYTE     "Cold or warm start (C or W)? ",0

MDC_1: 			.BYTE CR,LF
	   			.BYTE "Address (in hex): ",0

MON_TEST_SND_MSG:	.BYTE CR,LF," * Testing sound",CR,LF,0
MON_TEST_VID_MSG:	.BYTE " * Testing video",CR,LF,0
MON_TEST_KBD_MSG:	.BYTE " * Testing keyboard", CR,LF,0


MON_TST_VID_MODE0:	.BYTE "MODE 0",CR,LF,0

.END
