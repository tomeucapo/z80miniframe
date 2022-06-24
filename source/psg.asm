;
; psg.asm
; AY-3-8910 Sound Generator driver module 
;
; Tomeu Capó 2022
;
; This is adapted version from Leonardo Millani https://github.com/leomil72/LM80C  
;
; Code and computer schematics are released under
; the therms of the GNU GPL License 3.0 and in the form of "as is", without no
; kind of warranty: you can use them at your own risk.
; You are free to use them for any non-commercial use: you are only asked to
; maintain the copyright notices, include this advice and the note to the 
; attribution of the original version to Leonardo Miliani, if you intend to
; redistribuite them.
;

include "globals.inc"
include "psg.inc"

                extern PAUSE

;; PSG_INIT - Initialize PSG 

PSG_INIT::
                PUSH    BC

                ld      HL,CHASNDDTN   
                ld      B,11           
                xor     A              
EMPTSNDBFR:     ld      (HL),A         
                inc     HL             
                djnz    EMPTSNDBFR     

CLRPSGREGS:     ld     B, 16           
                ld     HL,SNDREGCFG    
                ld     D,$00           
RSTPSG:         LD     A, D
                LD     C, (HL)
                CALL   AYREGWRITE   
                inc    D               
                inc    HL              
                djnz   RSTPSG          

                POP    BC
                ret                     

;; PSGIOCFG - Configure I/O submodule to use for keyboard

PSGIOCFG::
                ld      A, AYMIXCTRL
                CALL    AYREGREAD
                set     7,A            ; Configure PORT B as output
                res     6,A            ; Configure PORT A as input
                ld      C,A
                ld      A, AYMIXCTRL
                CALL    AYREGWRITE
                RET   

;; CHIMPSOUND - Sample sound code

CHIMPSOUND::  
             PUSH   DE
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
             LD     A, D
             CP     20
             JR     NZ, LOOP1VOL

             LD     A, 8
             LD     C, 0
             CALL   AYREGWRITE   

             POP    BC
             POP    AF
             POP    DE
             RET

;; AYREGWRITE - Modify PSG register
;;      A = Register number
;;      C = Data

AYREGWRITE::    
            PUSH BC
            LD BC, AYCTRL       ; Select PSG register to write
            OUT (C), A
            POP BC                                
            LD  A, C
            PUSH BC
            LD BC, AYDATA       ; Write data to PSG selected register
            OUT (C), A
            POP BC
            RET

;; AYREGREAD - Read PSG register data
;;      A = Register number
;;      Return data into A

AYREGREAD:: 
            PUSH BC
            LD BC, AYCTRL       ; Select PSG register to read
            OUT (C), A
            IN  A, (C)          ; Read PSG register data
            POP BC         
            RET
                
SNDREGCFG:      defb $00,$00,$00,$00,$00,$00,$00,10111111b          
                defb $00,$00,$00,$00,$00,$00,$00,$00


