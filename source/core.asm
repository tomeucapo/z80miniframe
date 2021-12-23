;******************************************************************
; Firmware core main code
; Tomeu Capó 2020                      
;******************************************************************

SER_BUFSIZE     .EQU     $3F
SER_FULLSIZE    .EQU     $30
SER_EMPTYSIZE   .EQU     $05

; Firmware memory variables stars at $8000 RAM Address

serBuf          .EQU     $8000                    ; $8000  
serInPtr        .EQU     serBuf+SER_BUFSIZE+1     ; $8040
serRdPtr        .EQU     serInPtr+2               ; $8042
serBufUsed      .EQU     serRdPtr+2               ; $8044
basicStarted    .EQU     serBufUsed+1             ; $8045

SCR_X           .EQU     basicStarted+1           ; $8046
SCR_Y           .EQU     SCR_X+1                  ; $8047
SCR_CUR_X       .EQU     SCR_Y+1                  ; $8048
SCR_CUR_Y       .EQU     SCR_CUR_X+1              ; $8049
SCR_SIZE_W      .EQU     SCR_CUR_Y+1              ; $804A
SCR_SIZE_H      .EQU     SCR_SIZE_W+1             ; $804B
SCR_MODE        .EQU     SCR_SIZE_H+1             ; $804C
VIDEOBUFF       .EQU     SCR_MODE+2               ; $804E (40) buffer used for video scrolling and other purposes
VIDTMP1         .EQU     VIDEOBUFF+$28            ; $8075      (2) temporary video word
VIDTMP2         .EQU     VIDTMP1+$02              ; $8078      (2) temporary video word

