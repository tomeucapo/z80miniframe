include "globals.inc"
include "psg.inc"
include "keyboard.inc"

        extern PAUSE, CON_PRINT, CON_PUTC, CON_NL, PRHEXBYTE
        extern BUFF_PUTC
        extern AYREGWRITE, AYREGREAD, PSGIOCFG

;;
;; KBD_READKEY Wait for a keypress
;;      Return keypress code to register A
;;
KBD_READKEY::
    LD A, $FF
    LD (KBDROWMSK), A
    LD (KBDCOLMSK), A

    LD HL, KEYS_LOWCASE
    LD A, H
    LD (KBDMAP), A
    LD A, L
    LD (KBDMAP+1), A

    CALL PSGIOCFG           ; Ensure configure PSG IO as proper manner to manage keyboard matrix

    CALL KB_WAIT_RELEASE
    CALL KB_WAIT_KEYSTROKE
    CALL KB_KEYCODE

    LD (LASTKEYCODE), A
    RET

KB_WAIT_RELEASE:
    CALL KB_SCANKEYS    
    LD A, (KBDROWMSK)
    CP $FF
    JP NZ, KB_WAIT_RELEASE
    RET

KB_WAIT_KEYSTROKE:
    CALL KB_SCANKEYS
    LD A, (KBDROWMSK)
    CP $FF
    JP Z, KB_WAIT_KEYSTROKE
    RET

KB_DETECT_SHIFT:
    LD A, (KBDCOLMSK)
    CP $7F
    RET NZ

    LD A, (KBDROWMSK)
    CP $FD
    JR Z, KBUPCASE

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
    LD A, $00
    LD (KBDROWMSK),A    
    LD A, MASK

KB_DOSCAN:    
    LD  (KBDCOLMSK), A

    LD A, AYPORTB
    LD BC, AYCTRL       
    OUT (C), A

    LD  A, (KBDCOLMSK)
    LD BC, AYDATA       
    OUT (C), A

    LD A, AYPORTA
    LD BC, AYCTRL       
    OUT (C), A
    IN  A, (C)
    LD  (KBDROWMSK), A
    
    CALL KB_DETECT_SHIFT
    
    LD A, (KBSHIFTSTATE)
    CP 1
    JR Z, NEXTCOL

    LD A, (KBDROWMSK)
    CP $FF                  
    JR NZ, ENDSCAN
    
NEXTCOL:
    LD  A, (KBDCOLMSK)
    RRCA    
    JP C, KB_DOSCAN      
    RET

ENDSCAN:
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

MSG_SCAN:
    .BYTE "SCAN", CR,LF, 0    

MSG_ROW:
    .BYTE "ROW=", 0  

MSG_COL:
    .BYTE "COL=", 0  


MSG_SHIFT:
    .BYTE "SHIFT PRESSED", CR, LF, 0  

MSG_WRELE:
    .BYTE "WAITING FOR KEY RELEASE ...", CR, LF, 0    

MSG_WKSTRK:
    .BYTE "WAITING FOR KEY STROKE ...", CR, LF, 0    


POS_CODE:
    .DB 01111111b
    .DB 10111111b
    .DB 11011111b
    .DB 11101111b
    .DB 11110111b
    .DB 11111011b
    .DB 11111101b
    .DB 11111110b 

KEYS_UPCASE:
    .DB  BKSP, LF, 0, 118, 112, 114, 116, 0
    .DB '#', 'W', 'A', '$', 'Z', 'S', 'E', 0
    .DB '%', 'R', 'D', '&', 'C', 'F', 'T', 'X'
    .DB 39, 'Y', 'G', '(', 'B', 'H', 'U', 'V'
    .DB ')', 'I', 'J', '0', 'M', 'K', 'O', 'N'
    .DB '+', 'P', 'L', '-', '>', '[', '@', '<'
    .DB '|', '*', ']',  CS,   0, '=', '~', '?'
    .DB '1',   0,   0, '"', ' ',   0, 'Q',  ESCAPE 

KEYS_LOWCASE:
    .DB  BKSP, LF, 0, 118, 112, 114, 116, 0
    .DB '3', 'w', 'a', '4', 'z', 's', 'e', 0
    .DB '5', 'r', 'd', '6', 'c', 'f', 't', 'x'
    .DB '7', 'y', 'g', '8', 'b', 'h', 'u', 'v'
    .DB '9', 'i', 'j', '0', 'm', 'k', 'o', 'n'
    .DB '+', 'p', 'l', '-', '.', ':', '@', ','
    .DB '|', '*', ';',  CS,   0, '=', '~', '/'
    .DB '1',   0,   0, '2', ' ',   0, 'q',  ESCAPE     