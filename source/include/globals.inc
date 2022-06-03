
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

SCR_X           .EQU     basicStarted+1           ; $8046
SCR_Y           .EQU     SCR_X+1                  ; $8047
SCR_LAST_CHAR   .EQU     SCR_Y+1
SCR_CUR_X       .EQU     SCR_LAST_CHAR+1           
SCR_CUR_Y       .EQU     SCR_CUR_X+1              ; $8049
SCR_SIZE_W      .EQU     SCR_CUR_Y+1              ; $804A
SCR_SIZE_H      .EQU     SCR_SIZE_W+1             ; $804B
SCR_MODE        .EQU     SCR_SIZE_H+1             ; $804C
VIDEOBUFF       .EQU     SCR_MODE+2               ; $804E (40) buffer used for video scrolling and other purposes
VIDTMP1         .EQU     VIDEOBUFF+$28            ; $8075      (2) temporary video word
VIDTMP2         .EQU     VIDTMP1+$02              ; $8078      (2) temporary video word
CURSORSTATE     .EQU     VIDTMP2+1                ; $8079
TMRCNT          .EQU     CURSORSTATE+$01            ; $807C (4) TMR counter for 1/100 seconds
CTC0IV          .EQU     TMRCNT+$04               ; $8080 (3) CTC0 interrupt vector
CTC1IV          .EQU     CTC0IV+$03               ; $8083 (3) CTC1 interrupt vector
CTC2IV          .EQU     CTC1IV+$03               ; $8086 (3) CTC2 interrupt vector
CTC3IV          .EQU     CTC2IV+$03               ; $8089 (3) CTC3 interrupt vector
ENABLEDCURSOR   .EQU     CTC3IV+$01               ; $808A
ENABLECTC       .EQU     ENABLEDCURSOR+$01        ; $808B
CHASNDDTN       .EQU     ENABLECTC+$02            ; $808D
CHBSNDDTN       .EQU     CHASNDDTN+$02            ; $808F
CHCSNDDTN       .EQU     CHBSNDDTN+$02            ; $8091
KBDNPT          .EQU     CHCSNDDTN+$02            ; $8093 (1) temp cell used to flag if input comes from keyboard
KBTMP           .EQU     KBDNPT+$01               ; $8094 (1) temp cell used by keyboard scanner
TMPKEYBFR       .EQU     KBTMP+$01                ; $8095 (1) temp buffer for last key pressed
LASTKEYPRSD     .EQU     TMPKEYBFR+$01            ; $8096 (1) last key code pressed
CONTROLKEYS     .EQU     LASTKEYPRSD+$01          ; $8097 (1) flags for control keys (bit#0=SHIFT; bit#1=CTRL; bit#2=C=)
CHR4VID         .EQU     CONTROLKEYS+$01          ; $8098

bufWrap         .EQU     (serBuf + SER_BUFSIZE) & $FF

MON_HEX_LEN:	.EQU	 CHR4VID+1
MON_HEX_TYPE:	.EQU	 MON_HEX_LEN+1
MON_HEX_ADDR:	.EQU	 MON_HEX_TYPE+1

PPI_CONF:       .EQU     MON_HEX_ADDR+1

KBDROW          .EQU     PPI_CONF+1            
KBDCOL          .EQU     KBDROW+1            
KBDROWMSK       .EQU     KBDCOL+1              
KBDCOLMSK       .EQU     KBDROWMSK+1           
LASTKEYCODE     .EQU     KBDCOLMSK+1           

BASIC_WRKSPC    .EQU     LASTKEYCODE+1
TEMPSTACK       .EQU     BASIC_WRKSPC+$61                  ;  Top of BASIC line input buffer so is "free ram" when BASIC resets 

; CP/M CBIOS Address
BOOT_CPM                .EQU     $4388


    