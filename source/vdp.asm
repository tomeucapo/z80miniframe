;******************************************************************
; VDP (Video Display Processor) Routines for TMS9918
; Tomeu Capó 2020                      
;******************************************************************

; Addresses of Data and Register configuration of VDP

VDP_RAM         .EQU    $002E
VDP_REG         .EQU    $002F

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


; ************************************************************************************
; VDP_INIT - VDP Initialization routine
;       E = Mode number

VDP_INIT:       PUSH DE
                
                CALL VDP_RESET_VRAM
                CALL VDP_SET_MODE
                CALL VDP_LOADCHARSET
                
                LD A, 1
                LD (ENABLEDCURSOR), A

                POP DE
                RET

; ************************************************************************************
; VDP_SET_MODE - Change VDP Mode
;       E = Mode number

VDP_SET_MODE:   LD B, $08            ; 8 registers
                LD HL, VDPMODESCONF  ; pointer to registers settings
                SLA E
                SLA E
                PUSH DE
                SLA E
                ADD HL, DE
                LD A, VDP_WREG+$00  ; start with REG0 ($80+register number)
                
LDREGVLS:       LD D, (HL)          ; load register's value
                
                PUSH BC
                LD BC, VDP_REG      ; VDP port for registers access
                OUT (C), D          ; send data to VDP
                OUT (C), A          ; indicate the register to send data to
                POP BC

                INC A               ; next register
                INC HL              ; next value
                DJNZ LDREGVLS       ; repeat for 8 registers
                
                POP DE
                LD HL, VDPMODESSIZES  ; pointer to screen mode sizes
                ADD HL, DE

                LD A, (HL)
                LD (SCR_SIZE_W), A    
                INC HL
                LD A, (HL)
                LD (SCR_SIZE_H), A

                LD A, 1                ; Initialize screen coordinate variables
                LD (SCR_X), A
                LD A, 0
                LD (SCR_Y), A
                LD A, 1 
                LD (SCR_CUR_X), A
                LD A, 0
                LD (SCR_CUR_Y), A

                LD A, 1
                LD (CURSORSTATE), A

                RET

; ************************************************************************************
; VDP_RESET_VRAM - Clear VRAM content

VDP_RESET_VRAM: LD HL, $4000         ; first RAM cell $0000 (MSBs must be 0 & 1, resp.)
                XOR A, A
                
                LD BC, VDP_REG       ; load VPD port value
                OUT (C), L           ; low byte of address to VDP
                OUT (C), H           ; high byte address to VDP
                
                LD B, $40            ; $40 pages of RAM...
                LD D, A              ; ...each one with $100 cells (tot. $4000 bytes)
EMPTYVRAM:      PUSH BC
                LD BC, VDP_RAM
                OUT (C), A     ; after first byte, the VDP autoincrements VRAM pointer
                POP BC
                NOP
                NOP
                INC D               ; next cell
                JR NZ, EMPTYVRAM     ; repeat until page is fully cleared
                DJNZ EMPTYVRAM      ; repeat for $40 pages
                RET

; ************************************************************************************
; VDP_LOADCHARSET - Load charset

VDP_LOADCHARSET:
                LD HL, $4000         ; fist pattern cell $0000 (MSB must be 0 & 1)
                LD BC, VDP_REG      ; load VDP address into C
                OUT (C), L          ; send low byte of address
                OUT (C), H          ; send high byte

                LD B, 0              ; 0 = 256 chars to be loaded
                LD HL, CHARSET       ; address of first byte of first pattern into ROM
NXTCHAR:        LD D, $08            ; 8 bytes per pattern char
SENDCHRPTRNS:   LD A, (HL)           ; load byte to send to VDP
                
                PUSH BC
                LD BC, VDP_RAM
                OUT (C), A           ; send byte to VRAM
                POP BC
                NOP
                
                INC HL              ; inc byte pointer
                DEC D               ; 8 bytes sents (1 char)?
                JR NZ, SENDCHRPTRNS  ; no, continue
                DJNZ NXTCHAR        ; yes, decrement chars counter and continue for all the 127 chars
                RET                

; ************************************************************************************
; VDP_SCROLL_UP - Scroll up text area routine

