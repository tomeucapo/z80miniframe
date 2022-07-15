;;
;; Common routines
;;
;; Some routines from Leonardo Milliani used on utils.asm
;;
;; * WKT are routines from WikiTI:
;; http://wikiti.brandonw.net/index.php?title=WikiTI_Home
;;
;; * LAC are routines from Learn@Cemetch
;; https://learn.cemetech.net/index.php/Main_Page
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

;; 8/8 division by Leonardo Milliani
;; INPUT: D (dividend), E (divisor)
;; OPERATION: D/E
;; OUTPUT: D (quotient), A (remainder)

DIV_8_8::    xor     A
            push    BC
            ld      B,08h
DIV_8_8LOOP:sla     D
            rla
            cp      E
            jr      C,$+4
            sub     E
            inc     D
            djnz    DIV_8_8LOOP
            pop     BC
            ret        

; ----------------------------------------------------------------------
; divide a 16-bit number by a 16-bit number
; (16/16 division)
;
; inputs: AC (Dividend), DE (divisor)
; destroys: HL,A,C
; OPERATION: AC/DE
; returns: AC (quotient), HL (remainder)
; source: WKT
DIV_16_16::  ld      HL, 0
            ld      B, 16
DV16_16_LP: sla     C
            set     0,C         ; this simulates the SLL undocumented instruction
            rla
            adc     HL,HL
            sbc     HL,DE
            jr      NC, $+4
            add     HL,DE
            dec     C
            djnz    DV16_16_LP
            ret

;; ----------------------------------------------------------------------
;; absolute value of HL (same applies to other 16-bit register pairs)
;; also, invert value of HL (or any other 16-bit register, just adjust the code)
;;
;; inputs: HL
;; destroys: A
;; operation: ABS(HL)
;; returns: HL with no sign or negated
;; Source: WKT

absHL:: bit     7,H
        ret     Z
negHL:: xor     A
        sub     L
        ld      L,A
        sbc     A,A
        sub     H
        ld      H,A
        ret            


; compare two 16-bit registers, HL (minuend) and DE (subtrahend)
; values can be both signed or unsigned words
; inputs: HL, DE
; destroys: A,F,HL
;
; returns: Z=1 if HL = DE
; for UNSIGNED: C=1 if HL<DE  //  C=0 if HL>DE
; for SIGNED:   S=1 (M) if HL<DE  //  S=0 (P) if HL>DE
; if HL=DE: Z,P,NC  - Z=1, S=0; C=0
; if HL>DE: NZ,P,NC - Z=0, S=0; C=0
; if HL<DE: NZ,M,C  - Z=0, S=1; C=1
; Source: ALS

CMP16:: or      A           ; clear CARRY
        sbc     HL,DE       ; subtract DE from HL
        ret     PO          ; return if no overflow
        ld      A,H         ; overflow - invert SIGN flag
        rra                 ; save CARRY flag in bit 7
        xor     $40         ; complement bit 6 (SIGN bit)
        scf                 ; ensure a Non-Zero result
        adc     A,A         ; restore CARRY, complemented SIGN
                            ; ZERO flag = 0 for sure
        ret                 ; return        


STR_LEN::         
        XOR      B
	LD       A,(HL)          
	OR       A               
        RET      Z       
        INC      B                
        INC      HL              
        JR       STR_LEN       
        RET        