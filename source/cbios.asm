;	skeletal cbios for first level of CP/M 2.0 alteration
;
ccp:	.EQU    05948h  ;	0D400h		;base of ccp
bdos:	.EQU    05142h  ;	0DC06h		;bdos entry
bios:	.EQU    04348h  ;	0EA00h		;base of bios
cdisk:	.EQU	0004h		;address of current disk number 0=a,... l5=p
iobyte:	.EQU	0003h		;intel i/o byte
disks:	.EQU	04h		 ;number of disks in the system
;
	    .ORG	$4348    ;bios		;origin of this program

nsects:	.EQU	($-ccp)/128	;warm start sector count
;
;	jump vector for individual subroutines
;
	JP	boot	;cold start
wboote:	JP	wboot	;warm start
	JP	const	;console status
	JP	conin	;console character in
	JP	conout	;console character out
	JP	list	;list character out
	JP	punch	;punch character out
	JP	reader	;reader character out
	JP	home	;move head to home position
	JP	seldsk	;select disk
	JP	settrk	;set track number
	JP	setsec	;set sector number
	JP	setdma	;set dma address
	JP	read	;read disk
	JP	write	;write disk
	JP	listst	;return list status
	JP	sectran	;sector translate
;
;	fixed data tables for four-drive standard
;	ibm-compatible 8" disks
;	no translations
;
;	disk Parameter header for disk 00
dpbase:	.dw	0000h, 0000h
	.dw	0000h, 0000h
	.dw	dirbf, dpblk
	.dw	chk00, all00
;	disk parameter header for disk 01
	.dw	0000h, 0000h
	.dw	0000h, 0000h
	.dw	dirbf, dpblk
	.dw	chk01, all01
;	disk parameter header for disk 02
	.dw	0000h, 0000h
	.dw	0000h, 0000h
	.dw	dirbf, dpblk
	.dw	chk02, all02
;	disk parameter header for disk 03
	.dw	0000h, 0000h
	.dw	0000h, 0000h
	.dw	dirbf, dpblk
	.dw	chk03, all03
;
;	sector translate vector
trans:	.db	 1,  7, 13, 19	;sectors  1,  2,  3,  4
	.db	25,  5, 11, 17	;sectors  5,  6,  7,  6
	.db	23,  3,  9, 15	;sectors  9, 10, 11, 12
	.db	21,  2,  8, 14	;sectors 13, 14, 15, 16
	.db	20, 26,  6, 12	;sectors 17, 18, 19, 20
	.db	18, 24,  4, 10	;sectors 21, 22, 23, 24
	.db	16, 22		;sectors 25, 26
;
dpblk:	;disk parameter block for all disks.
	.dw	26		;sectors per track
	.db	3		;block shift factor
	.db	7		;block mask
	.db	0		;null mask
	.dw	242		;disk size-1
	.dw	63		;directory max
	.db	192		;alloc 0
	.db	0		;alloc 1
	.dw	0		;check size
	.dw	2		;track offset
;
;	end of fixed tables
;
;	individual subroutines to perform each function
boot:	;simplest case is to just perform parameter initialization
	XOR	a		;zero in the accum
	LD	(cdisk),A	;select disk zero
	ld a,3
	LD	(iobyte),A	;clear the iobyte

	ld hl,bios_hello_sign    ;just write greeting messages.
bios_print_hello:			
	ld a,(hl)
	cp 0
	jp z,bios_end_print_hello
	ld c,a
	call conout
	inc hl
	jp bios_print_hello

bios_end_print_hello:
	
	JP	gocpm		;initialize and go to cp/m
;
wboot:	;simplest case is to read the disk until all sectors loaded
	LD	sp, 80h		;use space below buffer for stack
	LD 	c, 0		;select disk 0
	
	call	seldsk
	call	home		;go to track 00
;
	LD 	b, nsects	;b counts * of sectors to load
	LD 	c, 0		;c has the current track number
	LD 	d, 2		;d has the next sector to read
;	note that we begin by reading track 0, sector 2 since sector 1
;	contains the cold start loader, which is skipped in a warm start
	LD	HL, ccp		;base of cp/m (initial load point)
load1:	;load	one more sector
	PUSH	BC		;save sector count, current track
	PUSH	DE		;save next sector to read
	PUSH	HL		;save dma address
	LD 	c, d		;get sector address to register C
	call	setsec		;set sector address from register C
	pop	BC		;recall dma address to b, C
	PUSH	BC		;replace on stack for later recall
	call	setdma		;set dma address from b, C
;
;	drive set to 0, track set, sector set, dma address set
	call	read
	CP	00h		;any errors?
	JP	NZ,wboot	;retry the entire boot if an error occurs
