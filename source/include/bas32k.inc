
; BASIC WORK SPACE ADDRESSES

WRKSPC  .EQU    BASIC_WRKSPC        ;  BASIC Work space   ( BEGINS AFTER FIRMWARE VARIABLES )

USR     .EQU    WRKSPC+3H           ; "USR (x)" jump
OUTSUB  .EQU    WRKSPC+6H           ; "OUT p,n"
OTPORT  .EQU    WRKSPC+7H           ; Port (p)
DIVSUP  .EQU    WRKSPC+9H           ; Division support routine
DIV1    .EQU    WRKSPC+0AH           ; <- Values
DIV2    .EQU    WRKSPC+0EH           ; <-   to
DIV3    .EQU    WRKSPC+12H           ; <-   be
DIV4    .EQU    WRKSPC+15H           ; <-inserted
SEED    .EQU    WRKSPC+17H           ; Random number seed
LSTRND  .EQU    WRKSPC+3AH           ; Last random number
INPSUB  .EQU    WRKSPC+3EH           ; #INP (x)" Routine
INPORT  .EQU    WRKSPC+3FH           ; PORT (x)
NULLS   .EQU    WRKSPC+41H           ; Number of nulls
LWIDTH  .EQU    WRKSPC+42H           ; Terminal width
COMMAN  .EQU    WRKSPC+43H           ; Width for commas
NULFLG  .EQU    WRKSPC+44H           ; Null after input byte flag
CTLOFG  .EQU    WRKSPC+45H           ; Control "O" flag
LINESC  .EQU    WRKSPC+46H           ; Lines counter
LINESN  .EQU    WRKSPC+48H           ; Lines number
CHKSUM  .EQU    WRKSPC+4AH           ; Array load/save check sum
NMIFLG  .EQU    WRKSPC+4CH           ; Flag for NMI break routine
BRKFLG  .EQU    WRKSPC+4DH           ; Break flag
RINPUT  .EQU    WRKSPC+4EH           ; Input reflection
POINT   .EQU    WRKSPC+51H           ; "POINT" reflection (unused)
PSET    .EQU    WRKSPC+54H           ; "SET"   reflection
RESET   .EQU    WRKSPC+57H           ; "RESET" reflection
STRSPC  .EQU    WRKSPC+5AH           ; Bottom of string space
LINEAT  .EQU    WRKSPC+5CH           ; Current line number
BASTXT  .EQU    WRKSPC+5EH           ; Pointer to start of program
BUFFER  .EQU    WRKSPC+61H           ; Input buffer
STACK   .EQU    WRKSPC+66H           ; Initial stack
CURPOS  .EQU    WRKSPC+0ABH          ; Character position on line
LCRFLG  .EQU    WRKSPC+0ACH          ; Locate/Create flag
TYPE    .EQU    WRKSPC+0ADH          ; Data type flag
DATFLG  .EQU    WRKSPC+0AEH          ; Literal statement flag
LSTRAM  .EQU    WRKSPC+0AFH          ; Last available RAM
TMSTPT  .EQU    WRKSPC+0B1H          ; Temporary string pointer
TMSTPL  .EQU    WRKSPC+0B3H          ; Temporary string pool
TMPSTR  .EQU    WRKSPC+0BFH          ; Temporary string
STRBOT  .EQU    WRKSPC+0C3H          ; Bottom of string space
CUROPR  .EQU    WRKSPC+0C5H          ; Current operator in EVAL
LOOPST  .EQU    WRKSPC+0C7H          ; First statement of loop
DATLIN  .EQU    WRKSPC+0C9H          ; Line of current DATA item
FORFLG  .EQU    WRKSPC+0CBH          ; "FOR" loop flag
LSTBIN  .EQU    WRKSPC+0CCH          ; Last byte entered
READFG  .EQU    WRKSPC+0CDH          ; Read/Input flag
BRKLIN  .EQU    WRKSPC+0CEH          ; Line of break
NXTOPR  .EQU    WRKSPC+0D0H          ; Next operator in EVAL
ERRLIN  .EQU    WRKSPC+0D2H          ; Line of error
CONTAD  .EQU    WRKSPC+0D4H          ; Where to CONTinue
PROGND  .EQU    WRKSPC+0D6H          ; End of program
VAREND  .EQU    WRKSPC+0D8H          ; End of variables
ARREND  .EQU    WRKSPC+0DAH          ; End of arrays
NXTDAT  .EQU    WRKSPC+0DCH          ; Next data item
FNRGNM  .EQU    WRKSPC+0DEH          ; Name of FN argument
FNARG   .EQU    WRKSPC+0E0H          ; FN argument value
FPREG   .EQU    WRKSPC+0E4H          ; Floating point register
FPEXP   .EQU    FPREG+3              ; Floating point exponent
SGNRES  .EQU    FPEXP+1              ; (1) Sign of result   

; Screen Variables
FRGNDCLR        .EQU     SGNRES+$01     ; (1) foreground color as set by SCREEN or COLOR commands
BKGNDCLR        .EQU     FRGNDCLR+$01    ; (1) background color as set by SCREEN or COLOR commands
TMPBFR1         .EQU     BKGNDCLR+$02    ; (2) word for general purposes use (temp. buffer for 1 or 2 bytes)
TMPBFR2         .EQU     TMPBFR1+$02     ; (2) word for general purposes use (temp. buffer for 1 or 2 bytes)
TMPBFR3         .EQU     TMPBFR2+$02     ; (2) word for general purposes use (temp. buffer for 1 or 2 bytes)
SCRMODE         .EQU     TMPBFR3+$02     ; (2) word for general purposes use (temp. buffer for 1 or 2 bytes)

PBUFF   .EQU    SCRMODE+1     ; Number print buffer
MULVAL  .EQU    PBUFF+$0D     ; Multiplier
PROGST  .EQU    MULVAL+$03    ; Start of program text area
STLOOK  .EQU    PROGST+$64    ; Start of memory test

; BASIC ERROR CODE VALUES

NF      .EQU    00H             ; NEXT without FOR
SN      .EQU    02H             ; Syntax error
RG      .EQU    04H             ; RETURN without GOSUB
OD      .EQU    06H             ; Out of DATA
FC      .EQU    08H             ; Function call error
OV      .EQU    0AH             ; Overflow
OM      .EQU    0CH             ; Out of memory
UL      .EQU    0EH             ; Undefined line number
BS      .EQU    10H             ; Bad subscript
DD      .EQU    12H             ; Re-DIMensioned array
DZ      .EQU    14H             ; Division by zero (/0)
ID      .EQU    16H             ; Illegal direct
TM      .EQU    18H             ; Type miss-match
OS      .EQU    1AH             ; Out of string space
LS      .EQU    1CH             ; String too long
ST      .EQU    1EH             ; String formula too complex
CN      .EQU    20H             ; Can't CONTinue
UF      .EQU    22H             ; UnDEFined FN function
MO      .EQU    24H             ; Missing operand
HX      .EQU    26H             ; HEX error
BN      .EQU    28H             ; BIN error