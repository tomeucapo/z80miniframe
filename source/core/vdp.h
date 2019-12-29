

/* VDP memory addresses */
#define		VDP_RAM     0x2e
#define		VDP_REG     0x2f

#define		VDP_WREG    10000000b       // to be added to the REG value
#define		VDP_RRAM    00000000b       // to be added to the ADRS value
#define		VDP_WRAM    01000000b       // to be added to the ADRS value
#define		VDP_R0      00h
#define		VDP_R1      01h
#define		VDP_R2      02h
#define		VDP_R3      03h
#define		VDP_R4      04h
#define		VDP_R5      05h
#define		VDP_R6      06h
#define		VDP_R7      07h
#define		VDP_WAIT    1

#define     VRAM_PAGES  64

void vdp_init();
void vdp_print(char *text);
void vdp_putch(char c);
void vdp_gotoxy(char x, char y);
