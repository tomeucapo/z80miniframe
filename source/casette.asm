
;; casette.asm
;;
;; Library implements Dragon Data casette format using same block formats.
;; get from Inside the Dragon Book (p. 214-215)
;;
;; Tomeu Capó 2022
;;

include "casette.inc"
include "globals.inc"

            extern  PPI_SND_BYTE, PPI_RCV_BYTE, PPI_RBIT, PPI_RCAL
            extern  CASMON, CASMOF
            extern  PAUSE, CON_PRINT
            extern  CON_NL, CON_PUTC

;;
;; CASWRFILE - Send file to tape
;;
;;  HL = Address of filename characters (not NUL terminated)
;;  A  = Filename length
;;  DE = Address of file data
;;  BC = Total number of data bytes
;;  Saves a Dragon BASIC file. Destroys: A, BC, DE, HL
;;

CASWRFILE::
            LD  (CFLEN), A
            LD  A, B
            OR  C                    ; Nothing to save?
            RET Z

            LD  (CASREM), BC
            LD  (CDPTR), DE
            LD  (CFNPTR), HL

            ; Dragon namefile field has a fixed eight-character name.
            LD  A, (CFLEN)
            CP  8
            JR  C, NAME_LEN_OK
            LD  A, 8
            LD  (CFLEN), A
NAME_LEN_OK:
            LD  HL, CNMBUF
            LD  B, 8
            LD  A, ' '
PAD_NAME:
            LD  (HL), A
            INC HL
            DJNZ PAD_NAME

            LD  HL, (CFNPTR)
            LD  DE, CNMBUF
            LD  A, (CFLEN)
            OR  A
            JR  Z, NAME_PADDED
            LD  B, A
COPY_NAME:
            LD  A, (HL)
            LD  (DE), A
            INC HL
            INC DE
            DJNZ COPY_NAME
NAME_PADDED:
            ; BASIC program: tokenised/binary, continuous, no EXEC/load address.
            LD  HL, CNMBUF+8
            LD  B, 7
            XOR A
CLEAR_NAME_METADATA:
            LD  (HL), A
            INC HL
            DJNZ CLEAR_NAME_METADATA

            CALL PR_STATUS

            CALL CASMON             ; Start cassette motor via PC1
            LD   BC, 5000           ; Allow the motor to get up to speed
            CALL PAUSE
            LD  B, LeadLen          ; Initial 128-byte leader
            CALL CASWRLEADER

            LD  DE, CNMBUF
            LD  B, NameFileLen
            LD  C, BlkNameFileType
            CALL CASWRBLOCK

            LD BC, 5000             ; Blank section of tape (wait 0.5 seconds)
            CALL PAUSE

            LD  B, LeadLen          ; Leader before data
            CALL CASWRLEADER

            ; Write data in blocks of at most 255 bytes. A zero length byte
            ; means an empty block, not 256 bytes.
SNDBLK:
            LD  HL, (CASREM)
            LD  A, H
            OR  L
            JR  Z, SEND_EOF

            LD  A, H
            OR  A
            JR  NZ, FULL_BLOCK
            LD  A, L
            LD  B, A
            LD  (CCHUNK), A
            JR  WRITE_BLOCK
FULL_BLOCK:
            LD  B, MaxDataLen
            LD  A, MaxDataLen
            LD  (CCHUNK), A
WRITE_BLOCK:
            LD  C, BlkDataType
            LD  DE, (CDPTR)
            CALL CASWRBLOCK
            LD  (CDPTR), DE

            LD  HL, (CASREM)
            LD  A, (CCHUNK)
            LD  E, A
            LD  D, 0
            OR  A                    ; Clear carry before subtraction
            SBC HL, DE
            LD  (CASREM), HL
            JR  SNDBLK

SEND_EOF:
            LD  B, 0
            LD  C, BlkEOFType
            LD  DE, (CDPTR)
            CALL CASWRBLOCK

            CALL CASMOF             ; Stop cassette motor
            CALL CON_NL
            RET

PR_STATUS:
            LD  HL, CASWRMSG        ; Print message and filename to save
            CALL CON_PRINT
            LD  HL, CNMBUF
            LD  A, (CFLEN)
            OR  A
            JR  Z, PR_STATUS_DONE
            LD  B, A
