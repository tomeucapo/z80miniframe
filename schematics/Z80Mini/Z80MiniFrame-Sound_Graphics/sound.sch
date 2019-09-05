EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:GND #PWR?
U 1 1 5D79891E
P 4750 5600
AR Path="/5D79891E" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5D79891E" Ref="#PWR0105"  Part="1" 
F 0 "#PWR0105" H 4750 5350 50  0001 C CNN
F 1 "GND" H 4755 5427 50  0000 C CNN
F 2 "" H 4750 5600 50  0001 C CNN
F 3 "" H 4750 5600 50  0001 C CNN
	1    4750 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 3850 3950 3850
Wire Wire Line
	3950 3850 3950 4150
Wire Wire Line
	3950 4150 4400 4150
$Comp
L power:VCC #PWR?
U 1 1 5D798927
P 3950 3700
AR Path="/5D798927" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5D798927" Ref="#PWR0106"  Part="1" 
F 0 "#PWR0106" H 3950 3550 50  0001 C CNN
F 1 "VCC" H 3967 3873 50  0000 C CNN
F 2 "" H 3950 3700 50  0001 C CNN
F 3 "" H 3950 3700 50  0001 C CNN
	1    3950 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 3700 3950 3850
Connection ~ 3950 3850
Wire Wire Line
	4400 3950 3550 3950
$Comp
L 74xx:74LS02 U?
U 1 1 5D798930
P 2800 3750
AR Path="/5D798930" Ref="U?"  Part="1" 
AR Path="/5D76ACBB/5D798930" Ref="U8"  Part="1" 
F 0 "U8" H 2800 4075 50  0000 C CNN
F 1 "74LS02" H 2800 3984 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 2800 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls02" H 2800 3750 50  0001 C CNN
	1    2800 3750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS02 U?
U 2 1 5D798936
P 2800 4300
AR Path="/5D798936" Ref="U?"  Part="2" 
AR Path="/5D76ACBB/5D798936" Ref="U8"  Part="2" 
F 0 "U8" H 2800 4625 50  0000 C CNN
F 1 "74LS02" H 2800 4534 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 2800 4300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls02" H 2800 4300 50  0001 C CNN
	2    2800 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 3750 4400 3750
Wire Wire Line
	3550 3950 3550 4300
Wire Wire Line
	3550 4300 3100 4300
Wire Wire Line
	2500 4400 2350 4400
Wire Wire Line
	2350 4400 2350 4200
Wire Wire Line
	2350 4200 2500 4200
Wire Wire Line
	2500 3850 2350 3850
Wire Wire Line
	2350 3850 2350 4200
Connection ~ 2350 4200
Wire Wire Line
	2500 3650 2000 3650
Wire Wire Line
	2000 3850 2350 3850
Connection ~ 2350 3850
Wire Wire Line
	4750 5600 4750 5500
Wire Wire Line
	4750 5500 3950 5500
Wire Wire Line
	3950 5500 3950 4250
Wire Wire Line
	3950 4250 4400 4250
Connection ~ 4750 5500
Wire Wire Line
	4750 5500 4750 5450
Wire Wire Line
	4400 4350 4050 4350
Wire Wire Line
	4050 4350 4050 4800
Wire Wire Line
	4400 4450 4200 4450
$Comp
L power:VCC #PWR?
U 1 1 5D798955
P 4750 2050
AR Path="/5D798955" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5D798955" Ref="#PWR0107"  Part="1" 
F 0 "#PWR0107" H 4750 1900 50  0001 C CNN
F 1 "VCC" H 4767 2223 50  0000 C CNN
F 2 "" H 4750 2050 50  0001 C CNN
F 3 "" H 4750 2050 50  0001 C CNN
	1    4750 2050
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5D79895B
P 5000 2100
AR Path="/5D79895B" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5D79895B" Ref="C1"  Part="1" 
F 0 "C1" V 5252 2100 50  0000 C CNN
F 1 "100nF" V 5161 2100 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 5038 1950 50  0001 C CNN
F 3 "~" H 5000 2100 50  0001 C CNN
	1    5000 2100
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4750 2450 4750 2100
$Comp
L Audio:AY-3-8910 U?
U 1 1 5D798962
P 3700 2300
AR Path="/5D798962" Ref="U?"  Part="1" 
AR Path="/5D76ACBB/5D798962" Ref="U7"  Part="1" 
F 0 "U7" H 4950 2331 50  0000 C CNN
F 1 "AY-3-8910" H 4950 2240 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_LongPads" H 4950 1050 50  0001 C CNN
F 3 "" H 4950 1050 50  0001 C CNN
	1    3700 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 2100 4850 2100