VDP_SCROLL_UP:  PUSH HL
                PUSH DE

                LD A, 0
                LD (ENABLEDCURSOR), A

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
                PUSH AF

COPYROW:        PUSH BC
                LD BC, VDP_RAM
                IN A, (C)
                POP BC
                LD (HL), A
                INC HL
                DJNZ COPYROW

                POP AF
                POP BC

                LD DE, (VIDTMP1)            
                DEC DE       
                CALL VDP_WRITEADDR              ; Jump to previous row

                PUSH BC

                LD B, A                         ; Put VIDEOBUFF buffer on previous row
                DEC B
                LD HL, VIDEOBUFF
                
                PUSH AF

PASTEROW:       PUSH BC
                LD BC, VDP_RAM
                LD A, (HL)
                OUT (C), A
                NOP
                NOP
                POP BC
                INC HL
                DJNZ PASTEROW

                POP AF
                POP BC

                LD DE, (VIDTMP2)
                LD (VIDTMP1), DE
                DJNZ SCROLL_LOOP
                
                ; Clear new line

                LD A, (SCR_SIZE_H)
                DEC A
                LD E, A
                LD A, 0
                CALL VDP_SETPOS

                LD A, (SCR_SIZE_W)
                LD B, A

                LD A, 32
CLR_LAST_LINE:  OUT (VDP_RAM), A
                NOP
                NOP
                DJNZ CLR_LAST_LINE

                LD A, (SCR_SIZE_H)
                DEC A
                LD E, A
                LD A, 0
                CALL VDP_SETPOS

                LD A, 1
                LD (ENABLEDCURSOR), A

                POP DE
                POP HL
                RET

; ************************************************************************************
; VDP_CLRSCR - Clear text screen area routine

VDP_CLRSCR:     PUSH BC

                LD DE, $0800
                CALL VDP_WRITEADDR
               
                LD BC, 960           ; Total text area = 24 * 40
CLRBUFF:        LD A, 32
                OUT (VDP_RAM), A
                NOP
                NOP
                DEC BC
                LD A, B
                OR C
                JR NZ, CLRBUFF

                CALL VDP_HOME
                
                POP BC
                RET

VDP_HOME:       LD A, 1
                LD E, 0
                CALL VDP_SETPOS
                RET

; ************************************************************************************
; VDP_PUTCHAR - Output character to VDP routine with character control decisions
;       A = Character to output

VDP_PUTCHAR:    PUSH AF
                PUSH DE
                PUSH HL
                PUSH BC

                ; Read control charaters to do something different

                CP CS                          
                JR Z, CLEARSCREEN
                CP LF
                JR Z, NEW_LINE
                CP CR
                JR Z, PUTEND
                CP BKSP
                JR Z, DELCHAR

                ; Otherwise print character
                JR PUTC

                ; Clear screen
CLEARSCREEN:    CALL VDP_CLRSCR
                JR PUTEND

                ; New line
NEW_LINE:       PUSH AF
                LD A, 0
                CALL VDP_CURSOR
                POP AF

                LD A, (SCR_Y)
                INC A
                CP 24                           ; TODO: Read from configuration of actual mode!
                JR Z, SCROLLUP
                LD E, A
                LD A, (SCR_X)
                XOR A, A
                CALL VDP_SETPOS
                JP PUTC

SCROLLUP:       CALL VDP_SCROLL_UP
                JP PUTC

                ; Delete character

DELCHAR:        LD A, 0
                CALL VDP_CURSOR
                
                LD A, (SCR_Y)
                LD E, A
                LD A, (SCR_X)
                DEC A
                PUSH DE
                PUSH AF

                CALL VDP_SETPOS
                LD B, A
                LD A, 32
                OUT (VDP_RAM), A
                NOP
                NOP

                POP AF
                POP DE
                CALL VDP_SETPOS
                JR PUTE

                ; Printout character
