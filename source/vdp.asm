;************************************************************************
; VDP (Video Display Processor) Routines for TMS9918
;
; Lenoardo Milliani 2020
; Tomeu Capó 2022
;
; This is adapted version from Leonardo Millani https://github.com/leomil72/LM80C  
; Code are released under the therms of the GNU GPL License 3.0 and in the form of "as is", without no
; kind of warranty: you can use them at your own risk.
; You are free to use them for any non-commercial use: you are only asked to
; maintain the copyright notices, include this advice and the note to the 
; attribution of the parts of original version to Leonardo Millani, if you intend to
; redistribuite them.
;************************************************************************

include "globals.inc"
include "vdp.inc"

                extern DIV_8_8

; ************************************************************************************
; VDP_INIT - VDP Initialization routine
;       E = Mode number

VDP_INIT::      PUSH DE
                
                LD A, E
                LD (SCR_MODE), A

                CALL VDP_RESET_VRAM
                CALL VDP_SET_MODE

                LD A, (SCR_MODE)
                CP $02
                JR Z, ENDINIT

                CALL VDP_LOADCHARSET                
                LD  A, VDP_DEFAULT_COLOR                             
                CALL VDP_SET_COLOR_TABLE
ENDINIT:
                LD A, 1
                LD (ENABLEDCURSOR), A

                POP DE
                RET

; ************************************************************************************
; VDP_SET_MODE - Change VDP Mode
;       E = Mode number

VDP_SET_MODE:   LD A, E
                CP $02
                JR Z, MODE2
                LD B, $08                     
                JR MODECFG
MODE2:          LD B, $07               ; If mode 2 only uses 7 registers
MODECFG:        LD HL, VDPMODESCONF  
                SLA E
                PUSH DE
                SLA E               
                SLA E
                ADD HL, DE
                LD A, VDP_WREG
                
LDREGVLS:       LD D, (HL)          
                
                PUSH BC
                LD BC, VDP_REG      
                OUT (C), D          
                OUT (C), A          
                POP BC

                INC A               
                INC HL              
                DJNZ LDREGVLS       
                
                POP DE
                LD HL, VDPMODESSIZES 
                ADD HL, DE

                LD A, (HL)             ; Initialize screen size variables
                LD (SCR_SIZE_W), A    
                INC HL
                LD A, (HL)
                LD (SCR_SIZE_H), A

                XOR A                  ; Initialize screen coordinate variables
                LD (SCR_X), A
                LD (SCR_Y), A
                LD (SCR_CUR_X), A
                LD (SCR_CUR_Y), A
                LD (SCR_LAST_CHAR), A
                 
                LD A, 1
                LD (CURSORSTATE), A

                RET

; ************************************************************************************
; VDP_SET_COLOR_TABLE - Set color table
;       A = loaded with colors for chars: black pixels on white background

VDP_SET_COLOR_TABLE:
                PUSH    HL

                LD      HL, $2000        ; color table start: $2000
                CALL    VDP_SET_ADDR

                LD      B, $20           ; 32 bytes of colors
LDCLRTBMD1:     PUSH    BC
                LD      BC,VDP_DATA    
                OUT     (C),A          
                POP     BC
                NOP
                NOP
                DJNZ    LDCLRTBMD1     

                POP     HL
                RET

; ************************************************************************************
; VDP_RESET_VRAM - Clear VRAM content

VDP_RESET_VRAM: LD HL, $4000            
                XOR A, A
                
                LD BC, VDP_REG     
                OUT (C), L         
                OUT (C), H         
                
                LD B, $40          
                LD D, A            
EMPTYVRAM:      PUSH BC
                LD BC, VDP_DATA
                OUT (C), A    
                POP BC
                NOP
                NOP
                INC D              
                JR NZ, EMPTYVRAM   
                DJNZ EMPTYVRAM     
                RET

; ************************************************************************************
; VDP_LOADCHARSET - Load charset

VDP_LOADCHARSET:
                LD HL, $4000        
                LD BC, VDP_REG      
                OUT (C), L          
                OUT (C), H          

                LD B, 0             

                LD HL, CHARSET68    
                LD A, (SCR_MODE)
                AND A
                JR Z, NXTCHAR
                LD HL, CHARSET88
                
NXTCHAR:        LD D, $08           
SENDCHRPTRNS:   LD A, (HL)          
                
                PUSH BC
                LD BC, VDP_DATA
                OUT (C), A          
                POP BC
                NOP
                
                INC HL              
                DEC D               
                JR NZ, SENDCHRPTRNS 
                DJNZ NXTCHAR        
                RET                

