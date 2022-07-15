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
include "common.inc"

                extern DIV_8_8, absHL, negHL, CMP16
                extern PRHEXBYTE, CON_PUTC, CON_NL

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
                JR Z, INIT2

                CALL VDP_LOADCHARSET                
                LD  A, VDP_DEFAULT_COLOR                             
                CALL VDP_SET_COLOR_TABLE

                LD A, 1
                LD (ENABLEDCURSOR), A

                JR ENDINIT

INIT2:                
                ld      HL,$1800        ; Mode 2 name table
                call    SETNAMETABLE    ; Configure table name

                xor     A
                LD      (X1),A
                LD      (X1+1),A
                LD      (Y1),A 
                LD      (Y1+1),A 
                LD      (X2),A
                LD      (X2+1),A
                LD      (Y2),A
                LD      (Y2+1),A
ENDINIT:

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

VDP_RESET_VRAM: XOR A
                LD H,A
                LD L,A                
                CALL VDP_SET_ADDR

                LD B, $40          
                LD D, A            
                DEC C
EMPTYVRAM:      PUSH BC
                LD BC, VDP_DATA
                OUT (C), A    
                POP BC
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



;; SETNAMETABLE - Set name table for G2 mode (patterns from $00 to $FF for each of the 3 areas of the screen)
;;      HL = Table name

SETNAMETABLE:   
                call    VDP_SET_ADDR    ; send address to VDP
                dec     C               ; VDP address for passing data
                ld      h, b
                ld      l, c
                ld      D,$03           ; 3 pages to fill into VRAM (768 cells)
                xor     A               ; starting char name #0 (chars go from 0 to 255)
                ld      B,A             ; reset B
  
RPTFLL1:        push    bc
                ld      b, h
                ld      c, l
                out     (C),A           ; send name to VRAM
                pop     bc
                nop
                inc     A               ; increment # of name
                djnz    RPTFLL1         ; repeat for 256 cells (1 page)
                dec     D               ; did we fill all the pages?
                jr      NZ,RPTFLL1      ; no, continue
                ret                     ; return to caller

; ************************************************************************************
; VDP_PUTCHAR - Output character to VDP routine with character control decisions
;       A = Character to output

VDP_PUTCHAR::   PUSH AF
                PUSH DE
                PUSH HL
                PUSH BC

                ; In mode 2 not write anything

                LD B, A
                
                LD A, (SCR_MODE)
                CP $02
                JP Z, PUTEND

                LD A, B

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
                ld      A,H
                res     7,A
                res     6,A
                ld      BC, VDP_REG     
                out     (C),L           
                out     (C),A                                           
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
                push    AF
                ld      A,H            
                res     7,A
                set     6,A                        
                ld      BC, VDP_REG     
                out     (C),L          
                out     (C),A                           
                nop                    
                nop                    
                nop
                nop
                pop     AF
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
PLOT:        
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



;; LINE X1,Y1,X2,Y2[,color]
;; Draw a line using Bresenham's line algorithm from X1,Y1 to X2,Y2
;; X1,Y1 can be either less than or greater than X2,Y2 (meaning that)
;; the drawing will be ever done from X1,Y2 to X2,Y2, regardless of
;; the values. If color is not specified, the foreground color set
;; with COLOR will be used 
;;      A = X, E = Y, D = X2, H = Y2, C = Color

VDP_LINE::   
        ld      (X1), A         ; X1
        ld      A, E            ; Y1
        ld      (Y1), A
        ld      A, D            ; X2
        ld      (X2), A
        ld      A, H            ; Y2
        ld      (Y2), A
        ld      A, C
        ld      (SCR_DOT_COLOR), A      

        push    HL              ; store register we'll use
        ld      DE,(X1)         ; load X1 and
        ld      HL,(X2)         ; X2
        or      A               ; clear CARRY
        sbc     HL,DE           ; DX=X2-X1
        call    absHL           ; DX=ABS(DX)
        ld      (DX),HL         ; store DX
        ld      BC,$FFFF        ; SX=-1
        ld      HL,(X1)
        ld      DE,(X2)
        call    CMP16           ; X1<X2?
        jp      Z,X1GR          ; no, X1=X2
        jp      P,X1GR          ; no, X1>X2
        ld      BC,$0001        ; yes, so set SX=1
