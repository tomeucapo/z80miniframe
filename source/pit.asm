
include "pit.inc"

PIT_INIT::
        PUSH AF
        PUSH BC

        LD A, 31h                   ; Configure as mode 0 interrupt on terminal count
        OUT (PITCTRL), A

        LOADCNT PITCNT0, 50h, 20h
          
        POP BC
        POP AF
        RET 

PIT_RESET::
        PUSH AF
        PUSH BC

        LOADCNT PITCNT0, 50h, 20h

        POP BC
        POP AF
        RET