Connection ~ 4750 2100
Wire Wire Line
	4750 2100 4750 2050
$Comp
L power:GND #PWR?
U 1 1 5D79896B
P 5350 2150
AR Path="/5D79896B" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5D79896B" Ref="#PWR0108"  Part="1" 
F 0 "#PWR0108" H 5350 1900 50  0001 C CNN
F 1 "GND" H 5355 1977 50  0000 C CNN
F 2 "" H 5350 2150 50  0001 C CNN
F 3 "" H 5350 2150 50  0001 C CNN
	1    5350 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 2100 5350 2100
Wire Wire Line
	5350 2100 5350 2150
NoConn ~ 5050 5450
NoConn ~ 5200 5450
Wire Wire Line
	4400 3550 4300 3550
Wire Wire Line
	4400 3450 4300 3450
Wire Wire Line
	4400 3350 4300 3350
Wire Wire Line
	4400 3250 4300 3250
Wire Wire Line
	4400 3150 4300 3150
Wire Wire Line
	4400 3050 4300 3050
Wire Wire Line
	4400 2950 4300 2950
Wire Wire Line
	4400 2850 4300 2850
Entry Wire Line
	4200 3450 4300 3550
Entry Wire Line
	4200 3350 4300 3450
Entry Wire Line
	4200 3250 4300 3350
Entry Wire Line
	4200 3150 4300 3250
Entry Wire Line
	4200 3050 4300 3150
Entry Wire Line
	4200 2950 4300 3050
Entry Wire Line
	4200 2850 4300 2950
Entry Wire Line
	4200 2750 4300 2850
Wire Bus Line
	4200 2300 1850 2300
Wire Wire Line
	5500 2850 5650 2850
Wire Wire Line
	5500 3050 5650 3050
Wire Wire Line
	5650 3050 5650 2950
Wire Wire Line
	5500 2950 5650 2950
Connection ~ 5650 2950
Wire Wire Line
	5650 2950 5650 2850
$Comp
L Device:R R?
U 1 1 5D79898D
P 6350 2250
AR Path="/5D79898D" Ref="R?"  Part="1" 
AR Path="/5D76ACBB/5D79898D" Ref="R2"  Part="1" 
F 0 "R2" V 6143 2250 50  0000 C CNN
F 1 "5K" V 6234 2250 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 6280 2250 50  0001 C CNN
F 3 "~" H 6350 2250 50  0001 C CNN
	1    6350 2250
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 5D798993
P 6000 2650
AR Path="/5D798993" Ref="R?"  Part="1" 
AR Path="/5D76ACBB/5D798993" Ref="R1"  Part="1" 
F 0 "R1" H 5930 2604 50  0000 R CNN
F 1 "1K" H 5930 2695 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 5930 2650 50  0001 C CNN
F 3 "~" H 6000 2650 50  0001 C CNN
	1    6000 2650
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 5D798999
P 6700 2650
AR Path="/5D798999" Ref="R?"  Part="1" 
AR Path="/5D76ACBB/5D798999" Ref="R3"  Part="1" 
F 0 "R3" H 6630 2604 50  0000 R CNN
F 1 "500" H 6630 2695 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 6630 2650 50  0001 C CNN
F 3 "~" H 6700 2650 50  0001 C CNN
	1    6700 2650
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5D7989A4
P 9600 3050
AR Path="/5D7989A4" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5D7989A4" Ref="#PWR0109"  Part="1" 
F 0 "#PWR0109" H 9600 2800 50  0001 C CNN
F 1 "GND" H 9605 2877 50  0000 C CNN
F 2 "" H 9600 3050 50  0001 C CNN
F 3 "" H 9600 3050 50  0001 C CNN
	1    9600 3050
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5D7989AA
P 7150 2650
AR Path="/5D7989AA" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5D7989AA" Ref="C2"  Part="1" 
F 0 "C2" H 7265 2696 50  0000 L CNN
F 1 "300pF" H 7265 2605 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 7188 2500 50  0001 C CNN
F 3 "~" H 7150 2650 50  0001 C CNN
	1    7150 2650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5D7989B0
