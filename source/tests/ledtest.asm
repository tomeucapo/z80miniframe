CH0         .EQU 0FF00h

            .ORG $0000
            JP INIT

            .ORG $0038
            EX AF, AF'
            EXX

            EXX
            EX AF, AF'
            RETI

            .ORG $0100
            
INIT:       LD SP, 0xffff        ; set the stack pointer to top of RAM
            IM 1
            EI

MAIN:       LD  B, 15

LOOP:       LD A, B

            LD  BC, CH0
            OUT (C), A

            LD B, A
            DJNZ LOOP
            JP MAIN


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