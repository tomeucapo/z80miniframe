.include "vdp.h.s"

.area _DATA
.area _CODE

; Main RST 20 routine dispacher

SVC_DISPATCH_ROUTINE::
                EX      AF, AF'

                LD      A, B
                CP      #0
                JR      Z, _VDP_SETCOLOR
                CP      #1
                JR      Z, _VDP_PRINT
                CP      #2
                JR      Z, _VDP_SETPOS
                CP      #3
                JR      Z, _VDP_MODE
                CP      #4
                JR      Z, _VDP_WRITE_VIDEO_LOC

                EX      AF, AF'
                JP      END20

_VDP_SETCOLOR:  EX      AF, AF'
                CALL    VDP_SETCOLOR
                JP      END20

_VDP_PRINT:     EX      AF, AF'
                CALL    VDP_PRINT
                JP      END20

_VDP_SETPOS:    EX      AF, AF'
                CALL    VDP_SETPOS
                JP      END20

_VDP_MODE:      EX      AF, AF'
                LD      E, A            
                CALL    VDP_INIT

_VDP_WRITE_VIDEO_LOC:
                EX      AF, AF'
                CALL    VDP_WRITE_VIDEO_LOC

END20:          RET