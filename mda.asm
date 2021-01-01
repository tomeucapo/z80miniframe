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


VRAM_POSITION:		.dw 0
CURSOR_POS:			.db 0,0

end.