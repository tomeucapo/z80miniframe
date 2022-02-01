
.include "pio.h.s"

.area _DATA
.area _CODE

;**************************************************************
; Initialize PIO 

PIO_INIT::
    LD      A, #0x90   
    OUT     (PIO1CONT),A
  
    LD      A, #0
    OUT	    (PIO1B), A
    RET


;**************************************************************
; Get configuration switch states
;   B = LSB switches (2,3)
;   C = MSB switches (0,1)

PIO_GETSWSTATE::
    IN	    A, (PIO1A)       ; Get 2 last bits switch state => B
    AND	    A, #0x0C
    RRA       
    RRA
    LD       B, A
    IN		 A,(PIO1A)       ; Get 2 first bits switch state => C
    AND	     A, #3
    LD       C, A
    RET