
;; PPI 82C55 I/O Addresses

PIO1A:       	.EQU    $00              ; Port A Address
PIO1B:       	.EQU    $01              ; Port B address
PIO1C:       	.EQU    $02              ; Port C address
PIO1CONT:    	.EQU    $03              ; Control register address

;; Some constants for configuration

PPIDEFCFG:       .EQU    10010000b       ; Default configuration register
PBIN:            .EQU    $02
PBOUT:           .EQU    $F0