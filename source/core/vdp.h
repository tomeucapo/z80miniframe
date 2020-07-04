

/* VDP memory addresses */
#define		VDP_DATA     0x2e
#define		VDP_MODE     0x2f

#define		VDP_WREG    0x80       // to be added to the REG value
#define		VDP_RRAM    0x00       // to be added to the ADRS value
#define		VDP_WRAM    0x40       // to be added to the ADRS value
#define		VDP_R0      0
#define		VDP_R1      1
#define		VDP_R2      2
#define		VDP_R3      3
#define		VDP_R4      4
#define		VDP_R5      5
#define		VDP_R6      6
#define		VDP_R7      7
#define		VDP_WAIT    1

#define     VRAM_PAGES  64

void vdp_init();
void vdp_poke(int loc, char value);
char vdp_peek(int loc);

void vdp_print(char *text);
void vdp_putch(char c);
void vdp_gotoxy(char x, char y);
void vdp_textbackground(char color);
void vdp_textcolor(char color);

static char CUR_POS_X = 1;
static char CUR_POS_Y = 1;
