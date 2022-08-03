;;
;; keyboard.asm
;; Keyboard driver
;;
;; Code and computer schematics are released under
;; the therms of the GNU GPL License 3.0 and in the form of "as is", without no
;; kind of warranty: you can use them at your own risk.
;; You are free to use them for any non-commercial use: you are only asked to
;; maintain the copyright notices, include this advice and the note to the 
;; attribution of the original version to Tomeu Capó, if you intend to
;; redistribuite them.

include "globals.inc"
include "psg.inc"
include "keyboard.inc"

        extern CON_PRINT, CON_PUTC, CON_NL, PRHEXBYTE
        extern PSGIOCFG

KB_KEYSCAN::
    PUSH AF
    CALL PSGIOCFG           ; Ensure configure PSG IO as proper manner to manage keyboard matrix

    LD A, $FF
    LD (KBDROWMSK), A
    LD (KBDCOLMSK), A

    CALL KB_SCANKEYS
    LD A, (KBDROWMSK)
    CP $FF
    JP Z, NOKEY

    CALL KB_KEYCODE
    LD (LASTKEYCODE), A
NOKEY:
    POP AF
    RET

;;
;; KB_READKEY Wait for a keypress
;;      Return keypress code to register A
;;
KB_READKEY::
    LD A, $FF
    LD (KBDROWMSK), A
    LD (KBDCOLMSK), A

    LD HL, KEYS_LOWCASE
    LD A, H
    LD (KBDMAP), A
    LD A, L
    LD (KBDMAP+1), A

    CALL PSGIOCFG               ; Ensure configure PSG IO as proper manner to manage keyboard matrix

    CALL KB_WAIT_RELEASE
    CALL KB_WAIT_KEYSTROKE
    CALL KB_KEYCODE

    LD (LASTKEYCODE), A

    RET

;; Key relase waiting loop

KB_WAIT_RELEASE:
    CALL KB_SCANKEYS    
    LD A, (KBDROWMSK)
    CP $FF
    JP NZ, KB_WAIT_RELEASE
    RET

;; Key stroke waiting loop

KB_WAIT_KEYSTROKE:
    CALL KB_SCANKEYS
    LD A, (KBDROWMSK)
    CP $FF
    JP Z, KB_WAIT_KEYSTROKE
    RET

;; Detect shift keypress

KB_DETECT_SHIFT:
    LD A, (KBDCOLMSK)
    CP $7F
    RET NZ

    LD A, (KBDROWMSK)
    CP $FD
    JR Z, KBUPCASE

;; Changing keyboard code maps lower or upper case

KBLOWCASE:
    LD HL, KEYS_LOWCASE
    LD A, 0
    LD (KBSHIFTSTATE),A
    JR KBCHGMAP

KBUPCASE:
    LD HL, KEYS_UPCASE
    LD A, $FF
    LD (KBSHIFTSTATE),A
     
KBCHGMAP:
    LD A, H
    LD (KBDMAP), A
    LD A, L
    LD (KBDMAP+1), A
    RET

GETKEYMAP:    
    LD A, (KBDMAP)
    LD H, A
    LD A, (KBDMAP+1)
    LD L, A
    RET

;;
;; KB_SCANKEYS - Scan rows and cols to detect any key press/release
;;

KB_SCANKEYS:
    XOR A
    LD (KBDROWMSK), A    ; Clear row mask
    LD A, MASK           ; Load column mask (inverted mask)

KB_DO_SCAN:    
    LD (KBDCOLMSK), A

    LD A, AYPORTB        ; Select PSG Port B
    LD BC, AYCTRL       
    OUT (C), A

    LD  A, (KBDCOLMSK)   ; Output column mask to Port B (Keyboard column lines)
    LD BC, AYDATA       
    OUT (C), A

    LD A, AYPORTA        ; Select PSG Port A (Keyboard row lines)
    LD BC, AYCTRL       
    OUT (C), A
    IN  A, (C)           ; Read row lines
    LD  (KBDROWMSK), A   ; Save row lines state
    
    CALL KB_DETECT_SHIFT ; Check if shift is pressed
    
    LD A, (KBSHIFTSTATE)
    CP 1
    JR Z, NEXTCOL        

    LD A, (KBDROWMSK)    ; If any key is pressed then row mask not 11111111, then end scan and return this mask
    CP $FF                  
    JR NZ, KB_END_SCAN
    
NEXTCOL:
    LD  A, (KBDCOLMSK)
    RRCA    
    JP C, KB_DO_SCAN      
    RET

KB_END_SCAN:
   RET


;; KB_KEYCODE - Key code decoder, locate to character map to return
;;      Returns key character into A

KB_KEYCODE:
    LD A, (KBDCOLMSK)
    CP $FF
    RET Z

    LD A, (KBDROWMSK)
    CP $FF
    RET Z

    LD B, 7
    LD HL, POS_CODE
    LD A, (KBDCOLMSK)
GETCOLNUM:
    LD C, (HL)   
    CP C
    JR Z, COLNUM
    INC HL
    DJNZ GETCOLNUM
    
COLNUM:
    LD A, B
    LD (KBDCOL), A

    LD B, 7
    LD HL, POS_CODE
    LD A, (KBDROWMSK)
GETROWNUM:
    LD C, (HL)   
    CP C
    JR Z, ROWNUM
    INC HL
    DJNZ GETROWNUM    
ROWNUM:
    LD A, B
    LD (KBDROW), A
    LD A, (KBDCOL)          
    LD B, A 
    LD A, (KBDROW)
    SLA A
    SLA A
    SLA A
    ADD B
    
    LD D, 0
    LD E, A
     
    CALL GETKEYMAP
    ADD HL, DE
    
    LD A, (HL)
    RET


PR_STATUS:
    PUSH AF

    LD HL, MSG_ROW
    CALL CON_PRINT

    LD A, (KBDROWMSK)
    CALL PRHEXBYTE

    LD A,','
    CALL CON_PUTC

    LD HL, MSG_COL
    CALL CON_PRINT

    LD A, (KBDCOLMSK) 
    CALL PRHEXBYTE
    CALL CON_NL

    POP AF
    RET

    ; Keyboard keymap data matrix

    include "keymap.inc"
