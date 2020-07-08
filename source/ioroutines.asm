;******************************************************************
; IO Routines
; Initialize 16650 UART and PIO 82C55A
; Tomeu Capó 2019                               
;******************************************************************

; UART 16C550 SERIAL
UART0:          .EQU    $10           ; DATA IN/OUT
UART1:          .EQU    $11           ; CHECK RX
UART2:          .EQU    $12           ; INTERRUPTS
UART3:          .EQU    $13           ; LINE CONTROL
UART4:          .EQU    $14           ; MODEM CONTROL
UART5:          .EQU    $15           ; LINE STATUS
UART6:          .EQU    $16           ; MODEM STATUS
UART7:          .EQU    $17           ; SCRATCH REG.

; PIO 82C55 I/O
PIO1A:       	.EQU    $00              ; (INPUT)  IN 1-8
PIO1B:       	.EQU    $01              ; (OUTPUT) OUT TO LEDS
PIO1C:       	.EQU    $02              ; (INPUT)
PIO1CONT:    	.EQU    $03              ; CONTROL BYTE PIO 82C55

; AY-3-8910
AYCTRL:         .EQU    $31 
AYDATA:         .EQU    $32

;**************************************************************
; General I/O Initialization
;**************************************************************

INIT_IO:        CALL INIT_PIO	

                LD        HL,serBuf         ; Setting up serial buffers	
                LD        (serInPtr),HL
                LD        (serRdPtr),HL
                XOR       A               
                LD        (serBufUsed),A

            
                CALL INIT_UART
                RET

;**************************************************************
; Init PIO 82C55
;**************************************************************

INIT_PIO:       LD      A,10011001B    ; A= IN, B= OUT C= IN
                OUT     (PIO1CONT),A

                LD      A, 4
                OUT     (PIO1B), A
                LD      BC, 500
                CALL    PAUSE

                LD      A, 8
                OUT     (PIO1B), A
                LD      BC, 500
                CALL    PAUSE

                LD      A,0
                OUT	    (PIO1B), A

                RET


;**************************************************************
; Init UART routine
;**************************************************************

INIT_UART:      LD      A,80H
                OUT     (UART3),A           ; SET DLAB FLAG (LINE CONTROL)

                IN		A,(PIO1A)           ; Get baud rate from SW1 4 firts bits of PA PIO Port
                AND	    A,$03
                LD		H, 0
                LD		L, A
                LD		DE, BAUDTABLE
                ADD     HL, DE
                LD      A,(HL)        
                OUT     (UART0),A            ; Set BAUD rate

                LD      A,00H
                OUT     (UART1),A            ; CHECK RX
                LD      A,03H
                OUT     (UART3),A            ; LINE CONTROL
                LD      A,$01
                OUT     (UART1),A            ; Enable receive data available interrupt only
                RET
			 
;**************************************************************
; Read character if available and put into buffer
;**************************************************************

READ_UART:		IN		 A,(UART5)    	 ;Fetch the control register
				BIT 	 0,A
                JR       Z,rts0          ; if not, ignore

				LD       A, 4
				OUT		 (PIO1B),A
				
				IN       A,(UART0)
                PUSH     AF
                LD       A,(serBufUsed)
                CP       SER_BUFSIZE     ; If full then ignore
                JR       NZ,notFull
                POP      AF
                JR       rts0

notFull:        LD       HL,(serInPtr)
                INC      HL
                LD       A,L             ; Only need to check low byte becasuse buffer<256 bytes
                CP       bufWrap
                JR       NZ, notWrap
                LD       HL,serBuf
notWrap:        LD       (serInPtr),HL
                POP      AF
                LD       (HL),A
                LD       A,(serBufUsed)
                INC      A
                LD       (serBufUsed),A
                CP       SER_FULLSIZE
                JR       C,rts0

				
rts0:           LD       A, 0
				OUT		 (PIO1B),A
				RET
				
;**************************************************************
; TX/RX Ready routines
;**************************************************************

UART_TX_RDY:    PUSH 	AF
UART_TX_RDY_LP:	IN		A,(UART5)    	;Fetch the control register
			    BIT 	5,A            	;Bit will be set if UART is ready to send
			    JP		Z,UART_TX_RDY_LP		
			    POP     AF
			    RET
			

UART_RX_RDY:    PUSH 	AF
UART_RX_RDY_LP:	IN		A,(UART5)    	;Fetch the control register
			    BIT 	0,A             ;Bit will be set if UART is ready to receive
			    JP		Z,UART_RX_RDY_LP		
			    POP     AF
			    RET

RXA:            LD       A,(serBufUsed)
                CP       $00
                JR       Z, RXA
                PUSH     HL
                LD       HL,(serRdPtr)
                INC      HL
                LD       A,L             ; Only need to check low byte becasuse buffer<256 bytes
                CP       bufWrap
                JR       NZ, notRdWrap
                LD       HL,serBuf
notRdWrap:      DI
                LD       (serRdPtr),HL
                LD       A,(serBufUsed)
                DEC      A
                LD       (serBufUsed),A
                CP       SER_EMPTYSIZE
rts1:
                LD       A,(HL)
                EI
                POP      HL
                RET                      ; Char ready in A
				
				
TXA:            CALL  UART_TX_RDY
				OUT   (UART0),A
                RET

GET_CHAR:	    CALL  RXA
				AND   11011111b
				RET

			
CKINCHAR        LD       A,(serBufUsed)
                CP       $0
                RET

PRINT_CHAR:		CALL  TXA
				RET
				
PRINT_NEW_LINE:	LD    A,CR
				CALL  TXA
				LD    A,LF
				CALL  TXA
				RET

PRINT:          LD       A,(HL)          ; Get character
                OR       A               ; Is it $00 ?
                RET      Z               ; Then RETurn on terminator
                RST      08H             ; Print it
                INC      HL              ; Next Character
                JR       PRINT           ; Continue until $00
                RET

;**************************************************************
; Sound generator register/data control
;**************************************************************

AYREGWRITE:     PUSH       BC
                OUT (AYCTRL), A
                POP        BC
                LD         A, C
                OUT (AYDATA), A
                RET

; Baud lookup table based on SW connected to PA0..3 port
			 
BAUDTABLE:      .BYTE	 208		; 1200
                .BYTE	 104		; 2400
                .BYTE	 26		    ; 9600
                .BYTE	 13			; 19200