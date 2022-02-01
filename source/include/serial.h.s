;;
;; Serial interface declarations
;;

; UART 16C550 SERIAL
UART0          .EQU    0x10           ; DATA IN/OUT
UART1          .EQU    0x11           ; CHECK RX
UART2          .EQU    0x12           ; INTERRUPTS
UART3          .EQU    0x13           ; LINE CONTROL
UART4          .EQU    0x14           ; MODEM CONTROL
UART5          .EQU    0x15           ; LINE STATUS
UART6          .EQU    0x16           ; MODEM STATUS
UART7          .EQU    0x17           ; SCRATCH REG.


; Speed values
BAUD1200     .EQU	 208		; 1200
BAUD2400     .EQU	 104		; 2400
BAUD9600     .EQU	 26		    ; 9600
BAUD19200    .EQU	 13	        ; 19200

RTS_LOW      .EQU    0b00000000
RTS_HIGH     .EQU    0b00000010


.globl UART_INIT, UART_READ_CHAR, UART_WRITE_CHAR, UART_PRINT, UART_GET_SPEED, UART_BUFFER_DATA_READY, UART_BUFFER_GETCHAR