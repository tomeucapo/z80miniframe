
DUMPVARBYTE macro var
        LD A, (var)
        CALL PRHEXBYTE
        endm

DUMPVARWORD macro var
        LD A, (var+1)
        CALL PRHEXBYTE
        LD A, (var)
        CALL PRHEXBYTE
        endm        