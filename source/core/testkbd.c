
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
                {0,   'N','5','V','V','1','X','3'},
                {0, 0x1b, 'R','J','F','.','W','Q'},
                {17, '6', 'B','.','4','Z','2','.'},
                {0,    0,'\\','K','-',',','9',';'},
                {16,  37, 40, 32, 38,39,',','.'},
                {0,   8,'O','P','U','I',']','['},
                {0, 'H','G','E','E','W','H','W'},
                {16, 13, 0, '8','/','=','L','0'}};

	z80_outp(PIO1CTRL, 0x90);
	vdp_init();
	
	z80_outp(PIO1B, 4);
	z80_delay_ms (200);
	z80_outp(PIO1B, 8);
	z80_delay_ms (200);
        
        vdp_print(helloTxt);
        /*
        for(char i = 0; i < 14; i++)
        {
                vdp_textcolor(i);
	        vdp_gotoxy(1, 1+i);
                
        }
        */
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
                                z80_delay_ms(1);
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
                        z80_outp(PIO1B, 4);
                        vdp_putch(keyCodes[row][col]);
                        cNum++;

                        if (cNum > 920)
                        {
                                cNum = 0;
                                vdp_gotoxy(1, 2);
                        }
                        z80_outp(PIO1B, 0);
                }
        }
}
