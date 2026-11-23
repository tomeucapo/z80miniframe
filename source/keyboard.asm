;;
;; keyboard.asm
;; Keyboard driver
;;
;; Code and computer schematics are released under
;; the therms of the GNU GPL License 3.0 and in the form of "as is", without no
;; kind of warranty: you can use them at your own risk.
;; You are free to use them for any non-commercial use: you are only asked to
;; maintain the copyright notices, include this advice and the note to the 
;; attribution of the original version to Tomeu Capó, if you intend to
;; redistribuite them.

include "globals.inc"
include "psg.inc"
include "keyboard.inc"

        extern CON_PRINT, CON_PUTC, CON_NL, PRHEXBYTE
        extern PSGIOCFG
        extern PAUSE

;;
;; Keyboard state initialization and public entry points.
;;
KB_INIT::
    PUSH AF
    PUSH BC
    PUSH HL

    XOR A
    LD (KBDCHAR), A
    LD (KBDCHARREADY), A
    LD (LASTKEYCODE), A
    LD (KBSHIFTSTATE), A

    LD A, $FF
    LD (KBDROWMSK), A
    LD (KBDCOLMSK), A
    LD (KBDHELDROW), A
    LD (KBDHELDCOL), A

    LD HL, KEYS_LOWCASE
    CALL KB_SETMAP

    POP HL
    POP BC
    POP AF
    RET

KB_KEYSCAN::
    PUSH AF
    PUSH BC
    PUSH DE
    PUSH HL
    CALL KB_POLL
    LD A, (KBDCHARREADY)
    OR A
    JR Z, KB_KEYSCAN_EMPTY
    LD A, (KBDCHAR)
    LD (LASTKEYCODE), A
    JR KB_KEYSCAN_EXIT
KB_KEYSCAN_EMPTY:
    XOR A
    LD (LASTKEYCODE), A
KB_KEYSCAN_EXIT:
    POP HL
    POP DE
    POP BC
    POP AF
    RET

KB_CKINCHAR::
    PUSH BC
    PUSH DE
    PUSH HL
    CALL KB_POLL
    LD A, (KBDCHARREADY)
    OR A
    POP HL
    POP DE
    POP BC
    RET

;;
;; KB_GETCHAR blocks until a new key is pressed. A key is queued once until
;; its matrix position is released; the UART can still be polled separately.
;;
KB_GETCHAR::
    PUSH BC
    PUSH DE
    PUSH HL
KB_GETCHAR_WAIT:
    CALL KB_POLL
    LD A, (KBDCHARREADY)
    OR A
    JR Z, KB_GETCHAR_WAIT

    XOR A
    LD (KBDCHARREADY), A
    LD A, (KBDCHAR)
    LD (LASTKEYCODE), A
    POP HL
    POP DE
    POP BC
    RET

KB_READKEY::
    JP KB_GETCHAR

;;
;; Poll the matrix and queue a debounced character on a new key-down.
;;
KB_POLL:
    LD A, (KBDCHARREADY)
    OR A
    RET NZ

    CALL KB_SCANKEYS
    OR A
    JR Z, KB_POLL_NO_KEY

    LD (KBDCHAR), A
    LD A, (KBDROWMSK)
    LD B, A
    LD A, (KBDHELDROW)
    CP B
    JR NZ, KB_POLL_NEW_KEY
    LD A, (KBDCOLMSK)
    LD B, A
    LD A, (KBDHELDCOL)
    CP B
    JR Z, KB_POLL_DUPLICATE

KB_POLL_NEW_KEY:
    LD A, (KBDROWMSK)
    LD (KBDHELDROW), A
    LD A, (KBDCOLMSK)
    LD (KBDHELDCOL), A

    ; Confirm the same matrix position after 5 ms to reject switch bounce.
    LD BC, 50
    CALL PAUSE
    CALL KB_SCANKEYS
    OR A
    JR Z, KB_POLL_BOUNCE
    LD B, A
    LD A, (KBDROWMSK)
    LD C, A
    LD A, (KBDHELDROW)
    CP C
    JR NZ, KB_POLL_BOUNCE
    LD A, (KBDCOLMSK)
    LD C, A
    LD A, (KBDHELDCOL)
    CP C
    JR NZ, KB_POLL_BOUNCE

    LD A, B
    LD (KBDCHAR), A
    LD A, 1
    LD (KBDCHARREADY), A
    RET

KB_POLL_DUPLICATE:
    XOR A
    LD (KBDCHAR), A
    RET

KB_POLL_BOUNCE:
KB_POLL_NO_KEY:
    LD A, $FF
    LD (KBDHELDROW), A
    LD (KBDHELDCOL), A
    XOR A
    LD (KBDCHAR), A
    RET

;;
;; Scan the C64 matrix. Shift and right-shift are modifiers, not characters.
;; Return a keymap character in A, or zero if no printable key is down.
;;
KB_SCANKEYS:
    CALL PSGIOCFG

    XOR A
    LD (KBSHIFTSTATE), A
    LD HL, KEYS_LOWCASE
    CALL KB_SETMAP

    ; First pass detects either C64 shift key, regardless of scan order.
    LD A, MASK
