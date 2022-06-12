
include "globals.inc"
include "ctc.inc"

CTC_INIT::
        ld a,00000011b     
                        
        LD BC, CTC_CH0
        out (C), A         
        
        LD BC, CTC_CH3
        out (C), A         

        ld a,00100111b      
                                    
        LD BC, CTC_CH1
        OUT (C), A
        LD A, 0x00          
        
        LD BC, CTC_CH1
        OUT (C), A

        ld a,11000111b      
                                    
        LD BC, CTC_CH2
        out (C),a
        ld a,0x38       

        LD BC, CTC_CH2
        out (C),a       
        ld a,00010000b  
                        
        LD BC, CTC_CH0
        out (C),a       

        RET
       

        