VDP_SET_ADDR:
                LD BC, VDP_REG
                SET 6, H
                OUT (C), L
                OUT (C), H
                RET

; ************************************************************************************
; VDP_SCROLL_UP - Scroll up text area routine

VDP_SCROLL_UP:  PUSH HL
                PUSH DE

                LD A, 0
                LD (ENABLEDCURSOR), A

                CALL VDP_GETTABLENAME           ; Get correct screen address depends on mode
                LD D, B
                LD E, C

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
                LD BC, VDP_DATA
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
                LD BC, VDP_DATA
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
                LD A, 0
CLR_LAST_LINE:  PUSH BC
                LD BC, VDP_DATA
                OUT (C), A
                NOP
                NOP
                POP BC
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

                CALL VDP_GETTABLENAME
                LD D, B
                LD E, C
                CALL VDP_WRITEADDR
               
                LD BC, 960           ; Total text area = 24 * 40
CLRBUFF:        LD A, 0
                PUSH BC
                LD BC, VDP_DATA
                OUT (C), A
                NOP
                NOP
                POP BC
                DEC BC
                LD A, B
                OR C
                JR NZ, CLRBUFF

                CALL VDP_HOME
                
                POP BC
                RET

VDP_HOME:       LD A, 0
                LD E, 0
                CALL VDP_SETPOS                
                LD (SCR_LAST_CHAR), A
                RET

; ************************************************************************************
; VDP_PUTCHAR - Output character to VDP routine with character control decisions
;       A = Character to output

VDP_PUTCHAR::   PUSH AF
                PUSH DE
                PUSH HL
                PUSH BC

                ; Store last character to variable

                LD (SCR_LAST_CHAR), A

                ; Read control charaters to do something different

                CP CS                          
                JR Z, CLEARSCREEN
                CP LF
                JR Z, NEW_LINE
                CP CR
                JP Z, PUTEND
                CP BKSP
                JR Z, DELCHAR

                ; Otherwise print character
                JR PUTC

                ; Clear screen
CLEARSCREEN:    CALL VDP_CLRSCR
                JR PUTEND

                ; New line
NEW_LINE:       XOR A                          ; Disable cursor
                CALL VDP_PUT_CURSOR
                
                LD A, (SCR_SIZE_H)
                LD B, A

                LD A, (SCR_Y)                  ; Checks if bottom of screen and scrolls up if is needed
                INC A
                CP B                
                JR Z, SCROLLUP
                
                LD E, A
                XOR A
                CALL VDP_SETPOS
                JP PUTE

SCROLLUP:       CALL VDP_SCROLL_UP
                JP PUTE

                ; Delete character

DELCHAR:        XOR A
                CALL VDP_PUT_CURSOR
                
                LD A, (SCR_Y)
                LD E, A
                LD A, (SCR_X)
                DEC A

                PUSH DE
                PUSH AF

                CALL VDP_SETPOS
                LD A, 0
                LD BC, VDP_DATA
                OUT (C), A
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
                LD BC, VDP_DATA
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
                CALL VDP_PUT_CURSOR
                
PUTEND:         POP BC
                POP HL
                POP DE
                POP AF
                RET


; ************************************************************************************
; VDP_BLINK_CURSOR - Change state of cursor to make blink and show or not.

VDP_BLINK_CURSOR::
                PUSH AF
                PUSH DE
                PUSH HL
                PUSH BC
               
                LD A, (CURSORSTATE)
                CP 0
                JR Z, CURSORSTATE1
                XOR A
                JP SHOWCURSOR

CURSORSTATE1:   LD A, 1
                 
SHOWCURSOR:     LD (CURSORSTATE), A
                CALL VDP_PUT_CURSOR
                
                POP BC
                POP HL
                POP DE
                POP AF
                RET

; ************************************************************************************
; VDP_PUT_CURSOR - Paint cursor to their position
;       A - Temporary state of cursor

VDP_PUT_CURSOR:     
                CALL VDP_LOCATE_CURSOR
                CP 0
                JR Z, DROPCURSOR
                
                LD A, (SCR_MODE)                ; Detects cursor character depends on mode
                LD HL, VDPCURSORS
                LD D,0
                LD E,A
                ADD HL,DE
                LD A, (HL)

                PUSH BC
                LD BC, VDP_DATA
                OUT (C), A
                NOP
                POP BC
                JP ENDCURSOR
                
