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
                extern PIT_INIT, PIT_RESET
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
              
                .ORG    $0170
                defw    INT_HND_USR4        ; $70
                defw    INT_HND_USR3        ; $72
                defw    INT_HND_USR2        ; $74
                defw    INT_HND_USR1        ; $76 
                defw    INT_HND_EXT1        ; $78
                defw    INT_HND_VDP         ; $7A
                defw    INT_HND_UART        ; $7C
                defw    INT_HND_PIT         ; $7E
                
;------------------------------------------------------------------------------
; Main code

INIT::            
               LD       HL,TEMPSTACK           ; Set up a temporary stack
               LD       SP,HL               
                                           
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
               endif
             
               CALL      PIT_INIT               ; Initialize PIT
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

INT_HND_VDP:  
INT_HND_EXT1:  
INT_HND_USR1:                
INT_HND_USR2:
INT_HND_USR3:
INT_HND_USR4:   EI
                RETI


HELLOWORLD:
               LD        HL,UEPMSG    
               CALL      CON_PRINT          
               HALT
               RET     

UEPMSG:       .BYTE   "UEP, COM ANAN?",CR,LF,0

CTCENABLEDMSG:  .BYTE    "PIT Enabled", CR,LF,0
UARTENABLEDMSG: .BYTE   "UART Enabled", CR,LF,0

               .end

