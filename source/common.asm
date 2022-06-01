;;
;; Common routines
;;


;; Pause in n*100uS (for n = 10000 for 1 second pause) 
;;      BC = Number of times

PAUSE::      PUSH   AF
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

;; Character to uppercase
;;      A = Input chracter

TO_UPPER:: 
        CP      'a'             	; Nothing to do if not lower case
        RET     C
        CP      'z' + 1         	; > 'z'?
        RET     NC              	; Nothing to do, either
        AND     $5F             	; Convert to upper case
        RET	

;;
;; CHAR_ISHEX - Function: Checks if value in A is a hexadecimal digit, C flag set if true
;;      A = Character to check
;;      Modify C flag. C = 0 Not HEX, 1 = HEX

CHAR_ISHEX::         
        CP      'F' + 1       		;(Acc) > 'F'? 
        RET     NC              	;Yes - Return / No - Continue
        CP      '0'             	;(Acc) < '0'?
        JP      NC,CHAR_ISHEX_1 	;Yes - Jump / No - Continue
        CCF                     	;Complement carry (clear it)
        RET
CHAR_ISHEX_1:       
        CP      '9' + 1         	;(Acc) < '9' + 1?
        RET     C               	;Yes - Return / No - Continue (meaning Acc between '0' and '9')
        CP      'A'             	;(Acc) > 'A'?
        JP      NC,CHAR_ISHEX_2 	;Yes - Jump / No - Continue
        CCF                     	;Complement carry (clear it)
        RET
CHAR_ISHEX_2:        
	                                ;Only gets here if Acc between 'A' and 'F'
	SCF                     	;Set carry flag to indicate the char is a hex digit
        RET

;; Calculate X MOD 8
;;      HL = X
;;      DE = X DIV 8

GET_MODULE::
        LD A, E       ;  4T 1B -- A := x div 7 [low bits]
        ADD A, A      ;  4T 1B -- A := (x div 7) * 2 [low bits]
        ADD A, A      ;  4T 1B -- A := (x div 7) * 4 [low bits]
        ADD A, A      ;  4T 1B -- A := (x div 7) * 8 [low bits]
        SUB E         ;  4T 1B -- A := (x div 7) * 7 [low bits]
        NEG           ;  8T 2B -- A := (x div 7) * -7 [low bits]
        ADD A, L      ;  4T 1B -- A := x mod 7  
        RET            