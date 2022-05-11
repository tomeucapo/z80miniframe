;;
;; core.s
;; Main code of firmware
;;

.include "pio.h.s"       
.include "serial.h.s"       
.include "vdp.h.s"
.include "psg.h.s"
.include "common.h.s"   
.include "monitor.h.s"
.include "serviceroutine.h.s"

.area HEAD (ABS)

.org 0x00
    di
    jp _main

.org 0x08
    jp print_char

.org 0x10
    jp read_char

.org 0x18
    jp UART_BUFFER_DATA_READY

.org 0x20
    jp SVC_DISPATCH_ROUTINE

.org 0x38
    jp INT_HANDLER

.area _DATA
.area _CODE

; Main code of firmware

_main::    
    CALL    PIO_INIT   
    CALL    SERIAL_INIT
    CALL    LED_BLINKING

    LD      E, #0
    CALL    VDP_INIT

    CALL    PSG_INIT

    IM      1
    EI

    JP    MON_INIT

LED_BLINKING:
    LD      A, #4
    OUT     (PIO1B), A
    LD      BC, #500
    CALL    PAUSE

    LD      A, #8
    OUT     (PIO1B), A
    LD      BC, #500
    CALL    PAUSE

    LD      A, #0
    OUT	    (PIO1B), A
    RET     


SERIAL_INIT:
    ; Read dip switches baud configuration
    CALL    PIO_GETSWSTATE
    LD		H, #0
    LD		L, C

    ; Configure UART
    CALL    UART_GET_SPEED
    CALL    UART_INIT
    RET

; Get character from buffer
read_char:
    CALL    UART_BUFFER_GETCHAR  
    EI
    RETI

; Put character
print_char:
    CALL    UART_WRITE_CHAR 
    CALL    VDP_PUTCHAR
    EI
    RETI

; Main interrupt handler (Read character from UART)    
INT_HANDLER:
    DI

    PUSH    AF
    PUSH    HL
    
    CALL    UART_READ_CHAR    
    
    POP     HL
    POP     AF
    EI
    RETI