;
;	no error, move to next sector
	pop	HL		;recall dma address
	LD	DE, 128		;dma=dma+128
	ADD	HL,DE		;new dma address is in h, l
	pop	DE		;recall sector address
	pop	BC		;recall number of sectors remaining, and current trk
	DEC	b		;sectors=sectors-1
	JP	Z,gocpm		;transfer to cp/m if all have been loaded
;
;	more	sectors remain to load, check for track change
	INC	d
	LD 	a,d		;sector=27?, if so, change tracks
	CP	27
	JP	C,load1		;carry generated if sector<27
;
;	end of	current track,	go to next track
	LD 	d, 1		;begin with first sector of next track
	INC	c		;track=track+1
;
;	save	register state, and change tracks
	PUSH	BC
	PUSH	DE
	PUSH	HL
	call	settrk		;track address set from register c
	pop	HL
	pop	DE
	pop	BC
	JP	load1		;for another sector
;
;	end of	load operation, set parameters and go to cp/m
gocpm:
	LD 	a, 0c3h		;c3 is a jmp instruction
	LD	(0),A		;for jmp to wboot
	LD	HL, wboote	;wboot entry point
	LD	(1),HL		;set address field for jmp at 0
;
	LD	(5),A		;for jmp to bdos
	LD	HL, bdos	;bdos entry point
	LD	(6),HL		;address field of Jump at 5 to bdos
;
	LD	BC, 80h		;default dma address is 80h
	call	setdma

	;screen and keyboard variables init
	ld a,0
	ld (R_SHIFT_PRESSED),a
	ld (L_SHIFT_PRESSED),a
	ld (CTRL_PRESSED),a
	ld (KEY_REPEAT),a
	ld (ESCAPE),a

	ld hl,hello_sign    ;just write greeting messages.
print_hello:			
	ld a,(hl)
	cp 0
	jp z,end_print_hello
	ld c,a
	call conout
	inc hl
	jp print_hello

end_print_hello:

	;ei			;enable the interrupt system
	LD	A,(cdisk)	;get current disk number
	cp	disks		;see if valid disk number
	jp	c,diskok	;disk valid, go to ccp
	ld	a,0		;invalid disk, change to disk 0
diskok:	LD 	c, a		;send to the ccp
	JP	ccp		;go to cp/m for further processing
;
;
;	simple i/o handlers (must be filled in by user)
;	in each case, the entry point is provided, with space reserved
;	to insert your own code
;
const:	;console status, return 0ffh if character ready, 00h if not
	; TODO: Call monitor function to do this

	ret
;
conin:	    ;console character into register a
	JP 		$0010
	ret
;
conout:		;console character output from register c
	ld 		a,c
	JP      $0008
	ret
;
list:	;list character from register c
	LD 	a, c	  	;character to register a
	ret		  	;null subroutine
;
listst:	;return list status (0 if not ready, 1 if ready)
	XOR	a	 	;0 is always ok to return
	ret
;
punch:	;punch	character from	register C
	LD 	a, c		;character to register a
	ret			;null subroutine
;
;
reader:	;reader character into register a from reader device
	LD     a, 1ah		;enter end of file for now (replace later)
	AND    7fh		;remember to strip parity bit
	ret
;
;
;	i/o drivers for the disk follow
;	for now, we will simply store the parameters away for use
;	in the read and write	subroutines
;
home:	;move to the track 00	position of current drive
;	translate this call into a settrk call with Parameter 00
	LD     c, 0		;select track 0
	call   settrk
	ret			;we will move to 00 on first read/write
;
seldsk:	;select disk given by register c
	LD	HL, 0000h	;error return code
	LD 	a, c
	LD	(diskno),A
	CP	disks		;must be between 0 and 3
	RET	NC		;no carry if 4, 5,...
;	disk number is in the proper range
;	defs	10		;space for disk select
;	compute proper disk Parameter header address
	LD	A,(diskno)
	LD 	l, a		;l=disk number 0, 1, 2, 3
	LD 	h, 0		;high order zero
	ADD	HL,HL		;*2
	ADD	HL,HL		;*4
	ADD	HL,HL		;*8
	ADD	HL,HL		;*16 (size of each header)
	LD	DE, dpbase
	ADD	HL,DE		;hl=,dpbase (diskno*16) Note typo here in original source.
	ret
;
settrk:	;set track given by register c
	LD 	a, c
	LD	(track),A
	ret
;
setsec:	;set sector given by register c
	LD 	a, c
	LD	(sector),A
	ret
