
.include "globals.h.s"
.include "common.h.s"
.include "psg.h.s"

.area _DATA
.area _CODE


PSG_INIT::
            
            RET

PSG_CHIMPSOUND::
             PUSH   DE
             PUSH   AF
             PUSH   BC

             LD     A, #7
             LD     C, #62
             CALL   AYREGWRITE
             LD     D, #1

LOOP1VOL:    LD     A, #8
             LD     C, D
             CALL   AYREGWRITE

             LD     E, #0
LOOP2PITCH:  LD     A, #1
             LD     C, E
             CALL   AYREGWRITE
             LD     BC,#200
             CALL   PAUSE
             INC    E
             LD     A, #7
             CP     E
             JR     NZ, LOOP2PITCH   

             LD     A, #8
             LD     C, #0
             CALL   AYREGWRITE   

             INC    D
             LD     A, #8
             CP     D
             JR     NZ, LOOP1VOL

             LD     A, #8
             LD     C, #0
             CALL   AYREGWRITE   

             POP    BC
             POP    AF
             POP    DE
             RET
AYREGWRITE:     
            PUSH BC
            LD BC, #AYCTRL
            OUT (C), A
            POP BC
            LD  A, C
            LD BC, #AYDATA
            OUT (C), A
            RET    