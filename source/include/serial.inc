
;; UART 16C550 SERIAL Addresses

ifdef Z80AIO

UART0          .EQU    $0020           ; DATA IN/OUT
UART1          .EQU    $0021           ; CHECK RX
UART2          .EQU    $0022           ; INTERRUPTS
UART3          .EQU    $0023           ; LINE CONTROL
UART4          .EQU    $0024           ; MODEM CONTROL
UART5          .EQU    $0025           ; LINE STATUS
UART6          .EQU    $0026           ; MODEM STATUS
UART7          .EQU    $0027           ; SCRATCH REG.

endif

ifdef Z80FRAME

UART0          .EQU    $0010           ; DATA IN/OUT
UART1          .EQU    $0011           ; CHECK RX
UART2          .EQU    $0012           ; INTERRUPTS
UART3          .EQU    $0013           ; LINE CONTROL
UART4          .EQU    $0014           ; MODEM CONTROL
UART5          .EQU    $0015           ; LINE STATUS
UART6          .EQU    $0016           ; MODEM STATUS
UART7          .EQU    $0017           ; SCRATCH REG.

endif

