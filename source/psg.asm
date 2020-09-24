
; AY-3-8910
AYCTRL:         .EQU    $31 
AYDATA:         .EQU    $32

;------------------------------------------------------------------------------
; configure the PSG

PSG_INIT:       ld      HL,CHASNDDTN    ; starting address of sound & keyboard RAM registers
                ld      B,11            ; # of PSG sound & keyboard registers

                xor     A               ; reset A
EMPTSNDBFR:     ld      (HL),A          ; reset RAM register
                inc     HL              ; next register
                djnz    EMPTSNDBFR      ; repeat

CLRPSGREGS:     ld      B,$10           ; 16 registers to set
                ld      HL,SNDREGCFG    ; starting address of register settings
                ld      D,$00           ; first register
RSTPSG:         ld      A,D             ; register value
                call    SETSNDREG       ; select register
                ld      A,(HL)          ; load value
                call    WRTSNDREG       ; write to register
                inc     D               ; next register
                inc     HL              ; next value
                djnz    RSTPSG          ; repeat for each register
                ret                     ; return to caller

; routine to play a welcome beep on channel C (tone 4010) and to shut it off
WLCMBEEP:       ld      HL,WLCBPDAT     ; data address
                jp      SENDSND
NOBEEP:         ld      HL,NOBPDAT      ; data address
SENDSND:        push    BC
                ld      B,$04           ; 4 pairs
RPTWLCMBP:      ld      A,(HL)          ; read register #
                call    SETSNDREG
                inc     HL              ; next cell
                ld      A,(HL)          ; read value
                call    WRTSNDREG
                inc     HL
                djnz    RPTWLCMBP       ; repeat
                pop     BC
                ret                     ; return to caller

;**************************************************************************************
; Simple sound generation with AY-3-8910 
;**************************************************************************************

CHIMPSOUND:  PUSH   DE
             PUSH   AF
             PUSH   BC

             LD     A, 7
             LD     C, 62
             CALL   AYREGWRITE
             LD     D, 1

LOOP1VOL:    LD     A, 8
             LD     C, D
             CALL   AYREGWRITE

             LD     E, 0
LOOP2PITCH:  LD     A, 1
             LD     C, E
             CALL   AYREGWRITE
             LD     BC,200
             CALL   PAUSE
             INC    E
             LD     A, 7
             CP     E
             JR     NZ, LOOP2PITCH   

             LD     A, 8
             LD     C, 0
             CALL   AYREGWRITE   

             INC    D
             LD     A, 8
             CP     D
             JR     NZ, LOOP1VOL

             LD     A, 8
             LD     C, 0
             CALL   AYREGWRITE   

             POP    BC
             POP    AF
             POP    DE
             RET


;**************************************************************
; Sound generator register/data control
;**************************************************************

AYREGWRITE:     OUT (AYCTRL), A
                LD         A, C
                OUT (AYDATA), A
                RET

; select register on PSG
SETSNDREG:      ld      C,AYCTRL        ; PSG register port
                out     (C),A           ; set register
                ret                     ; return to caller

; send data to PSG
WRTSNDREG:      ld      C,AYDATA        ; PSG data port
                out     (C),A           ; send data
                ret                     ; return to caller


SNDREGCFG:      defb $00,$00,$00,$00,$00,$00,$00,10111111b
                defb $00,$00,$00,$00,$00,$00,$ff,$ff

WLCBPDAT:       defb    $07,01111011b,$04,$56,$05,$00,$0A,$0F
NOBPDAT:        defb    $04,$00,$05,$00,$0A,$00,$07,01111111b