PUTC:           PUSH AF                         ; Save character
                
                LD A, (SCR_Y)                   
                LD E, A
                LD A, (SCR_X)
                CALL VDP_SETPOS
                
                POP AF

                PUSH BC
                LD BC, VDP_RAM
                OUT (C), A
                NOP
                NOP
                POP BC

                LD A, (SCR_X)
                INC A
                LD (SCR_X), A
                LD B, A
                LD A, (SCR_SIZE_W)
                CP B                
                JR Z, NEW_LINE
                
PUTE:           LD A, 1
                CALL VDP_CURSOR
                
PUTEND:         POP BC
                POP HL
                POP DE
                POP AF
                RET


; ************************************************************************************
; VDP_BLINK_CURSOR - Change state of cursor to make blink and show or not.

VDP_BLINK_CURSOR:
                PUSH AF
                PUSH DE
                PUSH HL
                PUSH BC
               
                LD A, (CURSORSTATE)
                CP 0
                JR Z, CURSORSTATE1

CURSORSTATE0:   LD A, 0
                JP SHOWCURSOR

CURSORSTATE1:   LD A, 1
                 
SHOWCURSOR:     LD (CURSORSTATE), A
                CALL VDP_CURSOR
                
                POP BC
                POP HL
                POP DE
                POP AF
                RET

; ************************************************************************************
; VDP_CURSOR - Paint cursor to their position
;       A - Temporary state of cursor

VDP_CURSOR:     CALL VDP_LOCATE_CURSOR
                CP 0
                JR Z, DROPCURSOR
                
                LD A, $FF 
                PUSH BC
                LD BC, VDP_RAM
                OUT (C), A
                NOP
                POP BC
                JP ENDCURSOR
                
DROPCURSOR:     LD A, 32
                PUSH BC
                LD BC, VDP_RAM
                OUT (C), A
                POP BC
                NOP

ENDCURSOR:      CALL VDP_LOCATE_CURSOR
                RET 


; ************************************************************************************
; VDP_LOCATE_CURSOR - Place cursor on screen based SRC_CUR_X and SCR_CUR_Y vars

VDP_LOCATE_CURSOR:
                PUSH AF
                LD A, (SCR_CUR_Y)
                LD E, A
                LD A, (SCR_CUR_X)
                CALL VDP_SCR_GOTOXY
                POP AF
                RET
                
; ************************************************************************************
; VDP_PRINT - Copy a null-terminated string to VRAM
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


; ************************************************************************************
; VDP_SETCOLOR - Set color
;       A = Foreground and Background color

VDP_SETCOLOR:
        PUSH BC
        LD BC, VDP_REG          ; Put color code
        OUT (C), A
        LD A, VDP_WREG+VDP_R7  ; Reg 7. Change color
        OUT (C), A        
        POP BC
        NOP
        RET

; ************************************************************************************
; VDP_SETPOS - Set the address to place text at X/Y coordinate and update memory variables
;       A = X
;       E = Y

VDP_SETPOS:
        LD      (SCR_X), A
        EX      AF, AF'       
        LD      A, (SCR_X) 
        INC     A
        LD      (SCR_CUR_X), A
        LD      A, E
        LD      (SCR_Y), A
        LD      (SCR_CUR_Y), A
        EX      AF, AF'

        CALL    VDP_SCR_GOTOXY
        RET

; ************************************************************************************
; VDP_SETPOS - Set the address to place text at X/Y coordinate
;       A = X
;       E = Y

VDP_SCR_GOTOXY:
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


; ************************************************************************************
; VDP_WRITEADDR - Set the next address of vram to write
;       DE = VDP address

VDP_WRITEADDR:
        PUSH    BC
        PUSH    DE

        LD      BC, VDP_REG                  
        SET     6, D 
        OUT     (C), E
        OUT     (C), D            

        POP     DE
        POP     BC
        RET

VDPMODESSIZES:  ; Screen mode dimensions

                .DEFB 40, 24
                .DEFB 32, 24
                .DEFB 0, 192      ; 0=256 x 192
                .DEFB 64, 48
                .DEFB 32, 24

                ; VDP registers settings to set up a text mode

VDPMODESCONF:   defb 00000000b    ; reg.0: external video disabled
                defb 11110000b    ; reg.1: text mode (40x24), enable display
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
                defb    $C5             ; reg.7: backdrop color: light blue

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

include "fonts.asm"