;;******************************************************************
;; FAT32 volume discovery and mount support.
;;
;; F32MNT scans LBA 0 as a superfloppy BPB, otherwise scans the
;; four MBR partition entries for FAT32 types 0Bh/0Ch.  It validates the
;; BPB and records the volume geometry used by the file layer.
;;
;; Input: CF_INIT must have completed.
;; Return: carry clear on success; carry set and A=FAT32_ERR_* on failure.
;;******************************************************************

                include "globals.inc"
                include "cf.inc"
                include "fat32.inc"

                extern CF_READ_SECTOR
                extern CF_INIT, CON_PRINT, CON_PUTC, CON_NL
                public F32MNT
                public F32DIR

F32MNT::
                XOR     A
                LD      (FMONT),A
                LD      (FPLBA),A
                LD      (FPLBA+1),A
                LD      (FPLBA+2),A
                LD      (FPLBA+3),A
                LD      (CF_LBA),A
                LD      (CF_LBA+1),A
                LD      (CF_LBA+2),A
                LD      (CF_LBA+3),A
                CALL    F32IO
                RET     C

                ; A valid FAT32 BPB at sector zero is a superfloppy.
                CALL    F32ISB
                JR      Z,F32BPR

                ; Otherwise find a primary FAT32 partition in the MBR.
                LD      HL,FAT32_SECTOR_BUFFER+510
                LD      A,(HL)
                CP      $55
                JP      NZ,F32BAD
                INC     HL
                LD      A,(HL)
                CP      $AA
                JP      NZ,F32BAD

                LD      HL,FAT32_SECTOR_BUFFER+446
                LD      B,4
F32PSC:
                PUSH    BC
                PUSH    HL
                LD      DE,4
                ADD     HL,DE
                LD      A,(HL)
                CP      $0B
                JR      Z,F32PFN
                CP      $0C
                JR      Z,F32PFN
                CP      $1B
                JR      Z,F32PFN
                CP      $1C
                JR      Z,F32PFN
                POP     HL
                LD      DE,16
                ADD     HL,DE
                POP     BC
                DJNZ    F32PSC
                JP      F32BAD

F32PFN:
                INC     HL
                INC     HL
                INC     HL
                INC     HL                  ; start LBA at entry offset 8
                LD      DE,FPLBA
                LD      C,4
F32CPL:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32CPL
                POP     HL                  ; discard saved entry pointer
                POP     BC
                LD      HL,FPLBA
                LD      DE,CF_LBA
                LD      C,4
F32LPL:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32LPL
                CALL    F32IO
                RET     C
                CALL    F32ISB
                JP      NZ,F32BAD
                LD      HL,FAT32_SECTOR_BUFFER+510
                LD      A,(HL)
                CP      $55
                JP      NZ,F32BAD
                INC     HL
                LD      A,(HL)
                CP      $AA
                JP      NZ,F32BAD

F32BPR:
                ; Require the FAT boot-sector signature for both layouts.
                LD      HL,FAT32_SECTOR_BUFFER+510
                LD      A,(HL)
                CP      $55
                JP      NZ,F32BAD
                INC     HL
                LD      A,(HL)
                CP      $AA
                JP      NZ,F32BAD

                ; Require 512-byte sectors, FAT32 (no FAT16 size/root table),
                ; non-zero reserved area, FAT count and sectors per cluster.
                LD      HL,FAT32_SECTOR_BUFFER+11
                LD      A,(HL)
                CP      0
                JP      NZ,F32BAD
                INC     HL
                LD      A,(HL)
                CP      2
                JP      NZ,F32BAD

                LD      HL,FAT32_SECTOR_BUFFER+17
                LD      A,(HL)
                INC     HL
                OR      (HL)
                JP      NZ,F32BAD
                LD      HL,FAT32_SECTOR_BUFFER+22
                LD      A,(HL)
                INC     HL
                OR      (HL)
                JP      NZ,F32BAD

                LD      A,(FAT32_SECTOR_BUFFER+13)
                OR      A
                JP      Z,F32BAD
                LD      (FSPC),A
                LD      B,A
                DEC     A
                AND     B
                JP      NZ,F32BAD   ; sectors/cluster must be power of 2

                LD      A,(FAT32_SECTOR_BUFFER+16)
                OR      A
                JP      Z,F32BAD
                LD      (FNFT),A
                LD      A,(FAT32_SECTOR_BUFFER+14)
                LD      B,A
                LD      A,(FAT32_SECTOR_BUFFER+15)
                OR      B
                JP      Z,F32BAD

                ; FAT start = partition start + BPB reserved sectors.
                LD      HL,FPLBA
                LD      DE,FFLBA
                LD      C,4
