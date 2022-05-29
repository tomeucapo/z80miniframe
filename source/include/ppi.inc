
; PPI 82C55 I/O Addresses

PIO1A:       	.EQU    $00              ; (INPUT)  IN 1-8
PIO1B:       	.EQU    $01              ; (OUTPUT) OUT TO LEDS
PIO1C:       	.EQU    $02              ; (INPUT)
PIO1CONT:    	.EQU    $03              ; CONTROL BYTE PIO 82C55


PBIN:            .EQU    $02
PBOUT:           .EQU    $F0