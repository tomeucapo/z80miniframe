;	skeletal cbios for first level of CP/M 2.0 alteration
;
ccp:	.equ 0D400h;	0D400h		;base of ccp
bdos:	.equ 0DC06h;	0DC06h		;bdos entry
bios:	.equ 0EA00h;	0EA00h		;base of bios
cdisk:	.equ	0004h		;address of current disk number 0=a,... l5=p
iobyte:	.equ	0003h		;intel i/o byte
disks:	.equ	04h		;number of disks in the system
;
	.org	bios		;origin of this program
nsects:	.equ	($-ccp)/128	;warm start sector count
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
	ld (VRAM_POSITION),A
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
;

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

	ei			;enable the interrupt system
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
;	push bc		;plain RS232 commented
;	ld bc,0ffb5h
;	in a,(c)
;	pop bc
;	bit 0,a

	call start_skan
	cp 0ffh
	jp 	z,no_char
	
	ld	a,0ffh		;char ready	
	ret
no_char:ld	a,00h		;no char
	ret
;
conin:	;console character into register a
;	push bc		;plain RS232 commented
;	ld bc,0ffb5h
;	in a,(c)
;	pop bc
;	bit 0,a
;	jp z,conin
;	push bc
;	ld bc,0ffb0h
;	in a,(c)
;	pop bc
	call start_skan
	cp 0ffh
	jp z,conin	
	
	call key_delay	
	call keyboard_decode
	call key_delay

	push af
release_wait:
	call start_skan
	cp 0ffh	
	jp nz,release_wait
	pop af
	AND	7fh		;strip parity bit
	ret
;
conout:	;console character output from register c
;	push bc
;	ld bc,0ffb5h
;	in a,(c)
;	pop bc
;	bit 6,a
;	jp z,conout
;	
;	ld a,c
;	push bc
;	ld bc,0ffb0h
;	out (c),a
;	pop bc
	ld a,c
	
	call char_display
	
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

;------------MOJE PROCEDURY OBS£UGI KLAWIATURY----
;**************************************************************************************
; Procedura skanuj¹ca klawiaturê. U¿ywa prtu fffeh w trybie wejœciowym i wyjœciowym.
; Na zatrzask wyjœciowy podawana jest kolejno liczba binarna maj¹ca jedno "0" i za ka¿dym
; razem "0" jest przesuwane w lewo (instrukcja rlc). Przy ka¿dym przesuniêciu jest 
; odczytywany port fffeh i sprawdzane jest na którym bicie pojawia siê "0". W przypadku 
; wykrycia zera, obliczany jest indeks dla dalszych tablic. Max iloœæ klawiszy to 64
; dla 8bit porty we i 8bit portu wy. 
; Procedura zwraca wynik w akumulatrze. Jest to ff gdy nie naciœniêto ¿adnego przycisku
; lub numer indeksu gdy naciœniêto przycisk. Dodatkowo procedura usupe³nia zmienne w RAM
; dotycz¹ce naciœniêcia shift.
; Na wyjœciu (w rej. A) mamy numer klawisza (kolejnoœæ przycisku na matrycy klawiatury)
; Procedura jest nieblokuj¹ca.
;**************************************************************************************
start_skan:

	push bc
	push de
	
;sprawdzam czy nacisnieto shift lub ctrl. Skanujê odpowiedni¹ kolumnê i wpisujê j¹ do pamiêci pod (R_SHIFT_PRESSED)
; (L_SHIFT_PRESSED) oraz (CTRL_PRESSED).
;W poni¿szym kodzie warto umieœciæ dodatkowe testy na inne klawisze, bêd¹ potem interpretowane w procedurze
;keyboard_decode.

;-------------------------
	ld a,11110111b
	ld bc,0fffeh
	out (c),a
	in a,(c)
	ld (R_SHIFT_PRESSED),a

	ld a,11101111b
	ld bc,0fffeh
	out (c),a
	in a,(c)
	ld (L_SHIFT_PRESSED),a	
	
	ld a,11011111b
	ld bc,0fffeh
	out (c),a
	in a,(c)
	ld (CTRL_PRESSED),a
