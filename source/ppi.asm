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
include "tape.inc"

        extern PAUSE
                
;; PPI_INIT
;;      Init PIO 82C55
;;

PPI_INIT::                     
        LD      A,10010000B    ; A=IN, B=OUT C=OUT (default)
        LD      (PPI_CONF),A   ; Save configuration into RAM         
        OUT     (PIO1CONT),A
        XOR     A
        LD      (CASMOT),A
        OUT     (PIO1C),A      ; Ensure cassette relay is off at startup
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
        IN	 A,(SW_PORT)       ; Get 2 last bits switch state => B
        AND	 A,$0C
        RRA       
        RRA
        LD       B, A
        IN	 A,(SW_PORT)       ; Get 2 first bits switch state => C
        AND	 A,$03
        LD       C, A
        RET

PPI_LED_BLINK::
        PUSH    AF
        PUSH    BC

        LD      A, LED_PIN_1
        CALL    PPI_LWRT
        
        LD      BC, 500
        CALL    PAUSE       

        LD      A, LED_PIN_2
        CALL    PPI_LWRT
        
        LD      BC, 500
        CALL    PAUSE       
        
        LD      A, 0
        CALL    PPI_LWRT

        POP     BC
        POP     AF
        RET                    

; Write the LED port without disturbing the cassette relay. On Z80AIO
; the relay shares PC1 with LED2, so LED2 is suppressed when the motor is off.
PPI_LWRT::
        PUSH    AF
        PUSH    BC
        LD      B,A
        ifdef Z80AIO
        LD      A,(CASMOT)
        OR      A
        LD      A,B
        JR      Z,LED_NO_MOTOR
        OR      CASMMSK
        JR      LED_WRITE
LED_NO_MOTOR:
        AND     $FD
LED_WRITE:
        endif
        ifdef Z80FRAME
        LD      A,B
        endif
        OUT     (LED_PORT),A
        POP     BC
        POP     AF
        RET

; Cassette relay control. PC1 is independent of the PA4 input.
CASMON::
        LD      A,CASMMSK
        LD      (CASMOT),A
        OUT     (PIO1C),A
        RET

CASMOF::
        XOR     A
        LD      (CASMOT),A
        OUT     (PIO1C),A
        RET

;;
;; PPI_SND_BYTE - Send byte to cassette via PPI Port C and D/A 6-bit conversor
;; Destroys HL, BC
;; A = Byte to send 
;;

PPI_SND_BYTE:: 
        LD  (CASLASTBYTE), A            ; Store byte to send
        LD  A, (CASMOT)                 ; Keep relay asserted on PC1
        LD  C, A
        LD  A, 1
        LD  (CASBITMASK), A             ; Reset bit mask
NEXTBIT:
        LD  HL, TAPE_SINE_TAB
        LD   A, (CASLASTSINE)        ; Get last used SIN value
        OR   C
        OUT  (CAS_PORT_OUT), A              ; Sends to cassette

        LD A, (CASLASTBYTE)             ; Test bit 
	LD B, A
 	LD A, (CASBITMASK)
	AND B
	JR Z, SEND_LOW
	JR SEND_HIGH

SEND_LOW:
        LD B, 36
SENDL:	LD  A, (HL)
        OR  C
        OUT (CAS_PORT_OUT), A
        INC HL
	DJNZ SENDL
        JR NEXT

SEND_HIGH:
        LD B, 18
SENDH:  LD  A, (HL)
        OR  C
        OUT (CAS_PORT_OUT), A
        INC HL
        INC HL
        DJNZ SENDH     	

NEXT:   AND $FD                       ; Do not retain the relay bit in waveform state
        LD (CASLASTSINE), A
        LD A, (CASBITMASK)
	RLCA
	LD (CASBITMASK), A
	JR NC, NEXTBIT
	RET

;;
;; Cassette input receiver
;; The LM393 output is connected to PA4. Bits are represented by one
;; complete waveform cycle: short periods are 1 and long periods are 0.
;;

; PPI_RPER - Acquire/measure one full input waveform period.
; Returns A = polling-loop count, carry set on timeout.
PPI_RPER::
        LD      A,(CRRSYNC)
        OR      A
        JR      NZ, RPER_MEASURE

        ; First acquire a rising edge, with a bounded wait for tape activity.
        LD      C,4
        LD      HL,$FFFF
