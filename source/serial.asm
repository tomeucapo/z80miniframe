;;
;; serial.asm
;; Tomeu Capó
;;
;; Code and computer schematics are released under
;; the therms of the GNU GPL License 3.0 and in the form of "as is", without no
;; kind of warranty: you can use them at your own risk.
;; You are free to use them for any non-commercial use: you are only asked to
;; maintain the copyright notices, include this advice and the note to the 
;; attribution of the original version to Leonardo Miliani, if you intend to
;; redistribuite them.
;;

include "serial.inc"

    extern BUFF_INIT, BUFF_PUTC, BUFF_GETC

; UART_INIT - Initialize UART serial IC
;   L = Serial speed

UART_INIT:: 
    LD      A,80H
    OUT     (UART3),A           ; SET DLAB FLAG (LINE CONTROL)

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

    CALL    BUFF_INIT

    RET

; UART_READ - Read character if available and put into buffer
;   Return last readed character into register A

UART_READ::		
    IN		 A,(UART5)    	 ;Fetch the control register
	BIT 	 0,A
    RET      Z

    IN       A,(UART0)
    CALL     BUFF_PUTC
    RET

UART_TX_RDY:    
    PUSH 	AF
UART_TX_RDY_LP:	
    IN		A,(UART5)    	;Fetch the control register
	BIT 	5,A            	;Bit will be set if UART is ready to send
	JP		Z,UART_TX_RDY_LP		
	POP     AF
	RET

UART_WRITE::
    CALL  UART_TX_RDY
    OUT   (UART0),A
    RET

UART_GETCHAR::
    CALL BUFF_GETC
	RET 





; Baud lookup table based on SW connected to PA0..3 port
			 
BAUDTABLE:      .BYTE	 208		; 1200
                .BYTE	 104		; 2400
                .BYTE	 26		    ; 9600
                .BYTE	 13			; 19200