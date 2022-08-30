
;; PPI 82C55 I/O Addresses

PIO1A:       	.EQU    $0000              ; Port A Address
PIO1B:       	.EQU    $0001              ; Port B address
PIO1C       	.EQU    $0002              ; Port C address
PIO1CONT:    	.EQU    $0003              ; Control register address

;; Some constants for configuration

PPIDEFCFG:       .EQU    10010000b       ; Default configuration register
PBIN:            .EQU    $02
PBOUT:           .EQU    $F0

;; Port names depends on system

ifdef Z80AIO

LED_PORT        .EQU            PIO1C
SW_PORT         .EQU            PIO1A
CAS_PORT_OUT    .EQU            PIO1C

LED_PIN_1       .EQU            1
LED_PIN_2       .EQU            2

endif

ifdef Z80FRAME

LED_PORT        .EQU            PIO1B
SW_PORT         .EQU            PIO1A
CAS_PORT_OUT    .EQU            PIO1C

LED_PIN_1       .EQU            4
LED_PIN_2       .EQU            8

endif