RPER_WAIT_LOW:
        IN      A,(CAS_PORT_IN)
        AND     CAS_INPUT_MASK
        JR      Z,RPER_WAIT_HIGH
        DEC     HL
        LD      A,H
        OR      L
        JR      NZ,RPER_WAIT_LOW
        DEC     C
        JR      Z,RPER_NO_EDGE
        LD      HL,$FFFF
        JR      RPER_WAIT_LOW
RPER_NO_EDGE:
        SCF
        RET
RPER_WAIT_HIGH:
        LD      C,4
        LD      HL,$FFFF
RPER_WAIT_HIGH_LOOP:
        IN      A,(CAS_PORT_IN)
        AND     CAS_INPUT_MASK
        JR      NZ,RPER_LOCKED
        DEC     HL
        LD      A,H
        OR      L
        JR      NZ,RPER_WAIT_HIGH_LOOP
        DEC     C
        JR      Z,RPER_NO_RISE
        LD      HL,$FFFF
        JR      RPER_WAIT_HIGH_LOOP
RPER_NO_RISE:
        SCF
        RET
RPER_LOCKED:
        LD      A,1
        LD      (CRRSYNC),A

RPER_MEASURE:
        LD      C,0
RPER_FALL:
        IN      A,(CAS_PORT_IN)
        AND     CAS_INPUT_MASK
        JR      Z,RPER_RISE
        INC     C
        JR      NZ,RPER_FALL
        SCF
        RET
RPER_RISE:
        IN      A,(CAS_PORT_IN)
        AND     CAS_INPUT_MASK
        JR      NZ,RPER_DONE
        INC     C
        JR      NZ,RPER_RISE
        SCF
        RET
RPER_DONE:
        LD      A,C
        OR      A                       ; Clear carry
        RET

; PPI_RCAL - Calibrate from the alternating 0/1 cassette leader.
; Returns carry set if there is no usable two-tone signal.
PPI_RCAL::
        XOR     A
        LD      (CRRSYNC),A
        LD      (CRRMAX),A
        LD      (CRRTHR),A
        LD      (CRRVAL),A
        LD      A,$FF
        LD      (CRRMIN),A
        LD      B,16
RCAL_SAMPLE:
        PUSH    BC
        CALL    PPI_RPER
        POP     BC
        RET     C
        LD      (CRRVAL),A
        LD      D,A
        LD      A,(CRRMIN)
        CP      D
        JR      C,RCAL_NOT_MIN
        LD      A,D
        LD      (CRRMIN),A
RCAL_NOT_MIN:
        LD      A,(CRRMAX)
        CP      D
        JR      NC,RCAL_NOT_MAX
        LD      A,D
        LD      (CRRMAX),A
RCAL_NOT_MAX:
        DJNZ    RCAL_SAMPLE

        ; Reject a constant/noisy input; the leader must contain both tones.
        LD      A,(CRRMIN)
        LD      E,A
        LD      A,(CRRMAX)
        SUB     E
        CP      3
        JR      C,RCAL_ERROR
        LD      A,(CRRMIN)
        LD      E,A
        LD      A,(CRRMAX)
        ADD     E
        SRL     A
        LD      (CRRTHR),A
        OR      A                       ; Clear carry
        RET
RCAL_ERROR:
        SCF
        RET

; PPI_RBIT - Read one tone-coded bit using the calibrated threshold.
; Returns A = 0/1, carry set on timeout.
PPI_RBIT::
        CALL    PPI_RPER
        RET     C
        LD      B,A
        LD      A,(CRRTHR)
        CP      B
        LD      A,0
        JR      C,RBIT_LONG
        INC     A                       ; Short period = logical one
RBIT_LONG:
        OR      A                       ; Clear carry
        RET

; PPI_RCV_BYTE - Read eight serial bits, least-significant bit first.
; DE is preserved; carry set indicates loss of input/timing.
PPI_RCV_BYTE::
        PUSH    DE
        LD      B,8
        LD      C,0
        LD      D,1
RCV_BYTE_BIT:
        PUSH    BC
        CALL    PPI_RBIT
        POP     BC
        JR      C,RCV_BYTE_ERROR
        OR      A
        JR      Z,RCV_BYTE_ZERO
        LD      A,C
        OR      D
        LD      C,A
RCV_BYTE_ZERO:
        SLA     D
        DJNZ    RCV_BYTE_BIT
        LD      A,C
        POP     DE
        OR      A                       ; Clear carry
        RET
RCV_BYTE_ERROR:
        POP     DE
        SCF
        RET
