;******************************************************************
; VDP (Video Display Processor) Routines for TMS9918
; Tomeu Capó 2020                      
;******************************************************************


; Addresses of Data and Register configuration of VDP

VDP_RAM         .EQU    $2E
VDP_REG         .EQU    $2F

VDP_WREG        .EQU    10000000b   ; to be added to the REG value
VDP_RRAM        .EQU    00000000b   ; to be added to the ADRS value
VDP_WRAM        .EQU    01000000b   ; to be added to the ADRS value
VDP_R0          .EQU    00h
VDP_R1          .EQU    01h
VDP_R2          .EQU    02h
VDP_R3          .EQU    03h
VDP_R4          .EQU    04h
VDP_R5          .EQU    05h
VDP_R6          .EQU    06h
VDP_R7          .EQU    07h

; VDP Initialization routine

VDP_INIT:       LD A, 0
                LD (SCR_X), A
                LD (SCR_Y), A

                LD A, 40
                LD (SCR_SIZE_W), A    
                LD A, 24
                LD (SCR_SIZE_H), A

                PUSH DE
                CALL VDP_RESET_VRAM
                CALL VDP_SET_MODE
                POP DE

                CALL VDP_LOADCHARSET
                RET

                ; Setup Register for TEXTMODE

VDP_SET_MODE:   LD B, $08            ; 8 registers
                LD HL, VDPMODESCONF  ; pointer to registers settings
                SLA E
                SLA E
                SLA E
                ADD HL, DE
                LD A, VDP_WREG+$00   ; start with REG0 ($80+register number)
                LD C, VDP_REG        ; VDP port for registers access
LDREGVLS        LD D, (HL)           ; load register's value
                OUT (C), D           ; send data to VDP
                OUT (C), A           ; indicate the register to send data to
                INC A               ; next register
                INC HL              ; next value
                DJNZ LDREGVLS       ; repeat for 8 registers

                ; Reset VRAM

VDP_RESET_VRAM:
                ld c,VDP_REG        ; load VPD port value
                ld hl,$4000         ; first RAM cell $0000 (MSBs must be 0 & 1, resp.)
                xor a,a
                out (c),l           ; low byte of address to VDP
                out (c),h           ; high byte address to VDP
                ld b,$40            ; $40 pages of RAM...
                ld d,a              ; ...each one with $100 cells (tot. $4000 bytes)
EMPTYVRAM:      out (VDP_RAM),a     ; after first byte, the VDP autoincrements VRAM pointer
                nop
                nop
                inc d               ; next cell
                jr nz,EMPTYVRAM     ; repeat until page is fully cleared
                djnz EMPTYVRAM      ; repeat for $40 pages

                RET

                ; Load charset

VDP_LOADCHARSET: 
                ld b,$81            ; 128 chars to be loaded
                ld hl,$4000         ; fist pattern cell $0000 (MSB must be 0 & 1)
                ld c,VDP_REG        ; load VDP address into C
                out (c),l           ; send low byte of address
                out (c),h           ; send high byte
                ld hl,CHARSET       ; address of first byte of first pattern into ROM
NXTCHAR:        ld d,$08            ; 8 bytes per pattern char
SENDCHRPTRNS:   ld a,(hl)           ; load byte to send to VDP
                out (VDP_RAM),a     ; send byte to VRAM
                nop
                inc hl              ; inc byte pointer
                dec d               ; 8 bytes sents (1 char)?
                jr nz,SENDCHRPTRNS  ; no, continue
                djnz NXTCHAR        ; yes, decrement chars counter and continue for all the 127 chars
                RET                

; Text area scrollup 

VDP_SCROLL_UP:  PUSH HL
                PUSH DE

                LD DE, $0800
                LD (VIDTMP1), DE
                LD A, (SCR_SIZE_H)
                DEC A
                LD B, A

SCROLL_LOOP:    LD A, (SCR_SIZE_W)              ; Jump next row
                LD L, A
                LD H, 0
                ADD HL, DE
                EX DE, HL
                CALL VDP_WRITEADDR
                LD (VIDTMP2), DE

                PUSH BC
                LD B, A                         ; Get next row content and save to VIDEOBUFF buffer
                DEC B
                LD HL, VIDEOBUFF
                LD C, VDP_RAM
                INIR
                POP BC

                LD DE, (VIDTMP1)                        
                CALL VDP_WRITEADDR              ; Jump to previous row

                PUSH BC
                LD B, A                         ; Put VIDEOBUFF buffer on previous row
                DEC B
                LD HL, VIDEOBUFF
                LD C, VDP_RAM
                OTIR 
                POP BC

                LD DE, (VIDTMP2)
                LD (VIDTMP1), DE
                DJNZ SCROLL_LOOP

                POP DE
                POP HL
                RET

