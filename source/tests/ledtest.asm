; PIO 82C55 I/O
PIO1A:       	.EQU    $00              ; (INPUT)  IN 1-8
PIO1B:       	.EQU    $01              ; (OUTPUT) OUT TO LEDS
PIO1C:       	.EQU    $02              ; (INPUT)
PIO1CONT:    	.EQU    $03              ; CONTROL BYTE PIO 82C55

            .ORG $0000
            JP INIT

            .ORG $0038
            EX AF, AF'
            EXX
            
            NOP

            EXX
            EX AF, AF'
            RETI

            .ORG $0100
            
INIT:       LD SP, 0xffff        ; set the stack pointer to top of RAM
            IM 1
            EI

MAIN:       LD      A,10010000B    ; A=IN, B=OUT C=OUT 10010001
            OUT     (PIO1CONT),A

LOOP:       LD      A, 4
            OUT     (PIO1B), A
            LD      BC, 500
            CALL    PAUSE

            LD      A, 8
            OUT     (PIO1B), A
            LD      BC, 500
            CALL    PAUSE
            JP      MAIN


PAUSE:       PUSH   AF
             INC    B
             INC    C              ; ADJUST THE LOOP
PAUSELOOP1:  LD     A,13H          ; ADJUST THE TIME 13h IS FOR 4 MHZ
PAUSELOOP2:  DEC    A              ; DEC COUNTER. 4 T-states = 1 uS.
             JP     NZ,PAUSELOOP2  ; JUMP TO PAUSELOOP2 IF A <> 0.
             DEC    C              ; DEC COUNTER
             JP     NZ,PAUSELOOP1  ; JUMP TO PAUSELOOP1 IF C <> 0.

             DJNZ   PAUSELOOP1     ; JUMP TO PAUSELOOP1 IF B <> 0.
PAUSESLUT:   POP    AF
             RET