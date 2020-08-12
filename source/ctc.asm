
; label defining for CTC
CTC_CH0         .EQU $0100      ;00010000b
CTC_CH1         .EQU $0101      ;00010001b
CTC_CH2         .EQU $0102      ;00010010b
CTC_CH3         .EQU $0103      ;00010011b

INIT_CTC:
;init CH0 & CH3
;CH0 & CH3 disabled
        ld a,00000011b      ; interrupt off, timer mode, prescaler=16, don't care ext. TRG edge,
                            ; start timer on loading constant, no time constant follows, software reset, command word
        
        LD BC, CTC_CH0
        out (C), A         ; CH0 doesn't run
        
        LD BC, CTC_CH3
        out (C), A         ; CH3 doesn't run

;init CH1
;CH1 divides CPU CLK by (256*256) providing a clock signal at TO1. TO1 is connected to TRG2.
;T01 outputs f= CPU_CLK/(256*256) => 3.68MHz / ( 256 * 256 ) => 56.15Hz
        ld a,00100111b      ; interrupt off; timer mode; prescaler=256; don't care ext; automatic trigger;
                            ; time constant follows; cont. operation; command word
        
        LD BC, CTC_CH1
        OUT (C), A
        LD A, 0x00           ; time constant - 0 stands for 256
        
        LD BC, CTC_CH1
        OUT (C), A

;init CH2
;CH2 divides CLK/TRG2 clock providing a clock signal at TO2.
; T02 outputs f= CLK/TRG / 56 => 56.15Hz / 56 => 1.002Hz ~ 1s
        ld a,11000111b      ; interrupt on, counter mode, prescaler=16 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows,sw reset, command word
        
        LD BC, CTC_CH2
        out (C),a
        ld a,0x38           ; time constant 56d

        LD BC, CTC_CH2
        out (C),a         ; loaded into channel 2
        ld a,00010000b      ; D7..D3 provide the first part of the int vector (in our case, $10), followed by
                            ; D2..D1, provided by the CTC (they point to the channel), d0=interrupt word
        LD BC, CTC_CH0
        out (C),a         ; send to CTC

                ; reset cells of 100ths of a second counter
               
                xor     A               ; reset A
                
                ld      HL,TMRCNT       ; load TMR pointer
                ld      B,$04           ; 4 memory cells
RESTMR:         ld      (HL),A          ; reset n-cell of TMR
                inc     HL              ; next cell
                djnz    RESTMR          ; repeat for 4 cells
                ret

        