; Clear text screen area

VDP_CLRSCR:     PUSH BC

                LD DE, $0800
                CALL VDP_WRITEADDR
               
                LD BC, 960           ; Total text area = 24 * 40
CLRBUFF:        LD A, 32
                OUT (VDP_RAM), A
                NOP
                DEC BC
                LD A, B
                OR C
                JR NZ, CLRBUFF

                CALL VDP_HOME
                
                POP BC
                RET

VDP_HOME:       LD A, (SCR_Y)
                XOR A, A
                LD E, A
                LD A, (SCR_X)
                XOR A, A
                CALL VDP_SETPOS
                RET

; Put char to VDP
;       A = Charater to output

VDP_PUTCHAR:    PUSH AF
                PUSH DE
                PUSH HL

                ; Read control charaters to do something different

                CP CS                          
                JR Z, CLEARSCREEN
                CP LF
                JR Z, NEW_LINE
                CP CR
                JR Z, PUTE
                CP BKSP
                JP Z, DELCHAR

                ; Otherwise print character
                JR PUTC

                ; New line
NEW_LINE:       LD A, (SCR_Y)
                INC A
                CP 24
                JR Z, SCROLLUP
                LD E, A
                LD A, (SCR_X)
                XOR A, A
                JR SETPOS

                ; Delte character
DELCHAR:        LD A, (SCR_Y)
                LD E, A
                LD A, (SCR_X)
                DEC A
                JP M, BEGIN_LINE
                CALL VDP_SETPOS
                LD A, 32
                OUT (VDP_RAM), A
                NOP
                JR PUTE
BEGIN_LINE:     LD A, 0
SETPOS:         CALL VDP_SETPOS
                JR PUTE

CLEARSCREEN:    CALL VDP_CLRSCR
                JR PUTE
                        
SCROLLUP:       CALL VDP_SCROLL_UP
                LD A, (SCR_SIZE_H)
                DEC A
                LD E, A
                LD A, 0
                CALL VDP_SETPOS

PUTC:           OUT (VDP_RAM), A
                LD A, (SCR_X)
                INC A
                CP 40                   ; TODO: LOAD VALUE FROM SCR_SIZE_W
                JR Z, NEW_LINE

PUTE:           POP HL
                POP DE
                POP AF
                RET

; Copy a null-terminated string to VRAM
;       HL = Initial string pointer address

VDP_PRINT:      
                PUSH HL

LDWLCMMSG:      LD A, (HL)           
                CP $00               ; is it the end of message?
                JR Z, ENDPRT

                CALL VDP_PUTCHAR

                INC HL
                JR LDWLCMMSG
                
ENDPRT:         POP HL
                RET


; Set color
;       A = Foreground and Background color

VDP_SETCOLOR:
        LD C, VDP_REG          ; Put color code
        OUT (C), A
        LD A, VDP_WREG+VDP_R7  ; Reg 7. Change color
        OUT (C), A        
        RET

; Set the address to place text at X/Y coordinate
;       A = X
;       E = Y

VDP_SETPOS:
        LD      (SCR_X), A
        EX      AF, AF'        
        LD      A, E
        LD      (SCR_Y), A
        EX      AF, AF'
        
        PUSH    HL

        ld      d, 0
        ld      hl, 0
        add     hl, de                  ; Y x 1
        add     hl, hl                  ; Y x 2
        add     hl, hl                  ; Y x 4
        add     hl, de                  ; Y x 5
        add     hl, hl                  ; Y x 10
        add     hl, hl                  ; Y x 20
        add     hl, hl                  ; Y x 40
        ld      e, a
        add     hl, de                  ; add column for final address
        ld      b, 8
        ld      c, 0
        add     hl, bc
        ex      de, hl                  ; send address to TMS
        call    VDP_WRITEADDR

        POP     HL
        RET

; Set the next address of vram to write
;       DE = VDP address
VDP_WRITEADDR:
        PUSH    BC
        PUSH    DE

        LD      C, VDP_REG                  
        SET     6, D 
        OUT     (C), E
        OUT     (C), D            

        POP     DE
        POP     BC
        RET

                ; VDP registers settings to set up a text mode

