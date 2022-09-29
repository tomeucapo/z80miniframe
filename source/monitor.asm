;****************************************************************************
; Monitor 
; Simple monitor firmware for Z80
; Tomeu Capó 2019/22 (C)
;****************************************************************************

include "globals.inc"
include "svcroutine.inc"

				extern PAUSE, TO_UPPER, CHAR_ISHEX
				extern CON_PRINT, CON_NL, CON_GETCHAR, GETHEXBYTE, GETHEXWORD, PRHEXWORD, PRHEXBYTE
				extern BASCOLD, BASWARM
				extern CON_PUTC, KB_READKEY, PRHEXBYTE
				extern CASWRLEADER

MON_MAIN::				
MON_LOOP:		EI
				LD	      HL, MON_PRMPT
				CALL	  CON_PRINT
				CALL	  CON_GETCHAR
				CALL	  TO_UPPER
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
				CP		  CR
				RET		  Z
				CP		  BKSP
				RET		  Z
				CP		  0
				RET		  Z
				CP		  ESCAPE
				RET	      Z

				CALL	  NZ, MON_UNK_CMD
				RET

MON_UNK_CMD:
				CALL	CON_NL
				CALL	CON_PUTC
				LD		A,'?'
				CALL	CON_PUTC
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
			   CALL		TO_UPPER
               CP       'C'
               JR       NZ, CHECKWARM
               RST      08H               
               CALL     CON_NL
               
COLDSTART:     LD        A,'Y'           ; Set the BASIC STARTED flag
               LD        (basicStarted),A
               JP        BASCOLD           ; Start BASIC COLD
CHECKWARM:
               CP        'W'
               JR        NZ, CORW
               RST       08H
               CALL      CON_NL
               JP        BASWARM           ; Start BASIC WARM

GO_COMMAND:
;			CALL CON_NL
;			LD  A,'*'
;			RST 8

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
			LD 		HL, MDC_1			
			CALL    CON_PRINT
			CALL    GETHEXWORD		
			PUSH	HL					
			
			CALL CON_NL
			
			POP		HL					
			LD		C,11				
MEMORY_DUMP_LINE:	
			LD		B,8					
			CALL	PRHEXWORD		    
			LD		A,' '				
			CALL	CON_PUTC
			DEC		C					
MEMORY_DUMP_BYTES:
			LD		A,(HL)				
			CALL	PRHEXBYTE		
			LD		A,' '				
			RST		8		
			INC 	HL					
			DJNZ	MEMORY_DUMP_BYTES	
			LD		B,C					
			CALL    CON_NL				
			DJNZ	MEMORY_DUMP_LINE	
			LD		A,$FF				
			RET

			


; Test hardware routine

MON_TEST::	
		LD HL, MON_TEST_KBD_MSG
		CALL CON_PRINT
		
		LD HL, MSG_TST_KBD
		CALL CON_PRINT
KEYLOOP:
		CALL KB_READKEY

		CP ESCAPE
    	RET Z
    	CP CR
    	JR Z, CRNL

    	CALL CON_PUTC
	    JR KEYLOOP
       
CRNL:
	    LD A, CR
	    CALL CON_PUTC
	    LD A, LF
	    CALL CON_PUTC		
	    JR KEYLOOP
			


WELCOMEMSG:    .BYTE     "Z80MiniFrame 32K",CR,LF
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
               .BYTE     "(C)old or (W)arm start? ",0

MDC_1: 			.BYTE CR,LF
	   			.BYTE "Address (in hex): ",0

MON_TEST_SND_MSG:	.BYTE CR,LF," * Testing sound",CR,LF,0
MON_TEST_VID_MSG:	.BYTE " * Testing video",CR,LF,0
MON_TEST_KBD_MSG:	.BYTE " * Testing keyboard", CR,LF,0

MSG_TST_KBD:
    .BYTE "Press any key to test (RUN-STOP to exit)", CR, LF, 0    

MON_TST_VID_MODE:	.BYTE "VIDEO MODE ",0

TST_FILE_NAME:		.BYTE "MYPROG", 0

.END
