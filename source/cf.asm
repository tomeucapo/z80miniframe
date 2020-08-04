; ------------------ Hardware specific CF subroutines------
;---------------------------------------------------------------------
; cf_read_sector
; Highest level subroutine for reading sector from drive. 
; entry data: lba0-3 bytes in RAM.
; Drive has to be initialised first.
;---------------------------------------------------------------------

cf_read_sector:
	call cf_wait
	call cf_set_lba
	ld bc,0ffc2h
	ld a,1			; we are reading one sector
	out (c),a
	call cf_wait
	
	ld bc,0ffc7h
	ld a,20h
	out (c),a	; sector read command (20h) to command register
	
	call cf_error_check			
	ld a,(local_error_flag)
	cp 01h
	ret z
	call cf_read
	ret

;---------------------------------------------------------------------
; cf_write_sector
; Highest level subroutine for writing sector to drive. 
; entry data: lba0-3 bytes in RAM.
; Drive has to be initialised first.
;---------------------------------------------------------------------
cf_write_sector:
	call cf_wait
	call cf_set_lba
	ld bc,0ffc2h
	ld a,1			; we are writing one sector
	out (c),a
	call cf_wait
	
	ld bc,0ffc7h
	ld a,30h
	out (c),a	; sector write command (30h) to command register
	
	call cf_error_check
	ld a,(local_error_flag)
	cp 01h
	ret z
	call cf_write
	ret
	
	
;---------------------------------------------------------------------
; cf_set_lba
; Sets LBA registers of CF card. LBA address given in lba0-3 bytes in
; RAM memory. 
;---------------------------------------------------------------------
cf_set_lba:
	ld a,(lba0)
	ld bc,0ffc3h
	out (c),a
	
	ld a,(lba1)
	ld bc,0ffc4h
	out (c),a
	
	ld a,(lba2)
	ld bc,0ffc5h
	out (c),a	
	
	ld a,(lba3)
	ld bc,0ffc6h
	
	and 0fh		; mask out 4 bits (MSB) of LBA
	or 0e0h		; setting mode: LBA, drive: master/
	
	out (c),a
	
	ret

;---------------------------------------------------------------------
; cf_wait
;waiting for the drive to complete an operation
;---------------------------------------------------------------------
cf_wait:
	ld bc,0ffc7h	;status register.
	in a,(c)
	and 80h			;checking bit 7: BSY, "1" means the drive is busy.
	jp nz,cf_wait
	ret
	
;---------------------------------------------------------------------
; cf_error_check
; Checking for errors after completinng an operation
;---------------------------------------------------------------------
cf_error_check:
	ld bc,0ffc7h	;status register.
	in a,(c)
	and 01h			;checking bit 0: if set, an error occured. 
	jp z,no_error

	ld a,01h	;on error
	ld (local_error_flag),a
	ret
	

no_error:			;no error: return.
	ld a,00h
	ld (local_error_flag),a
	ret
	

;-----------------------------------------------------------------
; cf_read
; Reads 128 byte sector from CF card and stores it in dmaad
;-----------------------------------------------------------------
cf_read:
	ld hl,(dmaad)
	ld d,128		;only this number of bytes to read!
cf_read1:	
	call cf_wait	;wait for drive to be ready.
	ld bc,0ffc7h	;status/command register
	in a,(c)
	and 08h			;checking DRQ bit. "1" means the drive has more data to read.
	jp z,no_more_data
	ld bc,0ffc0h	;reading one byte from drive`s data buffer.
	in a,(c)
	ld e,a			;lay aside for a moment.
	ld a,d			;checking if byte 128 read.
	cp 0
	jp z,cf_read1	;continue dummy read
	dec d			;continue normal read...
	ld a,e			;restare accumulator
	ld (hl),a		;storing the byte at (ix)
	inc hl
	jp cf_read1
no_more_data:
	ret

;-----------------------------------------------------------------
; cf_write
; Writes 128 byte sector from dmaad to CF card 
;-----------------------------------------------------------------
cf_write:
	ld hl,(dmaad)
	ld d,128
cf_write1:	
	call cf_wait	;wait for drive to be ready.
	ld bc,0ffc7h	;status/command register
	in a,(c)
	and 08h			;checking DRQ bit. "1" means the drive has more data to read.
	jp z,no_more_data_to_write
	ld bc,0ffc0h	;drive`s data buffer
	ld a,(hl)		;one byte from buffer in RAM
	out (c),a		;sending byte to drive
	ld a,d
	cp 0
	jp z,cf_write1
	dec d
	inc hl
	jp cf_write1
no_more_data_to_write:
	ret


;
;------------------- CF Card
lba0: .db 0
lba1: .db 0
lba2: .db 0
lba3: .db 0

start_lba0: .db 00h
start_lba1: .db 4ah
start_lba2: .db 01h
start_lba3: .db 00h

local_error_flag: .db 0

end.