P 7750 2250
AR Path="/5D7989B0" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5D7989B0" Ref="C3"  Part="1" 
F 0 "C3" V 7498 2250 50  0000 C CNN
F 1 "2uF" V 7589 2250 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 7788 2100 50  0001 C CNN
F 3 "~" H 7750 2250 50  0001 C CNN
	1    7750 2250
	0    1    1    0   
$EndComp
Wire Wire Line
	7900 2250 8000 2250
Wire Wire Line
	6700 3050 6000 3050
Connection ~ 6700 3050
$Comp
L Amplifier_Audio:LM386 U?
U 1 1 5D7989C3
P 8300 2350
AR Path="/5D7989C3" Ref="U?"  Part="1" 
AR Path="/5D76ACBB/5D7989C3" Ref="U9"  Part="1" 
F 0 "U9" H 8644 2396 50  0000 L CNN
F 1 "LM386" H 8644 2305 50  0000 L CNN
F 2 "Package_DIP:DIP-8_W7.62mm_LongPads" H 8400 2450 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lm386.pdf" H 8500 2550 50  0001 C CNN
	1    8300 2350
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR?
U 1 1 5D7989CB
P 8200 1500
AR Path="/5D7989CB" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5D7989CB" Ref="#PWR0110"  Part="1" 
F 0 "#PWR0110" H 8200 1350 50  0001 C CNN
F 1 "VCC" H 8217 1673 50  0000 C CNN
F 2 "" H 8200 1500 50  0001 C CNN
F 3 "" H 8200 1500 50  0001 C CNN
	1    8200 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	8200 3050 8000 3050
Connection ~ 8000 3050
Wire Wire Line
	8200 1500 8200 1750
Wire Wire Line
	8600 2350 8950 2350
$Comp
L Device:CP1 C?
U 1 1 5D7989D6
P 9200 2350
AR Path="/5D7989D6" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5D7989D6" Ref="C6"  Part="1" 
F 0 "C6" V 9452 2350 50  0000 C CNN
F 1 "250uF" V 9361 2350 50  0000 C CNN
F 2 "Capacitor_THT:CP_Radial_D6.3mm_P2.50mm" H 9200 2350 50  0001 C CNN
F 3 "~" H 9200 2350 50  0001 C CNN
	1    9200 2350
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9350 2350 9600 2350
Connection ~ 5650 2850
NoConn ~ 8300 2650
NoConn ~ 8400 2650
NoConn ~ 8300 2050
$Comp
L Device:CP1 C?
U 1 1 5D7989E4
P 8000 1750
AR Path="/5D7989E4" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5D7989E4" Ref="C4"  Part="1" 
F 0 "C4" V 7748 1750 50  0000 C CNN
F 1 "10uF" V 7839 1750 50  0000 C CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.00mm" H 8000 1750 50  0001 C CNN
F 3 "~" H 8000 1750 50  0001 C CNN
	1    8000 1750
	0    1    1    0   
$EndComp
Wire Wire Line
	8150 1750 8200 1750
Connection ~ 8200 1750
Wire Wire Line
	8200 1750 8200 2050
$Comp
L Device:C C?
U 1 1 5D7989F4
P 8450 1750
AR Path="/5D7989F4" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5D7989F4" Ref="C5"  Part="1" 
F 0 "C5" V 8702 1750 50  0000 C CNN
F 1 "0.1uF" V 8611 1750 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 8488 1600 50  0001 C CNN
F 3 "~" H 8450 1750 50  0001 C CNN
	1    8450 1750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8200 1750 8300 1750
$Comp
L power:GND #PWR?
U 1 1 5D7989FB
P 8700 1750
AR Path="/5D7989FB" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5D7989FB" Ref="#PWR0112"  Part="1" 
F 0 "#PWR0112" H 8700 1500 50  0001 C CNN
F 1 "GND" H 8705 1577 50  0000 C CNN
F 2 "" H 8700 1750 50  0001 C CNN
F 3 "" H 8700 1750 50  0001 C CNN
	1    8700 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8600 1750 8700 1750