;-------------------------

	ld d,0			; rejestr wynikowy - zawiera indeks naciœniêtego klawisza. Mapa klawiszy do zamieszczenia w dokumentacji komputera.
	ld e,0feh		; wartoœæ testuj¹ca - na pocz¹tku to liczba 11111110b, czyli sprawdzamy od skrajnie prawej kolumny

skanuj_kbd:			; skanujemy wszystkie wiersze z danej kolumny. jak znajdziemy naciœniety przycisk to dodajemy do rej. wynikowego
 ld a,e				; liczbê okreœlaj¹c¹ jego po³o¿enie w matrycy klawiszy,m przekazujemy j¹ do a i wychodzimy
 ld bc,0fffeh
 out (c),a
 in a,(c)
 
 bit 0,a
 jr nz,bit1
 ld a,d
	pop de
	pop bc
 ret
 
bit1:
	bit 3,e			;sprawdzamy czy testowana jest kolumna z R-SHIFT, jesli tak, to pomijamy test - sprawdzono shift na pocz. procedury
	jr z,bit2		; nie chcemy aby skan klawiatury zarejestrowa³ naciœniêcie shift.
 bit 1,a
 jr nz,bit2
 ld a,d
 add a,1
	pop de
	pop bc
 ret
 
bit2:
 bit 2,a
 jr nz,bit3
 ld a,d
 add a,2
	pop de
	pop bc
 ret
 
bit3:
 bit 3,a
 jr nz,bit4
 ld a,d
 add a,3
	pop de
	pop bc
 ret

bit4:
 bit 4,a
 jr nz,bit5
 ld a,d
 add a,4
	pop de
	pop bc
 ret
 
bit5:
 bit 5,a
 jr nz,bit6
 ld a,d
 add a,5
	pop de
	pop bc
 ret

bit6:
	bit 4,e			;sprawdzamy czy testowana jest kolumna z L-SHIFT, jesli tak, to pomijamy test - sprawdzono shift na pocz. procedury
	jr z,bit7		; nie chcemy aby skan klawiatury zarejestrowa³ naciœniêcie shift.
 bit 6,a
 jr nz,bit7
 ld a,d
 add a,6
	pop de
	pop bc
 ret
 
bit7:
	bit 5,e			;Omijamy CTRL tak jak SHIFTy
	jr z,dalej
 bit 7,a
 jr nz,dalej
 ld a,d
 add a,7
	pop de
	pop bc
 ret

dalej:
 bit 7,e				;tu po przeskanowaniu wierszy sprawdzamy czy w³aœnie przeskanowaliœmy ostatni¹ kolumnê - jak tak (bit 7=0) to a=ff i wychodzimy 
 jr nz,nie_koniec		;z procedury maj¹c w a informacjê, ¿e nie naciœniêto ¿adnego klawisza.
 ld a,0ffh
	pop de
	pop bc
 ret
 
nie_koniec:				;po ka¿dej przeskanowanej kolumnie przesuwamy wektor testuj¹cy w lewo, a do rejestru wynikowego dodajemy 8 i skanujemy
 rlc e					;dalsze kolumny
 ld a,d
 add a,8
 ld d,a
 jp skanuj_kbd

;**************************************************************************************
; Procedura odbieraj¹ca numer klawisza z poprzedniej procedury. Numer klawisza z matrycy
; staje siê indeksem do tablic "klawisze" i "klawisze_shift". W tych tablicach znajduj¹ siê
; nastêpuj¹ce mo¿liwe kody: ASCII - dla normalnych znaków i znaków steruj¹cych nadaj¹cych
; siê do wyœwietlenia, czyli RETURN (10) backspace (8). Najlepiej aby by³y zgodne z ASCII
; Inne typy to kody klawiszy specjalnych , np. Fx,<-,CLR/HOME itp. te bêd¹ tutaj dekodowane
; i zwracane w akumulatorze jako kod specjalnego klawisza. 
; Klawisze nieoprogramowane - kod 0 s¹ ignorowane i procedura 
; koñczy dzia³anie. Rozpoznane Kody ASCII s¹ przeznaczone do wyœwietlenia procedur¹ print_char, przedtem
; sprawdzane jest czy naciœniêty by³ jednoczeœnie shift - wówczas ASCII jest brane z innej 
; tablicy.
; ZWRACAMY: w AKUMULATORZE KOD ASCII ZNAKU Z KLAWIATURY.
;**************************************************************************************

