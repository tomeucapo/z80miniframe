10 OUT &H31,7
20 OUT &H32,62
21 FOR V=0 TO 8
22 OUT &H31,8
23 OUT &H32,V
30 FOR I=0 TO 7
40 OUT &H31,1
50 OUT &H32,I
51 FOR T=0 TO 10 :NEXT
60 NEXT
70 OUT &H31,8:OUT &H32,0
80 NEXT
90 OUT &H31,8:OUT &H32,0
100 END