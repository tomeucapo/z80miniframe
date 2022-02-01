VDP_DATA        .EQU    0x002E
VDP_REG         .EQU    0x002F

VDP_WREG        .EQU    0x80   ; to be added to the REG value
VDP_RRAM        .EQU    0x00   ; to be added to the ADRS value
VDP_WRAM        .EQU    0x40   ; to be added to the ADRS value

VDP_R0          .EQU    00
VDP_R1          .EQU    01
VDP_R2          .EQU    02
VDP_R3          .EQU    03
VDP_R4          .EQU    04
VDP_R5          .EQU    05
VDP_R6          .EQU    06
VDP_R7          .EQU    07

VDP_DEFAULT_COLOR      .EQU     0x5F

.globl VDP_INIT, VDP_PUTCHAR, VDP_PRINT
