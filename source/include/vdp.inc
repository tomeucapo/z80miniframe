; Addresses of Data and Register configuration of VDP

VDP_DATA        .EQU    $002E
VDP_REG         .EQU    $002F

VDP_RRAM        .EQU    $00   ; to be added to the ADRS value
VDP_WRAM        .EQU    $40   ; to be added to the ADRS value
VDP_WREG        .EQU    $80

VDP_R0          .EQU    00h
VDP_R1          .EQU    01h
VDP_R2          .EQU    02h
VDP_R3          .EQU    03h
VDP_R4          .EQU    04h
VDP_R5          .EQU    05h
VDP_R6          .EQU    06h
VDP_R7          .EQU    07h

VDP_DEFAULT_COLOR      .EQU     $F5