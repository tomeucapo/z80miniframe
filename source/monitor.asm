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
				extern CF_INIT
				extern F32MNT
				extern UART_GETCHAR

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
				JP		  Z, BASIC_INIT
 				CP		  'M'
				JP		  Z, MEMORY_DUMP_COMMAND
 				CP		  'R'
				JP		  Z, RECEIVE_HEX_COMMAND
 				CP		  'G'
				JP		  Z, GO_COMMAND
 				CP		  'T'
				JP		  Z, MON_TEST
				CP		  'C'
				JP		  Z, CF_INIT_COMMAND
				CP		  'F'
				JP		  Z, FAT32_MOUNT_COMMAND
				CP		  'L'
				JP		  Z, FAT32_LIST_COMMAND
				CP		  '?'
				JP		  Z, MON_HELP
				CP		  CR
				RET		  Z
				CP		  LF
				RET		  Z
				CP		  BKSP
				RET		  Z
				CP		  0
				RET		  Z
				CP		  ESCAPE
				RET	      Z

				CALL	  NZ, MON_UNK_CMD
				RET

; Initialize the CompactFlash card and report the result.
CF_INIT_COMMAND:
				CALL	CON_NL
				LD		HL, CF_INIT_START_MSG
				CALL	CON_PRINT
				CALL	CF_INIT
				JR		C, CF_INIT_FAILED
				LD		HL, CF_INIT_OK_MSG
				CALL	CON_PRINT
				RET

CF_INIT_FAILED:
				PUSH	AF
				LD		HL, CF_INIT_ERROR_MSG
				CALL	CON_PRINT
				POP		AF
				CALL	PRHEXBYTE
				CALL	CON_NL
				RET

FAT32_MOUNT_COMMAND:
				CALL	CF_INIT
				JR		C,FAT32_MOUNT_FAILED
				CALL	F32MNT
				JR		C,FAT32_MOUNT_FAILED
				LD		HL,FAT32_MOUNT_OK_MSG
				CALL	CON_PRINT
				RET

FAT32_MOUNT_FAILED:
				PUSH	AF
				LD		HL,FAT32_MOUNT_ERROR_MSG
				CALL	CON_PRINT
				POP		AF
				CALL	PRHEXBYTE
				CALL	CON_NL
				RET

; List the FAT32 root through the same RST $20 service used by BASIC FILES.
FAT32_LIST_COMMAND:
				CALL	CON_NL
				LD		B,F32DIRSVC
				RST		$20
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
			RET C
			JP (HL)


RECEIVE_HEX_COMMAND:
			CALL CON_NL
			LD		HL,HXMSG0
			CALL	CON_PRINT
			XOR		A
			LD		(HBASE),A
			LD		(HBASE+1),A

; Intel HEX records are read from the UART only. Ignore leading CR/LF/noise.
RXSEEK:
			CALL	UART_GETCHAR
			CP		ESCAPE
			JP		Z,RXABRT
			CP		':'
			JR		NZ,RXSEEK

			XOR		A
			LD		(HXSUM),A

; Record length.
			CALL	RXBYTE
			JP		C,RXERR
			LD		(MON_HEX_LEN),A
			CALL	HXADD

; 16-bit address, Intel HEX byte order is high then low.
			CALL	RXBYTE
			JP		C,RXERR
			LD		(MON_HEX_ADDR+1),A
			CALL	HXADD
			CALL	RXBYTE
			JP		C,RXERR
			LD		(MON_HEX_ADDR),A
			CALL	HXADD

; Record type.
			CALL	RXBYTE
			JP		C,RXERR
			LD		(MON_HEX_TYPE),A
			CALL	HXADD

; Buffer data until the checksum is verified, so a bad record writes nothing.
			LD		A,(MON_HEX_LEN)
			LD		(HCOUNT),A
			LD		HL,HEXBUF
RXDATA:
			LD		A,(HCOUNT)
			OR		A
			JR		Z,RXCSUM
			CALL	RXBYTE
			JP		C,RXERR
			LD		(HL),A
			INC		HL
			CALL	HXADD
			LD		A,(HCOUNT)
			DEC		A
			LD		(HCOUNT),A
			JR		RXDATA

; Sum of length, address, type, data and checksum must be zero modulo 256.
RXCSUM:
			CALL	RXBYTE
			JP		C,RXERR
			CALL	HXADD
			LD		A,(HXSUM)
			OR		A
			JP		NZ,RXERR

			LD		A,(MON_HEX_TYPE)
			OR		A
			JP		Z,RXWRIT
			CP		1
			JP		Z,RXEOF
			CP		2
			JP		Z,RXSEG
			CP		4
			JP		Z,RXLINE
			CP		3
			JP		Z,RXIGNR
			CP		5
			JP		Z,RXIGNR
			JP		RXERR

; Data record: address = segment base + record offset.
RXWRIT:
			LD		HL,(MON_HEX_ADDR)
			LD		DE,(HBASE)
			ADD		HL,DE
			JP		C,RXRANG
			LD		(HSTART),HL
			LD		A,(MON_HEX_LEN)
			OR		A
			JP		Z,RXSEEK

; Reject overflow and the reserved FAT32 sector-buffer region ($FE00-$FFFF).
			DEC		A
			LD		E,A
			LD		D,0
			LD		HL,(HSTART)
			ADD		HL,DE
			JP		C,RXRANG
			LD		A,H
			CP		$FE
			JP		NC,RXRANG

; Keep the monitor's globals and stack below TEMPSTACK intact while receiving.
			LD		HL,(HSTART)
			LD		DE,TEMPSTACK+1
			OR		A
			SBC		HL,DE
			JP		C,RXRANG

			LD		A,(MON_HEX_LEN)
			LD		B,A
			LD		HL,(HSTART)
			LD		DE,HEXBUF
