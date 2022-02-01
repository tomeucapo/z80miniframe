;;
;; VDP Modes Configurations
;;

VDPMODESSIZES:  ; Screen mode dimensions

                .db 40, 24
                .db 32, 24
                .db 0, 192      ; 0=256 x 192
                .db 64, 48
                .db 32, 24

VDPTABLENAMES:
                .db 0x08, 0x18, 0x18, 0x08, 0x38

                ; VDP registers settings to set up a text mode

VDPMODESCONF:   .db 0x00    ; reg.0: external video disabled
                .db 0xF0    ; reg.1: text mode (40x24), enable display
                .db 0x02          ; reg.2: name table set to $800 ($02x$400)
                .db 0x00          ; reg.3: not used in text mode
                .db 0x00          ; reg.4: pattern table set to $0000
                .db 0x00          ; reg.5: not used in text mode
                .db 0x00          ; reg.6: not used in text mode
                .db 0x5F          ; reg.7: light blue text on white background

                 ; VDP register settings for a graphics 1 mode

                .db    0x00       ; reg.0: ext. video off
                .db    0xC0       ; reg.1: 16K Vram; video on, int off, graphics mode 1, sprite size 8x8, sprite magn. 0
                .db    0x06             ; reg.2: name table address: $1800
                .db    0x80             ; reg.3: color table address: $2000
                .db    0x00             ; reg.4: pattern table address: $0000
                .db    0x36             ; reg.5: sprite attr. table address: $1B00
                .db    0x07             ; reg.6: sprite pattern table addr.: $3800
                .db    0x05             ; reg.7: backdrop color (light blue)

                ; VDP register settings for a graphics 2 mode
                
                .db    0x02       ; reg.0: graphics 2 mode, ext. video dis.
                .db    0xC0       ; reg.1: 16K VRAM, video on, INT off, sprite size 8x8, sprite magn. 0
                .db    0x06             ; reg.2: name table addr.: $1800
                .db    0xFF             ; reg.3: color table addr.: $2000
                .db    0x03             ; reg.4: pattern table addr.: $0000
                .db    0x36             ; reg.5: sprite attr. table addr.: $1B00
                .db    0x07             ; reg.6: sprite pattern table addr.: $3800
                .db    0xC5             ; reg.7: backdrop color: light blue

                ; VDP register settings for a multicolor mode

                .db    0x00       ; reg.0: ext. video dis.
                .db    0xCB       ; reg.1: 16K VRAM, video on, INT off, multicolor mode, sprite size 8x8, sprite magn. 0
                .db    0x02             ; reg.2: name table addr.: $0800
                .db    0x00             ; reg.3: don't care
                .db    0x00             ; reg.4: pattern table addr.: $0000
                .db    0x36             ; reg.5: sprite attr. table addr.: $1B00
                .db    0x07             ; reg.6: sprite pattern table addr.: $3800
                .db    0x0F             ; reg.7: backdrop color (white)

                ; VDP register settings for an extended graphics 2 mode

                .db    0x02       ; reg.0: graphics 2 mode, ext. video dis.
                .db    0xC0       ; reg.1: 16K VRAM, video on, INT off, sprite size 8x8, sprite magn. 0
                .db    0x0E             ; reg.2: name table addr.: $3800
                .db    0x9F             ; reg.3: color table addr.: $2000
                .db    0x00             ; reg.4: pattern table addr.: $0000
                .db    0x76             ; reg.5: sprite attr. table addr.: $3B00
                .db    0x03             ; reg.6: sprite pattern table addr.: $1800
                .db    0x05             ; reg.7: backdrop color: light blue