keyboard_decode:
		push bc
		push de
		push hl
		
	   ld d,a
       ld hl,klawisze
       ld bc,0h
       ld c,a
       add hl,bc
       ld a,(hl)

	cp 1
	jr nz,next_key1
;   call zwracamy w akumulatorze kod specjalnego klawisza - do obs³ugi w innej procedurze
;   Prawdopodobnie bedzie potrzeba u¿ycia update_command_buffer, aby prawid³owo obs³u¿yæ wprowadzon¹ komendê.
; Mo¿liwe, ¿e trzeba bêdzie uzupe³niæ bufor i w³¹czyæ flagê. Nie zdecydowa³em jeszcze.
; Taka fumnkcja "insert into buffer" w pliku util.asm
	jp nic_nie_rob
	
next_key1:
	cp 2
	jr nz,next_key2
;   call zwracamy w akumulatorze kod specjalnego klawisza - do obs³ugi w innej procedurze
;   Prawdopodobnie bedzie potrzeba u¿ycia update_command_buffer, aby prawid³owo obs³u¿yæ wprowadzon¹ komendê.
; Mo¿liwe, ¿e trzeba bêdzie uzupe³niæ bufor i w³¹czyæ flagê. Nie zdecydowa³em jeszcze.
; Taka fumnkcja "insert into buffer" w pliku util.asm
	jp nic_nie_rob
	
next_key2:		;klawisz nie zostal ani oprogramowany ani nie jest klawiszem specjalnym. Koniec funkcji - nic nie wypisujemy na ekran.
	cp 0
	jr z,nic_nie_rob  	


obsluga_wypisywania_znaku:

;Jak nie kod sterujacy lub nierozpoznany, to wypisz na ekranie: jezeli shift (L lub R) wcisniety to zaladuj ascii z shiftem lub ctrl, jak nie to normalny
	push af
	ld a,(CTRL_PRESSED)
	ld b,a
	pop af
	bit 7,b
	jr z,ctrl_display

	push af
	ld a,(R_SHIFT_PRESSED)
	ld b,a
	pop af
	bit 1,b
	jr z,shift_display

	push af
	ld a,(L_SHIFT_PRESSED)
	ld b,a
	pop af
	bit 6,b
	jr z,shift_display	

	jp normal_display

ctrl_display:

	ld a,d						;ladowanie znaku z CTRL
	ld hl,klawisze_ctrl
    ld bc,0h
    ld c,a
    add hl,bc
    ld a,(hl)

	jp normal_display
	
shift_display:
	
	ld a,d						;ladowanie znaku z shiftem
	ld hl,klawisze_shift
    ld bc,0h
    ld c,a
    add hl,bc
    ld a,(hl)
	
normal_display:					; ostateczne wyswietlenie znaku
			
	
nic_nie_rob:					; gdy klawisz nie oprogramowany, albo po wyswietleniu znaku - normalny powrot
	pop hl
	pop de
	pop bc
	ret

;**************************************************************************************
; TABELA KODÓW KLAWISZY
;**************************************************************************************

klawisze:       .BYTE     0,$7f,"-","0","8","6","4","2",0,0,"@","o","u","t","e","q",0,"=",":","k","h","f","s",0,0,0,".","m","b","c","z",32,0,47,44,"n","v","x",0,9,0,";","l","j","g","d","a",0,13,"*","p","i","y","r","w",1bh,8,0,"+","9","7","5","3","1"
klawisze_shift: .BYTE     0,7fh,"-","0","(","&","$",34,0,0,"@","O","U","T","E","Q",0,"=","(","K","H","F","S",0,0,0,">","M","B","C","Z",32,0,"?","<","N","V","X",0,09h,0,")","L","J","G","D","A",0,13,"*","P","I","Y","R","W",1bh,8,0,"+",")",39,37,35,33
klawisze_ctrl:  .BYTE     0,7fh,"-","0","8","6","4","2",0,0,"@",15,15h,24,05h,17,0,"=",":",11,8,6,13h,0,0,0,".",13,2,3,1ah,32,0,47,44,14,22,18h,0,09h,0,";",12,10,7,4,1,0,13,"*",10h,9,25,12h,23,1bh,8,0,"+","9","7","5","3","1"


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