VDPMODESCONF:   defb 00000000b    ; reg.0: external video disabled
                defb 11010000b    ; reg.1: text mode (40x24), enable display
                defb $02          ; reg.2: name table set to $800 ($02x$400)
                defb $00          ; reg.3: not used in text mode
                defb $00          ; reg.4: pattern table set to $0000
                defb $00          ; reg.5: not used in text mode
                defb $00          ; reg.6: not used in text mode
                defb $f5          ; reg.7: light blue text on white background

                 ; VDP register settings for a graphics 1 mode

                defb    00000000b       ; reg.0: ext. video off
                defb    11000000b       ; reg.1: 16K Vram; video on, int off, graphics mode 1, sprite size 8x8, sprite magn. 0
                defb    $06             ; reg.2: name table address: $1800
                defb    $80             ; reg.3: color table address: $2000
                defb    $00             ; reg.4: pattern table address: $0000
                defb    $36             ; reg.5: sprite attr. table address: $1B00
                defb    $07             ; reg.6: sprite pattern table addr.: $3800
                defb    $05             ; reg.7: backdrop color (light blue)

                ; VDP register settings for a graphics 2 mode
                
                defb    00000010b       ; reg.0: graphics 2 mode, ext. video dis.
                defb    11000000b       ; reg.1: 16K VRAM, video on, INT off, sprite size 8x8, sprite magn. 0
                defb    $06             ; reg.2: name table addr.: $1800
                defb    $FF             ; reg.3: color table addr.: $2000
                defb    $03             ; reg.4: pattern table addr.: $0000
                defb    $36             ; reg.5: sprite attr. table addr.: $1B00
                defb    $07             ; reg.6: sprite pattern table addr.: $3800
                defb    $05             ; reg.7: backdrop color: light blue

                ; VDP register settings for a multicolor mode

                defb    00000000b       ; reg.0: ext. video dis.
                defb    11001011b       ; reg.1: 16K VRAM, video on, INT off, multicolor mode, sprite size 8x8, sprite magn. 0
                defb    $02             ; reg.2: name table addr.: $0800
                defb    $00             ; reg.3: don't care
                defb    $00             ; reg.4: pattern table addr.: $0000
                defb    $36             ; reg.5: sprite attr. table addr.: $1B00
                defb    $07             ; reg.6: sprite pattern table addr.: $3800
                defb    $0F             ; reg.7: backdrop color (white)

                ; VDP register settings for an extended graphics 2 mode

                defb    00000010b       ; reg.0: graphics 2 mode, ext. video dis.
                defb    11000000b       ; reg.1: 16K VRAM, video on, INT off, sprite size 8x8, sprite magn. 0
                defb    $0E             ; reg.2: name table addr.: $3800
                defb    $9F             ; reg.3: color table addr.: $2000
                defb    $00             ; reg.4: pattern table addr.: $0000
                defb    $76             ; reg.5: sprite attr. table addr.: $3B00
                defb    $03             ; reg.6: sprite pattern table addr.: $1800
                defb    $05             ; reg.7: backdrop color: light blue


;-------------------------------------------------------------------------------
; CHARSET DEFINITION TABLE
;-------------------------------------------------------------------------------

