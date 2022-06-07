;******************************************************************
; Firmware main code
; Tomeu Capó 2022                     
;******************************************************************

include "globals.inc"
include "ppi.inc"
include "svcroutine.inc"

                extern SVC_ROUTINE
                extern UART_INIT, UART_READ, UART_WRITE, BUFF_GETC, BUFF_CKINCHAR
                extern PPI_INIT, PPI_GETSWSTATE, PPI_LED_BLINK
                extern CTC_INIT
                extern CON_PRINT, VDP_PUTCHAR, MON_WELCOM, BASIC_INIT
                extern PSG_INIT, CHIMPSOUND, PSG_LED_BLINK
                extern VDP_CUR_BLINK, KB_READKEY

                .ORG $0000

                DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

;------------------------------------------------------------------------------
; Put character to output (VDP and serial console)

                .ORG     $0008

                DI
                CALL     VDP_PUTCHAR
                EI
                JP       UART_WRITE
                      
                
;------------------------------------------------------------------------------
; Get character for buffer if is available

                .ORG    $0010
                JP      BUFF_GETC           

;------------------------------------------------------------------------------
; Check if any character into buffer are available

                .ORG    $0018
                JP      BUFF_CKINCHAR 

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

                PUSH     AF
                PUSH     HL

		CALL	 UART_READ
                ;CALL     VDP_CUR_BLINK

		POP      HL
                POP      AF
                EI
                RETI

;------------------------------------------------------------------------------
; NMI Interrupt vector

                .ORG    $0066
                EX AF, AF'
                EXX

                NOP             ; TODO

                EXX
                EX AF, AF'            
                EI
                RETN

;------------------------------------------------------------------------------
; Main code

INIT:            
               LD       HL,TEMPSTACK            ; Set up a temporary stack
               LD       SP,HL               

               CALL	 PPI_INIT               ; Initialize PPI
               CALL      PPI_GETSWSTATE         ; Get dipswitches configuration for UART speed
               
               LD        H, 0   
               LD	 L, C
               CALL      UART_INIT              ; Initialize UART at C speed

               PUSH      BC
               CALL      PSG_INIT
               POP       BC
               
               LD        A, B
               LD        (ENABLECTC), A         ; Check if CTC are disabled or not
               CP        0
               JR        Z, WITHOUT_CTC

               CALL      CTC_INIT               ; Initialize CTC

WITHOUT_CTC:              
               CALL      PPI_LED_BLINK          ; PPI LED Hello world welcome
               CALL      CHIMPSOUND             ; Welcome sound

               IM   1                           ; Enable interrupt mode 1
               EI                          

               LD        E, 0                   ; VDP Set video text mode
               LD        B, VDMODE
               RST       $20
                                       
               CALL      MON_WELCOM

               LD        A, (ENABLECTC)         ; If CTC is initialized print to string CTC Enabled
               CP        0
               JR        Z, MAIN_LOOP

               LD        HL,CTCENABLEDMSG    
               CALL      CON_PRINT               
MAIN_LOOP:
               LD        A, 'N'
               LD        (basicStarted),A        
               CALL      BASIC_INIT

CTCENABLEDMSG: .BYTE    "CTC Enabled", CR,LF,0

                .end