;----------------------  MDA subroutines

char_display:
	;Write char to  MDA card`s video buffer. Assuming "normal" attribute.
	;Entry:
	;
	; VRAM_POSITION = Video RAM position - even address, counted from 0
	; A = char to display
	
		push hl
		push bc
		push ix
	
		cp 08h
		jp z,display_del
		cp 0dh
		jp z,display_CR
		cp 0ah
		jp z,display_LF
		cp 0ch
		jp z,display_FF
		cp 0bh
		jp z,display_VT
		cp 26
		jp z,display_SUB
		cp 1bh
		jp z,enter_esc_seq
		cp 07h
		jp z,bel
		jp display_normal_char

display_del:
		
		ld hl,(VRAM_POSITION)
		dec hl
		dec hl
		ld (VRAM_POSITION),hl
		
		ld bc,0ffe3h
		ld a,h
		out (c),a
		
		ld bc,0ffe2h
		ld a,l
		out (c),a
	
		ld a,20h
		
		ld bc,0ffe0h
		out (c),a	

		call set_cursor
		
		pop ix
		pop bc
		pop hl
		ret

display_CR:		
		ld ix,line_lookup
_display_CR:
		ld hl,(VRAM_POSITION)
		ld c,(ix)
		ld b,(ix+1)
		
		or a	;clear carry flag
		sbc hl,bc
		jp z,line_found_zero
		jp c,line_found_carry

		inc ix
		inc ix

		jp _display_CR

line_found_zero:		
		ld h,(ix+1)
		ld l,(ix)
		ld (VRAM_POSITION),hl
		call set_cursor
		pop ix
		pop bc
		pop hl
		ret

line_found_carry:
		ld h,(ix-1)
		ld l,(ix-2)
		ld (VRAM_POSITION),hl
		call set_cursor
		pop ix
		pop bc
		pop hl
		ret
		
display_LF:
		
		ld hl,(VRAM_POSITION)
		ld bc,00A0h
		add hl,bc
		ld (VRAM_POSITION),hl
		call set_cursor
		call scroll_screen
		pop ix
		pop bc
		pop hl
		ret

display_VT:
		ld hl,(VRAM_POSITION)
		ld bc,00A0h
		or a
		sbc hl,bc
		ld (VRAM_POSITION),hl
		call set_cursor
		call scroll_screen
		pop ix
		pop bc
		pop hl
		ret

display_SUB:
		call clear_screen
		ld hl,0
		ld (VRAM_POSITION),hl
		call set_cursor
		pop ix
		pop bc
		pop hl
		ret

display_FF:

		call clear_screen
		ld hl,3680 ;bottom of screen
		ld (VRAM_POSITION),hl
		call set_cursor
		pop ix
		pop bc
		pop hl
		ret
bel:
		pop ix
		pop bc
		pop hl
		ret	
		
enter_esc_seq:		
		xor a
		ld (ESCAPE_CHAR_COUNT),a
		inc a
		ld (ESCAPE),a
		pop ix
		pop bc
		pop hl
		ret

display_normal_char:	

		ld a,(ESCAPE)
		cp 1
		jp z,process_escape_seq
		ld a,c					;c still contains char to display

		call scroll_screen
			
		ld hl,(VRAM_POSITION)
		
		
		ld bc,0ffe3h
		out (c),h
		
		dec c
		out (c),l
		
		ld c,0e0h
		out (c),a
		
		inc hl
		inc hl
		ld (VRAM_POSITION),hl
		call set_cursor

		pop ix
		pop bc
		pop hl
		ret
process_escape_seq:
		
		ld ix,ESCAPE_BUFFER
		ld l,c		;save character for now
		ld b,0
		ld a,(ESCAPE_CHAR_COUNT)
		ld c,a
		add ix,bc
		ld (ix),l	;store escape sequence character in buffer
		
		ld a,(ESCAPE_CHAR_COUNT)
		inc a
		ld (ESCAPE_CHAR_COUNT),a
		
		;--check if it`s the end of sequence - character is in L reg. 
		ld ix,ESC_SEQ_TERMINATORS
