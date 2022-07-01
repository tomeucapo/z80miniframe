;;
;; svcroutine.inc
;; This a service firmware routine dispacher
;;
;; Tomeu Capó 2022
;;
;; Code and computer schematics are released under
;; the therms of the GNU GPL License 3.0 and in the form of "as is", without no
;; kind of warranty: you can use them at your own risk.
;; You are free to use them for any non-commercial use: you are only asked to
;; maintain the copyright notices, include this advice and the note to the 
;; attribution of the original version to Tomeu Capó, if you intend to
;; redistribuite them.
;;

include "svcroutine.inc"

                extern MON_MAIN
                extern VDP_INIT, VDP_LOCATE, VDP_SETCOLOR, VDP_WRITE_VIDEO_LOC, VDP_READ_VIDEO_LOC, VDP_PLOT
                extern VDP_CURSOR, KB_READKEY

;;
;; Main RST 20 firmware service routine dispacher
;;
SVC_ROUTINE::
                EX      AF, AF'

                ;; Monitor 

                LD      A, B
                CP      MONMAIN             
                JR      Z, _MONITOR

                ;; VDP Commands

                CP      VDSETCOL
                JR      Z, _VDP_SETCOLOR
                CP      VDSETPOS
                JR      Z, _VDP_SETPOS
                CP      VDMODE
                JR      Z, _VDP_MODE
                CP      VDPOKE
                JR      Z, _VDP_WRITE_VIDEO_LOC
                CP      VDPEEK
                JR      Z, _VDP_READ_VIDEO_LOC
                CP      VDCURSOR
                JR      Z, _VDP_CURSOR          
                CP      VDPLOT
                JR      Z, _VDP_PLOT  

                ;; Keyboard control

                CP      KBWAITKEY
                JR      Z, _KB_WAITFORKEY

                EX      AF, AF'
                JP      END20

_MONITOR:       EX      AF, AF'
                CALL    MON_MAIN
                JP      END20

_VDP_SETCOLOR:  EX      AF, AF'
                CALL    VDP_SETCOLOR
                JP      END20
_VDP_SETPOS:    EX      AF, AF'
                CALL    VDP_LOCATE
                JP      END20

_VDP_MODE:      EX      AF, AF'
                LD      E, A            
                CALL    VDP_INIT
                JP      END20

_VDP_WRITE_VIDEO_LOC:
                EX      AF, AF'
                CALL    VDP_WRITE_VIDEO_LOC
                JP      END20

_VDP_READ_VIDEO_LOC:
                EX      AF, AF'
                CALL    VDP_READ_VIDEO_LOC
                LD      B, A
                JP      END20

_VDP_CURSOR:
                EX      AF, AF'
                CALL    VDP_CURSOR
                JP      END20

_VDP_PLOT:
                EX      AF, AF'
                CALL    VDP_PLOT
                JP      END20

_KB_WAITFORKEY:
                EX      AF, AF' 
                CALL    KB_READKEY
                LD      B, A
                
END20:          RET