CURSORSTATE     .EQU     VIDTMP2+1                ; $8079
KBDROW          .EQU     CURSORSTATE+1            ; $807A
KBDCOLMSK       .EQU     KBDROW+1                 ; $807B
TMRCNT          .EQU     KBDCOLMSK+$01            ; $807C (4) TMR counter for 1/100 seconds
CTC0IV          .EQU     TMRCNT+$04               ; $8080 (3) CTC0 interrupt vector
CTC1IV          .EQU     CTC0IV+$03               ; $8083 (3) CTC1 interrupt vector
CTC2IV          .EQU     CTC1IV+$03               ; $8086 (3) CTC2 interrupt vector
CTC3IV          .EQU     CTC2IV+$03               ; $8089 (3) CTC3 interrupt vector
ENABLEDCURSOR   .EQU     CTC3IV+$01               ; $808A
ENABLECTC       .EQU     ENABLEDCURSOR+$01        ; $808B
CHASNDDTN       .EQU     ENABLECTC+$02            ; $808D
CHBSNDDTN       .EQU     CHASNDDTN+$02            ; $808F
CHCSNDDTN       .EQU     CHBSNDDTN+$02            ; $8091
KBDNPT          .EQU     CHCSNDDTN+$02            ; $8093 (1) temp cell used to flag if input comes from keyboard
KBTMP           .EQU     KBDNPT+$01               ; $8094 (1) temp cell used by keyboard scanner
TMPKEYBFR       .EQU     KBTMP+$01                ; $8095 (1) temp buffer for last key pressed
LASTKEYPRSD     .EQU     TMPKEYBFR+$01            ; $8096 (1) last key code pressed
CONTROLKEYS     .EQU     LASTKEYPRSD+$01          ; $8097 (1) flags for control keys (bit#0=SHIFT; bit#1=CTRL; bit#2=C=)
CHR4VID         .EQU     CONTROLKEYS+$01          ; $8098


KBDSIZE         .EQU     8

bufWrap         .EQU     (serBuf + SER_BUFSIZE) & $FF

TEMPSTACK       .EQU     $8151                  ;  Top of BASIC line input buffer so is "free ram" when BASIC resets (old addresses used: 80DF, $81E6, $80AB, 80F2, 80ED)

CTRLC           .EQU     03H
CR              .EQU     0DH
LF              .EQU     0AH                
CS              .EQU     0CH             ; Clear screen
BKSP            .EQU     08H
ESCAPE          .EQU     1BH


; MS-BASIC Addresses
BASIC_COLD		.EQU	 $2678  
BASIC_WARM		.EQU	 $267B   

; CP/M CBIOS Address
BOOT_CPM                .EQU     $4388

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

                .ORG    $0010
RST10           JP      RXA

;------------------------------------------------------------------------------
; Check serial status

                 .ORG    $0018
RST18            JP      CKINCHAR

;------------------------------------------------------------------------------
; Main firmware interrupt service routine dispatcher

                .ORG    $0020

RST20           DI 

                PUSH     AF
                PUSH     HL
                
                CALL     DISPATCH_ROUTINE
                
                POP      HL
                POP      AF
                
                EI
                RETI            

;------------------------------------------------------------------------------
; Interrupt mode 1 routine

                .ORG   $0038            

                PUSH     AF
                PUSH     HL

		CALL	 READ_UART
				
		POP      HL
                POP      AF
                EI
                RETI

;------------------------------------------------------------------------------
; NMI Interrupt vector

                .ORG    $0066
                EX AF, AF'
                EXX

                LD A, (ENABLECTC)
                CP 0
                JR Z, EXITNMI

                LD A, (ENABLEDCURSOR)
                CP 0
                JR Z, EXITNMI

                CALL    LEDBLINK
                CALL    VDP_BLINK_CURSOR       
EXITNMI:      
                EXX
                EX AF, AF'            
                EI
                RETN

;------------------------------------------------------------------------------

INIT:
               LD        HL,TEMPSTACK    ; Temp stack
               LD        SP,HL           ; Set up a temporary stack
            
               CALL	 INIT_IO         ; Initialize I/O subsystem (PIO and UART)

               CALL      GETSWSTATE      ; Check if CTC are disabled or not
               LD        A, B
               LD        (ENABLECTC), A
               CP        0
               JR        Z, WITHOUT_CTC

               CALL      INIT_CTC        ; Initialize CTC

WITHOUT_CTC:
               LD        E, 0            ; Initialize VPD with TEXT MODE
               CALL      VDP_INIT
               ;CALL      PSG_INIT
               
               CALL      CHIMPSOUND

               ;XOR       A
               ;LD        I, A
               ;IM        2
               
               IM   1                   ; Enable interrupt mode 1
               EI                          
                
               LD        A, 0           ; Locate on top of screen
               LD        E, 0
               CALL      VDP_SETPOS

               LD        HL,WELCOMEMSG  ; Print welcome message      
               CALL      PRINT          

               LD        A, (ENABLECTC)
               CP        0
               JR        Z, MAIN_LOOP

               LD        HL,CTCENABLEDMSG    
               CALL      PRINT
               
MAIN_LOOP:
	       CALL      MON_LOOP       ; Go to monitor main loop awaiting for command

;**************************************************************************************
; Decide if start BASIC in Warm or Cold start mode
;**************************************************************************************

BASIC_INIT:    LD        A,(basicStarted); Check the BASIC STARTED flag
               CP        'Y'             ; to see if this is power-up
               JR        NZ,COLDSTART    ; If not BASIC started then always do cold start
               LD        HL, BASICSTARTMSG
               CALL      PRINT
CORW:
               ;CALL      RXA
               ;AND       11011111b       ; lower to uppercase
               
               CALL     GET_CHAR
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
               CALL     MON_NEW_LINE

               JP        BASIC_WARM           ; Start BASIC WARM

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


; Main RST 20 routine dispacher

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
                JR      Z, _VDP_MODE
                CP      4
                JR      Z, _VDP_WRITE_VIDEO_LOC

                EX      AF, AF'
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

_VDP_MODE:      EX      AF, AF'
                LD      E, A            
                CALL    VDP_INIT

_VDP_WRITE_VIDEO_LOC:
                EX      AF, AF'
                CALL    VDP_WRITE_VIDEO_LOC

END20:          RET


LEDBLINK:
        LD A, (CURSORSTATE)
        SLA A
        SLA A
        SLA A
        OUT (PIO1B), A      
        RET              

;**************************************************************************************
; NMI Routine code
;**************************************************************************************
;NMI_ROUTINE:


WELCOMEMSG:    .BYTE     CS
               .BYTE     "Z80MiniFrame 32K",CR,LF
               .BYTE     "Firmware v1.0 By Tomeu Capo",CR,LF,0

BASICSTARTMSG: .BYTE     CR,LF
               .BYTE     "Cold or warm start (C or W)? ",0

CTCENABLEDMSG: .BYTE    "CTC Enabled", CR,LF,0
                         
include "ioroutines.asm"
include "monitor.asm"
include "ctc.asm"
include "psg.asm"
include "vdp.asm"
include "cflm.asm"