check_seq_end:
		ld a,(ix)
		cp 0
		jp z,not_a_terminator_char
		cp l
		jp z,sequence_finished
		inc ix
		jp check_seq_end
		

sequence_finished:
		;here should be processed a complete escape sequence stored. 
		;ESCAPE_BUFFER is the start address. ESCAPE_CHAR_COUNT holds the total number of characters without 'ESC' at front
		;What`s more important - register L contains the ending character, which determines the type of sequence.
		
		ld a,l
		cp 'f'
		jp z,ansi_cursor_positioning
		cp 'H'
		jp z,ansi_cursor_positioning
		cp 'J'
		jp z,ansi_clear_display
		cp 'A'
		jp z,ansi_cursor_up
		cp 'B'
		jp z,ansi_cursor_down
		cp 'C'
		jp z,ansi_cursor_right
		cp 'D'
		jp z,ansi_cursor_left
		cp 's'
		jp z,ansi_save_cursor
		cp 'u'
		jp z,ansi_restore_cursor
		cp 'K'
		jp z,ansi_erase_line
		cp 'M'
		jp z,ansi_delete_line
		cp 'L'
		jp z,ansi_insert_line
		
		jp other_type

ansi_cursor_home:

		ld hl,0
		ld (VRAM_POSITION),hl
		call set_cursor

		jp other_type

ansi_cursor_positioning:

		ld ix,ESCAPE_BUFFER
		inc ix	;move to first number
		
		xor a
		ld a,(ix)
		sbc a,'0'
		ld c,a
		inc ix
		ld a,(ix)
		cp 3bh 	;semicolon
		jp z,cursor_positioning_col
		xor a
		ld a,(ix)
		sbc a,'0'
		sla c
		sla c
		sla c
		sla c
		or c	;we have BCD line number in A
		call bcd2bin
		ld c,a		 
		inc ix		
		
cursor_positioning_col:		
		inc ix		;ix points to column number now
		dec c		;ANSI numbers lines from 1 to 24, we do not.
		
		ld b,0
		sla c		;index has to be x2 , we are looking up words
		ld hl,line_lookup
		add hl,bc	;hl should hold the line offset address.
		ld c,(hl)
		inc hl
		ld b,(hl)	;now BC holds the VRAM address of destination line. 
		
		xor a
		ld a,(ix)
		sbc a,'0'
		ld l,a
		inc ix
		ld a,(ix)
		cp 'f'
		jp z,cursor_positioning_end
		xor a
		ld a,(ix)
		sbc a,'0'
		sla l
		sla l
		sla l
		sla l
		or l
		call bcd2bin
		ld l,a
		;now we have column offset in HL
		
cursor_positioning_end:		
		dec l
		sla l	;must x2 , because vram holds char + attribute
		ld h,0
		
		add hl,bc
		ld (VRAM_POSITION),HL
		call set_cursor
		jp other_type

ansi_clear_display:
		call clear_screen
		ld hl,0
		ld (VRAM_POSITION),hl
		call set_cursor		

		jp other_type

ansi_cursor_up:
		ld hl,(VRAM_POSITION)
		ld bc,160
		xor a
		sbc hl,bc
		ld (VRAM_POSITION),hl
		call set_cursor
		jp other_type
ansi_cursor_down:
		ld hl,(VRAM_POSITION)
		ld bc,160
		add hl,bc
		ld (VRAM_POSITION),hl
		call set_cursor
		jp other_type		
ansi_cursor_right:
		ld hl,(VRAM_POSITION)
		inc hl
		inc hl
		ld (VRAM_POSITION),hl
		call set_cursor
		jp other_type		
ansi_cursor_left:
		ld hl,(VRAM_POSITION)
		dec hl
		dec hl
		ld (VRAM_POSITION),hl
		call set_cursor
		jp other_type
ansi_save_cursor:
		ld hl,(VRAM_POSITION)
		ld bc,CURSOR_POS
		ld a,l
		ld (bc),a
		ld a,h
		inc bc
		ld (bc),a
		jp other_type	
ansi_restore_cursor:
		ld bc,CURSOR_POS
		ld a,(bc)
		ld l,a
		inc bc
		ld a,(bc)
		ld h,a		
		ld (VRAM_POSITION),hl
		call set_cursor
		jp other_type	

ansi_erase_line:
	
		ld hl,(VRAM_POSITION)

clear_next_char:
		ld a,0
		ld bc,0ffe3h
		out (c),h
		dec c
		out (c),l
		ld c,0e0h
		out (c),a		
		inc hl
		inc hl
		ld ix,line_lookup
		ld b,25

find_end_of_line:	
		ld a,(ix)
		ld c,(ix+1)
		inc ix
		inc ix
		xor h
		or c
		xor l
		jp z,other_type
		djnz find_end_of_line
		jp clear_next_char

		

ansi_delete_line:

		call find_line_start_address
		;here we should copy remining lines to this destination
		push de	;save - we need to use it here locally
		push hl
		pop de	;destination
		ld bc,160
		add hl,bc ;source (next line)
		
scrolling_up:
		
		ld bc,0ffe3h
		out (c),h
		
		dec c
		out (c),l
		
		ld c,0e0h
		in a,(c)
		
		ld c,0e3h
		out (c),d
		
		dec c
		out (c),e
		
		ld c,0e0h
		out (c),a		;character is copied one line upwards.

		
		inc de
		inc de
		inc hl			
		inc hl			;next char source (we ommit copying of attribute)

		push hl
		or a
		ld bc,4000		;26th line - invisible to CP/M - if found -> all done.
		sbc hl,bc
		pop hl
		
		jp nz,scrolling_up
		pop de	;restoring de
		ld (VRAM_POSITION),hl
		call set_cursor
		jp other_type

ansi_insert_line:
		call find_line_start_address

		push de	;save - we need to use it here locally
		push hl
		push hl	
		ld bc,160
		add hl,bc
		push hl
		pop de ;destination (current + 160)
		pop hl ;source
		
		
scrolling_down:
		
		ld bc,0ffe3h
		out (c),h
		
		dec c
		out (c),l
		
		ld c,0e0h
		in a,(c)
		
		ld c,0e3h
		out (c),d
		
		dec c
		out (c),e
		
		ld c,0e0h
		out (c),a		;character is copied one line upwards.

		
		inc de
		inc de
		inc hl			
		inc hl			;next char source (we ommit copying of attribute)

		push hl
		or a
		ld bc,3680		;26th line - invisible to CP/M - if found -> all done.
		sbc hl,bc
		pop hl
		
		jp nz,scrolling_down
		pop hl	;restoring hl for line clearing
		
		ld (VRAM_POSITION),hl
		call set_cursor
		
		ld d,80
current_line_clear:		
		ld bc,0ffe3h
		out (c),h
		
		dec c
		out (c),l
		
		ld c,0e0h
		out (c),a
		inc hl
		inc hl
		
		dec d
		cp d
		jp nz,current_line_clear
		
		pop de	;restoring de
		jp other_type
		
other_type:	
		;leaving escape seq - use after all characters processed.
		;An execution of a sequence should be here
		ld a,0
		ld (ESCAPE),a

not_a_terminator_char:	
		
		pop ix
		pop bc
		pop hl
		ret

;==================================		
find_line_start_address:
		ld hl,(VRAM_POSITION)	
		ld ix,line_lookup		
find_start_address:	
		ld a,(ix)
		ld c,(ix+1)
		inc ix
		inc ix
		xor h
		or c
		xor l
		ret z
		dec hl
		dec hl
		jp find_start_address	
;==================================				

ESC_SEQ_TERMINATORS:					;standard ASCII escape sequences.
		.db 'H','f','A','B','C','D','s','u','J','K','m','h','l','p',0
;==================================	
;check if scrolling needed and do the scrolling.
scroll_screen:
		push bc
		push hl
		push de
		
		ld hl,3840-2	;last character in 24th line
		ld bc,(VRAM_POSITION)
		or a
		sbc hl,bc				;checking if scroll needed
		jp c,commence_scrolling
		pop de
		pop hl
		pop bc
		ret

commence_scrolling:
;We need to copy lines number 1-24 to 0-23 let`s say one character at a time.

		ld hl,160	;source = second line
		ld de,0		;dest. = first line
		