KB_SCAN_SHIFT:
    CALL KB_READ_ROWS
    LD A, (KBDCOLMSK)
    CP $7F                         ; C64 left shift: row 1, column 7
    JR NZ, KB_CHECK_RIGHT_SHIFT
    LD A, (KBDROWMSK)
    AND $02
    JR Z, KB_SHIFT_PRESSED
KB_CHECK_RIGHT_SHIFT:
    LD A, (KBDCOLMSK)
    CP $EF                         ; C64 right shift: row 6, column 4
    JR NZ, KB_NEXT_SHIFT
    LD A, (KBDROWMSK)
    AND $40
    JR Z, KB_SHIFT_PRESSED
KB_NEXT_SHIFT:
    LD A, (KBDCOLMSK)
    RRCA
    JP C, KB_SCAN_SHIFT
    JR KB_SCAN_KEY_START

KB_SHIFT_PRESSED:
    LD A, $FF
    LD (KBSHIFTSTATE), A
    LD HL, KEYS_UPCASE
    CALL KB_SETMAP
    JR KB_NEXT_SHIFT

KB_SCAN_KEY_START:
    LD A, MASK
KB_SCAN_KEY:
    CALL KB_READ_ROWS
    LD A, (KBDROWMSK)
    CP $FF
    JR Z, KB_NEXT_KEY

    CALL KB_REMOVE_SHIFT
    LD A, (KBDROWMSK)
    CP $FF
    JR Z, KB_NEXT_KEY
    CALL KB_KEYCODE
    OR A
    RET NZ                         ; Ignore unmapped keys and modifier keys

KB_NEXT_KEY:
    LD A, (KBDCOLMSK)
    RRCA
    JP C, KB_SCAN_KEY
    LD A, $FF
    LD (KBDROWMSK), A
    LD (KBDCOLMSK), A
    XOR A
    RET

;;
;; Drive one column on AY port A and read the row mask from port B.
;;
KB_READ_ROWS:
    LD (KBDCOLMSK), A
    LD A, AYPORTA
    LD BC, AYCTRL
    OUT (C), A
    LD A, (KBDCOLMSK)
    LD BC, AYDATA
    OUT (C), A
    LD A, AYPORTB
    LD BC, AYCTRL
    OUT (C), A
    IN A, (C)
    LD (KBDROWMSK), A
    RET

KB_REMOVE_SHIFT:
    LD A, (KBDCOLMSK)
    CP $7F
    JR NZ, KB_REMOVE_RIGHT_SHIFT
    LD A, (KBDROWMSK)
    OR $02
    LD (KBDROWMSK), A
    RET
KB_REMOVE_RIGHT_SHIFT:
    CP $EF
    RET NZ
    LD A, (KBDROWMSK)
    OR $40
    LD (KBDROWMSK), A
    RET

;; KB_KEYCODE maps the current row/column masks to a character in A.
KB_KEYCODE:
    LD A, (KBDCOLMSK)
    CALL KB_MASK_INDEX
    JR C, KB_KEYCODE_INVALID
    LD (KBDCOL), A

    LD A, (KBDROWMSK)
    CALL KB_MASK_INDEX
    JR C, KB_KEYCODE_INVALID
    LD (KBDROW), A

    LD A, (KBDROW)
    SLA A
    SLA A
    SLA A
    LD B, A
    LD A, (KBDCOL)
    ADD B
    LD E, A
    LD D, 0
    CALL GETKEYMAP
    ADD HL, DE
    LD A, (HL)
    RET
KB_KEYCODE_INVALID:
    XOR A
    RET

; Return the index of the lowest active-low bit in A. Carry means no bit.
KB_MASK_INDEX:
    LD D, A
    LD B, 0
    LD C, 1
KB_MASK_INDEX_LOOP:
    LD A, D
    AND C
    JR Z, KB_MASK_INDEX_FOUND
    SLA C
    INC B
    LD A, B
    CP 8
    JR NZ, KB_MASK_INDEX_LOOP
    SCF
    RET
KB_MASK_INDEX_FOUND:
    LD A, B
    OR A
    RET

KB_SETMAP:
    LD A, H
    LD (KBDMAP), A
    LD A, L
    LD (KBDMAP+1), A
    RET

GETKEYMAP:
    LD A, (KBDMAP)
    LD H, A
    LD A, (KBDMAP+1)
    LD L, A
    RET


PR_STATUS:
    PUSH AF

    LD HL, MSG_ROW
    CALL CON_PRINT

    LD A, (KBDROWMSK)
    CALL PRHEXBYTE

    LD A,','
    CALL CON_PUTC

    LD HL, MSG_COL
    CALL CON_PRINT

    LD A, (KBDCOLMSK) 
    CALL PRHEXBYTE
    CALL CON_NL

    POP AF
    RET

    ; Keyboard keymap data matrix

    include "keymap.inc"
