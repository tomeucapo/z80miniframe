
CF_DATA       .EQU   $0130
CF_ERR        .EQU   $0131
CF_FTR        .EQU   $0131
CF_SECCNT     .EQU   $0132
CF_LBA0       .EQU   $0133
CF_LBA1       .EQU   $0134
CF_LBA2       .EQU   $0135
CF_LBA3       .EQU   $0136
CF_STAT       .EQU   $0137
CF_CMD        .EQU   $0137


;------------------------------------------------------------------------------
; R O U T I N E S
;------------------------------------------------------------------------------

; initilialize CF to work with, wakeing it up from standby and setting it to work in 8-bit mode
CF_INIT:    call    CF_NOP          ; execute a NOP to wake up the CF
            call    CR_DEV_RDY      ; wait for CF available and ready
            ret     C               ; no card or I/O error, leave
            ld      A,$01           ; 8-bit mode
            LD      BC, CF_FTR
            out     (C),A           ; set mode
            call    CF_BUSY         ; wait for CF being ready
            ld      A,$EF           ; command to set mode
            LD      BC, CF_CMD
            out     (C),A           ; execute command
            call    CF_BUSY         ; wait for CF being ready
            ret                     ; return to caller


; a NOP command, just used to wake up the CF card 
CF_NOP:     ld      A,$69           ; NOP command
            LD      BC, CF_FTR
            out     (C),A      ; send it
            ld      A,$EF           ; set mode command
            LD      BC, CF_CMD
            out     (C),A      ; execute NOP
            ret                     ; return to caller


; wait until BUSY bit is 0 (means CF has executed the requested job)  
CF_BUSY:    LD      BC, CF_STAT
            in      A,(C)     ; read status register
            rlca                    ; copy bit #7 into the Carry
            jp      C,CF_BUSY       ; loop while bit #7 is 1
            ret                     ; bit #7 cleared - return to caller


; check that CF is ready to get commands
CF_CMDRDY:  LD      BC, CF_STAT
            in      A,(C)     ; read status register
            bit     0,A             ; any error?
            jr      NZ,RETERR       ; yes, return error
            and     11000000b       ; check only bits #6 & #7
            xor     01000000b       ; bit #7 (BUSY) must be 0 and bit #6 (DRVRDY) must be 1
            jr      NZ,CF_CMDRDY    ; wait
            ret                     ; return to caller
RETERR:     scf                     ; set carry flag
            ret                     ; return


; wait until data is ready to be read
CF_DAT_RDY: LD      BC, CF_STAT
            in      A,(C)     ; read status register
            bit     0,A             ; any error?
            jr      NZ,RETERR       ; yes, return error
            and     10001000b       ; check only bits #7 & #3
            xor     00001000b       ; bit #7 (BUSY) must be 0 and bit #3 (DRQ) must be 1
            jr      NZ,CF_DAT_RDY   ; wait until data is ready
            ret                     ; return to caller


; set sector to read from/write to - sector number is into DEBC (C=LSB, D=MSB)
CF_SETSTR:  call    CF_CMDRDY       ; Make sure drive is ready for command
            ld      A,$01           ; 1 sector at a time
            LD      BC, CF_SECCNT
            out     (C),A   ; set number of sectors
            call    CF_CMDRDY       ; Make sure drive is ready for command
            ld      A,C             ; load LBA0 byte
            LD      BC, CF_LBA0
            out     (C),A     ; send it
            call    CF_CMDRDY       ; Make sure drive is ready for command
            ld      A,B             ; load LBA1 byte
            LD      BC, CF_LBA1
            out     (C),A     ; send it
            call    CF_CMDRDY       ; Make sure drive is ready for command
            ld      A,E             ; load LBA2 byte
            LD      BC, CF_LBA2
            out     (C),A     ; send it
            call    CF_CMDRDY       ; Make sure drive is ready for command
            ld      A,$E0           ; load LBA3 byte+master+LBA addressing
            or      D               ; add LBA sector
            LD      BC, CF_LBA3
            out     (C),A     ; send it
            ret                     ; return to caller