PR_STATUS_NAME:
            LD  A, (HL)
            PUSH HL
            PUSH BC
            CALL CON_PUTC
            POP  BC
            POP  HL
            INC  HL
            DJNZ PR_STATUS_NAME
PR_STATUS_DONE:
            LD A,' '
            CALL CON_PUTC
            RET

;;
;; CASWRBLOCK - Send block data to tape
;;
;;  B = Data length (00-FF; zero means no data)
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

            LD   A, B
            OR   A
            JR   Z, DATA_DONE        ; Zero length is a genuinely empty block

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
            DEC B
            JR NZ, SNDDATA

DATA_DONE:
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

CASWRLEADER::
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

;;
;; CASRDFILE - Read a Dragon BASIC cassette file.
;;  HL = requested filename characters (or 0 to accept any name)
;;  A  = requested filename length (0 accepts any name)
;;  DE = destination address
;;  BC = destination capacity
;;  Returns DE = first byte after loaded file, carry set on error.
;;

CASRDFILE::
            DI
            LD  (CFNPTR), HL
            LD  (CFLEN), A
            LD  (CDPTR), DE
            LD  (CASREM), BC
            LD  HL, 0
            LD  (CLDSIZ), HL

            CALL CASMON             ; Start cassette motor via PC1
            LD  A, (CFLEN)
            CP  8
            JR  C, RFILE_NAME_LEN_OK
            LD  A, 8
            LD  (CFLEN), A
RFILE_NAME_LEN_OK:
            CALL PPI_RCAL
            JP  C, RFILE_ERROR

            ; First block must be a 15-byte BASIC namefile.
            LD  HL, NameFileLen
            LD  (CBMAX), HL
            LD  DE, CNMBUF
            CALL CASRDBLOCK
            JP  C, RFILE_ERROR
            CP  BlkNameFileType
            JP  NZ, RFILE_ERROR
            LD  A, B
            CP  NameFileLen
            JP  NZ, RFILE_ERROR
            LD  A, (CNMBUF+8)       ; Only tokenised BASIC files supported
            OR  A
            JP  NZ, RFILE_ERROR
            LD  A, (CNMBUF+9)       ; Reject ASCII text BASIC files
            OR  A
            JP  NZ, RFILE_ERROR
            LD  A, (CNMBUF+10)      ; BASIC data is continuous
            OR  A
            JP  NZ, RFILE_ERROR

            ; If a name was supplied, compare it with the padded 8-byte field.
            LD  A, (CFLEN)
            OR  A
            JR  Z, RFILE_DATA
            LD  (CLEFT), A
            LD  HL, CNMBUF
            LD  DE, (CFNPTR)
            LD  B, 8
RFILE_NAME_LOOP:
            LD  A, (CLEFT)
            OR  A
            JR  Z, RFILE_NAME_SPACE
            LD  A, (DE)
            INC DE
            LD  C, A
            LD  A, (CLEFT)
            DEC A
            LD  (CLEFT), A
            LD  A, C
            JR  RFILE_NAME_COMPARE
RFILE_NAME_SPACE:
            LD  A, ' '
RFILE_NAME_COMPARE:
            CP  (HL)
            JP  NZ, RFILE_ERROR
            INC HL
            DJNZ RFILE_NAME_LOOP

RFILE_DATA:
            ; Each data block is checked before advancing to the next one.
            LD  HL, (CASREM)
            LD  (CBMAX), HL
            LD  DE, (CDPTR)
            CALL CASRDBLOCK
            JP  C, RFILE_ERROR
            CP  BlkEOFType
            JR  Z, RFILE_EOF
            CP  BlkDataType
            JP  NZ, RFILE_ERROR

            LD  (CDPTR), DE
            LD  A, B
            LD  E, A
            LD  D, 0
            LD  HL, (CASREM)
            OR  A
            SBC HL, DE
            LD  (CASREM), HL
            LD  HL, (CLDSIZ)
            ADD HL, DE
            LD  (CLDSIZ), HL
            JR  RFILE_DATA

