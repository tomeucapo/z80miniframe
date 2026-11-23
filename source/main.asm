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

                public IRQFAULT_VECTOR

                extern SVC_ROUTINE
                extern UART_INIT, UART_READ 
                
                extern PPI_INIT, PPI_GETSWSTATE, PPI_LED_BLINK
                ifdef Z80AIO
                extern PIT_INIT, PIT_RESET
                endif
                extern KB_INIT
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
                ; RETN restores IFF1 from IFF2; do not force-enable IRQs here.
                RETN
              
                .ORG    $0170
                defw    INT_HND_USR4        ; $70
                defw    INT_HND_USR3        ; $72
                defw    INT_HND_USR2        ; $74
                defw    INT_HND_USR1        ; $76 
                defw    INT_HND_EXT1        ; $78
                defw    INT_HND_VDP         ; $7A
                defw    INT_HND_UART        ; $7C
                ifdef Z80AIO
                defw    INT_HND_PIT         ; $7E
                else
                defw    INT_HND_SPURIOUS    ; $7E (no PIT on Z80FRAME)
                endif
                
;------------------------------------------------------------------------------
; Main code

INIT::            
               LD       HL,TEMPSTACK           ; Set up a temporary stack
               LD       SP,HL               

               XOR      A
               LD       (IRQFAULT_VECTOR),A    ; Clear unhandled IRQ record

               CALL	    PPI_INIT               ; Initialize PPI
               CALL     PPI_GETSWSTATE         ; Get dipswitches configuration for UART speed
               
               LD      A, 1
               OUT     (LED_PORT), A

               LD        H, 0   
               LD	     L, C
               CALL      UART_INIT              ; Initialize UART at C speed
              
               ifdef    IM_2         
                   IM   2                       ; Interrupt mode 2
                   ld   a, 1                    
                   ld   I, A                    ; Set high byte of interrupt vectors to point to page 0                   
               else
                   IM   1                       ; Interrupt mode 1
               endif

               LD      A, 2
               OUT     (LED_PORT), A

            ;    LD        A, B
            ;    LD        (ENABLECTC), A         ; Check if starts without VDP, CTC and PSG
            ;    CP        0
            ;    JR        Z, ONLY_CORE

            ;    LD      A, 3
            ;    OUT     (LED_PORT), A

               ifndef    VDP_DISABLE
               LD        E, 0                   ; VDP Set video text mode
               CALL      VDP_INIT 
               endif
            
                ifndef    PSG_DISABLE
                CALL      PSG_INIT               ; Initialize PSG
                CALL      CHIMPSOUND             ; Welcome sound
                CALL      KB_INIT                ; Reset C64 keyboard scanner state
                endif
             
                ifdef Z80AIO
                CALL      PIT_INIT               ; Initialize the Allinone 8253 PIT
                endif
                CALL      PPI_LED_BLINK          ; PPI LED Hello world welcome
                        
               xor  A
               ld   (TMRCNT), A                

               LD   A, 1
               LD   (CURSORSTATE), A   
                
               CALL      PPI_LED_BLINK          ; PPI LED Hello world welcome                               
               CALL      MON_WELCOM      

               EI

               LD        A, 'N'
               LD        (basicStarted),A        
               CALL      BASIC_INIT
                 
;;-----------------------------------------------------------------------------
;; Interrupt handler routines

                .ORG    $0200
                
INT_HND_UART:  DI
               EX AF, AF'
               EXX

		       CALL	 UART_READ

               EXX
               EX AF, AF'     
               EI
               RETI

                ifdef Z80AIO
INT_HND_PIT:   DI
               ; Reset counter

               CALL PIT_RESET

               PUSH AF
               PUSH BC

               LD      A, (ENABLEDCURSOR)
               OUT     (LED_PORT), A
               CPL
               LD      (ENABLEDCURSOR), A       

;                ld      HL,TMRCNT       ; load starting address of the timer
;                ld      B,$04           ; 4 bytes to check
; INCTMR3:       inc     (HL)            ; increment timer
;                jr      NZ,EXIT_INT     ; if not zero then exit (finished increment)
;                inc     HL              ; if yes, there was an overflow, so increment next byte
;                djnz    INCTMR3         ; repeat for 4 bytes
; EXIT_INT:                 
               POP     BC
               POP     AF

               EI
               RETI
                endif

INT_HND_VDP:
                PUSH    AF
                LD      A,$7A
                JR      INT_HND_UNHANDLED

INT_HND_EXT1:
                PUSH    AF
                LD      A,$78
                JR      INT_HND_UNHANDLED

INT_HND_USR1:
                PUSH    AF
                LD      A,$76
                JR      INT_HND_UNHANDLED

INT_HND_USR2:
                PUSH    AF
                LD      A,$74
                JR      INT_HND_UNHANDLED

INT_HND_USR3:
                PUSH    AF
                LD      A,$72
                JR      INT_HND_UNHANDLED

INT_HND_USR4:
                PUSH    AF
                LD      A,$70
                JR      INT_HND_UNHANDLED

INT_HND_SPURIOUS:
                PUSH    AF
                LD      A,$7E

; No device-specific acknowledge routine is installed for this vector.
; Record the IM2 byte and stop until reset.  Returning to application code
; could execute an EI and re-enable a still-asserted level-triggered source.
INT_HND_UNHANDLED:
                DI
                LD      (IRQFAULT_VECTOR),A
IRQ_FAULT_HALT:
                HALT
                JR      IRQ_FAULT_HALT


HELLOWORLD:
               LD        HL,UEPMSG    
               CALL      CON_PRINT          
               HALT
               RET     

UEPMSG:       .BYTE   "UEP, COM ANAN?",CR,LF,0

CTCENABLEDMSG:  .BYTE    "PIT Enabled", CR,LF,0
UARTENABLEDMSG: .BYTE   "UART Enabled", CR,LF,0

               .end
