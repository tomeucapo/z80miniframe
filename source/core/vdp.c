#include <z80.h>
#include "vdp.h"
#include "font.h"

unsigned char vdpTxtRegs[8] = { 
        0x04,   // reg.0: external video disabled
        0x50,   // reg.1: text mode (40x24), enable display
        0x02,   // reg.2: name table set to $800 ($02x$400)
        0x00,   // reg.3: not used in text mode
        0x00,   // reg.4: pattern table set to $0000
        0x00,   // reg.5: not used in text mode
        0x00,   // reg.6: not used in text mode
        0xf1    // reg.7: Background and text color
};

void vdp_clear_vram()
{
    z80_outp(VDP_REG, 0);
    z80_outp(VDP_REG, 0x40);
    
    for(int page = VRAM_PAGES; page > 0 ;page--)
    {
        for(int i = 0; i < 0xff; i++)
        {
            z80_outp(VDP_RAM, 0);
            __asm
                nop
                nop
            __endasm;
        }
    }
}

void vdp_init()
{
    // Initialize VDP registers
    for (unsigned char r = 0; r < 8; r++)
    {
            z80_outp(VDP_REG, vdpTxtRegs[r]);
            z80_outp(VDP_REG, 0x80 + r);
    }

    // Clear VRAM
    vdp_clear_vram();

    // Define characterset font
    z80_outp(VDP_REG, 0);
    z80_outp(VDP_REG, 0x40);

    for(unsigned char c = 0; c < 128; c++)
    {
        for(unsigned char b = 0; b < 8; b++) 
        {
            z80_outp(VDP_RAM, font8x8[c][b]);
            __asm
                nop
            __endasm;
        }
    }
}

void vdp_print(char *text)
{
    for(int i=0; text[i] != 0; i++)
    {
        z80_outp(VDP_RAM, text[i]);
        __asm
            nop
        __endasm;
    }
}

/**
 * set the address to place text at X/Y coordinate
 *      A = X
 *      E = Y
 */

void vdp_gotoxy(char x, char y)
{
	__asm
	    ld hl,2
  		add hl,sp              ; skip over return address on stack
  		ld e,(hl)              ; e = y
  		inc hl
  		ld a,(hl)              ; a = x

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
        ex      de, hl                  ; send address to TMS
        call    tmswriteaddr
        ret

tmswriteaddr:
        ld      c, VDP_REG
        out     (c), e             ; send lsb     
        ld      a, d                    ; mask off msb to max of 16KB
        and     $3F
        or      $48                ; set second highest bit to indicate write
        out     (VDP_REG), a             ; send msb
        ret
	__endasm;
}

void vdp_putch(char c)
{
    z80_outp(VDP_RAM, c);
    __asm
        nop
	__endasm;
}
