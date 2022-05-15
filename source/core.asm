;******************************************************************
; Firmware core main code
; Tomeu Capó 2022                     
;******************************************************************

include "globals.inc"
include "ppi.inc"

                extern UART_INIT, UART_READ, UART_WRITE, BUFF_GETC, BUFF_CKINCHAR
                extern PPI_INIT, PPI_GETSWSTATE, PPI_LED_BLINK
                extern CTC_INIT
                extern VDP_INIT, VDP_SETPOS, VDP_SETCOLOR, VDP_PUTCHAR, VDP_BLINK_CURSOR, VDP_PRINT, VDP_WRITE_VIDEO_LOC
                extern MON_PRINT, MON_LOOP, MON_NEW_LINE

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
                JP       UART_WRITE
                      
                
;------------------------------------------------------------------------------
; RX a character over RS232 Channel A [Console], hold here until char ready.

                .ORG    $0010
RST10           JP      BUFF_GETC

;------------------------------------------------------------------------------
; Check serial status

                 .ORG    $0018
RST18            JP      BUFF_CKINCHAR

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

		CALL	 UART_READ
				
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
               LD        HL,TEMPSTACK
               LD        SP,HL               ; Set up a temporary stack
            
               CALL	 PPI_INIT            ; Initialize I/O subsystem (PIO and UART)
               CALL      PPI_GETSWSTATE      ; Check if CTC are disabled or not
               
               LD        H, 0
               LD	 L, C

               CALL      UART_INIT

               LD        A, B
               LD        (ENABLECTC), A
               CP        0
               JR        Z, WITHOUT_CTC

               CALL      CTC_INIT        ; Initialize CTC

WITHOUT_CTC:
               LD        E, 0            ; Initialize VPD with TEXT MODE
               CALL      VDP_INIT
               
               CALL      PPI_LED_BLINK

               LD        A, 0           ; Locate on top of screen
               LD        E, 0
               CALL      VDP_SETPOS
               
               IM   1                   ; Enable interrupt mode 1
               EI                          
                       
               LD        HL,WELCOMEMSG  ; Print welcome message      
               CALL      MON_PRINT

               LD        A, (ENABLECTC)
               CP        0
               JR        Z, MAIN_LOOP

               LD        HL,CTCENABLEDMSG    
               CALL      MON_PRINT
               
MAIN_LOOP:
	       CALL      MON_LOOP       ; Go to monitor main loop awaiting for command



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

WELCOMEMSG:    .BYTE     CS
               .BYTE     "Z80MiniFrame 32K",CR,LF
               .BYTE     "Firmware v1.0 By Tomeu Capo",CR,LF,0


CTCENABLEDMSG: .BYTE    "CTC Enabled", CR,LF,0


