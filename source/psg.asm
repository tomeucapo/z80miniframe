include "globals.inc"
include "psg.inc"

                extern PAUSE

;; PSG_INIT - Initialize PSG 

PSG_INIT::
                ld      HL,CHASNDDTN    ; Clear all PSG RAM Variables 
                ld      B,11             
                xor     A               
EMPTSNDBFR:     ld      (HL),A          
                inc     HL              
                djnz    EMPTSNDBFR      

CLRPSGREGS:     ld     B, 16           ; 16 registers to set
                ld     HL,SNDREGCFG    ; starting address of register settings
                ld     D,$00           ; first register
RSTPSG:         LD     A, D
                LD     C, (HL)
                CALL   AYREGWRITE   
                inc    D               
                inc    HL              
                djnz   RSTPSG          
                ret                     


PSGIOCFG::
                ld      A,$07          
                ld      BC,AYCTRL      
                out     (C),A          
                in      A,(C)          
                set     7,A            
                res     6,A            
                push    af
                ld      A,$07          
                out     (C),A          
                pop     af
                ld      BC,AYDATA      
                out     (C),A       
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
            LD BC, AYCTRL       ; Select PSG register to read
            IN  A, (C)          ; Read PSG register data
            POP BC         
            RET


                
SNDREGCFG:      defb $00,$00,$00,$00,$00,$00,$00,10111111b          
                defb $00,$00,$00,$00,$00,$00,$00,$00


