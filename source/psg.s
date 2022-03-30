
.include "globals.h.s"
.include "common.h.s"
.include "psg.h.s"

.area _DATA
.area _CODE


PSG_INIT::

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