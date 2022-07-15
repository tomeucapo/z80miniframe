;;
;; ppi.asm
;; PPI Routines that initializes PPI 82C55
;;
;; Code are released under the therms of the GNU GPL License 3.0 and in the form of "as is", without no
;; kind of warranty: you can use them at your own risk.
;; You are free to use them for any non-commercial use: you are only asked to
;; maintain the copyright notices, include this advice and the note to the 
;; attribution of the original version to Tomeu Capó, if you intend to
;; redistribuite them.
;;

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
        IN	 A,(PIO1A)       ; Get 2 last bits switch state => B
        AND	 A,$0C
        RRA       
        RRA
        LD       B, A
        IN	 A,(PIO1A)       ; Get 2 first bits switch state => C
        AND	 A,$03
        LD       C, A
        RET

PPI_LED_BLINK::
        PUSH    AF
        PUSH    BC

        LD      A, 4
        OUT     (PIO1B), A
        LD      BC, 500
        CALL    PAUSE       
        LD      A, 8
        OUT     (PIO1B), A
        LD      BC, 500
        CALL    PAUSE       
        LD      A, 0
        OUT	(PIO1B), A

        POP     BC
        POP     AF
        RET                    

;;
;; PPI_SND_BYTE - Send byte to cassette via PPI Port C and D/A 6-bit conversor
;; Destroys HL, BC
;; A = Byte to send 
;;

PPI_SND_BYTE:: 
        LD  (CASLASTBYTE), A        ; Store byte to send
        LD  A, 1
        LD  (CASBITMASK), A         ; Reset bit mask
NEXTBIT:
        LD      HL, (TAPE_SINE_TAB)            
        LD      A, (CASLASTSINE)        ; Get last used SIN value
        OUT     (PIO1C), A              ; Sends to cassette

        LD A, (CASLASTBYTE)             ; Test bit 
	LD B, A
 	LD A, (CASBITMASK)
	AND B
	JR Z, SEND_LOW	

SEND_LOW:
        LD B, 36
SENDL:	LD  A, (HL)
        OUT (PIO1C), A
        INC HL
	DJNZ SENDL
        JR NEXT

SEND_HIGH:
        LD B, 18
SENDH:  LD  A, (HL)
        OUT (PIO1C), A
        INC HL
        INC HL
        DJNZ SENDH     	

NEXT: 	LD (CASLASTSINE), A
        LD A, (CASBITMASK)
	RLCA
	LD (CASBITMASK), A
	JR NC, NEXTBIT
	RET

.include "tape.inc"