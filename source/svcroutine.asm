include "svcroutine.inc "

                extern MON_MAIN
                extern VDP_INIT, VDP_SETPOS, VDP_SETCOLOR, VDP_PUTCHAR, VDP_WRITE_VIDEO_LOC

; Main RST 20 routine dispacher

SVC_ROUTINE::
                EX      AF, AF'

                LD      A, B
                CP      MONMAIN
                JR      Z, _MONITOR
                CP      VDSETCOL
                JR      Z, _VDP_SETCOLOR
                CP      VDSETPOS
                JR      Z, _VDP_SETPOS
                CP      VDMODE
                JR      Z, _VDP_MODE
                CP      VDPOKE
                JR      Z, _VDP_WRITE_VIDEO_LOC

                EX      AF, AF'
                JP      END20

_MONITOR:       EX      AF, AF'
                CALL    MON_MAIN
                JP      END20

_VDP_SETCOLOR:  EX      AF, AF'
                CALL    VDP_SETCOLOR
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