
PAUSE::       PUSH   AF
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


TO_UPPER::      
		    CP      'a'             	; Nothing to do if not lower case
            RET     C
            CP      'z' + 1         	; > 'z'?
            RET     NC              	; Nothing to do, either
            AND     $5F             	; Convert to upper case
            RET	