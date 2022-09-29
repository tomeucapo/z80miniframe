;;******************************************************************
;; Firmware main code
;; Tomeu Capó 2022     
;;                
;; Code and computer schematics are released under
;; the therms of the GNU GPL License 3.0 and in the form of "as is", without no
;; kind of warranty: you can use them at your own risk.
;; You are free to use them for any non-commercial use: you are only asked to
;; maintain the copyright notices, include this advice and the note to the 
;; attribution of the original version to Tomeu Capó, if you intend to
;; redistribuite them.
;;******************************************************************

include "globals.inc"
include "ppi.inc"
include "svcroutine.inc"

                extern SVC_ROUTINE
                extern UART_INIT, UART_READ 
                
                extern PPI_INIT, PPI_GETSWSTATE, PPI_LED_BLINK
                extern CTC_INIT
                extern PSG_INIT, CHIMPSOUND
                extern VDP_INIT, BUFF_PUTC, KB_KEYSCAN

                extern CON_PRINT, CON_PUTC, CON_CKINCHAR, CON_GETCHAR
                extern MON_WELCOM, BASIC_INIT, MON_MAIN
               

                .ORG $0000
                DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

;------------------------------------------------------------------------------
; Put character to output

                .ORG     $0008
                JP       CON_PUTC
                      
;------------------------------------------------------------------------------
; Get character for buffer if is available

                .ORG    $0010
                JP      CON_GETCHAR

;------------------------------------------------------------------------------
; Check if any character into buffer are available

                .ORG    $0018
                JP      CON_CKINCHAR 

;------------------------------------------------------------------------------
; Firmware service routine dispatcher

                .ORG    $0020

                DI 

                PUSH     AF
                PUSH     HL
                
                CALL     SVC_ROUTINE
                
                POP      HL
                POP      AF
                
                EI
                RETI            

;------------------------------------------------------------------------------
; Interrupt mode 1 routine

    ifndef IM_2
                .ORG   $0038            
                JP     INT_HND_UART
    endif

;------------------------------------------------------------------------------
; NMI Interrupt routine

                .ORG    $0066
                EI
                RETN                

;------------------------------------------------------------------------------
; Main code

INIT::            
               LD       HL,TEMPSTACK            ; Set up a temporary stack
               LD       SP,HL               
                
               CALL	    PPI_INIT               ; Initialize PPI
               CALL     PPI_GETSWSTATE         ; Get dipswitches configuration for UART speed
               
               LD        H, 0   
               LD	     L, C
               CALL      UART_INIT              ; Initialize UART at C speed
        
               ifdef    IM_2                    
                   ld   a, 1                    ; Interrupt mode 2
                   ld   I, A                    ; Set high byte of interrupt vectors to point to page 0
                   IM   2
               else
                   IM   1                       ; Interrupt mode 1
               endif
               EI

               LD        A, B
               LD        (ENABLECTC), A         ; Check if starts without VDP, CTC and PSG
               CP        0
               JR        Z, ONLY_CORE

               CALL      CTC_INIT               ; Initialize CTC 

               ifndef    VDP_DISABLE
               LD        E, 0                   ; VDP Set video text mode
               CALL      VDP_INIT 
               endif

               ifndef    PSG_DISABLE               
               CALL      PSG_INIT               ; Initialize PSG
               CALL      CHIMPSOUND             ; Welcome sound
               endif
ONLY_CORE:                                     
               CALL      PPI_LED_BLINK          ; PPI LED Hello world welcome

               CALL      MON_WELCOM
               LD        A, (ENABLECTC)         ; If CTC is initialized shows CTC Enabled message
               CP        0
               JR        Z, MAIN_LOOP

               LD        HL,CTCENABLEDMSG    
               CALL      CON_PRINT               

MAIN_LOOP:

               LD        A, 'N'
               LD        (basicStarted),A        
               CALL      BASIC_INIT
                 

;; Interrupt handler routines

INT_HND_UART:  DI
               EX AF, AF'
               EXX

		       CALL	 UART_READ

               EXX
               EX AF, AF'     
               EI
               RETI

INT_HND_CTC:   DI
               EX AF, AF'
               EXX
               
               ;LD      A, (ENABLEDCURSOR)
               ;OUT     (LED_PORT), A
               ;CPL
               ;LD      (ENABLEDCURSOR), A                
               
               ; Call keyboard scan and put key into buffer
               CALL    KB_KEYSCAN
               LD      A, (LASTKEYCODE)
               JP      Z, EXIT_INTCTC               
               CALL    BUFF_PUTC  
               ;CALL    CON_PUTC

EXIT_INTCTC:
               EXX
               EX AF, AF'     
               EI
               RETI

INT_HND_VDP:   DI
               EX AF, AF'
               EXX
               
              ; LD      A, 1
              ; OUT     (LED_PORT), A

               EXX
               EX AF, AF'     
               EI
               RETI                

INT_HND_EXT1:  DI
               EX AF, AF'
               EXX

               ;LD      A, 2
               ;OUT     (LED_PORT), A

               EXX
               EX AF, AF'     
               EI
               RETI

INT_HND_USR1:                
INT_HND_USR2:
INT_HND_USR3:
INT_HND_USR4:   DI
                
                EI
                RETI

;------------------------------------------------------------------------------
; Interrupt mode 2 vector

                .ORG    $0170
                dw      INT_HND_USR4
                dw      INT_HND_USR3
                dw      INT_HND_USR2
                dw      INT_HND_USR1
                dw      INT_HND_EXT1   
                dw      INT_HND_VDP             
                dw      INT_HND_UART
                dw      INT_HND_CTC

CTCENABLEDMSG: .BYTE    "CTC Enabled", CR,LF,0

               .end

