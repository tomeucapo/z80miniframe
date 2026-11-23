
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

        ; Mode 0 latches OUT high at terminal count.  A new control word
        ; returns OUT low, clearing the active-low request through the
        ; interrupt-manager inverter before the next one-shot interval.
        LD A, 31h
        OUT (PITCTRL), A
        LOADCNT PITCNT0, 50h, 20h

        POP BC
        POP AF
        RET