RXCOPY:
			LD		A,(DE)
			LD		(HL),A
			INC		DE
			INC		HL
			DJNZ	RXCOPY
			JP		RXSEEK

; Extended segment address record (type 02), segment << 4.
RXSEG:
			LD		A,(MON_HEX_LEN)
			CP		2
			JP		NZ,RXERR
			LD		HL,(MON_HEX_ADDR)
			LD		A,H
			OR		L
			JP		NZ,RXERR
			LD		A,(HEXBUF)
			CP		$10
			JP		NC,RXRANG
			LD		H,A
			LD		A,(HEXBUF+1)
			LD		L,A
			ADD		HL,HL
			ADD		HL,HL
			ADD		HL,HL
			ADD		HL,HL
			LD		(HBASE),HL
			JP		RXSEEK

; Extended linear address record (type 04). Only the 64-KiB address space
; is available; accept the zero upper word and reject addresses above it.
RXLINE:
			LD		A,(MON_HEX_LEN)
			CP		2
			JP		NZ,RXERR
			LD		HL,(MON_HEX_ADDR)
			LD		A,H
			OR		L
			JP		NZ,RXERR
			LD		A,(HEXBUF)
			LD		B,A
			LD		A,(HEXBUF+1)
			OR		B
			JP		NZ,RXRANG
			XOR		A
			LD		(HBASE),A
			LD		(HBASE+1),A
			JP		RXSEEK

; Start-address records are checksum-validated, then ignored.
RXIGNR:
			LD		A,(MON_HEX_LEN)
			CP		4
			JP		NZ,RXERR
			JP		RXSEEK

RXEOF:
			LD		A,(MON_HEX_LEN)
			OR		A
			JP		NZ,RXERR
			LD		HL,(MON_HEX_ADDR)
			LD		A,H
			OR		L
			JP		NZ,RXERR
			LD		HL,HXMSG1
			CALL	CON_PRINT
			CALL	CON_NL
			RET

; Read one byte represented by two hex digits; carry reports malformed input.
RXBYTE:
			CALL	RXNIB
			RET		C
			RLCA
			RLCA
			RLCA
			RLCA
			LD		B,A
			CALL	RXNIB
			RET		C
			OR		B
			OR		A
			RET

RXNIB:
			CALL	UART_GETCHAR
			CP		'0'
			JR		C,RXNBAD
			CP		'9'+1
			JR		C,RXNDIG
			CALL	TO_UPPER
			CP		'A'
			JR		C,RXNBAD
			CP		'F'+1
			JR		NC,RXNBAD
			SUB		'A'-10
			OR		A
			RET
RXNDIG:
			SUB		'0'
			OR		A
			RET
RXNBAD:
			SCF
			RET

; Add A to the modulo-256 record checksum and return A unchanged.
HXADD:
			LD		B,A
			LD		A,(HXSUM)
			ADD		A,B
			LD		(HXSUM),A
			LD		A,B
			RET

RXRANG:
			LD		HL,HXMSG3
			CALL	CON_PRINT
			CALL	CON_NL
			RET
RXERR:
			LD		HL,HXMSG2
			CALL	CON_PRINT
			CALL	CON_NL
			RET
RXABRT:
			LD		HL,HXMSG4
			CALL	CON_PRINT
			CALL	CON_NL
			RET

; Reuse the RAM sector-cache area; the monitor and FAT routines are not
; active concurrently.  Keep the top 512 bytes reserved from BASIC.
HEXBUF		.EQU	$FE00
HXMSG0:		.BYTE	"Send Intel HEX; ESC cancels",CR,LF,0
HXMSG1:		.BYTE	"Intel HEX received",CR,LF,0
HXMSG2:		.BYTE	"Intel HEX format/checksum error",CR,LF,0
HXMSG3:		.BYTE	"Intel HEX address out of range",CR,LF,0
HXMSG4:		.BYTE	"Intel HEX receive cancelled",CR,LF,0


MEMORY_DUMP_COMMAND:
			LD 		HL, MDC_1			
			CALL    CON_PRINT
			CALL    GETHEXWORD		
			RET		C
			PUSH	HL
			CALL	CON_NL
			POP		HL

			LD		D,10				; Ten rows, eight bytes per row
MEMORY_DUMP_LINE:
			CALL	PRHEXWORD			; Address of the first byte in this row
			LD		A,' '
			CALL	CON_PUTC
			LD		B,8
MEMORY_DUMP_BYTES:
			LD		A,(HL)
			CALL	PRHEXBYTE
			INC		HL
			LD		A,' '
			CALL	CON_PUTC
			DJNZ	MEMORY_DUMP_BYTES
			CALL	CON_NL
			DEC		D
			JR		NZ,MEMORY_DUMP_LINE
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
		CP CTRLC
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
				.BYTE   "C - Initialize CompactFlash", CR, LF
				.BYTE   "F - Mount FAT32 volume", CR, LF
				.BYTE   "L - List FAT32 root directory", CR, LF
				.BYTE	"? - This help", CR, LF, 0

CF_INIT_START_MSG: .BYTE "Initializing CompactFlash...", CR, LF, 0
CF_INIT_OK_MSG:    .BYTE "CompactFlash initialized (8-bit PIO)", CR, LF, 0
CF_INIT_ERROR_MSG: .BYTE "CompactFlash init failed; status=$", 0
FAT32_MOUNT_OK_MSG: .BYTE "FAT32 volume mounted", CR, LF, 0
FAT32_MOUNT_ERROR_MSG: .BYTE "FAT32 mount failed; code/status=$", 0

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
