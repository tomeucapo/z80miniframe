
;; casette.asm
;;
;; Library implements Dragon Data casette format using same block formats.
;; get from Inside the Dragon Book (p. 214-215)
;;
;; Tomeu Capó 2022
;;

include "casette.inc"
include "globals.inc"

            extern  PPI_SND_BYTE, PAUSE, STR_LEN, CON_PRINT
            extern  CON_NL, CON_PUTC, PRHEXBYTE

;;
;; CASWRFILE - Send file to tape
;;
;;  HL = Address of filename string
;;  DE = Begin of data block address
;;  B = Number of data blocks
;;  Destoys: A, BC, HL
;;

CASWRFILE::
            ld a, b                  ; Check if number of blocks is 0, exit
            and a
            ret z

            CALL PR_STATUS

            PUSH BC
            LD  B, LeadLen          ; Send 128 byte leader
            CALL CASWRLEADER

            CALL CASWRFILENAME      ; Write filename block

            LD BC, 5000             ; Blank section of tape (wait 0.5 seconds)
            CALL PAUSE

            LD  B, LeadLen          ; Send 128 byte leader
            CALL CASWRLEADER
            POP BC

            ; Send data blocks to tape
SNDBLK:     PUSH BC
            LD B, 0                 ; 255 bytes
            LD C, BlkDataType             
            CALL CASWRBLOCK
            POP BC
            DJNZ SNDBLK            

            ; TODO: Send end of file block

            CALL CON_NL

            RET

PR_STATUS:
            PUSH HL
            LD  HL, CASWRMSG        ; Print message and filename to save
            CALL CON_PRINT
            POP HL
            PUSH HL
            CALL CON_PRINT
            POP HL

            LD A,' '
            CALL CON_PUTC

            LD A, B                 ; Print number of blocks
            CALL PRHEXBYTE

            LD A,'/'
            CALL CON_PUTC
            RET
;;
;; CASWRFILENAME - Write file name block to tape
;;  HL = Filename string address
;;  Destroys: A, B
;;

CASWRFILENAME:       
            PUSH HL                 
            CALL STR_LEN                ; Return lenght on register B
            LD C, BlkNameFileType       ; Set block type to filename type
            POP HL
            PUSH DE
            EX DE, HL                   ; Points DE to start of filename string address     
            PUSH HL
            CALL CASWRBLOCK             ; Write filename block
            POP HL
            POP DE
            RET

;;
;; CASWRBLOCK - Send block data to tape
;;
;;  B = Data length (00-FF)
;;  C = Block type (00 = Namefile block, 01 = Data block, FF = End of file)
;;  DE = Data address
;;  Destoys: A, BC, HL
;;

CASWRBLOCK:
            DI
            XOR  A                   ; Clear checksum
            LD   (CASCHKSUM), A

            PUSH BC
            LD   A, LeadByte         ; Send 1 byte leader
            CALL PPI_SND_BYTE
            LD   A, SyncByte         ; Send sync byte 
            CALL PPI_SND_BYTE
            POP BC

            LD  A, (CASCHKSUM)
            ADD C
            LD (CASCHKSUM), A
        
            LD   A, C                ; Send block type
            PUSH BC
            CALL PPI_SND_BYTE        ; Send length to tape
            POP BC

            LD  A, (CASCHKSUM)
            ADD B
            LD (CASCHKSUM), A

            LD   A, B                ; Get lenght and send to tape
            PUSH BC
            CALL PPI_SND_BYTE        ; Send length to tape
            POP BC

SNDDATA:    LD  A, (DE)               ; Get data from buffer
            
            LD  C, A                  ; Update checksum
            LD  A, (CASCHKSUM)
            ADD C
            LD (CASCHKSUM), A
            LD A, C

            PUSH BC                    ; Send byte to tape   
            CALL PPI_SND_BYTE
            POP BC

            INC DE
            DJNZ SNDDATA

            LD   A, (CASCHKSUM)        ; Send checksum byte
            CALL PPI_SND_BYTE

            LD   A, LeadByte           ; Send 1 byte leader
            CALL PPI_SND_BYTE
            EI

            RET


;;
;; CASWRLEADER - Send leader to tape
;;  B = Number bytes of leader
;;

CASWRLEADER:
            DI
            PUSH HL
SNDLEAD:    LD A, LeadByte          
            PUSH BC
            CALL PPI_SND_BYTE
            POP BC
            DJNZ SNDLEAD

            POP HL
            EI
            
            RET

CASWRMSG:   .BYTE "Saving file: ", 0