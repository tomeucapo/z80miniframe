.area _DATA
.area _CODE

PAUSE::      PUSH   AF
             INC    B
             INC    C              ; ADJUST THE LOOP
PAUSELOOP1:  LD     A, #0x13          ; ADJUST THE TIME 13h IS FOR 4 MHZ
PAUSELOOP2:  DEC    A              ; DEC COUNTER. 4 T-states = 1 uS.
             JP     NZ, PAUSELOOP2  ; JUMP TO PAUSELOOP2 IF A <> 0.
             DEC    C              ; DEC COUNTER
             JP     NZ, PAUSELOOP1  ; JUMP TO PAUSELOOP1 IF C <> 0.

             DJNZ   PAUSELOOP1     ; JUMP TO PAUSELOOP1 IF B <> 0.
PAUSESLUT:   POP    AF
             RET
