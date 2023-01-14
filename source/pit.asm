
include "pit.inc"

PIT_INIT::
        PUSH AF

        LD A, 31h               	; Configure as mode 0 interrut on terminal count
        OUT (PITCTRL), A
         
        LD A, 25h                   ; LSB Counter Reg. 0
        OUT (PITCNT0), A

        LD A, 01h                   ; MSB Counter Reg. 0
        OUT (PITCNT0), A
          
        POP AF
        RET 

PIT_RESET::
        PUSH AF
        
        LD A, 25h                   ; LSB Counter Reg. 0
        OUT (PITCNT0), A

        LD A, 01h                   ; MSB Counter Reg. 0
        OUT (PITCNT0), A
        POP AF
        RET