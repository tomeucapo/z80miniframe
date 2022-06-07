include "globals.inc"

BUFF_INIT::   
    PUSH     HL
    LD       HL,serBuf         ; Setting up serial buffers	
    LD       (serInPtr),HL
    LD       (serRdPtr),HL
    PUSH     AF
    XOR      A               
    LD       (serBufUsed),A
    POP      AF
    POP      HL
    RET

;;
;; BUFF_PUTC
;;     A = Character to store
;;
BUFF_PUTC::    
    PUSH     AF
    LD       A,(serBufUsed)
    CP       SER_BUFSIZE     ; If full then ignore
    JR       NZ,BUFF_NOT_FULL
    POP      AF
    RET
BUFF_NOT_FULL:  
    LD       HL,(serInPtr)
    INC      HL
    LD       A,L             ; Only need to check low byte becasuse buffer<256 bytes
    CP       bufWrap
    JR       NZ, BUFF_NOT_WRAP
    LD       HL,serBuf

BUFF_NOT_WRAP:  
    LD       (serInPtr),HL
    POP      AF
    LD       (HL),A
    LD       A,(serBufUsed)
    INC      A
    LD       (serBufUsed),A
    RET

;;
;; BUFF_GETC
;;    Return character into A
;;
BUFF_GETC::
    LD       A,(serBufUsed)
    CP       $00
    JR       Z, BUFF_GETC
    PUSH     HL
    LD       HL,(serRdPtr)
    INC      HL
    LD       A,L             ; Only need to check low byte becasuse buffer<256 bytes
    CP       bufWrap
    JR       NZ, notRdWrap
    LD       HL,serBuf
notRdWrap:      
    DI
    LD       (serRdPtr),HL
    LD       A,(serBufUsed)
    DEC      A
    LD       (serBufUsed),A
    CP       SER_EMPTYSIZE

    LD       A,(HL)
    EI
    POP      HL
    RET                      ; Char ready in A


BUFF_CKINCHAR::
    LD       A,(serBufUsed)
    CP       $0
    RET

