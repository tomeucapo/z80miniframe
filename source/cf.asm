;;******************************************************************
;; CompactFlash (IDE task-file) routines
;;
;; API:
;;   CF_INIT         Configure the card for 8-bit PIO transfers.
;;   CF_READ_SECTOR  Read one 512-byte sector.
;;   CF_WRITE_SECTOR Write one 512-byte sector.
;;
;; Before a read/write, set CF_LBA (four-byte little-endian LBA28) and
;; CF_BUFFER (two-byte little-endian RAM pointer) in globals.inc.
;; Carry is clear on success. On error, carry is set and A contains the
;; ATA status byte, or CF_ERR_TIMEOUT / CF_ERR_LBA for local errors.
;; AF, BC and HL are clobbered. The caller must provide a contiguous
;; 512-byte buffer and call CF_INIT before the first data transfer.
;;******************************************************************

                include "globals.inc"
                include "cf.inc"

                public CF_INIT, CF_READ_SECTOR, CF_WRITE_SECTOR

CF_INIT::
                CALL    CF_WAIT_NOT_BUSY
                RET     C
                CALL    CF_CHECK_STATUS
                RET     C

                ; Select master in LBA mode.
                LD      A,$E0
                OUT     (CF_DEVICE),A
                CALL    CF_WAIT_NOT_BUSY
                RET     C
                CALL    CF_CHECK_STATUS
                RET     C

                ; CompactFlash SET FEATURES: enable 8-bit data transfers.
                LD      A,CF_FEATURE_8BIT
                OUT     (CF_FEATURES),A
                LD      A,0
                OUT     (CF_SECTOR_COUNT),A
                LD      A,CF_CMD_SET_FEAT
                OUT     (CF_COMMAND),A
                CALL    CF_WAIT_NOT_BUSY
                RET     C
                JP      CF_CHECK_STATUS

CF_READ_SECTOR::
                CALL    CF_PREPARE_SECTOR
                RET     C
                LD      A,CF_CMD_READ
                OUT     (CF_COMMAND),A
                CALL    CF_WAIT_DRQ
                RET     C

                LD      HL,(CF_BUFFER)
                LD      B,0
CF_READ_BLOCK_1:
                IN      A,(CF_DATA)
                LD      (HL),A
                INC     HL
                DJNZ    CF_READ_BLOCK_1
                LD      B,0
CF_READ_BLOCK_2:
                IN      A,(CF_DATA)
                LD      (HL),A
                INC     HL
                DJNZ    CF_READ_BLOCK_2

                CALL    CF_WAIT_NOT_BUSY
                RET     C
                JP      CF_CHECK_STATUS

CF_WRITE_SECTOR::
                CALL    CF_PREPARE_SECTOR
                RET     C
                LD      A,CF_CMD_WRITE
                OUT     (CF_COMMAND),A
                CALL    CF_WAIT_DRQ
                RET     C

                LD      HL,(CF_BUFFER)
                LD      B,0
CF_WRITE_BLOCK_1:
                LD      A,(HL)
                OUT     (CF_DATA),A
                INC     HL
                DJNZ    CF_WRITE_BLOCK_1
                LD      B,0
CF_WRITE_BLOCK_2:
                LD      A,(HL)
                OUT     (CF_DATA),A
                INC     HL
                DJNZ    CF_WRITE_BLOCK_2

                CALL    CF_WAIT_NOT_BUSY
                RET     C
                JP      CF_CHECK_STATUS

; Validate LBA28, wait for the device, select the addressed sector and
; program a one-sector transfer.
CF_PREPARE_SECTOR:
                LD      A,(CF_LBA+3)
                AND     $F0
                JR      Z,CF_LBA_VALID
                LD      A,CF_ERR_LBA
                SCF
                RET

CF_LBA_VALID:
                CALL    CF_WAIT_NOT_BUSY
                RET     C
                CALL    CF_CHECK_STATUS
                RET     C

                LD      A,(CF_LBA+3)
                AND     $0F
                OR      $E0
                OUT     (CF_DEVICE),A
                CALL    CF_WAIT_NOT_BUSY
                RET     C
                CALL    CF_CHECK_STATUS
                RET     C

                LD      A,1
                OUT     (CF_SECTOR_COUNT),A
                LD      A,(CF_LBA)
                OUT     (CF_LBA_LOW),A
                LD      A,(CF_LBA+1)
                OUT     (CF_LBA_MID),A
                LD      A,(CF_LBA+2)
                OUT     (CF_LBA_HIGH),A
                OR      A               ; Clear carry
                RET

; Poll until BSY clears. BC is a bounded timeout counter.
CF_WAIT_NOT_BUSY:
                LD      BC,$FFFF
CF_WAIT_NOT_BUSY_LOOP:
                IN      A,(CF_STATUS)
                BIT     7,A
                JR      Z,CF_WAIT_NOT_BUSY_OK
                DEC     BC
                LD      A,B
                OR      C
                JR      NZ,CF_WAIT_NOT_BUSY_LOOP
                LD      A,CF_ERR_TIMEOUT
                SCF
                RET
CF_WAIT_NOT_BUSY_OK:
                IN      A,(CF_STATUS)
                OR      A               ; Clear carry, keep status in A
                RET

; Poll until DRQ is asserted. Return carry set on timeout or ATA error.
CF_WAIT_DRQ:
                LD      BC,$FFFF
CF_WAIT_DRQ_LOOP:
                IN      A,(CF_STATUS)
                BIT     7,A
                JR      NZ,CF_WAIT_DRQ_AGAIN
                BIT     0,A
                JR      NZ,CF_WAIT_DRQ_ERROR
                BIT     5,A
                JR      NZ,CF_WAIT_DRQ_ERROR
                BIT     3,A
                JR      NZ,CF_WAIT_DRQ_OK
CF_WAIT_DRQ_AGAIN:
                DEC     BC
                LD      A,B
                OR      C
                JR      NZ,CF_WAIT_DRQ_LOOP
                LD      A,CF_ERR_TIMEOUT
                SCF
                RET
CF_WAIT_DRQ_ERROR:
                SCF
                RET
CF_WAIT_DRQ_OK:
                OR      A               ; Clear carry, keep status in A
                RET

; Check ATA ERR and device-fault bits in the status byte in A.
CF_CHECK_STATUS:
                BIT     0,A
                JR      NZ,CF_CHECK_STATUS_ERROR
                BIT     5,A
                JR      NZ,CF_CHECK_STATUS_ERROR
                OR      A
                RET
CF_CHECK_STATUS_ERROR:
                SCF
                RET