DROPCURSOR:     LD A, 0
                PUSH BC
                LD BC, VDP_DATA
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
                
VDP_CURSOR::          
                LD (CURSORSTATE), A
                JR Z, DROPCURSOR
                RET

; ************************************************************************************
; VDP_PRINT - Copy a null-terminated string to VRAM
;       HL = Initial string pointer address

VDP_PRINT::      
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
;       E = Set border color (backdrop)

VDP_SETCOLOR::
        PUSH BC

        LD B, A                 ; Detects if not TEXT Mode you need change first color table
        LD A, (SCR_MODE)        ; and then sets 7 register to set backdrop color.
        CP 0
        JR Z, SET_REG_COLOR
        
SET_COLOR_TABLE:
        LD A, B
        CALL VDP_SET_COLOR_TABLE
        LD B, E

SET_REG_COLOR:
        LD A, B
        LD BC, VDP_REG         ; Put color code
        OUT (C), A
        LD A, VDP_WREG+VDP_R7  ; Reg 7. Change color
        OUT (C), A        
        NOP

        POP BC
        RET

; ************************************************************************************
; VDP_LOCATE - Set the address to place text at X/Y coordinate and update memory variables
;       A = X
;       E = Y

VDP_LOCATE::
VDP_SETPOS:        
        LD      (SCR_X), A

        ; Control if need increment cursor character after printed character or not
        LD      A, (SCR_LAST_CHAR)                      
        CP      0             
        JR      Z,NOINCR 
        CP      CR
        JR      Z,NOINCR
        CP      LF
        JR      Z,NOINCR
        CP      CS
        JR      Z,NOINCR
        CP      BKSP
        JR      Z,NOINCR
        
        LD      A, (SCR_X)
        INC     A
        JR      SET_X

NOINCR:
        LD      A, (SCR_X)
SET_X:  LD      (SCR_CUR_X), A
        LD      A, E
        LD      (SCR_Y), A
        LD      (SCR_CUR_Y), A
        LD      A, (SCR_X)

        CALL    VDP_SCR_GOTOXY
        RET

; ************************************************************************************
; VDP_SCR_GOTOXY - Set the address to place text at X/Y coordinate
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
        
        LD      B, A
        LD      A, (SCR_MODE)
        CP      $01                     ; If mode 1 then num columns is 32
        JR      Z, GOTOXY_32
        
        add     hl, hl                  ; Y x 40
        JP      GOTOXY_40

GOTOXY_32:
        rept 12
                add     hl, de
        endm

GOTOXY_40:
        LD      A, B
        ld      e, a
        add     hl, de                  ; add column for final address

        CALL VDP_GETTABLENAME

WRADDR:  add     hl, bc
         ex      de, hl                  ; send address to TMS
         call    VDP_WRITEADDR

         POP     HL
         RET

; ************************************************************************************
; VDP_GETTABLENAME - Get correct start page address (PAGE NAME)
;      Return BC = Page table name

VDP_GETTABLENAME:
        PUSH HL
        PUSH DE

        LD A, (SCR_MODE)
        LD E, A
        LD D, 0

        LD HL, VDPTABLENAMES  ; pointer to registers settings
        ADD HL, DE

        LD B, (HL)
        LD C, 0

        POP DE
        POP HL
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

; ************************************************************************************
; VDP_READ_VIDEO_LOC - load the char or byte at the VRAM position set by HL
; value is returned into A

VDP_READ_VIDEO_LOC:: 
                push    BC              
                ld      C,VDP_REG       
                ld      B,H
                res     7,B
                res     6,B
                out     (C),L           
                out     (C),B                           
                nop                     
                nop                     
                nop
                nop
                ld      BC,VDP_DATA     
                in      A,(C)           
                pop     BC              
                ret                     

; ************************************************************************************
; VDP_WRITE_VIDEO_LOC - write a byte at the VRAM position pointed by HL
;       HL = Address to write
;       A = Value to write 

VDP_WRITE_VIDEO_LOC::
                push    BC             
                ld      C, VDP_REG      
                ld      B,H            
                res     7,B
                set     6,B            
                out     (C),L          
                out     (C),B                           
                nop                    
                nop                    
                nop
                nop
                ld      BC, VDP_DATA    
                out     (C),A          
                pop     BC             
                ret                    

; ************************************************************************************
; VDP_PLOT - Plot dot on graphics mode (LM80C Leonardo Milliani)
;       A = X
;       E = Y
;       C = Color

