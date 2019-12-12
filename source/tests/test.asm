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

                .ORG $0000
;------------------------------------------------------------------------------
; Reset

RST00           DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

                .ORG   $38            ; Int mode 1

                PUSH     AF
                PUSH     HL

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

               LD       A, 0
			   OUT		 (PIO1B),A
               LD     BC,600
               CALL   PAUSE
                              
LOOP:          LD       A, 4
			   OUT		 (PIO1B),A

               LD     BC,600
               CALL   PAUSE

               LD       A, 8
			   OUT		 (PIO1B),A

               LD     BC,600
               CALL   PAUSE
               JP       LOOP
               

;**************************************************************************************
; Simple sound generation with AY-3-8910 
;**************************************************************************************

CHIMPSOUND:  PUSH   D

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

             POP    D
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

SIGNON1:       .BYTE     CS
               .BYTE     "Z80 SBC By Grant Searle",CR,LF
			   .BYTE     "UART 16650 and IO routines written by Tomeu Capó",CR,LF,0
SIGNON2:       .BYTE     CR,LF
               .BYTE     "Cold or warm start (C or W)? ",0
			   
include "ioroutines.asm"

.END