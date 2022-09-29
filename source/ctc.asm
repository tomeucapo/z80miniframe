
include "globals.inc"
include "ctc.inc"

CTC_INIT::
        ld      A,00000011b     ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                                ; start timer on loading constant, no time constant follows, software reset, command word
        out     (CTC_CH0),A     ; set CH0
        out     (CTC_CH1),A     ; set CH1
        out     (CTC_CH2),A     ; set CH2

        ;init CH3
        ;CH3 divides CPU CLK by 144*256 providing an interrupt signal at 100 Hz (1/100 sec).
        ;f = CPU_CLK/(144*256) => 3,686,400 / ( 36,864 ) => 100Hz

        ld      A,10100111b     ; interrupt on; timer mode; prescaler=256; don't care ext; automatic trigger;
                                ; time constant follows; cont. operation; command word
        out     (CTC_CH3),A     ; send to CH3
        ld      A,$90           ; time constant - 90$ (144d)
        out     (CTC_CH3),A     ; send to CH3


        ld      A,01111000b     ; D7..D3 provide the first part of the int vector (in our case, $0100), followed by
                                ; D2..D1, provided by the CTC (they point to the channel), D0=interrupt word
                                ; so int vector is 01000xx00
        out     (CTC_CH0),A     ; send to CTC

        ; PUSH AF
        ; PUSH BC

        ; ld a,00000011b                             
        ; LD BC, CTC_CH0
        ; out (C), A         
        
        ; LD BC, CTC_CH3
        ; out (C), A         

        ; ld a,00100111b                                         
        ; LD BC, CTC_CH1
        ; OUT (C), A

        ; LD A, 0x00          
        ; LD BC, CTC_CH1
        ; OUT (C), A

        ; ld a,11000111b                                         
        ; LD BC, CTC_CH2
        ; out (C),a

        ; ld a,0x38      
        ; LD BC, CTC_CH2
        ; out (C),a     

        ; ld a,00010000b    ; 0x100              
        ; LD BC, CTC_CH0
        ; out (C),a       

        ; POP BC
        ; POP AF

        RET
       

        

