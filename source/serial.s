.include "globals.h.s"
.include "serial.h.s"

.area _DATA
.area _CODE

;;
;; UART_INIT
;;        A = Speed value
;;
UART_INIT::         
    PUSH    BC

    LD      C, A
    LD      A,#0x80
    OUT     (UART3),A           ; SET DLAB FLAG (LINE CONTROL)
    
    LD      A, C
    OUT     (UART0),A            ; Set BAUD rate to 19200

    LD      A, #0
    OUT     (UART1),A            ; CHECK RX
    LD      A, #3
    OUT     (UART3),A            ; LINE CONTROL
    LD      A, #1
    OUT     (UART1),A            ; Enable receive data available interrupt only
    
    LD      A, #RTS_LOW  
    OUT     (UART4), A

    POP     BC
    RET

UART_READ_CHAR::
    CALL    UART_RX_RDY
    IN      A, (UART0)
    CALL    BUFFER_PUTCHAR
    RET

UART_WRITE_CHAR::
    CALL  UART_TX_RDY
	OUT   (UART0),A
    RET

UART_TX_RDY:    
    PUSH 	AF
UART_TX_RDY_LP:	
    IN		A, (UART5)      	
	BIT 	5, A            	
	JP		Z, UART_TX_RDY_LP	
	POP     AF
	RET

UART_RX_RDY:    
    PUSH 	AF
UART_RX_RDY_LP:	
    IN		A, (UART5)    
	BIT 	0, A          
	JP		Z, UART_RX_RDY_LP		
	POP     AF
	RET

UART_PRINT::          
    LD       A,(HL)          ; Get character
    OR       A               ; Is it $00 ?
    RET      Z               ; Then RETurn on terminator
    CALL     UART_WRITE_CHAR
    INC      HL              ; Next Character
    JR       UART_PRINT      ; Continue until $00
    RET

UART_GET_SPEED::
    LD		DE, #UART_BAUDTABLE
    ADD     HL, DE
    LD      A,(HL)    
    RET

;;
;;  Put received character into circular buffer
;;      A = Character to put
BUFFER_PUTCHAR:
    PUSH    AF
    LD      A, (SERIAL_BUFF_USED)
    CP      #SER_BUFSIZE
    JR      NZ, BUFF_NOT_FULL
    POP     AF
    RET
BUFF_NOT_FULL:
    LD      HL, (SERIAL_IN_PTR)
    INC     HL
    LD      A, L
    CP      #SERIAL_BUFF_WRAP
    JR      NZ, BUFF_NOT_WRAP
    LD      HL, #SERIAL_BUFFER       ; Restar buffer pointer to start
BUFF_NOT_WRAP:
    LD      (SERIAL_IN_PTR), HL     ; Save IN Buffer pointer
    POP     AF                      ; Get character to write to buffer
    LD      (HL), A                 ; Write character to buffer
    PUSH    AF
    LD      A, (SERIAL_BUFF_USED)
    INC     A
    LD      (SERIAL_BUFF_USED), A
    CP      #SER_FULLSIZE	
    JR      C, BUFF_PUTC_END
    LD      A, #RTS_HIGH
    OUT     (UART4), A
BUFF_PUTC_END:    
    POP     AF
    RET


UART_BUFFER_DATA_READY::
    LD      A, (SERIAL_BUFF_USED)
    CP      #0
    RET

;;
;;  Get first character from buffer
;;    A = Character
;;

UART_BUFFER_GETCHAR::
    PUSH    HL
WAITING_FOR_CHARACTER:
    CALL    UART_BUFFER_DATA_READY
    JR      Z, WAITING_FOR_CHARACTER
    LD      HL, (SERIAL_RD_PTR)
    INC     HL
    LD      A, L
    CP      #SERIAL_BUFF_WRAP
    JR      NZ, BUFF_NOT_WRAP_RD
    LD      HL, #SERIAL_BUFFER
BUFF_NOT_WRAP_RD:
    DI
    LD      (SERIAL_RD_PTR), HL
    LD      A, (SERIAL_BUFF_USED)
    DEC     A
    LD      (SERIAL_BUFF_USED), A
    CP      #SER_EMPTYSIZE
    JR      NC, BUFFER_GETCHAR_END
    LD      A, #RTS_LOW
    OUT     (UART4), A
BUFFER_GETCHAR_END:
    LD      A, (HL)
    EI  
    POP     HL
    RET



UART_BAUDTABLE:
    .db     BAUD1200, BAUD2400, BAUD9600, BAUD19200
