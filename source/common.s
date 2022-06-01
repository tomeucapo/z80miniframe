.area _DATA
.area _CODE

;; Pause routine using nested loops
;;      BC = Number of miliseconds

PAUSE::      PUSH   AF
             INC    B
             INC    C              ; ADJUST THE LOOP
PAUSELOOP1:  LD     A, #0x13       ; ADJUST THE TIME 13h IS FOR 4 MHZ
PAUSELOOP2:  DEC    A              ; DEC COUNTER. 4 T-states = 1 uS.
             JP     NZ, PAUSELOOP2  ; JUMP TO PAUSELOOP2 IF A <> 0.
             DEC    C              ; DEC COUNTER
             JP     NZ, PAUSELOOP1  ; JUMP TO PAUSELOOP1 IF C <> 0.

             DJNZ   PAUSELOOP1     ; JUMP TO PAUSELOOP1 IF B <> 0.
PAUSESLUT:   POP    AF
             RET


;; To upper character
;;      A = Char to upper
TO_UPPER::       
			CP      #'a'             
            RET     C
            CP      #'z' + 1         
            RET     NC              
            AND     #0x5f             
            RET	


;; Checks if value in A is a hexadecimal digit, C flag set if true
;;      A = Character check is hex or not

CHAR_ISHEX::
										;Checks if Acc between '0' and 'F'
			CP      #'F' + 1       		;(Acc) > 'F'? 
            RET     NC              	;Yes - Return / No - Continue
            CP      #'0'             	;(Acc) < '0'?
            JP      NC,CHAR_ISHEX_1 	;Yes - Jump / No - Continue
            CCF                     	;Complement carry (clear it)
            RET
CHAR_ISHEX_1:       
										;Checks if Acc below '9' and above 'A'
			CP      #'9' + 1         	;(Acc) < '9' + 1?
            RET     C               	;Yes - Return / No - Continue (meaning Acc between '0' and '9')
            CP      #'A'             	;(Acc) > 'A'?
            JP      NC,CHAR_ISHEX_2 	;Yes - Jump / No - Continue
            CCF                     	;Complement carry (clear it)
            RET
CHAR_ISHEX_2:        
										;Only gets here if Acc between 'A' and 'F'
			SCF                     	;Set carry flag to indicate the char is a hex digit
            RET