X1GR:   ld      (SX),BC         ; store SX
        ld      DE,(Y1)
        ld      HL,(Y2)
        or      A               ; clear Carry
        sbc     HL,DE           ; DY=Y2-Y1
        call    absHL           ; DY=ABS(DY)
        ld      (DY),HL         ; store DY
        ld      BC,$FFFF        ; SY=-1
        ld      HL,(Y1)
        ld      DE,(Y2)
        call    CMP16           ; is Y1<Y2?
        jp      Z,Y1GR          ; no, Y1=Y2
        jp      P,Y1GR          ; no, Y1>Y2 - jump over
        ld      BC,$0001        ; yes, so set SY=1
Y1GR:   ld      (SY),BC         ; store SY
        ld      HL,(DY)         ; ER=DY
        call    negHL           ; ER=-DY
        ld      (ER),HL         ; store ER
        ld      HL,(DX)
        ld      DE,(DY)
        call    CMP16           ; DX>DY?
        jp      Z,ER2           ; no, DX=DY
        jp      M,ER2           ; no, DX<DY
        ld      HL,(DX)         ; reload DX
        ld      (ER),HL         ; yes: DX>DY, so ER=DX
ER2:    ld      HL,(ER)         ; load ER
        sra     H               ; right shift (and preserve sign)...
        rr      L               ; ...of HL, so ER=INT(ER/2)
        bit     7,H             ; is the number negative?
        jp      Z,STRE2         ; no, jump over
        inc     HL              ; yes, add 1 'cos INT of a negative number needs to be incremented
STRE2:  ld      (ER),HL         ; store ER
RPTDRW: 
        call    PLOT            ; plot first pixel
        ld      HL,(X1)
        ld      DE,(X2)
        call    CMP16           ; X1=X2?
        jr      NZ,CNTDRW       ; no, continue drawing
        ld      HL,(Y1)         ; yes, so check
        ld      DE,(Y2)         ; also Y
        call    CMP16           ; Y1=Y2?
        jp      Z,ENDDRAW       ; yes, finished drawing: exit
CNTDRW: ld      DE,(ER)
        ld      (E2),DE         ; E2=ER
        ld      HL,(DX)
        call    negHL           ; DX=-DX
        ex      DE,HL           ; invert DE and HL => HL=E2, DE=-DX
        call    CMP16           ; E2>-DX?
        jp      Z,DXGR          ; no, E2=-DX: jump
        jp      M,DXGR          ; no, E2<-DX: jump
        ld      HL,(ER)         ; yes
        ld      DE,(DY)
        or      A               ; clear CARRY
        sbc     HL,DE           ; ER=ER-DY
        ld      (ER),HL
        ld      HL,(X1)
        ld      DE,(SX)
        add     HL,DE           ; X1=X1+SX (increment X1)
        ld      (X1),HL
DXGR:   ld      HL,(E2)
        ld      DE,(DY)
        call    CMP16           ; E2<DY?
        jp      Z,RPTDRW        ; no, E2=DY: jump
        jp      P,RPTDRW        ; no, E2>DY: jump
        ld      HL,(ER)         ; yes
        ld      DE,(DX)
        add     HL,DE           ; ER=ER+DX
        ld      (ER),HL
        ld      HL,(Y1)
        ld      DE,(SY)
        add     HL,DE           ; Y1=Y1+SY (increment Y1)
        ld      (Y1),HL
        jp      RPTDRW          ; repeat
ENDDRAW:pop     HL              ; retrieve HL
        ret                     ; return to caller

; ************************************************************************************
; XY2HL
;
; compute the VRAM address of the byte containing the pixel
; being pointed by X,Y (SCR_DOT_X, SCR_DOT_Y)
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


;; CIRCLE X,Y,R[,C]
;; Draw a circle using Bresenham's circle algorithm with center in X,Y
;; and radius R, with optional color C. If color is not specified, the
;; foreground color set with COLOR will be used 