; check if device is available & ready - try a bit of times, then exit with
; error if no response, otherwise wait until device is ready
; return Carry = 0 if device is available and ready, Carry = 1 if errors
CR_DEV_RDY: push    BC              ; store HL
            ld      B,$00           ; 256 tries
CR_DV_RD_1: push    BC
            ld      BC, CF_STAT       ; address of status register
            in      A,(C)           ; load status register (curiously, with no CF attached, in(CF_STAT) returns %01111000)
            cp      01000000b       ; busy=0, rdy=1
            jr      Z,CR_DV_RD_E    ; got a response, so leave
            cp      01010000b       ; busy=0, rdy=1, dsc=1
            jr      Z,CR_DV_RD_E    ; got a response, so leave
            POP     BC
            djnz    CR_DV_RD_1      ; repeat until timeout (Carry=1 while HL<DE)
            scf                     ; exit with Carry = 1 (device NOT ready)
CR_DV_RD_E: pop     BC              ; retrieve HL
            ret                     ; return to caller


; put the CF into stand-by mode
CF_STANDBY: ld 	    A,$E0   		; select CF as master, driver 0, LBA mode (bits #5-7=111) 
            LD      BC, CF_LBA3
            out 	(C),A     ; send configuration
            ld      A,$92           ; standby mode
            LD      BC, CF_CMD
            out     (C),A      ; send command
            call    CF_BUSY         ; wait for CF being ready
            ret                     ; return to caller


;***************************************************************************
; CF_RD_SEC
; Function: load a sector (512 bytes) into RAM buffer.
;***************************************************************************			
CF_RD_SEC:  call    CF_CMDRDY       ; Make sure drive is ready for command
            ret     C               ; return if error
            ld      A,$20           ; Prepare read command
            LD      BC, CF_CMD
            out     (C),A      ; Send read command
            call    CF_DAT_RDY      ; Wait until data is ready to be read
            ret     C               ; return if error       
            LD      BC, CF_STAT
            in      A,(C)     ; Read status
            and     00000001b       ; mask off error bit
            jp      NZ,CF_RD_SEC    ; Try again if error
; read CF buffer after it's been filled up by a previous command
; and store data into the I/O buffer
CF_RD_CMD:  push    BC              ; store BC
            push    HL              ; store HL
            call    CF_DAT_RDY	    ; wait for data from CF to be ready
            jr      C,CF_RD_EXIT    ; if error, leave
            ld      BC,CF_DATA      ; set 256 bytes per loop (B=$00) and CF port (C=CF_DATA)
            ld      HL,IOBUFF       ; get starting address of I/O buffer
            inir                    ; get 256 bytes
            inir                    ; get 256 bytes
CF_RD_EXIT: pop     HL              ; retrieve HL
            pop     BC              ; retrieve BC
            ret                     ; return to caller


;***************************************************************************
; CF_WR_SEC
; Function: write a sector to Compact Flash - sector address is into BCDE - source address is into HL
;***************************************************************************
CF_WR_SEC:  push    BC              ; store BC
            push    HL              ; store HL
            call    CF_SETSTR       ; set sector
            call    CF_CMDRDY       ; Make sure drive is ready for command
            jr      C,CF_WR_EXIT    ; return if error
            ld      A,$30           ; set write command
            LD      BC, CF_CMD
            out     (C),A      ; send command
            call    CF_DAT_RDY      ; Make sure drive is ready to get data
            jr      C,CF_WR_EXIT    ; return if error
            ld 	    HL,IOBUFF       ; get starting address of I/O buffer
            ld      BC,CF_DATA      ; set 256 bytes per loop (B=$00) and CF port (C=CF_DATA)
            otir                    ; output 256 bytes
            otir                    ; output 256 bytes
            call    CF_BUSY         ; wait for CF to complete the writing
            xor     A               ; clear Carry
CF_WR_EXIT: pop     HL              ; retrieve HL
            pop     BC              ; retrieve BC
            ret                     ; return to caller

            .ORG    $FDA0
IOBUFF:     BLOCK   $200, $FF        ; 512 bytes buffer
            BLOCK   $06, $FF