continue_scrolling:
		
		ld bc,0ffe3h
		out (c),h
		
		dec c
		out (c),l
		
		ld c,0e0h
		in a,(c)
		
		ld c,0e3h
		out (c),d
		
		dec c
		out (c),e
		
		ld c,0e0h
		out (c),a		;character is copied one line upwards.

		
		inc de
		inc de
		inc hl			
		inc hl			;next char source (we ommit copying of attribute)

		push hl
		or a
		ld bc,4000		;26th line - invisible to CP/M - if found -> all done.
		sbc hl,bc
		pop hl
		
		jp nz,continue_scrolling
		ld hl,3680
		ld (VRAM_POSITION),hl
		call set_cursor

		pop de
		pop hl
		pop bc
		ret

;set cursor to position in HL
set_cursor:
		push de
		push hl
		push bc
		srl h
		rr l				
		ld d,14
		
		; ---- reg_write
		ld bc,0ffe3h
		ld a,03h
		out (c),a
		dec c
		ld a,0b4h
		out (c),a
		dec c
		out (c),d	
		inc c
		ld a,0b5h
		out (c),a		
		dec c
		out (c),h				
		;---------------
		inc d
		; ---- reg_write	
		inc c
		ld a,0b4h
		out (c),a
		dec c
		out (c),d
		inc c
		ld a,0b5h
		out (c),a
		dec c
		out (c),l				
		;---------------
		
		pop bc
		pop hl
		pop de
		ret

