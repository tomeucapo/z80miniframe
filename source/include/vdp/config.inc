PXLSET: 
                .DEFB    $80,$40,$20,$10,$08,$04,$02,$01

;; Screen mode dimensions

VDPMODESSIZES:  
                .DEFB 40, 24
                .DEFB 32, 24
                .DEFB 0, 192      ; 0=256 x 192
                .DEFB 64, 48
                .DEFB 32, 24

VDPCURSORS:
                .DEFB $FF, 219, 0, 0, 0                

;; Table names

VDPTABLENAMES:
                .DEFB $08, $18, $18, $08, $38


;; VDP registers settings to set up a text mode

VDPMODESCONF:   defb 00000000b          ; reg.0: external video disabled
                defb 11110100b          ; reg.1: text mode (40x24), enable display, enable interrupts
                defb $02                ; reg.2: name table set to $800 ($02x$400)
                defb $00                ; reg.3: not used in text mode
                defb $00                ; reg.4: pattern table set to $0000
                defb $00                ; reg.5: not used in text mode
                defb $00                ; reg.6: not used in text mode
                defb VDP_DEFAULT_COLOR  ; reg.7: light blue text on white background

                 ; VDP register settings for a graphics 1 mode

                defb    00000000b       ; reg.0: ext. video off
                defb    11000100b       ; reg.1: 16K Vram; video on, int off, graphics mode 1, sprite size 8x8, sprite magn. 0
                defb    $06             ; reg.2: name table address: $1800
                defb    $80             ; reg.3: color table address: $2000
                defb    $00             ; reg.4: pattern table address: $0000
                defb    $36             ; reg.5: sprite attr. table address: $1B00
                defb    $07             ; reg.6: sprite pattern table addr.: $3800
                defb    $05             ; reg.7: backdrop color (light blue)

                ; VDP register settings for a graphics 2 mode
                
                defb    00000010b       ; reg.0: graphics 2 mode, ext. video dis.
                defb    11000100b       ; reg.1: 16K VRAM, video on, INT off, sprite size 8x8, sprite magn. 0
                defb    $06             ; reg.2: name table addr.: $1800
                defb    $FF             ; reg.3: color table addr.: $2000
                defb    $03             ; reg.4: pattern table addr.: $0000
                defb    $36             ; reg.5: sprite attr. table addr.: $1B00
                defb    $07             ; reg.6: sprite pattern table addr.: $3800
                defb    $C5             ; reg.7: backdrop color: light blue

                ; VDP register settings for a multicolor mode

                defb    00000000b       ; reg.0: ext. video dis.
                defb    11001111b       ; reg.1: 16K VRAM, video on, INT off, multicolor mode, sprite size 8x8, sprite magn. 0
                defb    $02             ; reg.2: name table addr.: $0800
                defb    $00             ; reg.3: don't care
                defb    $00             ; reg.4: pattern table addr.: $0000
                defb    $36             ; reg.5: sprite attr. table addr.: $1B00
                defb    $07             ; reg.6: sprite pattern table addr.: $3800
                defb    $0F             ; reg.7: backdrop color (white)

                ; VDP register settings for an extended graphics 2 mode

                defb    00000010b       ; reg.0: graphics 2 mode, ext. video dis.
                defb    11000100b       ; reg.1: 16K VRAM, video on, INT off, sprite size 8x8, sprite magn. 0
                defb    $0E             ; reg.2: name table addr.: $3800
                defb    $9F             ; reg.3: color table addr.: $2000
                defb    $00             ; reg.4: pattern table addr.: $0000
                defb    $76             ; reg.5: sprite attr. table addr.: $3B00
                defb    $03             ; reg.6: sprite pattern table addr.: $1800
                defb    $05             ; reg.7: backdrop color: light blue
