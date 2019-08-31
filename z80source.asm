;*********************************************
;* z80core.asm
;* Tomeu Capó

;             .ORG    $8000

RAMSTART:    .DS     1              ; RAM start adresse (256 test adr)
INT_COUNTER: .DS     1              ; Interrupt-counter
SER_ON:      .DS     1              ; serial on/off
UARTFEJL:    .DS     1              ;
SER_BAUD:    .DS     4

; PIO 82C55 I/O
PIO1A:       .EQU    0              ; (INPUT)  IN 1-8
PIO1B:       .EQU    1              ; (OUTPUT) OUT TO LEDS
PIO1C:       .EQU    2              ; (INPUT)
PIO1CONT:    .EQU    3              ; CONTROL BYTE PIO 82C55

; UART 16C550 SERIAL
UART0:       .EQU    $80            ; DATA IN/OUT
UART1:       .EQU    $81            ; CHECK RX
UART2:       .EQU    $82            ; INTERRUPTS
UART3:       .EQU    $83            ; LINE CONTROL
UART4:       .EQU    $84            ; MODEM CONTROL
UART5:       .EQU    $85            ; LINE STATUS
UART6:       .EQU    $86            ; MODEM STATUS
UART7:       .EQU    $87            ; SCRATCH REG.

SER_BUFSIZE     .EQU     3FH
serBuf          .EQU     $8000
serInPtr        .EQU     serBuf+SER_BUFSIZE
serRdPtr        .EQU     serInPtr+2
serBufUsed      .EQU     serRdPtr+2

;********************* CONSTANTS ****************************************
RAMTOP:      .EQU    $FFFF          ; 32Kb RAM   8000H-FFFFH

STR_TER:         .EQU    $FF            ; Mark END OF TEXT


;*******************************************************************
;*        START AFTER RESET,                                       *
;*        Function....: ready system and restart                   *
;*******************************************************************
             .ORG    0
             DI                    ; Disable interrupt             
			 JP     MAIN         ; jump to Start of program

             .byte " Z80 Phi Kernel "  ; text string in rom
             .byte " V 1.00 "
             .byte " 2019 "

;************************************************************************
;*        INTERRUPT-PROGRAM                                             *
;************************************************************************
             .ORG   $38            ; Int mode 1
             DI                    ; disable
             EXX                   ; IN THE INT ROUTINE, YOU ONLY USES
             EX     AF,AF'         ; THE EXTRA REGISTERS.

			 ;Start interrupt routine
			 CALL	UART_RX	
			 CALL	UART_TX
			 ;End interrupt routine

             EX     AF,AF'         ; BEFORE RETURN, SWITCH REGISTERS BACK
             EXX
             EI                    ; enable again
             RETI                  ; return from interrupt

             .ORG   $66           ; HERE IS THE NMI ROUTINE

             RETI

;*******************************************************************
;*        MAIN PROGRAM                                             *
;*******************************************************************
             .ORG   $100

MAIN:        LD     SP,RAMTOP      ; Set stack pointer to top off ram
			 CALL   INIT_PIO       ; programm the PIO
             ;CALL   INIT_UART      ; INIT AND TEST OF UART
			 ;IM     1              ; Set interrupt mode 1
             ;EI       
           
			 ;LD     HL,TXT_HELLO  
             ;CALL   PRINT_STRING  
			 
             LD     A,3
             OUT    (PIO1B),A    ; ALL BITS ON FOR 1 SEC..

             LD     BC,2000
             CALL   PAUSE

             LD     A,1
             OUT    (PIO1B),A    ; ALL BITS ON FOR 1 SEC..



MAIN_LOOP:	 LD     A,4
             OUT    (PIO1B),A    ; ALL BITS ON FOR 1 SEC..

             LD     BC,1000
             CALL   PAUSE

             LD     A,1
             OUT    (PIO1B),A

             LD     BC,1000
             CALL   PAUSE

             JP     MAIN_LOOP


;******************************************************************
;        INIT_UART                                                
;******************************************************************
INIT_UART:   LD     A,80H
             OUT    (UART3),A     ; SET DLAB FLAG (LINE CONTROL)
             LD     A,13        
             OUT    (UART0),A     ; Set BAUD rate 9600
             LD     A,00H
             OUT    (UART1),A     ; CHECK RX
             LD     A,03H
             OUT    (UART3),A     ; LINE CONTROL
			 LD	    A,$01
			 OUT    (UART1),A	; Enable receive data available interrupt only
			 
			 ; Init buffer
			 LD        HL,serBuf
             LD        (serInPtr),HL
			 XOR       A               ;0 to accumulator
             LD        (serBufUsed),A
			 
			 RET

UART_TX_RDY:
			PUSH 	AF
UART_TX_RDY_LP:			
			IN		A,(UART5)    	;Fetch the control register
			BIT 	5,A            	;Bit will be set if UART is ready to send
			JP		Z,UART_TX_RDY_LP		
			POP     AF
			RET

UART_TX:
			CALL  UART_TX_RDY
			OUT   (UART0),A
			RET
				
;***************************************************************************
; Check if UART is ready to receive
;***************************************************************************

UART_RX_RDY:
			PUSH 	AF
UART_RX_RDY_LP:			
			IN		A,(UART5)    	;Fetch the control register
			BIT 	0,A             ;Bit will be set if UART is ready to receive
			JP		Z,UART_RX_RDY_LP		
			POP     AF
			RET
	
;***************************************************************************
; Receive character in UART to A
;***************************************************************************

UART_RX:
			CALL  UART_RX_RDY
			IN    A,(UART0)
			RET			


PRINT_STRING:
			 LD		A,(HL)
             CP     STR_TER             ; Test for end byte
             JP     Z,END_PRINT_STRING  ; Jump if end byte is found
			 CALL   UART_TX
             INC    HL                  ; Increment pointer to next char
             JP     PRINT_STRING    	; Transmit loop
END_PRINT_STRING:
			 RET


;******************************************************************
;        INIT_PIO                                   
;******************************************************************
INIT_PIO:
             LD     A,10011001B    ; A= IN, B= OUT C= IN
             OUT    (PIO1CONT),A
             RET

BOUT:        ;LD     A,10000000B    ; A= OUT, B= OUT C= OUT (DATA TIL LCD)
             ;OUT    (PIO1CONT),A   ; if there are 2 PIO
             ;RET

BIN:    	 ;LD     A,10000010B    ; A= OUT, B= IN C= OUT  (DATA FRA LCD)
			 ;OUT    (PIO2CONT),A
			 ;RET

;******************************************************************
;        SUB-RUTINE..: PAUSE                                      ;
;        Function....: Pause in 100uS. times value in BC          ;
;        Input.......: BC reg                                     ;
;******************************************************************
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
			 
TXT_HELLO:  .BYTE " Phi Kernel 0.1 ",STR_TER




 ;  .include ctxt001.asm         ; YOU CAN INCLUDE OTHER ASM FILES AND USE-
                                 ; THE SUB ROUTINES FROM THEM.
 .text "\n\r  -END-OF-FILE-  \n\r"
 .end