VDP_CIRCLE::
        PUSH    AF
        CALL    CLRVARS
        POP     AF

        ld      (XC), A         ; X
        ld      A, E            ; Y
        ld      (YC), A
        ld      A, D            ; RADIUS
        ld      (RADIUS), A
        ld      A, C
        ld      (SCR_DOT_COLOR), A      
 
        push    HL              ; store HL
        xor     A               ; clear A,
        ld      B,A             ; B,
        ld      C,A             ; C,
        ld      D,A             ; D,
        ld      H,A             ; and H
        ld      (XI),BC         ; clear XI
        ld      A,(RADIUS)      ; load RADIUS into A
        ld      L,A             ; HL now contains R
        ld      (YI),HL         ; YI=RADIUS
        add     HL,HL           ; R*2
        ex      DE,HL           ; put HL into DE
        ld      HL,$0003        ; HL = 3
        xor     A               ; clear Carry
        sbc     HL,DE           ; D=3-(2*R) => HL
        ld      (DC),HL         ; store D
        call    DRWCRL          ; draw initial point
RPTCRL: ld      DE,(XI)         ; load XI
        ld      HL,(YI)         ; load YI
        call    CMP16           ; is YI<DI?
        jp      Z,RPTCL1        ; no, YI=XI
        jp      P,RPTCL1        ; no, YI>XI
        jp      ENDCRL          ; yes, so we've finished
RPTCL1: ld      HL,XI
        inc     (HL)            ; XI=XI+1
        ld      HL,(DC)         ; load D
        ld      A,H
        or      L               ; is D=0? Yes, jump over
        jp      Z,DLSZ
        bit     7,H             ; is D<0?
        jr      NZ,DLSZ         ; yes, jump over
        ld      DE,(YI)         ; D>0
        dec     DE              ; so, YI=YI-1
        ld      (YI),DE         ; store YI
        xor     A               ; clear Carry
        ld      HL,(XI)
        sbc     HL,DE           ; HL=XI-YI
        add     HL,HL
        add     HL,HL           ; HL=HL*4
        ld      DE,10
        add     HL,DE           ; HL=HL+10
        ld      DE,(DC)         ; load D
        ex      DE,HL           ; invert DE and HL, so that HL=4*(XI-YI)+10 and DE=D
        add     HL,DE           ; D=D+4*(XI-YI)+10
        jr      PLTCRL          ; plot next pixel
DLSZ:   ld      HL,(XI)         ; load XI
        add     HL,HL
        add     HL,HL           ; XI=XI*4
        ld      DE,$0006
        add     HL,DE
        ld      DE,(DC)
        ex      DE,HL           ; HL=D and DE=4*XI+6
        add     HL,DE           ; D=D+4*XI+6
PLTCRL: ld      (DC),HL         ; store new D
        call    DRWCRL          ; plot pixel
        jp      RPTCRL          ; repeat
ENDCRL: pop     HL
        ret                     ; return to caller
DRWCRL: ld      HL,(XC)
        ld      DE,(XI)
        add     HL,DE           ; X=XC+XI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        jp      C,CNTCL1        ; if Carry is set, X is not valid
        ld      HL,(YC)
        ld      DE,(YI)
        add     HL,DE           ; Y=YC+YI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT      ; if Carry is reset, Y is valid and plot the pixel
CNTCL1: xor     A               ; clear Carry
        ld      HL,(XC)
        ld      DE,(XI)
        sbc     HL,DE           ; X=XC-XI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        jp      C,CNTCL2        ; if Carry is set, X is not valid
        ld      HL,(YC)
        ld      DE,(YI)
        add     HL,DE           ; Y=YC+YI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT      ; if Carry is reset, Y is valid and plot the pixel
CNTCL2: ld      HL,(XC)
        ld      DE,(XI)
        add     HL,DE           ; X=XC+XI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        jp      C,CNTCL3        ; if Carry is set, X is not valid
        xor     A               ; clear Carry
        ld      HL,(YC)
        ld      DE,(YI)
        sbc     HL,DE           ; Y=YC-YI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT      ; if Carry is reset, Y is valid and plot the pixel
