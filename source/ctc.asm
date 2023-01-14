
include "globals.inc"
include "ctc.inc"

CTC_INIT::
        PUSH AF

        ld      A,00000011b     ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                                ; start timer on loading constant, no time constant follows, software reset, command word
        out     (CTC_CH0),A     ; set CH0
        out     (CTC_CH1),A     ; set CH1
        out     (CTC_CH2),A     ; set CH2
        
        ;init CH3
        ;CH3 divides CPU CLK by 144*256 providing an interrupt signal at 100 Hz (1/100 sec).
        
        ld      A,10100111b     ; interrupt on; timer mode; prescaler=256; don't care ext; automatic trigger;
                                 ; time constant follows; cont. operation; command word
        out     (CTC_CH3),A     ; send to CH3
        ld      A,144           ; time constant f = CPU_CLK/(144*256) => 3686400 / 36864  => 100Hz
        out     (CTC_CH3),A     ; send to CH3


        ld      A,01110000b     ; D7..D3 provide the first part of the int vector (in our case, $0080), followed by
                                 ; D2..D1, provided by the CTC (they point to the channel), D0=interrupt word
                                 ; so int vector is 01000xx00
        out     (CTC_CH0),A     ; send to CTC

        POP AF
        RET
       

        