F32CPB:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32CPB
                LD      A,(FAT32_SECTOR_BUFFER+14)
                LD      B,A
                LD      A,(FFLBA)
                ADD     A,B
                LD      (FFLBA),A
                LD      A,(FAT32_SECTOR_BUFFER+15)
                LD      B,A
                LD      A,(FFLBA+1)
                ADC     A,B
                LD      (FFLBA+1),A
                LD      A,(FFLBA+2)
                ADC     A,0
                LD      (FFLBA+2),A
                LD      A,(FFLBA+3)
                ADC     A,0
                LD      (FFLBA+3),A

                ; Save FAT32 sectors-per-FAT and root cluster.
                LD      HL,FAT32_SECTOR_BUFFER+36
                LD      DE,FFSIZE
                LD      C,4
F32CFS:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32CFS
                LD      A,(FFSIZE)
                LD      B,A
                LD      A,(FFSIZE+1)
                OR      B
                LD      B,A
                LD      A,(FFSIZE+2)
                OR      B
                LD      B,A
                LD      A,(FFSIZE+3)
                OR      B
                JP      Z,F32BAD
                LD      HL,FAT32_SECTOR_BUFFER+44
                LD      DE,FROOT
                LD      C,4
F32CRT:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32CRT
                LD      A,(FROOT+3)
                AND     $0F
                LD      (FROOT+3),A
                LD      A,(FROOT+1)
                LD      B,A
                LD      A,(FROOT+2)
                OR      B
                LD      B,A
                LD      A,(FROOT+3)
                OR      B
                JR      NZ,F32RCK
                LD      A,(FROOT)
                CP      2
                JP      C,F32BAD
F32RCK:

                ; Data start = FAT start + (number of FATs * FAT size).
                LD      HL,FFLBA
                LD      DE,FDLBA
                LD      C,4
F32CDB:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32CDB
                LD      A,(FNFT)
                LD      (FWCNT),A
F32AFL:
                LD      A,(FDLBA)
                LD      B,A
                LD      A,(FFSIZE)
                ADD     A,B
                LD      (FDLBA),A
                LD      A,(FDLBA+1)
                LD      B,A
                LD      A,(FFSIZE+1)
                ADC     A,B
                LD      (FDLBA+1),A
                LD      A,(FDLBA+2)
                LD      B,A
                LD      A,(FFSIZE+2)
                ADC     A,B
                LD      (FDLBA+2),A
                LD      A,(FDLBA+3)
                LD      B,A
                LD      A,(FFSIZE+3)
                ADC     A,B
                LD      (FDLBA+3),A
                LD      A,(FWCNT)
                DEC     A
                LD      (FWCNT),A
                JR      NZ,F32AFL

                LD      A,1
                LD      (FMONT),A
                XOR     A
                RET

F32ISB:
                ; Z if the boot sector has the FAT32 BPB signature fields.
                LD      A,(FAT32_SECTOR_BUFFER+11)
                OR      A
                RET     NZ
                LD      A,(FAT32_SECTOR_BUFFER+12)
                CP      2
                RET     NZ
                LD      A,(FAT32_SECTOR_BUFFER+17)
                OR      A
                RET     NZ
                LD      A,(FAT32_SECTOR_BUFFER+18)
                OR      A
                RET     NZ
                LD      A,(FAT32_SECTOR_BUFFER+22)
                OR      A
                RET     NZ
                LD      A,(FAT32_SECTOR_BUFFER+23)
                OR      A
                RET

F32IO:
                LD      HL,FAT32_SECTOR_BUFFER
                LD      (CF_BUFFER),HL
                CALL    CF_READ_SECTOR
                RET     C
                XOR     A
                RET

F32BAD:
                LD      A,FAT32_ERR_FORMAT
                SCF
                RET

;; List entries in the FAT32 root directory.  This routine is called by the
;; RST $20 service dispatcher; it initializes/mounts the card if necessary.
F32DIR::
                CALL    CF_INIT
                JR      C,F32DIO
                CALL    F32MNT
                JR      C,F32DIO

                LD      HL,FROOT
                LD      DE,DCLST
                LD      C,4
