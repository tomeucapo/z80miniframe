
;; Counters addresses

PITCNT0        .EQU        0x0080
PITCNT1        .EQU        0x0081
PITCNT2        .EQU        0x0082

;; PIT Control register address

PITCTRL        .EQU        0x0083

;; Macro that reload value onto specified counter

LOADCNT macro cnt, lsb, msb      
        LD A, lsb                   ; LSB Counter Reg. 0
        OUT (cnt), A

        LD A, msb                   ; MSB Counter Reg. 0
        OUT (cnt), A
        endm