;
;
sectran:
	;translate the sector given by bc using the
	;translate table given by de
	EX	DE,HL		;hl=.trans
	ADD	HL,BC		;hl=.trans (sector)
	ret			;debug no translation
	LD 	l, (hl)		;l=trans (sector)
	LD 	h, 0		;hl=trans (sector)
	ret			;with value in hl
;
setdma:	;set	dma address given by registers b and c
	LD 	l, c		;low order address
	LD 	h, b		;high order address
	LD	(dmaad),HL	;save the address
	ret
;
read:
;Read one CP/M sector from disk.
;Return a 00h in register a if the operation completes properly, and 0lh if an error occurs during the read.
;Disk number in 'diskno'
;Track number in 'track'
;Sector number in 'sector'
;Dma address in 'dmaad' (0-65535)
;
			
			call std_to_lba
			call cf_read_sector
			ld a,(local_error_flag)			;error bit
			
			ret

write:
;Write one CP/M sector to disk.
;Return a 00h in register a if the operation completes properly, and 0lh if an error occurs during the read or write
;Disk number in 'diskno'
;Track number in 'track'
;Sector number in 'sector'
;Dma address in 'dmaad' (0-65535)
			
			
			call std_to_lba	
			call cf_write_sector
			ld a,(local_error_flag)			;check for error	
			
			ret


	
;----------------------------------
;Packs CP/M Sector / track / disk number 
;into lba0-3 and adds shift from start
;of the CF drive to preserve
;FAT16 partition. 
;----------------------------------
std_to_lba:	

	ld a,0
	ld (lba3),a
	ld (lba2),a
	ld (lba1),a
	ld (lba0),a

	ld a,(track)
	ld b,a
	ld a,(sector)
	sla b
	sla b
	sla b
	sla b
	sla b
	or b
	ld (lba0),a
	ld a,(track)
	ld b,a
	srl b
	srl b
	srl b
	ld a,(diskno)
	sla a
	sla a
	sla a
	sla a
	or b
	ld (lba1),a

	ld de,start_lba0
	ld hl,lba0
	ld b,4
	call longadd
	ret 

longadd:
	xor a

addlop:
	ld a,(de)
	adc a,(hl)
	ld (hl),a
	inc hl
	inc de
	djnz addlop
	ret

;---- Simple delay for character read

key_delay:
	push af
	push bc
	ld b,255
_key_delay:
	nop
	djnz _key_delay
	pop bc
	pop af
	ret


;****************************
;	a(BCD) => a(BIN) 
;	[00h..99h] -> [0..99]
;****************************
bcd2bin:
	push	bc
	ld	c,a
	and	0f0h
	srl	a
	ld	b,a
	srl	a
	srl	a
	add	a,b
	ld	b,a
	ld	a,c
	and	0fh
	add	a,b
	pop	bc
	ret

line_lookup: .dw 0,160,320,480,640,800,960,1120,1280,1440,1600,1760,1920,2080,2240,2400,2560,2720,2880,3040,3200,3360,3520,3680,3840

track:	.db	0		;two bytes for expansion
sector:	.db	0		;two bytes for expansion
dmaad:	.dw	0		;direct memory address
diskno:	.db	0		;disk number 0-15
;
;	scratch ram area for bdos use
begdat:	.equ	$	 	;beginning of data area
dirbf:	.ds	128,0	 	;scratch directory area
all00:	.ds	31,0	 	;allocation vector 0
all01:	.ds	31,0	 	;allocation vector 1
all02:	.ds	31,0	 	;allocation vector 2
all03:	.ds	31,0	 	;allocation vector 3
chk00:	.ds	16,0		;check vector 0
chk01:	.ds	16,0		;check vector 1
chk02:	.ds 	16,0	 	;check vector 2
chk03:	.ds	16,0	 	;check vector 3


hello_sign: .db 0dh,0ah,"CP/M 2.2 Copyright 1979 (c) by Digital Research",0Dh,0Ah,0
bios_hello_sign: .db 0dh,0ah,"CP/M Bios for C-Z80 Computer Copyright 2016 (c) by Michal Cierniak" ,0Dh,0Ah,0

; Keyboard/monitor buffers and variables:

ESCAPE_BUFFER:		.ds 10,0
ESCAPE:				.db 0
ESCAPE_CHAR_COUNT:	.db 0
KEY_REPEAT: 		.db 0
R_SHIFT_PRESSED:	.db 0  
L_SHIFT_PRESSED:	.db 0  
CTRL_PRESSED:		.db 0

;-------------------------

enddat:	.equ	$	 	;end of data area
datsiz:	.equ	$-begdat;	;size of data area

include "cf.asm"

.end