$Comp
L Connector:Conn_01x02_Male SPEAKER?
U 1 1 5D798A02
P 9800 2450
AR Path="/5D798A02" Ref="SPEAKER?"  Part="1" 
AR Path="/5D76ACBB/5D798A02" Ref="SPEAKER1"  Part="1" 
F 0 "SPEAKER1" H 9772 2332 50  0000 R CNN
F 1 "Conn_01x02_Male" H 9772 2423 50  0000 R CNN
F 2 "Connector_Wire:SolderWirePad_1x02_P3.81mm_Drill1mm" H 9800 2450 50  0001 C CNN
F 3 "~" H 9800 2450 50  0001 C CNN
	1    9800 2450
	-1   0    0    1   
$EndComp
Wire Wire Line
	9600 3050 8950 3050
Text HLabel 1850 2300 0    50   BiDi ~ 0
D[0..7]
NoConn ~ 5500 4850
NoConn ~ 5500 4750
NoConn ~ 5500 4650
NoConn ~ 5500 4550
NoConn ~ 5500 4450
NoConn ~ 5500 4350
NoConn ~ 5500 4250
NoConn ~ 5500 4150
NoConn ~ 5500 3950
NoConn ~ 5500 3850
NoConn ~ 5500 3750
NoConn ~ 5500 3650
NoConn ~ 5500 3550
NoConn ~ 5500 3450
NoConn ~ 5500 3350
NoConn ~ 5500 3250
Text HLabel 2000 3650 0    50   Input ~ 0
A0
Text HLabel 2000 3850 0    50   Input ~ 0
SND_SEL
Text HLabel 4050 4800 3    50   Input ~ 0
RESET
$Comp
L Device:R R?
U 1 1 5DB0E5F5
P 8950 2900
AR Path="/5DB0E5F5" Ref="R?"  Part="1" 
AR Path="/5D76ACBB/5DB0E5F5" Ref="R4"  Part="1" 
F 0 "R4" H 8880 2854 50  0000 R CNN
F 1 "10" H 8880 2945 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8880 2900 50  0001 C CNN
F 3 "~" H 8950 2900 50  0001 C CNN
	1    8950 2900
	-1   0    0    1   
$EndComp
Connection ~ 8950 3050
Wire Wire Line
	8950 3050 8200 3050
$Comp
L Device:C C?
U 1 1 5DB1062D
P 8950 2550
AR Path="/5DB1062D" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DB1062D" Ref="C7"  Part="1" 
F 0 "C7" H 9065 2596 50  0000 L CNN
F 1 "0.05uF" H 9065 2505 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D5.0mm_W2.5mm_P5.00mm" H 8988 2400 50  0001 C CNN
F 3 "~" H 8950 2550 50  0001 C CNN
	1    8950 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8950 2750 8950 2700
Wire Wire Line
	8950 2400 8950 2350
Connection ~ 8950 2350
Wire Wire Line
	8950 2350 9050 2350
Wire Wire Line
	9600 2450 9600 3050
Connection ~ 8200 3050
Wire Wire Line
	5650 2250 6000 2250
Wire Wire Line
	6500 2250 6700 2250
Wire Wire Line
	6000 2250 6000 2500
Connection ~ 6000 2250
Wire Wire Line
	6000 2250 6200 2250
Wire Wire Line
	6000 2800 6000 3050
Wire Wire Line
	6700 2250 6700 2500
Connection ~ 6700 2250
Wire Wire Line
	7150 2250 7150 2500
Wire Wire Line
	8000 2450 8000 3050
Wire Wire Line
	7150 2800 7150 3050
Wire Wire Line
	6700 2800 6700 3050
Wire Wire Line
	5650 2250 5650 2850
Connection ~ 9600 3050
Wire Wire Line
	6700 3050 7150 3050
Wire Wire Line
	6700 2250 7150 2250
