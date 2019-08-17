;==================================================================================
; Contents of this file are copyright Grant Searle
;
; You have permission to use this for NON COMMERCIAL USE ONLY
; If you wish to use it elsewhere, please include an acknowledgement to myself.
;
; http://searle.hostei.com/grant/index.html
;
; eMail: home.micros01@btinternet.com
;
; If the above don't work, please perform an Internet search to see if I have
; updated the web page hosting service.
;
;==================================================================================

; The original Grant Searle code only supports 6850 ACIA driven serial. This code
; have modified serial routines to adapt to UART 16650 and add PIO initialization routines
; by Tomeu Capó

SER_BUFSIZE     .EQU     3FH
SER_FULLSIZE    .EQU     30H
SER_EMPTYSIZE   .EQU     5

serBuf          .EQU     $8000
serInPtr        .EQU     serBuf+SER_BUFSIZE
serRdPtr        .EQU     serInPtr+2
serBufUsed      .EQU     serRdPtr+2
basicStarted    .EQU     serBufUsed+1
TEMPSTACK       .EQU     $80ED ; Top of BASIC line input buffer so is "free ram" when BASIC resets

CR              .EQU     0DH
LF              .EQU     0AH
CS              .EQU     0CH             ; Clear screen

; MS-BASIC Addresses
BASIC_COLD		.EQU	 $0318
BASIC_WARM		.EQU	 $0320

                .ORG $0000
;------------------------------------------------------------------------------
; Reset

RST00           DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

;------------------------------------------------------------------------------
; TX a character over RS232 

                .ORG     0008H
RST08           JP      TXA

;------------------------------------------------------------------------------
; RX a character over RS232 Channel A [Console], hold here until char ready.

                .ORG    0010H
RST10           JP      RXA

;------------------------------------------------------------------------------
; Check serial status

                 .ORG    0018H
RST18            JP      CKINCHAR

;------------------------------------------------------------------------------
; RST 38 - INTERRUPT VECTOR [ for IM 1 ]

                .ORG   $38            ; Int mode 1

                PUSH     AF
                PUSH     HL

				CALL	 READ_UART
				
				POP      HL
                POP      AF
                EI
                RETI

;------------------------------------------------------------------------------
INIT:
               LD        HL,TEMPSTACK    ; Temp stack
               LD        SP,HL           ; Set up a temporary stack
               
               
			   CALL		 INIT_IO
			   
			   IM        1
               EI
               LD        HL,SIGNON1      ; Sign-on message
               CALL      PRINT           ; Output string
			   
			   CALL		 MON_HELP
			   CALL		 MON_LOOP
			   
BASIC_INIT:	   LD        A,(basicStarted); Check the BASIC STARTED flag
               CP        'Y'             ; to see if this is power-up
               JR        NZ,COLDSTART    ; If not BASIC started then always do cold start
               LD		 HL, SIGNON2
			   CALL		 PRINT
CORW:
               CALL      RXA
               AND       11011111b       ; lower to uppercase
               CP        'C'
               JR        NZ, CHECKWARM
               RST       08H
               LD        A,$0D
               RST       08H
               LD        A,$0A
               RST       08H
COLDSTART:     LD        A,'Y'           ; Set the BASIC STARTED flag
               LD        (basicStarted),A
               JP        BASIC_COLD           ; Start BASIC COLD
CHECKWARM:
               CP        'W'
               JR        NZ, CORW
               RST       08H
               LD        A,$0D
               RST       08H
               LD        A,$0A
               RST       08H
               JP        BASIC_WARM           ; Start BASIC WARM
              
SIGNON1:       .BYTE     CS
               .BYTE     "Z80 SBC By Grant Searle",CR,LF
			   .BYTE     "UART 16650 and IO routines written by Tomeu Capó",CR,LF,0
SIGNON2:       .BYTE     CR,LF
               .BYTE     "Cold or warm start (C or W)? ",0

			   
include "ioroutines.asm"
include "monitor.asm"

.END
