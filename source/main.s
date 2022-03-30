;;
;; core.s
;; Core main code of firmware
;;

.include "pio.h.s"       
.include "serial.h.s"       
.include "vdp.h.s"
.include "psg.h.s"
.include "common.h.s"   

.area HEAD (ABS)

.org 0x08
    jp print_char

.org 0x10
    jp read_char

.org 0x18
    jp UART_BUFFER_DATA_READY

.org 0x38
    jp int_handler

.area _DATA
.area _CODE
    
; Get character from buffer
read_char:
    CALL    UART_BUFFER_GETCHAR  
    EI
    RETI

; Put character
print_char:
    CALL    UART_WRITE_CHAR 
    EI
    RETI

; Main interrupt handler (Read character from UART)    
int_handler:
    PUSH    AF
    PUSH    HL
    
    CALL    UART_READ_CHAR    
    CALL    UART_WRITE_CHAR
    CALL    VDP_PUTCHAR
    
    POP     HL
    POP     AF
    EI
    RETI

; Main code of firmware

_main::    
    CALL    PIO_INIT
    CALL    SERIAL_INIT

    ld      E, #0
    CALL    VDP_INIT

    im      1
    ei

    call    PSG_CHIMPSOUND

    ld      hl, #hellomessage
    call    UART_PRINT

    LD      HL, #hellomessage
    call    VDP_PRINT

led_blink_loop:
    LD      A, #4
    OUT     (PIO1B), A

    LD      BC, #1000
    CALL    PAUSE  

    LD      A, #8
    OUT     (PIO1B), A
    
    LD      BC, #1000
    CALL    PAUSE
    
    jp      led_blink_loop


SERIAL_INIT:
    ; Read dip switches baud configuration
    CALL    PIO_GETSWSTATE
    LD		H, #0
    LD		L, C

    ; Configure UART
    CALL    UART_GET_SPEED
    CALL    UART_INIT
    RET

hellomessage:
    .db 12
    .ascii     "Z80 Miniframe v2.0"
    .db 0x0a, 0x0d, 0