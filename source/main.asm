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
                extern VDP_INIT

                extern CON_PRINT, CON_PUTC, CON_CKINCHAR, CON_GETCHAR
                extern MON_WELCOM, BASIC_INIT
               

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

                .ORG   $0038            
                EX AF, AF'
                EXX

		CALL	 UART_READ

                EXX
                EX AF, AF'     
                EI
                RETI

;------------------------------------------------------------------------------
; NMI Interrupt routine

                .ORG    $0066
                EX AF, AF'
                EXX

                LD A, (ENABLECTC)
                CP 0
                JR Z, EXITNMI

                CALL    LEDBLINK
               ; CALL    VDP_BLINK_CURSOR

                ;CALL    KB_KEYSCAN
                ;LD      A, (LASTKEYCODE)
                ;CP      $FF
                ;JR      Z, EXITNMI

                ;CALL    VDP_PUTCHAR
                ;CALL    BUFF_PUTC
EXITNMI:  
                EXX
                EX AF, AF'            
                EI
                RETN

;------------------------------------------------------------------------------
; Main code

INIT::            
               LD       HL,TEMPSTACK            ; Set up a temporary stack
               LD       SP,HL               
                
               CALL	 PPI_INIT               ; Initialize PPI
               CALL      PPI_GETSWSTATE         ; Get dipswitches configuration for UART speed
               
               LD        H, 0   
               LD	 L, C
               CALL      UART_INIT              ; Initialize UART at C speed

               CALL      PSG_INIT

               LD        A, B
               LD        (ENABLECTC), A         ; Check if CTC are disabled or not
               CP        0
               JR        Z, WITHOUT_CTC

               CALL      CTC_INIT               ; Initialize CTC
WITHOUT_CTC:              
               LD        E, 0                   ; VDP Set video text mode
               CALL      VDP_INIT

               CALL      PPI_LED_BLINK          ; PPI LED Hello world welcome
               CALL      CHIMPSOUND             ; Welcome sound

               IM   1                           ; Enable interrupt mode 1
               EI                          

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

LEDBLINK:
        PUSH AF
        LD A, (CURSORSTATE)
        SLA A
        SLA A
        SLA A
        OUT (PIO1B), A      
        POP AF
        RET   

CTCENABLEDMSG: .BYTE    "CTC Enabled", CR,LF,0

               .end

