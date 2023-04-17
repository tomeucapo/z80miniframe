
; Constants

SER_BUFSIZE     .EQU     $3F
SER_FULLSIZE    .EQU     $30
SER_EMPTYSIZE   .EQU     $05

; GENERAL EQUATES

CTRLC   .EQU    03H             ; Control "C"
CTRLG   .EQU    07H             ; Control "G"
BKSP    .EQU    08H             ; Back space
LF      .EQU    0AH             ; Line feed
CS      .EQU    0CH             ; Clear screen
CR      .EQU    0DH             ; Carriage return
CTRLO   .EQU    0FH             ; Control "O"
CTRLQ	.EQU	11H		        ; Control "Q"
CTRLR   .EQU    12H             ; Control "R"
CTRLS   .EQU    13H             ; Control "S"
CTRLU   .EQU    15H             ; Control "U"
ESC     .EQU    1BH             ; Escape
ESCAPE  .EQU     1BH
DEL     .EQU    7FH             ; Delete

; Firmware memory variables stars at $8000 RAM Address

serBuf          .EQU     $8000                    ; $8000  
serInPtr        .EQU     serBuf+SER_BUFSIZE+1     ; $8040
serRdPtr        .EQU     serInPtr+2               ; $8042
serBufUsed      .EQU     serRdPtr+2               ; $8044
basicStarted    .EQU     serBufUsed+1             ; $8045
bufWrap         .EQU     (serBuf + SER_BUFSIZE) & $FF

SCR_X           .EQU     basicStarted+1           ; $8046
SCR_Y           .EQU     SCR_X+1                  ; $8047
SCR_LAST_CHAR   .EQU     SCR_Y+1
SCR_COLOR_FG    .EQU     SCR_LAST_CHAR+1
SCR_COLOR_BG    .EQU     SCR_COLOR_FG+1

SCR_CUR_X       .EQU     SCR_COLOR_BG+1           
SCR_CUR_Y       .EQU     SCR_CUR_X+1              ; $8049
SCR_SIZE_W      .EQU     SCR_CUR_Y+1              ; $804A
SCR_SIZE_H      .EQU     SCR_SIZE_W+1             ; $804B
SCR_DOT_X       .EQU     SCR_SIZE_H+2             ; Last plotted locations in graphics mode
SCR_DOT_Y       .EQU     SCR_DOT_X+2
X1              .equ     SCR_DOT_X                ; Line variables
Y1              .equ     SCR_DOT_Y
SCR_DOT_COLOR   .EQU     SCR_DOT_Y+1
SCR_MODE        .EQU     SCR_DOT_COLOR+1             ; $804C
SCR_NAM_TB      .EQU     SCR_MODE+2

X2              .equ     SCR_NAM_TB+2
Y2              .equ     X2+2
ER              .equ     Y2+2
E2              .equ     ER+2
SX              .equ     E2+2
SY              .equ     SX+2
DX              .equ     SY+2
DY              .equ     DX+2

XC               .equ     DY+2
YC               .equ     XC+2
RADIUS           .equ     YC+2
XI               .equ     RADIUS+2
YI               .equ     XI+2
DC               .equ     YI+2

VDP_READY       .EQU     DC+1

VIDEOBUFF       .EQU     VDP_READY+2                     ; $804E (40) buffer used for video scrolling and other purposes
VIDTMP1         .EQU     VIDEOBUFF+$28            ; $8075      (2) temporary video word
VIDTMP2         .EQU     VIDTMP1+$02              ; $8078      (2) temporary video word
CURSORSTATE     .EQU     VIDTMP2+1                ; $8079
TMRCNT          .EQU     CURSORSTATE+$01          ; $801A 
ENABLEDCURSOR   .EQU     TMRCNT+$04               ; $808A
ENABLECTC       .EQU     ENABLEDCURSOR+$01        ; $808B
CHASNDDTN       .EQU     ENABLECTC+$02            ; $808D
CHBSNDDTN       .EQU     CHASNDDTN+$02            ; $808F
CHCSNDDTN       .EQU     CHBSNDDTN+$02            ; $8091

MON_HEX_LEN 	.EQU	 CHCSNDDTN+1
MON_HEX_TYPE 	.EQU	 MON_HEX_LEN+1
MON_HEX_ADDR 	.EQU	 MON_HEX_TYPE+1

PPI_CONF        .EQU     MON_HEX_ADDR+1

KBDROW          .EQU     PPI_CONF+1            
KBDCOL          .EQU     KBDROW+1            
KBDROWMSK       .EQU     KBDCOL+1              
KBDCOLMSK       .EQU     KBDROWMSK+1           
LASTKEYCODE     .EQU     KBDCOLMSK+1         
KBDMAP          .EQU     LASTKEYCODE+1
KBSHIFTSTATE    .EQU     KBDMAP+2

CASLASTSINE    .EQU     KBSHIFTSTATE+1
CASLASTBYTE    .EQU     CASLASTSINE+1
CASBITMASK      .EQU    CASLASTBYTE+1
CASCHKSUM       .EQU    CASBITMASK+1

TMPDBF          .EQU    CASCHKSUM+1
TPBF4           .EQU    TMPDBF+$24

BYT_SIZ         .equ     TPBF4+$02     ; (2) file size in bytes
SCT_SIZ         .equ     BYT_SIZ+$02     ; (1) file size in sectors

BASIC_WRKSPC    .EQU     SCT_SIZ+2

TEMPSTACK       .EQU     BASIC_WRKSPC+$61                  ;  Top of BASIC line input buffer so is "free ram" when BASIC resets 

; CP/M CBIOS Address
BOOT_CPM                .EQU     $4388


    