CHARSET: equ $
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 0
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 1
        defb 0x3C,0xFF,0xBD,0xFF,0xBD,0x42,0x3C,0x00 ; char 2
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 3
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 4
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 5
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 6
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 7
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 8
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 9
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 10
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 11
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 12
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 13
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 14
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 15
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 16
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 17
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 18
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 19
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 20
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 21
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 22
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 23
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 24
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 25
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 26
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 27
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 28
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 29
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 30
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; char 31
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; space
        defb 0x20,0x20,0x20,0x20,0x20,0x00,0x20,0x00 ; !
        defb 0x50,0x50,0x00,0x00,0x00,0x00,0x00,0x00 ; "
        defb 0x50,0x50,0xf8,0x50,0xf8,0x50,0x50,0x00 ; #
        defb 0x20,0x78,0xa0,0x70,0x28,0xf0,0x20,0x00 ; $
        defb 0xc0,0xc8,0x10,0x20,0x40,0x98,0x18,0x00 ; %
        defb 0x60,0x90,0xa0,0x40,0xa8,0x90,0x68,0x00 ; &
        defb 0x60,0x20,0x40,0x00,0x00,0x00,0x00,0x00 ; '
        defb 0x10,0x20,0x40,0x40,0x40,0x20,0x10,0x00 ; (
        defb 0x40,0x20,0x10,0x10,0x10,0x20,0x40,0x00 ; )
        defb 0x00,0x20,0xa8,0x70,0xa8,0x20,0x00,0x00 ; *
        defb 0x00,0x20,0x20,0xf8,0x20,0x20,0x00,0x00 ; +
        defb 0x00,0x00,0x00,0x00,0x60,0x20,0x40,0x00 ; ,
        defb 0x00,0x00,0x00,0xf8,0x00,0x00,0x00,0x00 ; -
        defb 0x00,0x00,0x00,0x00,0x00,0x60,0x60,0x00 ; .
        defb 0x00,0x08,0x10,0x20,0x40,0x80,0x00,0x00 ; /
        defb 0x70,0x88,0x98,0xa8,0xc8,0x88,0x70,0x00 ; 0
        defb 0x20,0x60,0x20,0x20,0x20,0x20,0x70,0x00 ; 1
        defb 0x70,0x88,0x08,0x10,0x20,0x40,0xf8,0x00 ; 2
        defb 0xf8,0x10,0x20,0x10,0x08,0x88,0x70,0x00 ; 3
        defb 0x10,0x30,0x50,0x90,0xf8,0x10,0x10,0x00 ; 4
        defb 0xf8,0x80,0xf0,0x08,0x08,0x88,0x70,0x00 ; 5
        defb 0x30,0x40,0x80,0xf8,0x88,0x88,0x70,0x00 ; 6
        defb 0xf8,0x08,0x10,0x20,0x40,0x40,0x40,0x00 ; 7
        defb 0x70,0x88,0x88,0x70,0x88,0x88,0x70,0x00 ; 8
        defb 0x70,0x88,0x88,0x78,0x08,0x10,0x60,0x00 ; 9
        defb 0x00,0x30,0x30,0x00,0x30,0x30,0x00,0x00 ; :
        defb 0x00,0x30,0x30,0x00,0x30,0x10,0x20,0x00 ; ;
        defb 0x10,0x20,0x40,0x80,0x40,0x20,0x10,0x00 ; <
        defb 0x00,0x00,0xf8,0x00,0xf8,0x00,0x00,0x00 ; =
        defb 0x40,0x20,0x10,0x08,0x10,0x20,0x40,0x00 ; >
        defb 0x70,0x88,0x08,0x10,0x20,0x00,0x20,0x00 ; ?
        defb 0x70,0x88,0x08,0x68,0xa8,0xa8,0x70,0x00 ; @
        defb 0x70,0x88,0x88,0x88,0xf8,0x88,0x88,0x00 ; A
        defb 0xf0,0x88,0x88,0xf0,0x88,0x88,0xf0,0x00 ; B
        defb 0x70,0x88,0x80,0x80,0x80,0x88,0x70,0x00 ; C
        defb 0xe0,0x90,0x88,0x88,0x88,0x90,0xe0,0x00 ; D
        defb 0xf8,0x80,0x80,0xf0,0x80,0x80,0xf8,0x00 ; E
        defb 0xf8,0x80,0x80,0xf0,0x80,0x80,0x80,0x00 ; F
        defb 0x70,0x88,0x80,0xb8,0x88,0x88,0x78,0x00 ; G
        defb 0x88,0x88,0x88,0xf8,0x88,0x88,0x88,0x00 ; H
        defb 0x70,0x20,0x20,0x20,0x20,0x20,0x70,0x00 ; I
        defb 0x38,0x10,0x10,0x10,0x10,0x90,0x60,0x00 ; J
        defb 0x88,0x90,0xa0,0xc0,0xa0,0x90,0x88,0x00 ; K
        defb 0x80,0x80,0x80,0x80,0x80,0x80,0xf8,0x00 ; L
        defb 0x88,0xd8,0xa8,0xa8,0x88,0x88,0x88,0x00 ; M
        defb 0x88,0xc8,0xa8,0x98,0x88,0x88,0x88,0x00 ; N
        defb 0x70,0x88,0x88,0x88,0x88,0x88,0x70,0x00 ; O
        defb 0xf0,0x88,0x88,0xf0,0x80,0x80,0x80,0x00 ; P
        defb 0x70,0x88,0x88,0x88,0xa8,0x90,0x68,0x00 ; Q
        defb 0xf0,0x88,0x88,0xf0,0xa0,0x90,0x88,0x00 ; R
        defb 0x78,0x80,0x80,0x70,0x08,0x08,0xf0,0x00 ; S
        defb 0xf8,0x20,0x20,0x20,0x20,0x20,0x20,0x00 ; T
        defb 0x88,0x88,0x88,0x88,0x88,0x88,0x70,0x00 ; U
        defb 0x88,0x88,0x88,0x88,0x88,0x50,0x20,0x00 ; V
        defb 0x88,0x88,0x88,0x88,0xa8,0xa8,0x50,0x00 ; W
        defb 0x88,0x88,0x50,0x20,0x50,0x88,0x88,0x00 ; X
        defb 0x88,0x88,0x88,0x50,0x20,0x20,0x20,0x00 ; Y
        defb 0xf8,0x08,0x10,0x20,0x40,0x80,0xf8,0x00 ; Z
        defb 0x70,0x40,0x40,0x40,0x40,0x40,0x70,0x00 ; [
        defb 0x00,0x80,0x40,0x20,0x10,0x08,0x00,0x00 ; \
        defb 0x70,0x10,0x10,0x10,0x10,0x10,0x70,0x00 ; ]
        defb 0x20,0x50,0x88,0x00,0x00,0x00,0x00,0x00 ; ^
        defb 0x00,0x00,0x00,0x00,0x00,0x00,0xf8,0x00 ; _
        defb 0x40,0x20,0x10,0x00,0x00,0x00,0x00,0x00 ; `
        defb 0x00,0x00,0x70,0x08,0x78,0x88,0x78,0x00 ; a
        defb 0x00,0x80,0x80,0xb0,0xc8,0x88,0xf0,0x00 ; b
        defb 0x00,0x00,0x70,0x80,0x80,0x88,0x70,0x00 ; c
        defb 0x08,0x08,0x08,0x68,0x98,0x88,0x78,0x00 ; d
        defb 0x00,0x00,0x70,0x88,0xf8,0x80,0x70,0x00 ; e
        defb 0x30,0x48,0x40,0xe0,0x40,0x40,0x40,0x00 ; f
        defb 0x00,0x78,0x88,0x88,0x78,0x08,0x70,0x00 ; g
        defb 0x80,0x80,0xb0,0xc8,0x88,0x88,0x88,0x00 ; h
        defb 0x00,0x20,0x00,0x20,0x20,0x20,0x20,0x00 ; i
        defb 0x10,0x00,0x30,0x10,0x10,0x90,0x60,0x00 ; j
        defb 0x80,0x80,0x90,0xa0,0xc0,0xa0,0x90,0x00 ; k
        defb 0x60,0x20,0x20,0x20,0x20,0x20,0x70,0x00 ; l
        defb 0x00,0x00,0xd0,0xa8,0xa8,0x88,0x88,0x00 ; m
        defb 0x00,0x00,0xb0,0xc8,0x88,0x88,0x88,0x00 ; n
        defb 0x00,0x00,0x70,0x88,0x88,0x88,0x70,0x00 ; o
        defb 0x00,0x00,0xf0,0x88,0xf0,0x80,0x80,0x00 ; p
        defb 0x00,0x00,0x68,0x98,0x78,0x08,0x08,0x00 ; q
        defb 0x00,0x00,0xb0,0xc8,0x80,0x80,0x80,0x00 ; r
        defb 0x00,0x00,0x70,0x80,0x70,0x08,0xf0,0x00 ; s
        defb 0x40,0x40,0xe0,0x40,0x40,0x48,0x30,0x00 ; t
        defb 0x00,0x00,0x88,0x88,0x88,0x98,0x68,0x00 ; u
        defb 0x00,0x00,0x88,0x88,0x88,0x50,0x20,0x00 ; v
        defb 0x00,0x00,0x88,0x88,0xa8,0xa8,0x50,0x00 ; w
        defb 0x00,0x00,0x88,0x50,0x20,0x50,0x88,0x00 ; x
        defb 0x00,0x00,0x88,0x88,0x78,0x08,0x70,0x00 ; y
        defb 0x00,0x00,0xf8,0x10,0x20,0x40,0xf8,0x00 ; z
        defb 0x10,0x20,0x20,0x40,0x20,0x20,0x10,0x00 ; {
        defb 0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x00 ; |
        defb 0x20,0x10,0x10,0x08,0x10,0x10,0x20,0x00 ; }
        defb 0x00,0x28,0x50,0x00,0x00,0x00,0x00,0x00 ; ~ (127th char, last ASCII char)
        defb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.END