VDP_PLOT::
        ld      (SCR_DOT_X), A
        ld      A, E
        ld      (SCR_DOT_Y), A
        ld      A, C
        ld      (SCR_DOT_COLOR), A
        
        push    HL              ; store HL ** do NOT remove these PUSHs since this
        push    BC              ; store BC ** function is called from other routines
        push    DE              ; store DE ***
        call    XY2HL           ; find VRAM address of byte containing pixel at X,Y & return into HL
        jp      NC,NOGD         ; if carry is reset, there was an error -> so leave
        ld      D,A             ; move pixel value into D
        ld      A,(SCR_DOT_COLOR)     ; retrieve color
        and     A               ; is it 0? (background, or reset pixel)
        jr      NZ,CNTPLT1      ; no, continue
        di                      ; yes - so, disable INTs
        call    VDP_READ_VIDEO_LOC  ; load original value of VRAM cell pointed by HL
        ei                      ; re-enable INTs
        ld      E,A             ; store value of cell
        ld      A,D             ; retrieve pixel
        cpl                     ; revert bits
        and     E               ; set video pixel to off
        di                      ; disable INTs
        call    VDP_WRITE_VIDEO_LOC ; write new value into VRAM cell
        ei                      ; re-enable INTs
        jp      NOGD            ; leave
CNTPLT1:add     A,A             ; now we move low nibble
        add     A,A             ; in the high nibble
        add     A,A             ; by adding A to itself
        add     A,A             ; 4 times (this is a shift left 4)
        ld      E,A             ; move it into E
        di                      ; disable INTs
        call    VDP_READ_VIDEO_LOC  ; load original value of VRAM cell pointed by HL
        ei
        or      D               ; merge new pixel preserving original pattern
        di
        call    VDP_WRITE_VIDEO_LOC ; write new value into VRAM cell
        ei
        set     5,H             ; set to read from color VRAM (it's like adding $2000 to HL)
        di
        call    VDP_READ_VIDEO_LOC  ; load original colors of pixel
        ei
        and     $0F             ; reset high nibble (the foreground color)
        or      E               ; set new foreground color
        di
        call    VDP_WRITE_VIDEO_LOC ; write new color settings
        ei                      ; re-enable INTs
        nop                     ; wait for INTs to be enabled again
NOGD:   pop     DE              ; retrieve DE
        pop     BC              ; retrieve BC
        pop     HL              ; retrieve HL
        ret                     ; return to caller

; ************************************************************************************
; XY2HL
;
; compute the VRAM address of the byte containing the pixel
; being pointed by X,Y (TMPBFR1,TMPBFR2)
; byte address is returned into HL
; pixel is returned into A

XY2HL:  ; formula is: ADDRESS=(INT(X/8))*8 + (INT(Y/8))*256 + R(Y/8)
        ; where R(Y/8) is the remainder of (Y/8)
        ; the pixel to be set is given by R(X/8), and data is taken from the array

        ld      A, (SCR_DOT_Y)
        cp      $C0             ; Y>=192?
        ret     NC              ; yes, so leave

        ld      E,$08           ; load E with divisor
        ld      D,A             ; and store into D (dividend)
        call    DIV_8_8         ; get Y/8, D is quotient=INT(Y/8), and A is remainder
        ld      C,A             ; store remainder into C
        ld      B,D             ; B=(INT(Y/8))*256 (we simply copy quotient into B)
        
        ld      H, B            ; copy BC into HL: now HL has the VRAM address of the byte being set
        ld      L, C
        
        ;ld      HL,BC           
        
        ld      A, (SCR_DOT_X)
        ld      D,A             ; and move it into D (dividend)
        call    DIV_8_8         ; get X/8, D is quotient=INT(X/8), and A is remainder
        ld      C,A             ; store remainder into C
        ld      A,D             ; move quotient into A
        add     A,A             ; multiply quotient by 8
        add     A,A
        add     A,A
        ld      E,A             ; store result into E
        ld      D,$00           ; reset D
        ld      B,D             ; reset B
        add     HL,DE           ; add DE to HL, getting the final VRAM address
        ex      DE,HL           ; move VRAM address into DE
        ld      HL,PXLSET       ; starting address of table for pixel to draw
        
        add     HL,BC           ; add C (remainder of X/8) to get address of pixel to turn on

        ld      A,(HL)          ; load pixel data
        ex      DE,HL           ; retrieve VRAM pattern address into HL
        scf                     ; set Carry for normal exit
        ret                     ; return to caller
include "vdp/config.inc"
include "vdp/font68_new.inc"
include "vdp/font88.inc"