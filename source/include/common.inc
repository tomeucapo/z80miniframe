;; Common macro definitions

;; Dump byte variable value to console
DUMPVARBYTE macro var
        LD A, (var)
        CALL PRHEXBYTE
        endm

;; Dump word variable value to console
DUMPVARWORD macro var
        LD A, (var+1)
        CALL PRHEXBYTE
        LD A, (var)
        CALL PRHEXBYTE
        endm        