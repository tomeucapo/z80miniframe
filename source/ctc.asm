
include "globals.inc"
include "ctc.inc"

CTC_INIT::
                ld      A, 00000011b    ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                                      
                
                LD      BC, CTC_CH0
                out     (C),A     ; set CH0
                
                LD      BC, CTC_CH1
                out     (C),A     ; set CH1

                LD      BC, CTC_CH2
                out     (C),A     ; set CH2

                ;init CH3
                ;CH3 divides CPU CLK by 144*256 providing an interrupt signal at 100 Hz (1/100 sec).            
                ;f = CPU_CLK/(144*256) => 3,686,400 / ( 36,864 ) => 100Hz

                ld      A, 10100111b    ; interrupt on; timer mode; prescaler=256; don't care ext; automatic trigger;
                                        ; time constant follows; cont. operation; command word

                LD      BC, CTC_CH3                                        
                out     (C),A           ; send to CH3
                ld      A,$90           ; time constant - 90$ (144d)
                out     (C),A           ; send to CH3
                ld      A,01000000b     ; D7..D3 provide the first part of the int vector (in our case, $0100), followed by
                                        ; D2..D1, provided by the CTC (they point to the channel), D0=interrupt word
                                        ; so int vector is 01000xx00

                LD      BC, CTC_CH0                                            
                out     (C),A     ; send to CTC

                ; reset cells of 100ths of a second counter
               
                xor     A               ; reset A
                
                ld      HL,TMRCNT       ; load TMR pointer
                ld      B,$04           ; 4 memory cells
RESTMR:         ld      (HL),A          ; reset n-cell of TMR
                inc     HL              ; next cell
                djnz    RESTMR          ; repeat for 4 cells
                ret

        