$Comp
L 74xx:74LS02 U?
U 5 1 5DCC627F
P 2050 5550
AR Path="/5DCC627F" Ref="U?"  Part="1" 
AR Path="/5D76ACBB/5DCC627F" Ref="U8"  Part="5" 
F 0 "U8" H 2280 5596 50  0000 L CNN
F 1 "74LS02" H 2280 5505 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 2050 5550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74ls02" H 2050 5550 50  0001 C CNN
	5    2050 5550
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5DCC928A
P 1450 5550
AR Path="/5DCC928A" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DCC928A" Ref="C14"  Part="1" 
F 0 "C14" H 1335 5504 50  0000 R CNN
F 1 "100nF" H 1335 5595 50  0000 R CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 1488 5400 50  0001 C CNN
F 3 "~" H 1450 5550 50  0001 C CNN
	1    1450 5550
	-1   0    0    1   
$EndComp
Wire Wire Line
	1450 5400 1450 5050
Wire Wire Line
	1450 5050 2050 5050
Wire Wire Line
	1450 5700 1450 6050
Wire Wire Line
	1450 6050 2050 6050
$Comp
L power:VCC #PWR0127
U 1 1 5DCD110A
P 2050 5000
F 0 "#PWR0127" H 2050 4850 50  0001 C CNN
F 1 "VCC" H 2067 5173 50  0000 C CNN
F 2 "" H 2050 5000 50  0001 C CNN
F 3 "" H 2050 5000 50  0001 C CNN
	1    2050 5000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0128
U 1 1 5DCD1A8E
P 2050 6100
F 0 "#PWR0128" H 2050 5850 50  0001 C CNN
F 1 "GND" H 2055 5927 50  0000 C CNN
F 2 "" H 2050 6100 50  0001 C CNN
F 3 "" H 2050 6100 50  0001 C CNN
	1    2050 6100
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 6100 2050 6050
Connection ~ 2050 6050
Wire Wire Line
	2050 5050 2050 5000
Connection ~ 2050 5050
Text Label 3950 2300 0    50   ~ 0
D[0..7]
Text Label 4300 2850 0    50   ~ 0
D0
Text Label 4300 2950 0    50   ~ 0
D1
Text Label 4300 3050 0    50   ~ 0
D2
Text Label 4300 3150 0    50   ~ 0
D3
Text Label 4300 3250 0    50   ~ 0
D4
Text Label 4300 3350 0    50   ~ 0
D5
Text Label 4300 3450 0    50   ~ 0
D6
Text Label 4300 3550 0    50   ~ 0
D7
$Comp
L Oscillator:ACO-xxxMHz X1
U 1 1 5E3763A5
P 3850 6100
F 0 "X1" H 3507 6146 50  0000 R CNN
F 1 "ACO-2MHz" H 3507 6055 50  0000 R CNN
F 2 "Oscillator:Oscillator_DIP-14" H 4300 5750 50  0001 C CNN
F 3 "http://www.conwin.com/datasheets/cx/cx030.pdf" H 3750 6100 50  0001 C CNN
	1    3850 6100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 6100 4150 6100
Wire Wire Line
	4200 4450 4200 6100
$Comp
L power:VCC #PWR0147
U 1 1 5E37FE16
P 3850 5700
F 0 "#PWR0147" H 3850 5550 50  0001 C CNN
F 1 "VCC" H 3867 5873 50  0000 C CNN
F 2 "" H 3850 5700 50  0001 C CNN
F 3 "" H 3850 5700 50  0001 C CNN
	1    3850 5700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0148
U 1 1 5E380313
P 3850 6500
F 0 "#PWR0148" H 3850 6250 50  0001 C CNN
F 1 "GND" H 3855 6327 50  0000 C CNN
F 2 "" H 3850 6500 50  0001 C CNN
F 3 "" H 3850 6500 50  0001 C CNN
	1    3850 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3850 5800 3850 5700
Wire Wire Line
	3850 6500 3850 6400
Wire Wire Line
	7150 3050 8000 3050
Connection ~ 7150 3050
Wire Wire Line
	8200 2650 8200 3050
Wire Wire Line
	7850 1750 7500 1750
Wire Wire Line
	7500 1750 7500 2650
Wire Wire Line
	7500 2650 8200 2650
Connection ~ 8200 2650
Wire Wire Line
	7600 2250 7150 2250
Connection ~ 7150 2250
Wire Bus Line
	4200 2300 4200 3450
$EndSCHEMATC
