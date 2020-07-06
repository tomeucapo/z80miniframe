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
SCR_X           .EQU     basicStarted+1
SCR_Y           .EQU     SCR_X+1


TEMPSTACK       .EQU     $80F0      ; 80ED Top of BASIC line input buffer so is "free ram" when BASIC resets

CR              .EQU     0DH
LF              .EQU     0AH
CS              .EQU     0CH             ; Clear screen

; MS-BASIC Addresses
BASIC_COLD		.EQU	 $08B8   ;$0368
BASIC_WARM		.EQU	 $08DB   ;$0388

                .ORG $0000

;------------------------------------------------------------------------------
; Reset

RST00           DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

;------------------------------------------------------------------------------
; TX a character over RS232 

                .ORG     0008H
RST08           CALL     VDP_PUTCHAR
                JP       TXA
                
;------------------------------------------------------------------------------
; RX a character over RS232 Channel A [Console], hold here until char ready.

                .ORG    0010H
RST10           JP      RXA

;------------------------------------------------------------------------------
; Check serial status

                 .ORG    0018H
RST18            JP      CKINCHAR

;------------------------------------------------------------------------------
; Main firmware interrupt service routine dispacher

                .ORG    0020H

RST20           
                DI 

                PUSH     AF
                PUSH     HL
                
                CALL     DISPATCH_ROUTINE
                
                POP      HL
                POP      AF
                
                EI
                RETI            

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
               CALL      VDP_INIT
               CALL      CHIMPSOUND
			   
               IM        1
               EI                          

               LD        HL,SIGNON1      ; Sign-on message
               CALL      PRINT           ; Output string
		
               ;LD        A, 0
               ;LD        E, 0
               ;CALL      VDP_SETPOS

               ;LD        HL, WELCOME_MSG  ; Print string to screen
               ;CALL      VDP_PRINT

               ;LD        A, 0             ; Locate screen at 0,1
               ;LD        E, 1
               ;CALL      VDP_SETPOS

               ;LD        HL, WELCOME_MSG2   ; Print second message
               ;CALL      VDP_PRINT

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

;**************************************************************************************
; Simple sound generation with AY-3-8910 
;**************************************************************************************

CHIMPSOUND:  PUSH   DE
             PUSH   AF
             PUSH   BC

             LD     A, 7
             LD     C, 62
             CALL   AYREGWRITE
             LD     D, 1

LOOP1VOL:    LD     A, 8
             LD     C, D
             CALL   AYREGWRITE

             LD     E, 0
LOOP2PITCH:  LD     A, 1
             LD     C, E
             CALL   AYREGWRITE
             LD     BC,200
             CALL   PAUSE
             INC    E
             LD     A, 7
             CP     E
             JR     NZ, LOOP2PITCH   

             LD     A, 8
             LD     C, 0
             CALL   AYREGWRITE   

             INC    D
             LD     A, 8
             CP     D
             JR     NZ, LOOP1VOL

             LD     A, 8
             LD     C, 0
             CALL   AYREGWRITE   

             POP    BC
             POP    AF
             POP    DE
             RET

PAUSE:       PUSH   AF
             INC    B
             INC    C              ; ADJUST THE LOOP
PAUSELOOP1:  LD     A,13H          ; ADJUST THE TIME 13h IS FOR 4 MHZ
PAUSELOOP2:  DEC    A              ; DEC COUNTER. 4 T-states = 1 uS.
             JP     NZ,PAUSELOOP2  ; JUMP TO PAUSELOOP2 IF A <> 0.
             DEC    C              ; DEC COUNTER
             JP     NZ,PAUSELOOP1  ; JUMP TO PAUSELOOP1 IF C <> 0.

             DJNZ   PAUSELOOP1     ; JUMP TO PAUSELOOP1 IF B <> 0.
PAUSESLUT:   POP    AF
             RET


DISPATCH_ROUTINE:
                EX      AF, AF'
                LD      A, B
                CP      0
                JR      Z, _VDP_SETCOLOR
                CP      1
                JR      Z, _VDP_PRINT
                CP      2
                JR      Z, _VDP_SETPOS
                CP      3
                JR      Z, _VDP_CLRSCR
                JP      END20

_VDP_SETCOLOR:  EX      AF, AF'
                CALL    VDP_SETCOLOR
                JP      END20

_VDP_PRINT:     EX      AF, AF'
                CALL    VDP_PRINT
                JP      END20

_VDP_SETPOS:    EX      AF, AF'
                CALL    VDP_SETPOS
                JP      END20

_VDP_CLRSCR:    EX      AF, AF'
                CALL    VDP_CLRSCR

END20:          RET


SIGNON1:       .BYTE     CS
               .BYTE     "Z80 SBC By Grant Searle",CR,LF
			   .BYTE     "Firmware v2.1 By Tomeu Capo",CR,LF,0
SIGNON2:       .BYTE     CR,LF
               .BYTE     "Cold or warm start (C or W)? ",0

WELCOME_MSG:   .BYTE     "Z80MiniFrame v2.1", 0
WELCOME_MSG2:  .BYTE     "TCC 2020 (C)", 0
			   
include "ioroutines.asm"
include "monitor.asm"
include "vdp.asm"

.END