CNTCL3: xor     A               ; clear Carry
        ld      HL,(XC)
        ld      DE,(XI)
        sbc     HL,DE           ; X=XC-XI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        jp      C,CNTCL4        ; if Carry is set, X is not valid
        xor     A               ; clear Carry
        ld      HL,(YC)
        ld      DE,(YI)
        sbc     HL,DE           ; Y=YC-YI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT      ; if Carry is reset, Y is valid and plot the pixel
CNTCL4: ld      HL,(XC)
        ld      DE,(YI)
        add     HL,DE           ; X=XC+YI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        jp      C,CNTCL5        ; if Carry is set, X is not valid
        ld      HL,(YC)
        ld      DE,(XI)
        add     HL,DE           ; Y=YC+XI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT      ; if Carry is reset, Y is valid and plot the pixel
CNTCL5: xor     A               ; clear Carry
        ld      HL,(XC)
        ld      DE,(YI)
        sbc     HL,DE           ; X=XC-YI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        jp      C,CNTCL6        ; if Carry is set, X is not valid
        ld      HL,(YC)
        ld      DE,(XI)
        add     HL,DE           ; Y=YC+XI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT      ; if Carry is reset, Y is valid and plot the pixel
CNTCL6: ld      HL,(XC)
        ld      DE,(YI)
        add     HL,DE           ; X=XC+YI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        jp      C,CNTCL7        ; if Carry is set, X is not valid
        xor     A               ; clear Carry
        ld      HL,(YC)
        ld      DE,(XI)
        sbc     HL,DE           ; Y=YC-XI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT         ; if Carry is reset, Y is valid and plot the pixel
CNTCL7: xor     A               ; clear Carry
        ld      HL,(XC)
        ld      DE,(YI)
        sbc     HL,DE           ; X=XC-YI
        ld      (SCR_DOT_X),HL         ; store X
        call    VALIDX          ; check if X is valid (0~255)
        ret     C               ; if Carry is set, X is not valid
        xor     A               ; clear Carry
        ld      HL,(YC)
        ld      DE,(XI)
        sbc     HL,DE           ; Y=YC-XI
        ld      (SCR_DOT_Y),HL         ; store Y
        call    VALIDY          ; check if Y is valid (0~191)
        call    NC,PLOT      ; if Carry is reset, Y is valid and plot the pixel
        ret                     ; return to caller

; check if X,Y coordinates are valid: 0<=X<=255 and 0<=Y<=191
; input: HL (value to check), can be negative
; output: CARRY flag: reset => VALID  //  set => NOT VALID
; destroys: A
VALIDX: xor     A               ; reset A
        or      H               ; check if H is 0 (this means that X is in range 0~255 and not negative)
        ret     Z               ; yes, we can return (C is clear)
        scf                     ; set Carry flag to raise error
        ret                     ; return to caller

VALIDY: xor     A               ; reset A
        or      H               ; check if H is 0 (this means that Y is in range 0~255 and not negative)
        jr      Z,CNTVALY       ; yes, continue checking
        scf                     ; no, raise error by setting Carry flag
        ret                     ; return to caller
CNTVALY:ld      A,L
        cp      $C0             ; is Y<192? Carry is set if Y<192
        ccf                     ; invert Carry, so Carry=0 means OK, Carry=1 means ERROR
        ret                     ; return to caller

CLRVARS:
        XOR A
        
        LD (SCR_DOT_X),A
        LD (SCR_DOT_X+1),A
        LD (SCR_DOT_Y),A
        LD (SCR_DOT_Y+1),A
        LD (XC),A
        LD (XC+1),A
        LD (YC),A
        LD (YC+1),A
        LD (XI),A
        LD (XI+1),A
        LD (YI),A
        LD (YI+1),A

        LD (RADIUS),A
        LD (RADIUS+1),A

        LD (DC),A
        LD (DC+1),A
        RET

include "vdp/config.inc"
include "vdp/font68_new.inc"
include "vdp/font88.inc"