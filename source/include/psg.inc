
;; AY-3-8910 Addresses

ifdef Z80FRAME
AYCTRL:         .EQU    $0030     
AYDATA:         .EQU    $0031       
endif

ifdef Z80AIO
AYCTRL:         .EQU    $0060     
AYDATA:         .EQU    $0061      
endif

R10:            .EQU    8
R11:            .EQU    9
R12:            .EQU    10

R13:            .EQU    11
R14:            .EQU    12
R15:            .EQU    13

AYMIXCTRL:          .EQU    $07              ; R7 Mixer control and I/O
AYPORTA:            .EQU    $0E              ; R16 I/O Port A data store
AYPORTB:            .EQU    $0F              ; R17 I/O Port B data store


