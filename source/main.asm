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
                extern VDP_INIT, VDP_SETPOS, VDP_SETCOLOR, VDP_PUTCHAR, VDP_BLINK_CURSOR
                extern CON_PRINT, MON_WELCOM, BASIC_INIT

                .ORG $0000

                DI                       ;Disable interrupts
                JP       INIT            ;Initialize Hardware and go

;------------------------------------------------------------------------------
; Put character to output (VDP and serial console)

                .ORG     0008H

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
				
		POP      HL
                POP      AF
                EI
                RETI

;------------------------------------------------------------------------------
; NMI Interrupt vector

                .ORG    $0066
                EX AF, AF'
                EXX

;                CALL     KBD_SCAN
                
;                LD A, (ENABLECTC)
;                CP 0
;                JR Z, EXITNMI

;                LD A, (ENABLEDCURSOR)
;                CP 0
;                JR Z, EXITNMI

;                CALL    LEDBLINK
;                CALL    VDP_BLINK_CURSOR       
; EXITNMI:      
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

               LD        A, B
               LD        (ENABLECTC), A         ; Check if CTC are disabled or not
               CP        0
               JR        Z, WITHOUT_CTC

               CALL      CTC_INIT               ; Initialize CTC

WITHOUT_CTC:              
               CALL      PPI_LED_BLINK          ; LED Hello world welcome

               IM   1                           ; Enable interrupt mode 1
               EI                          

               LD        E, 0                   ; VDP Set video text mode
               LD        B, VDMODE
               RST       $20
                                       
               LD        A, (ENABLECTC)         ; If CTC is initialized print to string CTC Enabled
               CP        0
               JR        Z, MAIN_LOOP

               LD        HL,CTCENABLEDMSG    
               CALL      CON_PRINT
               
MAIN_LOOP:
               LD        A, 'N'
               LD        (basicStarted),A
        
               CALL      MON_WELCOM
               CALL      BASIC_INIT
;LOOP:                
;	       CALL      KBD_SCAN
;              JR        LOOP

CTCENABLEDMSG: .BYTE    "CTC Enabled", CR,LF,0


