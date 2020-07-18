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

SER_BUFSIZE     .EQU     $3F
SER_FULLSIZE    .EQU     $30
SER_EMPTYSIZE   .EQU     $05

serBuf          .EQU     $8000                    ; $8000  
serInPtr        .EQU     serBuf+SER_BUFSIZE+1     ; $8040
serRdPtr        .EQU     serInPtr+2               ; $8042
serBufUsed      .EQU     serRdPtr+2               ; $8044
basicStarted    .EQU     serBufUsed+1             ; $8045

SCR_X           .EQU     basicStarted+1           ; $8046
SCR_Y           .EQU     SCR_X+1                  ; $8047
SCR_SIZE_W      .EQU     SCR_Y+1                  ; $8048
SCR_SIZE_H      .EQU     SCR_SIZE_W+1             ; $8049
SCR_MODE        .EQU     SCR_SIZE_H+1             ; $804A
VIDEOBUFF       .EQU     SCR_MODE+2               ; $804C (40) buffer used for video scrolling and other purposes
VIDTMP1         .EQU     VIDEOBUFF+$28            ; $8074 (2) temporary video word
VIDTMP2         .EQU     VIDTMP1+$02              ; $8076 (2) temporary video word

bufWrap         .EQU     (serBuf + SER_BUFSIZE) & $FF

TEMPSTACK       .EQU     $80DF                  ; $81E6, $80AB, 80F2, 80ED Top of BASIC line input buffer so is "free ram" when BASIC resets

CR              .EQU     0DH
LF              .EQU     0AH                
CS              .EQU     0CH             ; Clear screen
BKSP            .EQU     08H

; MS-BASIC Addresses
BASIC_COLD		.EQU	 $2678  
BASIC_WARM		.EQU	 $267B   

                .ORG $0000

;------------------------------------------------------------------------------
; Reset

RST00           DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

;------------------------------------------------------------------------------
; TX a character over RS232 

                .ORG     0008H
RST08           DI
                CALL     VDP_PUTCHAR
                EI
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

RST20           DI 

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
               CALL      CHIMPSOUND

               LD        E, 0            ; Initialize VPD with TEXT MODE
               CALL      VDP_INIT
			   
               IM        1
               EI                          
                
               LD        A, 0
               LD        E, 0
               CALL      VDP_SETPOS

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

_VDP_SETCOLOR:  EX      AF, AF'
                CALL    VDP_SETCOLOR
                JP      END20

_VDP_PRINT:     EX      AF, AF'
                CALL    VDP_PRINT
                JP      END20

_VDP_SETPOS:    EX      AF, AF'
                CALL    VDP_SETPOS
                JP      END20

END20:          RET


SIGNON1:       .BYTE     CS
               .BYTE     "Z80 SBC By Grant Searle",CR,LF
			   .BYTE     "Firmware v2.1 By Tomeu Capo",CR,LF,0
SIGNON2:       .BYTE     CR,LF
               .BYTE     "Cold or warm start (C or W)? ",0
                         
WELCOME_MSG:   .BYTE     "Z80MiniFrame v2.1 ***********************", 0
WELCOME_MSG2:  .BYTE     "TCC 2020 (C)", 0
			   
include "ioroutines.asm"
include "monitor.asm"
include "vdp.asm"

.END
