3 FOR C=0 TO &H0F
4 OUT &H2F, C:OUT &H2F, 135
5 OUT &H2F, 0:OUT &H2F, 64
20 FOR P=0 TO 63
30 OUT &H2E, 0
40 NEXT P
50 NEXT C


2 OUT &H2F,0:OUT &H2F,&H40
3 OUT &H2E,0
4 OUT &H2F,1:OUT &H2F,&H40:OUT &H2E,0
5 FOR P=0 TO 255
6 OUT &H2F,0:OUT &H2F,&H40
30 OUT &H2E, P
40 NEXT


3 FOR C=0 TO &H0F
4 OUT &H2F, C or &HF:OUT &H2F, 135
20 FOR P=0 TO 63
30 OUT &H2E, 40
40 NEXT P
50 NEXT C

5 A = &h800
10 LADDR = A AND &H00FF
20 HADDR = A AND &HFF00
21 HADDR = HADDR/2/2/2/2/2/2/2/2
22 OUT &H2F, LADDR:OUT &H2F, HADDR
30 FOR P = 960 to 0 step -1
40 OUT &H2E,32
50 next

4 ADDR=&H800
5 COLS=40
10 FOR Y=0 to 23
10 FOR X=0 to 39
21 PADDR = ADDR+X+Y*COLS
30 LADDR = PADDR AND &H00FF
31 HADDR = PADDR AND &HFF00
32 HADDR = HADDR/2/2/2/2/2/2/2/2
41 OUT &H2F, LADDR:OUT &H2F, HADDR
42 OUT &H2E, 48
43 NEXT X
44 NEXT Y

4 ADDR=&H800
5 OUT &H2F,0:OUT &H2F,&H08
10 FOR Y=0 TO 23
11 FOR X=0 TO 39
42 OUT &H2E,32
43 NEXT X
44 NEXT Y