F32DCP:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32DCP

                LD      HL,F32DMSG
                CALL    CON_PRINT
F32DCL:
                CALL    F32CLB
                LD      A,(FSPC)
                LD      (DSEC),A
F32DSL:
                CALL    F32DRD
                JR      C,F32DIO
                LD      HL,FAT32_SECTOR_BUFFER
                LD      (DPTR),HL
                LD      A,16
                LD      (DIDX),A
F32DEN:
                LD      HL,(DPTR)
                LD      A,(HL)
                OR      A
                JR      Z,F32DONE
                CP      $E5
                JR      Z,F32DSK
                LD      DE,11
                ADD     HL,DE
                LD      A,(HL)
                CP      $0F
                JR      Z,F32DSK
                AND     8
                JR      NZ,F32DSK
                CALL    F32DPR
F32DSK:
                LD      HL,(DPTR)
                LD      DE,32
                ADD     HL,DE
                LD      (DPTR),HL
                LD      A,(DIDX)
                DEC     A
                LD      (DIDX),A
                JR      NZ,F32DEN

                LD      A,(DSEC)
                DEC     A
                LD      (DSEC),A
                JR      Z,F32DNX
                CALL    F32INC
                JR      F32DSL

F32DNX:
                CALL    F32FAT
                JR      NC,F32DCL
                OR      A
                JR      Z,F32DONE
                JR      F32DIO

F32DONE:
                CALL    CON_NL
                RET

F32DIO:
                LD      HL,F32DERR
                CALL    CON_PRINT
                CALL    CON_NL
                RET

;; Read the sector at DLBA into the common sector cache.
F32DRD:
                LD      HL,DLBA
                LD      DE,CF_LBA
                LD      C,4
F32RCP:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32RCP
                JP      F32IO

F32INC:
                LD      A,(DLBA)
                INC     A
                LD      (DLBA),A
                RET     NZ
                LD      A,(DLBA+1)
                INC     A
                LD      (DLBA+1),A
                RET     NZ
                LD      A,(DLBA+2)
                INC     A
                LD      (DLBA+2),A
                RET     NZ
                LD      A,(DLBA+3)
                INC     A
                LD      (DLBA+3),A
                RET

;; DLBA = DATA_LBA + ((cluster - 2) * sectors/cluster).
F32CLB:
                LD      HL,DCLST
                LD      DE,DLBA
                LD      C,4
F32CLP:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32CLP
                LD      A,(DLBA)
                SUB     2
                LD      (DLBA),A
                LD      A,(DLBA+1)
                SBC     A,0
                LD      (DLBA+1),A
                LD      A,(DLBA+2)
                SBC     A,0
                LD      (DLBA+2),A
                LD      A,(DLBA+3)
                SBC     A,0
                LD      (DLBA+3),A

                LD      A,(FSPC)
                LD      B,0
F32SHC:
                CP      1
                JR      Z,F32SHL
                SRL     A
                INC     B
                JR      F32SHC
F32SHL:
                LD      A,B
                OR      A
                JR      Z,F32ADD
                LD      C,A
F32SH1:
                LD      A,(DLBA)
                ADD     A,A
                LD      (DLBA),A
                LD      A,(DLBA+1)
                RLA
                LD      (DLBA+1),A
                LD      A,(DLBA+2)
                RLA
                LD      (DLBA+2),A
                LD      A,(DLBA+3)
                RLA
                LD      (DLBA+3),A
                DEC     C
                JR      NZ,F32SH1
F32ADD:
                LD      A,(DLBA)
                LD      B,A
                LD      A,(FDLBA)
                ADD     A,B
                LD      (DLBA),A
                LD      A,(DLBA+1)
                LD      B,A
                LD      A,(FDLBA+1)
                ADC     A,B
                LD      (DLBA+1),A
                LD      A,(DLBA+2)
                LD      B,A
                LD      A,(FDLBA+2)
                ADC     A,B
                LD      (DLBA+2),A
                LD      A,(DLBA+3)
                LD      B,A
                LD      A,(FDLBA+3)
                ADC     A,B
                LD      (DLBA+3),A
                RET

