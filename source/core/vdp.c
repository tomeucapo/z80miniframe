#include <z80.h>
#include "vdp.h"
#include "font.h"

unsigned char vdpTxtRegs[8] = { 
        0x00,   // reg.0: external video disabled
        0xd0,   // reg.1: text mode (40x24), enable display
        0x02,   // reg.2: name table set to $800 ($02x$400)
        0x00,   // reg.3: not used in text mode
        0x00,   // reg.4: pattern table set to $0000
        0x00,   // reg.5: not used in text mode
        0x00,   // reg.6: not used in text mode
        0xf5    // reg.7: Background and text color
};

void vdp_set_address(int addr)
{
    z80_outp(VDP_MODE, addr & 0x00FF);
    z80_outp(VDP_MODE, ((addr & 0xFF00) >> 8) | VDP_WRAM);
}

void vdp_clear_vram()
{
    //z80_outp(VDP_MODE, 0);
    //z80_outp(VDP_MODE, 0x40);    // First page of VRAM 
    
    vdp_set_address(0);

    for(int page = VRAM_PAGES; page > 0 ;page--)
    {
        for(int i = 0; i < 0xff; i++)
        {
            z80_outp(VDP_DATA, 0);
        }
    }
}

void vdp_init()
{
    // Clear VRAM
    vdp_clear_vram();

    // Initialize VDP registers
    for (unsigned char r = 0; r < 8; r++)
    {
            z80_outp(VDP_MODE, vdpTxtRegs[r]);
            z80_outp(VDP_MODE, VDP_WREG + r);
    }

    // Define characterset font
    z80_outp(VDP_MODE, 0);
    z80_outp(VDP_MODE, 0x40);

    for(unsigned char c = 0; c < 128; c++)
    {
        for(unsigned char b = 0; b < 8; b++) 
        {
            z80_outp(VDP_DATA, font8x8[c][b]);
        }
    }
}

void vdp_poke(int addr, char value)
{
    char highLoc = (addr & 0xFF00) >> 8;
    highLoc |= VDP_WRAM;

    z80_outp(VDP_MODE, addr & 0x00FF);
    z80_outp(VDP_MODE, highLoc);
    __asm
        nop
        nop
    __endasm;
    z80_outp(VDP_DATA, value);
}

char vdp_peek(int loc)
{
    z80_outp(VDP_MODE, loc & 0x00FF);
    z80_outp(VDP_MODE, (loc & 0xFF00) >> 8);
     __asm
        nop
        nop
     __endasm;
    return z80_inp(VDP_DATA);
}

void vdp_print(char *text)
{
    for(int i=0; text[i] != 0; i++)
    {
        vdp_putch(text[i]);
        __asm
                nop
        __endasm;
        CUR_POS_X++;
    }
}

void vdp_gotoxy(char x, char y)
{
    CUR_POS_X = x;
    CUR_POS_Y = y;
}

void vdp_putch(char c)
{
    int pos = (CUR_POS_Y*40)+CUR_POS_X;
    vdp_poke(pos, c);
}

void vdp_textbackground(char color)
{
     char current = vdpTxtRegs[VDP_R7];
     current &= 0xFC;

     z80_outp(VDP_MODE, current | color);
     z80_outp(VDP_MODE, VDP_WREG + VDP_R7);

     vdpTxtRegs[VDP_R7] = current | color;
}

void vdp_textcolor(char color)
{
     char current = vdpTxtRegs[VDP_R7];
     current &= 0x03;

     z80_outp(VDP_MODE, current | (color << 4));
     z80_outp(VDP_MODE, VDP_WREG + VDP_R7);

     vdpTxtRegs[VDP_R7] = current | (color << 4);

}
