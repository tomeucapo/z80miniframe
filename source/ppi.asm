include "globals.inc"
include "ppi.inc"

        extern PAUSE
                
;; PPI_INIT
;;      Init PIO 82C55
;;

PPI_INIT::                     
        LD      A,10010000B    ; A=IN, B=OUT C=OUT (default)
        LD      (PPI_CONF),A   ; Save configuration into RAM         
        OUT     (PIO1CONT),A
        RET

;; PPI_PBIN
;;     Configure PORTB as output

PPI_PBIN::
        PUSH    AF
        LD      A, (PPI_CONF)
        OR      PBIN
        OUT     (PIO1CONT),A        
        POP     AF
        RET

;; PPI_PBOUT
;;     Configure PORTB as output

PPI_PBOUT::
        PUSH    AF
        LD      A, (PPI_CONF)
        AND     PBOUT
        OUT     (PIO1CONT),A        
        POP     AF
        RET

;**************************************************************
; Get configuration switch states
;   B = LSB switches (2,3)
;   C = MSB switches (0,1)

PPI_GETSWSTATE::
        IN	    A,(PIO1A)       ; Get 2 last bits switch state => B
        AND	    A,$0C
        RRA       
        RRA
        LD       B, A
        IN		A,(PIO1A)       ; Get 2 first bits switch state => C
        AND	    A,$03
        LD       C, A
        RET

PPI_LED_BLINK::
        LD      A, 4
        OUT     (PIO1B), A
        LD      BC, 500
        CALL    PAUSE       
        LD      A, 8
        OUT     (PIO1B), A
        LD      BC, 500
        CALL    PAUSE       
        LD      A, 0
        OUT	    (PIO1B), A
        RET                    