RFILE_EOF:
            LD  HL, (CLDSIZ)
            LD  A, H
            OR  A
            JR  NZ, RFILE_CHECK_END
            LD  A, L
            CP  2
            JP  C, RFILE_ERROR
RFILE_CHECK_END:
            LD  HL, (CDPTR)
            DEC HL
            LD  A, (HL)
            OR  A
            JP  NZ, RFILE_ERROR
            DEC HL
            LD  A, (HL)
            OR  A
            JP  NZ, RFILE_ERROR
            LD  DE, (CDPTR)
            CALL CASMOF
            EI
            OR  A                       ; Successful return, carry clear
            RET

RFILE_ERROR:
            CALL CASMOF
            EI
            SCF
            RET

;;
;; CASRDBLOCK - Find sync, receive and checksum one block.
;;  DE = destination for payload
;;  CBMAX = maximum allowed payload length
;;  Returns A = block type, B = payload length, DE = next destination.
;;  Carry set on timeout, invalid length, checksum or trailer.
;;

CASRDBLOCK:
            CALL CASRDFIND
            RET  C
            CALL PPI_RCV_BYTE
            RET  C
            LD   (CBTYPE), A
            LD   A, (CBTYPE)
            LD   (CASCHKSUM), A

            CALL PPI_RCV_BYTE
            RET  C
            LD   (CBLEN), A

            ; Check the payload fits its destination before writing any bytes.
            LD   A, (CBMAX+1)
            OR   A
            JR   NZ, RDBLOCK_SIZE_OK
            LD   B, A
            LD   A, (CBMAX)
            LD   B, A
            LD   A, (CBLEN)
            CP   B
            JR   C, RDBLOCK_SIZE_OK
            JR   Z, RDBLOCK_SIZE_OK
            SCF
            RET
RDBLOCK_SIZE_OK:
            LD   A, (CASCHKSUM)
            LD   B, A
            LD   A, (CBLEN)
            ADD  B
            LD   (CASCHKSUM), A

            LD   A, (CBLEN)
            LD   B, A
            LD   A, B
            OR   A
            JR   Z, RDBLOCK_CHECKSUM
RDBLOCK_DATA:
            PUSH BC
            CALL PPI_RCV_BYTE
            POP  BC
            RET  C
            LD   C, A
            LD   A, (CASCHKSUM)
            ADD  C
            LD   (CASCHKSUM), A
            LD   A, C
            LD   (DE), A
            INC  DE
            DEC  B
            JR   NZ, RDBLOCK_DATA

RDBLOCK_CHECKSUM:
            CALL PPI_RCV_BYTE
            RET  C
            LD   B, A
            LD   A, (CASCHKSUM)
            CP   B
            JR   NZ, RDBLOCK_ERROR
            CALL PPI_RCV_BYTE
            RET  C
            CP   LeadByte
            JR   NZ, RDBLOCK_ERROR
            LD   A, (CBLEN)
            LD   B, A
            LD   A, (CBTYPE)
            OR   A                       ; Clear carry on success
            RET
RDBLOCK_ERROR:
            SCF
            RET

;;
;; CASRDFIND - Scan the serial bit stream for the $3C sync byte.
;; Sync is detected bit-by-bit so byte phase can be arbitrary after the leader.
;;

CASRDFIND:
            XOR  A
            LD   (CRRWIN), A
            LD   (CRRBITS), A
            LD   (CRRSYNC), A            ; Re-acquire after inter-block gaps
RDFIND_BIT:
            CALL PPI_RBIT
            RET  C
            LD   (CRRVAL), A
            LD   A, (CRRWIN)
            SRL  A
            LD   (CRRWIN), A
            LD   A, (CRRVAL)
            OR   A
            JR   Z, RDFIND_COUNT
            LD   A, (CRRWIN)
            OR   $80
            LD   (CRRWIN), A
RDFIND_COUNT:
            LD   A, (CRRBITS)
            CP   8
            JR   NC, RDFIND_TEST
            INC  A
            LD   (CRRBITS), A
            JR   RDFIND_BIT
RDFIND_TEST:
            LD   A, (CRRWIN)
            CP   SyncByte
            JR   NZ, RDFIND_BIT
            OR   A                       ; Clear carry on success
            RET

CASWRMSG:   .BYTE "Saving file: ", 0
