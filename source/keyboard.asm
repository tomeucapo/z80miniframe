include "globals.inc"
include "ppi.inc"
include "keyboard.inc"

        extern PAUSE, CON_PRINT, CON_PUTC, CON_NL, PPI_PBIN, PPI_PBOUT, PRHEXBYTE
        extern BUFF_PUTC

;;
;; KBD_READKEY Wait for a keypress
;;      Return keypress code to register A
;;
KBD_READKEY::
    LD A, $FF
    LD (KBDROWMSK), A
    LD (KBDCOLMSK), A
     
    CALL PPI_PBIN          ; Configure PPI Port B as input

    ;CALL KB_WAIT_RELEASE
    CALL KB_WAIT_KEYSTROKE
    CALL KB_KEYCODE

    LD (LASTKEYCODE), A    ; Store key code into RAM variable

    CALL BUFF_PUTC

    CALL PPI_PBOUT
    RET

KB_WAIT_RELEASE:
    CALL KB_SCANKEYS
    LD A, (KBDCOLMSK)
    CP $FF
    JP NZ, KB_WAIT_RELEASE
    RET

KB_WAIT_KEYSTROKE:
    CALL KB_SCANKEYS
    LD A, (KBDCOLMSK)
    CP $FF
    JP Z, KB_WAIT_KEYSTROKE
    RET


KB_READCOL:
    IN A, (PIO1B)       ; Read 4..7 columns state (From PORT B)     
    AND $F0
    LD B, A
    IN A, (PIO1A)       ; Read 0..3 columns state (From PORT A)
    AND $F0        
    RRA
    RRA
    RRA
    RRA    
    OR B    
    LD (KBDCOLMSK),A    
    RET

KB_SCANKEYS:
    LD A, MASK
    
KB_DOSCAN:    
    LD  (KBDROWMSK), A
    OUT (PIO1C), A   
    NOP
    CALL KB_READCOL    
    CP $FF
    RET NZ

    LD  A, (KBDROWMSK)
    RRCA    
    JP C, KB_DOSCAN      
    RET

PR_STATUS:
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
    RET


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

KEYCODEC:
    LD A, (KBDCOL)
    LD B, A
    LD A, (KBDROW)
    SLA A
    SLA A
    SLA A
    ADD B
    
    LD D, 0
    LD E, A
     
    LD HL, KEYS
    ADD HL, DE
    
    LD A, (HL)
    ;LD (LASTKEYCODE), A

    ; LD HL, MSG_ROW
    ; CALL CON_PRINT

    ; LD A, (KBDROW)
    ; CALL PRHEXBYTE

    ; LD A,','
    ; CALL CON_PUTC

    ; LD HL, MSG_COL
    ; CALL CON_PRINT

    ; LD A, (KBDCOL)
    ; CALL PRHEXBYTE

    ; LD A, ' '
    ; CALL CON_PUTC

    ;LD (LASTKEYCODE), A
    ;CALL CON_PUTC
    ;CALL CON_NL
    RET

MSG_SCAN:
    .BYTE "SCAN", CR,LF, 0    

MSG_ROW:
    .BYTE "ROW=", 0  

MSG_COL:
    .BYTE "COL=", 0  


MSG_MASK:
    .BYTE "MASK=", 0  

MSG_PRESSED:
    .BYTE "KEY= ", 0    

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

KEYS:
    .DB  BKSP, LF, 0, 118, 112, 114, 116, 0
    .DB '3', 'W', 'A', '4', 'Z', 'S', 'E', 0
    .DB '5', 'R', 'D', '6', 'C', 'F', 'T', 'X'
    .DB '7', 'Y', 'G', '8', 'B', 'H', 'U', 'V'
    .DB '9', 'I', 'J', '0', 'M', 'K', 'O', 'N'
    .DB '+', 'P', 'L', '-', '.', ':', '@', ','
    .DB '|', '*', ';',  CS,   0, '=', '~', '/'
    .DB '1',   0,   0, '2', ' ',   0, 'Q',  ESCAPE 