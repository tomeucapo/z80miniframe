
; label defining for CTC
CH0         .EQU $0100      ;00010000b
CH1         .EQU $0101      ;00010001b
CH2         .EQU $0102      ;00010010b
CH3         .EQU $0103      ;00010011b

; labels defining for PIO
DATAREGA    .EQU $0120
DATAREGB    .EQU $0121      ;00000001b
CTRLREGA    .EQU $0122      ;equ 00000010b
CTRLREGB    .EQU $0123      ;equ 00000011b

; PIO 82C55 I/O
PIO1A:       	.EQU    $00              ; (INPUT)  IN 1-8
PIO1B:       	.EQU    $01              ; (OUTPUT) OUT TO LEDS
PIO1C:       	.EQU    $02              ; (INPUT)
PIO1CONT:    	.EQU    $03              ; CONTROL BYTE PIO 82C55

RAMCELL     .EQU $8000

;--------------------------------------------------
reset:  ; this corresponds to the RESET vector (the CPU jumps to 0000h after a reset)

        jp MAIN

        ; interrupt vector for CH2 Timer
        org 14h
        defw CH2_TIMER

;---------------------------------------------------
; Main code
        org 0100h           ; main code starts at $0100
MAIN:
        ld sp,0xffff        ; set the stack pointer to top of RAM

        ld d,0x80
        call delay          ; little delay

        call SET_CTC        ; set the CTC

        LD      A,10010000B    ; A=IN, B=OUT C=OUT 10010001
        OUT     (PIO1CONT),A

        LD      A, 4
        OUT     (PIO1B), A
        ld d,0xA0
        call delay          ; little delay


        LD      A, 8
        OUT     (PIO1B), A
        ld d,0xA0
        call delay          ; little delay


        LD      A, 0
        OUT	    (PIO1B), A

        xor a,a             ; clear reg. A
        OUT  (PIO1B), A

        ld i,a              ; set most significant bits of interrupt vector to $0000
        ld (RAMCELL),a      ; reset the seconds' counter into RAM
        im 2                ; interrupt mode 2
        ei                  ; enable interrupts

DO_NOTHING:                 ; this is the main loop: the CPU simply does nothing...
        ld d,0x80
        call delay
        jp DO_NOTHING

;-------------------------------------------------
; Interrupt service routine (ISR) for CH2 timer
CH2_TIMER:
        di                  ; disable interrupts
        push af             ; save reg. A
        ld a,(RAMCELL)      ; load the timer from RAM
        inc a               ; increment it
        ld (RAMCELL),a      ; write the new value
        OUT  (PIO1B), A
        pop af              ; recover reg. A
        ei                  ; re-enable interrupts
        reti                ; exit from ISR

;-------------------------------------------------
SET_CTC:
;init CH0 & CH3
;CH0 & CH3 disabled
        ld a,00000011b      ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                            ; start timer on loading constant, no time constant follows, software reset, command word
        
        LD BC, CH0
        out (C), A         ; CH0 doesn't run
        
        LD BC, CH3
        out (C), A         ; CH3 doesn't run

;init CH1
;CH1 divides CPU CLK by (256*256) providing a clock signal at TO1. TO1 is connected to TRG2.
;T01 outputs f= CPU_CLK/(256*256) => 3.68MHz / ( 256 * 256 ) => 56.15Hz
        ld a,00100111b      ; interrupt off; timer mode; prescaler=256; don't care ext; automatic trigger;
                            ; time constant follows; cont. operation; command word
        
        LD BC, CH1
        OUT (C), A
        LD A, 0x00           ; time constant - 0 stands for 256
        
        LD BC, CH1
        OUT (C), A

;init CH2
;CH2 divides CLK/TRG2 clock providing a clock signal at TO2.
; T02 outputs f= CLK/TRG / 56 => 56.15Hz / 56 => 1.002Hz ~ 1s
        ld a,11000111b      ; interrupt on, counter mode, prescaler=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows,sw reset, command word
        
        LD BC, CH2
        out (C),a
        ld a,0x38           ; time constant 56d

        LD BC, CH2
        out (C),a         ; loaded into channel 2
        ld a,00010000b      ; D7..D3 provide the first part of the int vector (in our case, $10), followed by
                            ; D2..D1, provided by the CTC (they point to the channel), d0=interrupt word
        LD BC, CH0
        out (C),a         ; send to CTC

;-------------------------------------------------
;program the PIO
SET_PIO:
        ld a,11001111b      ; mode 3 (bit control)
        LD BC, CTRLREGB
        out (C),a
        ld a,00000000b      ; set pins of port B to OUTPUT
        LD BC, CTRLREGB
        out (C),a
        ret

;-------------------------------------------------
delay:                      ; routine to add a programmable delay (set by value stored in D)
        push bc
loop1:
        ld b,0xff
loop2:
        djnz loop2
        dec d
        jp nz, loop1
        pop bc
        ret