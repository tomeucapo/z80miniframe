
#include <z80.h>
#include "vdp.h"

#define 	PIO1A		0x00
#define		PIO1B		0x01
#define		PIO1C		0x02
#define		PIO1CTRL	0x03

void main(void)
{
	char helloTxt[9]={'K','B','D','T','S','T',' ','1',0};
        char keyCodes[8][8] = {
                {0,   '1','X','7','V','3','N','5'},
                {0, 0x1b, 'Q','J','F','D','T','R'},
                {17, 'Z', '2','M','4','C','6','B'},
                {0,    0,'\\','K','-',',','9',';'},
                {16,  37, 40, 32, 38,39,',','.'},
                {0,   8,']','U','P','[','I','O'},
                {0, 'A','S','Y','E','W','H','G'},
                {16, 13, 0, '8','/','=','L','0'}};

	z80_outp(PIO1CTRL, 0x90);
	vdp_init();
	
	vdp_gotoxy(1, 1);
	vdp_print(helloTxt);

	z80_outp(PIO1B, 4);
	z80_delay_ms (200);
	z80_outp(PIO1B, 8);
	z80_delay_ms (200);

	unsigned int cNum = 0; 
	vdp_gotoxy(1,2);

        while (1)
        {
                unsigned char colPoll = 1;
                unsigned char col = 0, row = 0;
                unsigned char keyPressed = 0;
                
                while (colPoll != 0)
                {
                        z80_outp(PIO1C, ~colPoll);
                        for (row = 0; row < 8; row++)
                        {
                                z80_outp(PIO1B, row << 4);
                                z80_delay_ms(20);
                                if (!(z80_inp(PIO1A) & 0x80))
                                {
                                        keyPressed = 1;
                                        break;
                                } 
                        }

                        if (keyPressed)
                           break;

                        colPoll <<= 1;
                        col++;
                }

                if (keyPressed)
                {
                        vdp_putch(keyCodes[row][col]);
                        cNum++;

                        if (cNum > 920)
                        {
                                cNum = 0;
                                vdp_gotoxy(1, 2);
                        }

                }
        }
}