;; Follow the current directory cluster through the first FAT.
;; Carry is set at end-of-chain or on an I/O error.
F32FAT:
                LD      HL,DCLST
                LD      DE,DWORK
                LD      C,4
F32FCP:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32FCP
                LD      B,7
F32FSR:
                LD      A,(DWORK+3)
                SRL     A
                LD      (DWORK+3),A
                LD      A,(DWORK+2)
                RR      A
                LD      (DWORK+2),A
                LD      A,(DWORK+1)
                RR      A
                LD      (DWORK+1),A
                LD      A,(DWORK)
                RR      A
                LD      (DWORK),A
                DJNZ    F32FSR

                LD      HL,FFLBA
                LD      DE,DLBA
                LD      C,4
F32FLB:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32FLB
                LD      A,(DLBA)
                LD      B,A
                LD      A,(DWORK)
                ADD     A,B
                LD      (DLBA),A
                LD      A,(DLBA+1)
                LD      B,A
                LD      A,(DWORK+1)
                ADC     A,B
                LD      (DLBA+1),A
                LD      A,(DLBA+2)
                LD      B,A
                LD      A,(DWORK+2)
                ADC     A,B
                LD      (DLBA+2),A
                LD      A,(DLBA+3)
                LD      B,A
                LD      A,(DWORK+3)
                ADC     A,B
                LD      (DLBA+3),A
                CALL    F32DRD
                JR      C,F32FCE

                LD      A,(DCLST)
                AND     $7F
                LD      L,A
                LD      H,0
                ADD     HL,HL
                ADD     HL,HL
                LD      DE,FAT32_SECTOR_BUFFER
                ADD     HL,DE
                LD      DE,DCLST
                LD      C,4
F32FCPY:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DEC     C
                JR      NZ,F32FCPY
                LD      A,(DCLST+3)
                AND     $0F
                LD      (DCLST+3),A
                CP      $0F
                JR      NZ,F32FCK
                LD      A,(DCLST+2)
                CP      $FF
                JR      NZ,F32FCK
                LD      A,(DCLST+1)
                CP      $FF
                JR      NZ,F32FCK
                LD      A,(DCLST)
                CP      $F8
                JR      NC,F32FEOC
                CP      $F0
                JR      NC,F32FERR
F32FCK:
                LD      A,(DCLST)
                CP      2
                JR      C,F32FERR
                OR      A
                RET
F32FEOC:
                XOR     A
                SCF
                RET
F32FERR:
                LD      A,FAT32_ERR_CHAIN
                SCF
                RET
F32FCE:
                SCF
                RET

;; Print a single 8.3 name.  The directory entry pointer is in DPTR.
F32DPR:
                LD      HL,(DPTR)
                LD      DE,DNAME
                LD      B,8
F32DBA:
                LD      A,(HL)
                LD      (DE),A
                INC     HL
                INC     DE
                DJNZ    F32DBA
                LD      HL,DNAME+7
                LD      B,8
F32DTR:
                LD      A,(HL)
                CP      ' '
                JR      NZ,F32DBT
                DEC     HL
                DJNZ    F32DTR
                LD      HL,DNAME
                JR      F32DBZ
F32DBT:
                INC     HL
F32DBZ:
                LD      (HL),0
                LD      A,(DPTR)
                ; Extension starts at directory-entry byte 8.
                LD      HL,(DPTR)
                LD      DE,8
                ADD     HL,DE
                LD      A,(HL)
                CP      ' '
                JR      Z,F32DOUT
                LD      HL,DNAME
F32DLN:
                LD      A,(HL)
                OR      A
                JR      Z,F32DDOT
                INC     HL
                JR      F32DLN
F32DDOT:
                LD      (HL),'.'
                INC     HL
                PUSH    HL
                LD      HL,(DPTR)
                LD      DE,8
                ADD     HL,DE
                EX      DE,HL
                POP     HL
                LD      B,3
F32DEX:
                LD      A,(DE)
                LD      (HL),A
                INC     DE
                INC     HL
                DJNZ    F32DEX
                LD      (HL),0
F32DOUT:
                LD      HL,DNAME
                CALL    CON_PRINT
                CALL    CON_NL
                RET

F32DMSG:
                .BYTE   CR,LF,"Root directory:",CR,LF,0
F32DERR:
                .BYTE   CR,LF,"FAT32 read/mount error",0

                .END