reg_write:
	; writing value to 6845 register.
	;Entry:
	;
	; D - register number
	; E - value
		
		ld bc,0ffe3h
		ld a,03h
		out (c),a
		
		dec c
		ld a,0b4h
		out (c),a
		
		dec c
		out (c),d
				
		ld c,0e3h
		ld a,03h
		out (c),a
		
		dec c
		ld a,0b5h
		out (c),a
		
		dec c
		out (c),e		
		ret		

clear_screen:
	;Fills the 4K video RAM with zeros

		ld hl,4000
		
continue_clear_screen:

		dec hl
		
		ld bc,0ffe3h
		out (c),h

		dec c
		out (c),l

		ld c,0e0h
		ld a,07h			;attribute
		out (c),a
		
		dec hl
		
		ld c,0e3h
		out (c),h

		dec c
		out (c),l

		ld c,0e0h
		ld a,0			;empty char
		out (c),a

		ld a,h
		or l 
		ret z
		jp continue_clear_screen;		

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

hello_sign: .db 0dh,0ah,"CP/M 2.2 Copyright 1979 (c) by Digital Research",0Dh,0Ah,0
bios_hello_sign: .db 0dh,0ah,"CP/M Bios for C-Z80 Computer Copyright 2016 (c) by Michal Cierniak" ,0Dh,0Ah,0

; Keyboard/monitor buffers and variables:

CURSOR_POS:			.db 0,0
ESCAPE_BUFFER:		.ds 10,0
ESCAPE:				.db 0
ESCAPE_CHAR_COUNT:	.db 0
KEY_REPEAT: 		.db 0
R_SHIFT_PRESSED:	.db 0  
L_SHIFT_PRESSED:	.db 0  
CTRL_PRESSED:		.db 0
VRAM_POSITION:		.dw 0

;-------------------------

enddat:	.equ	$	 	;end of data area
datsiz:	.equ	$-begdat;	;size of data area
	.end
