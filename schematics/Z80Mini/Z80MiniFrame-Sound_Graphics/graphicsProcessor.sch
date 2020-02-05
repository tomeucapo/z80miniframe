EESchema Schematic File Version 4
LIBS:Z80MiniFrame-Sound_Graphics-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 3
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Bus Line
	7350 1050 7800 1050
Entry Wire Line
	7800 1450 7900 1550
Entry Wire Line
	7800 1350 7900 1450
Entry Wire Line
	7800 1550 7900 1650
Entry Wire Line
	7800 1650 7900 1750
Entry Wire Line
	7800 1750 7900 1850
Entry Wire Line
	7800 1850 7900 1950
Entry Wire Line
	7800 1950 7900 2050
Entry Wire Line
	7800 2050 7900 2150
Entry Wire Line
	7800 2150 7900 2250
Wire Wire Line
	7900 1450 8000 1450
Wire Wire Line
	8000 1550 7900 1550
Wire Wire Line
	7900 1650 8000 1650
Wire Wire Line
	8000 1750 7900 1750
Wire Wire Line
	7900 1950 8000 1950
Wire Wire Line
	7900 1850 8000 1850
Wire Wire Line
	7900 2050 8000 2050
Wire Wire Line
	7900 2150 8000 2150
Wire Wire Line
	8000 2250 7900 2250
Wire Bus Line
	7600 1050 7800 1050
Connection ~ 7800 1050
Entry Wire Line
	9250 1950 9150 2050
Entry Wire Line
	9250 1750 9150 1850
Entry Wire Line
	9250 1650 9150 1750
Entry Wire Line
	9250 1550 9150 1650
Entry Wire Line
	9250 1450 9150 1550
Wire Wire Line
	9000 1350 9100 1350
Wire Wire Line
	9100 1350 9100 850 
$Comp
L power:VCC #PWR0103
U 1 1 5D7AF4D2
P 7850 750
F 0 "#PWR0103" H 7850 600 50  0001 C CNN
F 1 "VCC" H 7867 923 50  0000 C CNN
F 2 "" H 7850 750 50  0001 C CNN
F 3 "" H 7850 750 50  0001 C CNN
	1    7850 750 
	1    0    0    -1  
$EndComp
Wire Wire Line
	6600 950  6600 850 
Wire Wire Line
	6600 850  7850 850 
Connection ~ 9100 850 
Wire Wire Line
	7850 850  7850 750 
Wire Wire Line
	7100 1350 7250 1350
Wire Wire Line
	7100 1450 7250 1450
Entry Wire Line
	7250 1450 7350 1350
Entry Wire Line
	7250 1550 7350 1450
Entry Wire Line
	7250 1650 7350 1550
Entry Wire Line
	7250 1750 7350 1650
Entry Wire Line
	7250 1850 7350 1750
Entry Wire Line
	7250 1950 7350 1850
Wire Wire Line
	7100 1550 7250 1550
Wire Wire Line
	7250 1650 7100 1650
Wire Wire Line
	7100 1750 7250 1750
Wire Wire Line
	7250 1850 7100 1850
Wire Wire Line
	7100 1950 7250 1950
Entry Wire Line
	7250 1350 7350 1250
NoConn ~ 7100 1250
$Comp
L 74xx:74HC04 U6
U 1 1 5D7D0CC9
P 5100 2150
F 0 "U6" H 5100 2467 50  0000 C CNN
F 1 "74HC04" H 5100 2376 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5100 2150 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 5100 2150 50  0001 C CNN
	1    5100 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 2150 6100 2150
Wire Wire Line
	3950 2250 4350 2250
Wire Wire Line
	3950 2150 4800 2150
Wire Wire Line
	9700 1950 9700 6500
Wire Wire Line
	9800 6600 9800 1450
Wire Wire Line
	9900 2150 9900 6700
Text Label 7350 1050 0    50   ~ 0
VA[0..13]
Text Label 7100 1350 0    50   ~ 0
VA0
Text Label 7100 1450 0    50   ~ 0
VA1
Text Label 7100 1550 0    50   ~ 0
VA2
Text Label 7100 1650 0    50   ~ 0
VA3
Text Label 7100 1850 0    50   ~ 0
VA5
Text Label 7100 1750 0    50   ~ 0
VA4
Text Label 7100 1950 0    50   ~ 0
VA6
Text Label 7900 2250 0    50   ~ 0
VA0
Text Label 7900 2150 0    50   ~ 0
VA1
Text Label 7900 2050 0    50   ~ 0
VA2
Text Label 7900 1950 0    50   ~ 0
VA3
Text Label 9050 2050 0    50   ~ 0
VA4
Text Label 7900 1850 0    50   ~ 0
VA5
Text Label 7900 1750 0    50   ~ 0
VA6
Text Label 9050 1850 0    50   ~ 0
VA7
Text Label 9050 1650 0    50   ~ 0
VA12
Text Label 7900 1650 0    50   ~ 0
VA8
Text Label 7900 1550 0    50   ~ 0
VA9
Text Label 7900 1450 0    50   ~ 0
VA11
Text Label 9050 1750 0    50   ~ 0
VA10
Entry Wire Line
	9250 2350 9150 2250
Entry Wire Line
	9250 2450 9150 2350
Entry Wire Line
	9250 2550 9150 2450
Entry Wire Line
	9250 2650 9150 2550
Entry Wire Line
	9250 2750 9150 2650
Wire Wire Line
	9000 2150 9900 2150
Wire Wire Line
	5700 6500 9700 6500
Wire Wire Line
	4350 6700 9900 6700
Wire Wire Line
	9000 2250 9150 2250
Wire Wire Line
	9000 2350 9150 2350
Wire Wire Line
	9000 2450 9150 2450
Wire Wire Line
	9000 2550 9150 2550
Wire Wire Line
	9000 2650 9150 2650
Wire Wire Line
	9000 1750 9150 1750
Wire Wire Line
	9000 2050 9150 2050
Wire Bus Line
	7800 1050 9250 1050
Text Label 9050 1550 0    50   ~ 0
VA13
Wire Wire Line
	9000 1550 9150 1550
Wire Wire Line
	9000 1650 9150 1650
Wire Wire Line
	9000 1850 9150 1850
Text Label 9000 2650 0    50   ~ 0
VD3
Text Label 9000 2550 0    50   ~ 0
VD4
Text Label 9000 2450 0    50   ~ 0
VD5
Text Label 9000 2350 0    50   ~ 0
VD6
Text Label 9000 2250 0    50   ~ 0
VD7
Wire Bus Line
	4150 1050 5850 1050
Entry Wire Line
	5850 1150 5950 1250
Entry Wire Line
	5850 1250 5950 1350
Entry Wire Line
	5850 1350 5950 1450
Entry Wire Line
	5850 1450 5950 1550
Entry Wire Line
	5850 1550 5950 1650
Entry Wire Line
	5850 1650 5950 1750
Entry Wire Line
	5850 1750 5950 1850
Entry Wire Line
	5850 1850 5950 1950
Wire Wire Line
	5950 1250 6100 1250
Wire Wire Line
	6100 1350 5950 1350
Wire Wire Line
	5950 1450 6100 1450
Wire Wire Line
	5950 1550 6100 1550
Wire Wire Line
	5950 1650 6100 1650
Wire Wire Line
	5950 1750 6100 1750
Wire Wire Line
	5950 1850 6100 1850
Wire Wire Line
	5950 1950 6100 1950
Text Label 4250 1050 0    50   ~ 0
AD[0..7]
Text Label 5700 6850 0    50   ~ 0
VD[0..7]
Wire Bus Line
	7700 6850 4150 6850
Wire Wire Line
	3250 1950 3250 1700
$Comp
L power:VCC #PWR0119
U 1 1 5DA31E47
P 3250 1650
F 0 "#PWR0119" H 3250 1500 50  0001 C CNN
F 1 "VCC" H 3267 1823 50  0000 C CNN
F 2 "" H 3250 1650 50  0001 C CNN
F 3 "" H 3250 1650 50  0001 C CNN
	1    3250 1650
	1    0    0    -1  
$EndComp
Wire Bus Line
	2800 1050 1300 1050
Text HLabel 1300 1050 0    50   BiDi ~ 0
D[0..7]
$Comp
L Device:C C?
U 1 1 5DB449A4
P 3600 1700
AR Path="/5DB449A4" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DB449A4" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DB449A4" Ref="C8"  Part="1" 
F 0 "C8" V 3852 1700 50  0000 C CNN
F 1 "100nF" V 3761 1700 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 3638 1550 50  0001 C CNN
F 3 "~" H 3600 1700 50  0001 C CNN
	1    3600 1700
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5DB449AA
P 3950 1750
AR Path="/5DB449AA" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5DB449AA" Ref="#PWR?"  Part="1" 
AR Path="/5D79B46A/5DB449AA" Ref="#PWR0120"  Part="1" 
F 0 "#PWR0120" H 3950 1500 50  0001 C CNN
F 1 "GND" H 3955 1577 50  0000 C CNN
F 2 "" H 3950 1750 50  0001 C CNN
F 3 "" H 3950 1750 50  0001 C CNN
	1    3950 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 1700 3950 1700
Wire Wire Line
	3950 1700 3950 1750
Wire Wire Line
	3450 1700 3250 1700
Connection ~ 3250 1700
Wire Wire Line
	3250 1700 3250 1650
$Comp
L Device:C C?
U 1 1 5DB5AB3C
P 6250 850
AR Path="/5DB5AB3C" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DB5AB3C" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DB5AB3C" Ref="C9"  Part="1" 
F 0 "C9" V 6502 850 50  0000 C CNN
F 1 "100nF" V 6411 850 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 6288 700 50  0001 C CNN
F 3 "~" H 6250 850 50  0001 C CNN
	1    6250 850 
	0    1    -1   0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5DB5AB46
P 6000 900
AR Path="/5DB5AB46" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5DB5AB46" Ref="#PWR?"  Part="1" 
AR Path="/5D79B46A/5DB5AB46" Ref="#PWR0121"  Part="1" 
F 0 "#PWR0121" H 6000 650 50  0001 C CNN
F 1 "GND" H 6005 727 50  0000 C CNN
F 2 "" H 6000 900 50  0001 C CNN
F 3 "" H 6000 900 50  0001 C CNN
	1    6000 900 
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6400 850  6600 850 
Connection ~ 6600 850 
Wire Wire Line
	6000 900  6000 850 
Wire Wire Line
	6000 850  6100 850 
$Comp
L Device:C C?
U 1 1 5DC4E64F
P 9450 850
AR Path="/5DC4E64F" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DC4E64F" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DC4E64F" Ref="C12"  Part="1" 
F 0 "C12" V 9702 850 50  0000 C CNN
F 1 "100nF" V 9611 850 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 9488 700 50  0001 C CNN
F 3 "~" H 9450 850 50  0001 C CNN
	1    9450 850 
	0    1    -1   0   
$EndComp
Wire Wire Line
	9100 850  9300 850 
Wire Wire Line
	9600 850  9850 850 
Wire Wire Line
	9850 850  9850 900 
$Comp
L power:GND #PWR0124
U 1 1 5DC64F63
P 9850 900
F 0 "#PWR0124" H 9850 650 50  0001 C CNN
F 1 "GND" H 9855 727 50  0000 C CNN
F 2 "" H 9850 900 50  0001 C CNN
F 3 "" H 9850 900 50  0001 C CNN
	1    9850 900 
	1    0    0    -1  
$EndComp
Wire Wire Line
	10300 3800 10700 3800
$Comp
L power:GND #PWR0125
U 1 1 5DC9F1EA
P 10700 3850
F 0 "#PWR0125" H 10700 3600 50  0001 C CNN
F 1 "GND" H 10705 3677 50  0000 C CNN
F 2 "" H 10700 3850 50  0001 C CNN
F 3 "" H 10700 3850 50  0001 C CNN
	1    10700 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	10700 3800 10700 3850
Text Label 6000 1250 0    50   ~ 0
AD0
Text Label 6000 1350 0    50   ~ 0
AD1
Text Label 6000 1450 0    50   ~ 0
AD2
Text Label 6000 1550 0    50   ~ 0
AD3
Text Label 6000 1650 0    50   ~ 0
AD4
Text Label 6000 1750 0    50   ~ 0
AD5
Text Label 6000 1850 0    50   ~ 0
AD6
Text Label 6000 1950 0    50   ~ 0
AD7
Text Label 2550 1050 0    50   ~ 0
D[0..7]
$Comp
L Device:C C?
U 1 1 5E3463D5
P 10300 4800
AR Path="/5E3463D5" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5E3463D5" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5E3463D5" Ref="C22"  Part="1" 
F 0 "C22" H 10186 4754 50  0000 R CNN
F 1 "100nF" H 10186 4845 50  0000 R CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 10338 4650 50  0001 C CNN
F 3 "~" H 10300 4800 50  0001 C CNN
	1    10300 4800
	1    0    0    1   
$EndComp
Wire Wire Line
	10300 4650 10300 4350
Wire Wire Line
	10300 4350 10700 4350
$Comp
L power:VCC #PWR0146
U 1 1 5E373CDE
P 10700 4350
F 0 "#PWR0146" H 10700 4200 50  0001 C CNN
F 1 "VCC" H 10717 4523 50  0000 C CNN
F 2 "" H 10700 4350 50  0001 C CNN
F 3 "" H 10700 4350 50  0001 C CNN
	1    10700 4350
	1    0    0    -1  
$EndComp
Connection ~ 7850 850 
Wire Wire Line
	7850 850  9100 850 
$Comp
L Transistor_BJT:2N3904 Q1
U 1 1 5DF3F803
P 2600 6600
F 0 "Q1" H 2790 6646 50  0000 L CNN
F 1 "2N3904" H 2790 6555 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 2800 6525 50  0001 L CIN
F 3 "https://www.fairchildsemi.com/datasheets/2N/2N3904.pdf" H 2600 6600 50  0001 L CNN
	1    2600 6600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 6600 2400 6600
$Comp
L Device:R R10
U 1 1 5DF713C1
P 2700 7050
F 0 "R10" H 2770 7096 50  0000 L CNN
F 1 "75R" H 2770 7005 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 2630 7050 50  0001 C CNN
F 3 "~" H 2700 7050 50  0001 C CNN
	1    2700 7050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R11
U 1 1 5DF72D0C
P 2200 7050
F 0 "R11" H 2270 7096 50  0000 L CNN
F 1 "470R" H 2270 7005 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 2130 7050 50  0001 C CNN
F 3 "~" H 2200 7050 50  0001 C CNN
	1    2200 7050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R12
U 1 1 5DF73493
P 3100 6800
F 0 "R12" V 2893 6800 50  0000 C CNN
F 1 "75R" V 2984 6800 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 3030 6800 50  0001 C CNN
F 3 "~" H 3100 6800 50  0001 C CNN
	1    3100 6800
	0    1    1    0   
$EndComp
Wire Wire Line
	2200 6900 2200 6600
Wire Wire Line
	2700 6900 2700 6800
Wire Wire Line
	2700 6800 2950 6800
Connection ~ 2700 6800
$Comp
L power:GND #PWR0111
U 1 1 5DFAFE6A
P 2200 7250
F 0 "#PWR0111" H 2200 7000 50  0001 C CNN
F 1 "GND" H 2205 7077 50  0000 C CNN
F 2 "" H 2200 7250 50  0001 C CNN
F 3 "" H 2200 7250 50  0001 C CNN
	1    2200 7250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0133
U 1 1 5DFB02AB
P 2700 7250
F 0 "#PWR0133" H 2700 7000 50  0001 C CNN
F 1 "GND" H 2705 7077 50  0000 C CNN
F 2 "" H 2700 7250 50  0001 C CNN
F 3 "" H 2700 7250 50  0001 C CNN
	1    2700 7250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 7250 2200 7200
Wire Wire Line
	2700 7250 2700 7200
$Comp
L Device:CP C18
U 1 1 5E018E66
P 3500 6800
F 0 "C18" V 3755 6800 50  0000 C CNN
F 1 "220uF" V 3664 6800 50  0000 C CNN
F 2 "Capacitor_THT:CP_Radial_Tantal_D6.0mm_P2.50mm" H 3538 6650 50  0001 C CNN
F 3 "~" H 3500 6800 50  0001 C CNN
	1    3500 6800
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3250 6800 3350 6800
$Comp
L Connector:Conn_Coaxial J2
U 1 1 5E02F43B
P 3900 6800
F 0 "J2" H 4000 6775 50  0000 L CNN
F 1 "COMP_VIDEOUT" H 4000 6684 50  0000 L CNN
F 2 "Connector:RCA_Female_902" H 3900 6800 50  0001 C CNN
F 3 " ~" H 3900 6800 50  0001 C CNN
	1    3900 6800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0136
U 1 1 5E02FD11
P 3900 7250
F 0 "#PWR0136" H 3900 7000 50  0001 C CNN
F 1 "GND" H 3905 7077 50  0000 C CNN
F 2 "" H 3900 7250 50  0001 C CNN
F 3 "" H 3900 7250 50  0001 C CNN
	1    3900 7250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 6800 3700 6800
Wire Wire Line
	3900 7250 3900 7000
Connection ~ 2200 6600
Connection ~ 10700 4350
Connection ~ 10700 3800
Connection ~ 6100 6600
Wire Wire Line
	6100 6600 9800 6600
Wire Wire Line
	4250 6600 6100 6600
Entry Wire Line
	4050 3950 4150 4050
Wire Wire Line
	3200 5300 3250 5300
$Comp
L power:GND #PWR0137
U 1 1 5E07CB70
P 3200 5300
F 0 "#PWR0137" H 3200 5050 50  0001 C CNN
F 1 "GND" H 3205 5127 50  0000 C CNN
F 2 "" H 3200 5300 50  0001 C CNN
F 3 "" H 3200 5300 50  0001 C CNN
	1    3200 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 5100 3950 4300
Wire Wire Line
	3450 5100 3950 5100
$Comp
L Connector:Conn_Coaxial J5
U 1 1 5E065098
P 3450 5300
F 0 "J5" V 3332 5400 50  0000 L CNN
F 1 "COMP_VIDEOIN" V 3423 5400 50  0000 L CNN
F 2 "Connector:RCA_Female_902" H 3450 5300 50  0001 C CNN
F 3 " ~" H 3450 5300 50  0001 C CNN
	1    3450 5300
	0    1    1    0   
$EndComp
Wire Wire Line
	3100 6250 3200 6250
$Comp
L power:GND #PWR0135
U 1 1 5DFDA439
P 3200 6250
F 0 "#PWR0135" H 3200 6000 50  0001 C CNN
F 1 "GND" H 3205 6077 50  0000 C CNN
F 2 "" H 3200 6250 50  0001 C CNN
F 3 "" H 3200 6250 50  0001 C CNN
	1    3200 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 6250 2700 6150
Connection ~ 2700 6250
Wire Wire Line
	2700 6250 2800 6250
Wire Wire Line
	2700 6400 2700 6250
$Comp
L Device:C C?
U 1 1 5DFB0F5E
P 2950 6250
AR Path="/5DFB0F5E" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DFB0F5E" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DFB0F5E" Ref="C19"  Part="1" 
F 0 "C19" V 3202 6250 50  0000 C CNN
F 1 "100nF" V 3111 6250 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 2988 6100 50  0001 C CNN
F 3 "~" H 2950 6250 50  0001 C CNN
	1    2950 6250
	0    1    -1   0   
$EndComp
$Comp
L power:VCC #PWR0134
U 1 1 5DFB05A3
P 2700 6150
F 0 "#PWR0134" H 2700 6000 50  0001 C CNN
F 1 "VCC" H 2717 6323 50  0000 C CNN
F 2 "" H 2700 6150 50  0001 C CNN
F 3 "" H 2700 6150 50  0001 C CNN
	1    2700 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 5650 2200 6600
Wire Wire Line
	4050 5650 2200 5650
Wire Wire Line
	4050 4200 4050 5650
Wire Wire Line
	3950 4200 4050 4200
$Comp
L Video:TMS9918A U1
U 1 1 5DECA710
P 3400 1950
F 0 "U1" H 3475 2131 50  0000 C CNN
F 1 "TMS9918A" H 3475 2040 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_LongPads" H 3500 1950 50  0001 C CNN
F 3 "" H 3500 1950 50  0001 C CNN
	1    3400 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 2350 4250 5850
Connection ~ 10700 5350
$Comp
L power:GND #PWR0145
U 1 1 5E3729CC
P 10700 5350
F 0 "#PWR0145" H 10700 5100 50  0001 C CNN
F 1 "GND" H 10705 5177 50  0000 C CNN
F 2 "" H 10700 5350 50  0001 C CNN
F 3 "" H 10700 5350 50  0001 C CNN
	1    10700 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	10300 5350 10700 5350
Wire Wire Line
	10300 4950 10300 5350
$Comp
L 74xx:74LS32 U12
U 5 1 5E343B66
P 10700 4850
F 0 "U12" H 10930 4896 50  0000 L CNN
F 1 "74LS32" H 10930 4805 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 10700 4850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 10700 4850 50  0001 C CNN
	5    10700 4850
	1    0    0    -1  
$EndComp
Text HLabel 650  3650 0    50   Output ~ 0
INT
Wire Wire Line
	2300 3800 2300 3650
$Comp
L power:GND #PWR0132
U 1 1 5DF45E8C
P 1050 2900
F 0 "#PWR0132" H 1050 2650 50  0001 C CNN
F 1 "GND" H 1055 2727 50  0000 C CNN
F 2 "" H 1050 2900 50  0001 C CNN
F 3 "" H 1050 2900 50  0001 C CNN
	1    1050 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	1050 2850 1050 2900
Connection ~ 1050 2850
Wire Wire Line
	1200 2850 1050 2850
Wire Wire Line
	1050 2550 1050 2850
Wire Wire Line
	1200 2550 1050 2550
$Comp
L Device:C C?
U 1 1 5DF22922
P 1350 2550
AR Path="/5DF22922" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DF22922" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DF22922" Ref="C17"  Part="1" 
F 0 "C17" V 1098 2550 50  0000 C CNN
F 1 "33pF" V 1189 2550 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 1388 2400 50  0001 C CNN
F 3 "~" H 1350 2550 50  0001 C CNN
	1    1350 2550
	0    -1   1    0   
$EndComp
$Comp
L Device:C C?
U 1 1 5DF21B0E
P 1750 3000
AR Path="/5DF21B0E" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DF21B0E" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DF21B0E" Ref="C16"  Part="1" 
F 0 "C16" V 1498 3000 50  0000 C CNN
F 1 "33pf" V 1589 3000 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 1788 2850 50  0001 C CNN
F 3 "~" H 1750 3000 50  0001 C CNN
	1    1750 3000
	1    0    0    1   
$EndComp
Wire Wire Line
	1750 2550 1500 2550
Connection ~ 1750 2550
Wire Wire Line
	2450 2550 1750 2550
Wire Wire Line
	1750 2850 1500 2850
$Comp
L Device:Crystal Y1
U 1 1 5DEA812D
P 1750 2700
F 0 "Y1" V 1704 2831 50  0000 L CNN
F 1 "10.73MHz" V 1795 2831 50  0000 L CNN
F 2 "Crystal:Crystal_HC18-U_Vertical" H 1750 2700 50  0001 C CNN
F 3 "~" H 1750 2700 50  0001 C CNN
	1    1750 2700
	0    1    1    0   
$EndComp
Wire Wire Line
	1250 3850 1350 3850
Text HLabel 1100 5250 0    50   Input ~ 0
A0
Wire Wire Line
	2550 5250 1100 5250
Wire Wire Line
	2550 4100 2550 5250
Wire Wire Line
	3000 4100 2550 4100
Wire Wire Line
	2400 4000 3000 4000
Wire Wire Line
	2400 4950 2400 4000
Wire Wire Line
	1950 4950 2400 4950
Wire Wire Line
	2300 3900 3000 3900
Wire Wire Line
	2300 4450 2300 3900
Wire Wire Line
	1950 4450 2300 4450
Wire Wire Line
	1350 5050 1100 5050
Wire Wire Line
	1100 4550 1350 4550
Text HLabel 1100 5050 0    50   Input ~ 0
WR
Text HLabel 1100 4550 0    50   Input ~ 0
RD
Connection ~ 1250 4350
Wire Wire Line
	1250 4850 1350 4850
Wire Wire Line
	1250 4350 1250 4850
$Comp
L 74xx:74LS32 U12
U 3 1 5DDBD47B
P 1650 4950
F 0 "U12" H 1650 5275 50  0000 C CNN
F 1 "74LS32" H 1650 5184 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 1650 4950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1650 4950 50  0001 C CNN
	3    1650 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 4350 1350 4350
Wire Wire Line
	1250 4200 1250 4350
Wire Wire Line
	2100 4200 1250 4200
Wire Wire Line
	2100 3950 2100 4200
Wire Wire Line
	1950 3950 2100 3950
Wire Wire Line
	1250 4050 1350 4050
Text HLabel 1250 4050 0    50   Input ~ 0
IORQ
Text HLabel 1250 3850 0    50   Input ~ 0
VD_SEL
$Comp
L 74xx:74LS32 U12
U 2 1 5DD742FC
P 1650 4450
F 0 "U12" H 1650 4775 50  0000 C CNN
F 1 "74LS32" H 1650 4684 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 1650 4450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1650 4450 50  0001 C CNN
	2    1650 4450
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U12
U 1 1 5DD72F03
P 1650 3950
F 0 "U12" H 1650 4275 50  0000 C CNN
F 1 "74LS32" H 1650 4184 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 1650 3950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1650 3950 50  0001 C CNN
	1    1650 3950
	1    0    0    -1  
$EndComp
Text HLabel 1300 3500 0    50   Input ~ 0
RESET
Wire Wire Line
	3000 3500 1300 3500
Text Label 2900 3050 0    50   ~ 0
D0
Text Label 2900 2950 0    50   ~ 0
D1
Text Label 2900 2850 0    50   ~ 0
D2
Text Label 2900 2750 0    50   ~ 0
D3
Text Label 2900 2650 0    50   ~ 0
D4
Text Label 2900 2550 0    50   ~ 0
D5
Text Label 2900 2450 0    50   ~ 0
D6
Text Label 2900 2350 0    50   ~ 0
D7
Text Label 6000 5650 0    50   ~ 0
AD7
Text Label 6000 5550 0    50   ~ 0
AD6
Text Label 6000 5450 0    50   ~ 0
AD5
Text Label 6000 5350 0    50   ~ 0
AD4
Text Label 6000 5250 0    50   ~ 0
AD3
Text Label 6000 5150 0    50   ~ 0
AD2
Text Label 6000 5050 0    50   ~ 0
AD1
Text Label 6000 4950 0    50   ~ 0
AD0
Wire Wire Line
	5950 5650 6100 5650
Wire Wire Line
	5950 5550 6100 5550
Wire Wire Line
	6100 5450 5950 5450
Wire Wire Line
	5950 5350 6100 5350
Wire Wire Line
	6100 5250 5950 5250
Wire Wire Line
	5950 5150 6100 5150
Wire Wire Line
	6100 5050 5950 5050
Wire Wire Line
	5950 4950 6100 4950
Entry Wire Line
	5850 4850 5950 4950
Entry Wire Line
	5850 4950 5950 5050
Entry Wire Line
	5850 5050 5950 5150
Entry Wire Line
	5850 5150 5950 5250
Entry Wire Line
	5850 5250 5950 5350
Entry Wire Line
	5850 5350 5950 5450
Entry Wire Line
	5850 5450 5950 5550
Entry Wire Line
	5850 5550 5950 5650
Text Label 6000 3800 0    50   ~ 0
AD7
Text Label 6000 3700 0    50   ~ 0
AD6
Text Label 6000 3600 0    50   ~ 0
AD5
Text Label 6000 3500 0    50   ~ 0
AD4
Text Label 6000 3400 0    50   ~ 0
AD3
Text Label 6000 3300 0    50   ~ 0
AD2
Text Label 6000 3200 0    50   ~ 0
AD1
Text Label 6000 3100 0    50   ~ 0
AD0
Text Label 4000 3950 0    50   ~ 0
VD7
Text Label 4000 3850 0    50   ~ 0
VD6
Text Label 4000 3750 0    50   ~ 0
VD5
Text Label 4000 3650 0    50   ~ 0
VD4
Text Label 4000 3550 0    50   ~ 0
VD3
Connection ~ 10700 2800
Wire Wire Line
	10700 2800 10700 2750
$Comp
L power:VCC #PWR0126
U 1 1 5DC9F666
P 10700 2750
F 0 "#PWR0126" H 10700 2600 50  0001 C CNN
F 1 "VCC" H 10717 2923 50  0000 C CNN
F 2 "" H 10700 2750 50  0001 C CNN
F 3 "" H 10700 2750 50  0001 C CNN
	1    10700 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	10300 3450 10300 3800
Wire Wire Line
	10300 2800 10700 2800
Wire Wire Line
	10300 3150 10300 2800
$Comp
L Device:C C?
U 1 1 5DC66E7F
P 10300 3300
AR Path="/5DC66E7F" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DC66E7F" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DC66E7F" Ref="C13"  Part="1" 
F 0 "C13" H 10186 3254 50  0000 R CNN
F 1 "100nF" H 10186 3345 50  0000 R CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 10338 3150 50  0001 C CNN
F 3 "~" H 10300 3300 50  0001 C CNN
	1    10300 3300
	1    0    0    1   
$EndComp
$Comp
L 74xx:74HC04 U6
U 7 1 5DC65E3C
P 10700 3300
F 0 "U6" H 10930 3346 50  0000 L CNN
F 1 "74HC04" H 10930 3255 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 10700 3300 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 10700 3300 50  0001 C CNN
	7    10700 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	7200 4600 7200 4650
Wire Wire Line
	7050 4600 7200 4600
$Comp
L power:GND #PWR0123
U 1 1 5DC114FC
P 7200 4650
F 0 "#PWR0123" H 7200 4400 50  0001 C CNN
F 1 "GND" H 7205 4477 50  0000 C CNN
F 2 "" H 7200 4650 50  0001 C CNN
F 3 "" H 7200 4650 50  0001 C CNN
	1    7200 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6600 4600 6600 4550
Connection ~ 6600 4600
Wire Wire Line
	6600 4600 6750 4600
$Comp
L Device:C C?
U 1 1 5DC06021
P 6900 4600
AR Path="/5DC06021" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DC06021" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DC06021" Ref="C11"  Part="1" 
F 0 "C11" V 7152 4600 50  0000 C CNN
F 1 "100nF" V 7061 4600 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 6938 4450 50  0001 C CNN
F 3 "~" H 6900 4600 50  0001 C CNN
	1    6900 4600
	0    1    -1   0   
$EndComp
Wire Wire Line
	7250 2800 7250 2850
Wire Wire Line
	7100 2800 7250 2800
Wire Wire Line
	6600 2800 6800 2800
Connection ~ 6600 2800
$Comp
L power:GND #PWR?
U 1 1 5DBADC0C
P 7250 2850
AR Path="/5DBADC0C" Ref="#PWR?"  Part="1" 
AR Path="/5D76ACBB/5DBADC0C" Ref="#PWR?"  Part="1" 
AR Path="/5D79B46A/5DBADC0C" Ref="#PWR0122"  Part="1" 
F 0 "#PWR0122" H 7250 2600 50  0001 C CNN
F 1 "GND" H 7255 2677 50  0000 C CNN
F 2 "" H 7250 2850 50  0001 C CNN
F 3 "" H 7250 2850 50  0001 C CNN
	1    7250 2850
	-1   0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 5DBADC02
P 6950 2800
AR Path="/5DBADC02" Ref="C?"  Part="1" 
AR Path="/5D76ACBB/5DBADC02" Ref="C?"  Part="1" 
AR Path="/5D79B46A/5DBADC02" Ref="C10"  Part="1" 
F 0 "C10" V 7202 2800 50  0000 C CNN
F 1 "100nF" V 7111 2800 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 6988 2650 50  0001 C CNN
F 3 "~" H 6950 2800 50  0001 C CNN
	1    6950 2800
	0    1    -1   0   
$EndComp
Wire Wire Line
	6100 3100 5950 3100
Wire Wire Line
	5950 3200 6100 3200
Wire Wire Line
	6100 3300 5950 3300
Wire Wire Line
	5950 3400 6100 3400
Wire Wire Line
	6100 3500 5950 3500
Wire Wire Line
	5950 3600 6100 3600
Wire Wire Line
	6100 3700 5950 3700
Wire Wire Line
	5950 3800 6100 3800
Entry Wire Line
	5850 3000 5950 3100
Entry Wire Line
	5850 3100 5950 3200
Entry Wire Line
	5850 3200 5950 3300
Entry Wire Line
	5850 3300 5950 3400
Entry Wire Line
	5850 3400 5950 3500
Entry Wire Line
	5850 3500 5950 3600
Entry Wire Line
	5850 3600 5950 3700
Entry Wire Line
	5850 3700 5950 3800
Wire Wire Line
	2900 2350 3000 2350
Wire Wire Line
	2900 2450 3000 2450
Wire Wire Line
	2900 2550 3000 2550
Wire Wire Line
	3000 2650 2900 2650
Wire Wire Line
	2900 2750 3000 2750
Wire Wire Line
	2900 2850 3000 2850
Wire Wire Line
	3000 2950 2900 2950
Wire Wire Line
	2900 3050 3000 3050
Entry Wire Line
	2800 2250 2900 2350
Entry Wire Line
	2800 2350 2900 2450
Entry Wire Line
	2800 2450 2900 2550
Entry Wire Line
	2800 2550 2900 2650
Entry Wire Line
	2800 2650 2900 2750
Entry Wire Line
	2800 2750 2900 2850
Entry Wire Line
	2800 2850 2900 2950
Entry Wire Line
	2800 2950 2900 3050
NoConn ~ 3000 3700
Wire Wire Line
	3450 4600 3450 4500
$Comp
L power:GND #PWR0118
U 1 1 5DA231D2
P 3450 4600
F 0 "#PWR0118" H 3450 4350 50  0001 C CNN
F 1 "GND" H 3455 4427 50  0000 C CNN
F 2 "" H 3450 4600 50  0001 C CNN
F 3 "" H 3450 4600 50  0001 C CNN
	1    3450 4600
	1    0    0    -1  
$EndComp
Text Label 4000 3450 0    50   ~ 0
VD2
Text Label 4000 3350 0    50   ~ 0
VD1
Text Label 4000 3250 0    50   ~ 0
VD0
Wire Wire Line
	3950 3950 4050 3950
Wire Wire Line
	4050 3850 3950 3850
Wire Wire Line
	3950 3750 4050 3750
Wire Wire Line
	4050 3650 3950 3650
Wire Wire Line
	3950 3550 4050 3550
Wire Wire Line
	3950 3450 4050 3450
Wire Wire Line
	4050 3350 3950 3350
Wire Wire Line
	3950 3250 4050 3250
Entry Wire Line
	4150 3950 4050 3850
Entry Wire Line
	4150 3850 4050 3750
Entry Wire Line
	4150 3750 4050 3650
Entry Wire Line
	4150 3650 4050 3550
Entry Wire Line
	4150 3550 4050 3450
Entry Wire Line
	4150 3450 4050 3350
Entry Wire Line
	4150 3350 4050 3250
Wire Wire Line
	7100 5650 7600 5650
Wire Wire Line
	7100 5550 7600 5550
Wire Wire Line
	7100 5450 7600 5450
Wire Wire Line
	7100 5350 7600 5350
Wire Wire Line
	7100 5250 7600 5250
Wire Wire Line
	7100 5150 7600 5150
Wire Wire Line
	7100 5050 7600 5050
Wire Wire Line
	7100 4950 7600 4950
Text Label 4000 3150 0    50   ~ 0
AD7
Text Label 4000 3050 0    50   ~ 0
AD6
Text Label 4000 2950 0    50   ~ 0
AD5
Text Label 4000 2850 0    50   ~ 0
AD4
Text Label 4000 2750 0    50   ~ 0
AD3
Text Label 4000 2650 0    50   ~ 0
AD2
Text Label 4000 2550 0    50   ~ 0
AD1
Text Label 4000 2450 0    50   ~ 0
AD0
Wire Wire Line
	3950 2450 4050 2450
Wire Wire Line
	4050 2550 3950 2550
Wire Wire Line
	3950 2650 4050 2650
Wire Wire Line
	3950 2750 4050 2750
Wire Wire Line
	4050 2850 3950 2850
Wire Wire Line
	3950 2950 4050 2950
Wire Wire Line
	4050 3050 3950 3050
Wire Wire Line
	3950 3150 4050 3150
Entry Wire Line
	4150 3050 4050 3150
Entry Wire Line
	4150 2350 4050 2450
Entry Wire Line
	4150 2450 4050 2550
Entry Wire Line
	4150 2550 4050 2650
Entry Wire Line
	4150 2650 4050 2750
Entry Wire Line
	4150 2750 4050 2850
Entry Wire Line
	4150 2850 4050 2950
Entry Wire Line
	4150 2950 4050 3050
Text Label 7500 5650 0    50   ~ 0
VD7
Text Label 7500 5550 0    50   ~ 0
VD6
Text Label 7500 5450 0    50   ~ 0
VD5
Text Label 7500 5350 0    50   ~ 0
VD4
Text Label 7500 5250 0    50   ~ 0
VD3
Text Label 7500 5150 0    50   ~ 0
VD2
Text Label 7500 5050 0    50   ~ 0
VD1
Text Label 7500 4950 0    50   ~ 0
VD0
Entry Wire Line
	7700 4850 7600 4950
Entry Wire Line
	7700 4950 7600 5050
Entry Wire Line
	7700 5050 7600 5150
Entry Wire Line
	7700 5150 7600 5250
Entry Wire Line
	7700 5250 7600 5350
Entry Wire Line
	7700 5350 7600 5450
Entry Wire Line
	7700 5450 7600 5550
Entry Wire Line
	7600 5650 7700 5550
Text Label 7850 2550 0    50   ~ 0
VD2
Text Label 7850 2450 0    50   ~ 0
VD1
Text Label 7850 2350 0    50   ~ 0
VD0
Wire Wire Line
	7800 2550 8000 2550
Wire Wire Line
	8000 2450 7800 2450
Wire Wire Line
	7800 2350 8000 2350
Entry Wire Line
	7700 2450 7800 2350
Entry Wire Line
	7700 2550 7800 2450
Entry Wire Line
	7700 2650 7800 2550
Text Label 7100 3800 0    50   ~ 0
VA13
Text Label 7100 3700 0    50   ~ 0
VA12
Text Label 7100 3600 0    50   ~ 0
VA11
Text Label 7100 3500 0    50   ~ 0
VA10
Text Label 7100 3400 0    50   ~ 0
VA9
Text Label 7100 3300 0    50   ~ 0
VA8
Text Label 7100 3200 0    50   ~ 0
VA7
Entry Wire Line
	7250 3800 7350 3700
Entry Wire Line
	7250 3700 7350 3600
Entry Wire Line
	7250 3600 7350 3500
Entry Wire Line
	7250 3500 7350 3400
Entry Wire Line
	7250 3400 7350 3300
Entry Wire Line
	7250 3300 7350 3200
Entry Wire Line
	7250 3200 7350 3100
Wire Wire Line
	6600 4650 6600 4600
Wire Wire Line
	6600 2800 6600 2750
$Comp
L power:VCC #PWR0117
U 1 1 5D86E6EC
P 6600 4550
F 0 "#PWR0117" H 6600 4400 50  0001 C CNN
F 1 "VCC" H 6617 4723 50  0000 C CNN
F 2 "" H 6600 4550 50  0001 C CNN
F 3 "" H 6600 4550 50  0001 C CNN
	1    6600 4550
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0116
U 1 1 5D86E0C0
P 6600 2750
F 0 "#PWR0116" H 6600 2600 50  0001 C CNN
F 1 "VCC" H 6617 2923 50  0000 C CNN
F 2 "" H 6600 2750 50  0001 C CNN
F 3 "" H 6600 2750 50  0001 C CNN
	1    6600 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 5850 6100 5850
Connection ~ 5700 5850
Wire Wire Line
	5700 6500 5700 5850
Wire Wire Line
	5400 5850 5700 5850
Wire Wire Line
	4250 5850 4800 5850
Wire Wire Line
	4250 5850 4250 6600
Wire Wire Line
	6100 6600 6100 5950
$Comp
L 74xx:74LS574 U4
U 1 1 5D7A1D7A
P 6600 5450
F 0 "U4" H 6600 6431 50  0000 C CNN
F 1 "74LS574" H 6600 6340 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket_LongPads" H 6600 5450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS574" H 6600 5450 50  0001 C CNN
	1    6600 5450
	1    0    0    -1  
$EndComp
Connection ~ 4350 3000
Wire Wire Line
	4350 6700 4350 3000
Wire Wire Line
	4350 3000 4800 3000
Wire Wire Line
	5400 4000 6100 4000
Connection ~ 4250 5850
$Comp
L 74xx:74HC04 U6
U 5 1 5D7F3765
P 5100 5850
F 0 "U6" H 5100 6167 50  0000 C CNN
F 1 "74HC04" H 5100 6076 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5100 5850 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 5100 5850 50  0001 C CNN
	5    5100 5850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 2250 4350 3000
Wire Wire Line
	4750 3500 4800 3500
Wire Wire Line
	4750 3250 4750 3500
Wire Wire Line
	5500 3250 4750 3250
Wire Wire Line
	5500 3000 5500 3250
Wire Wire Line
	5400 3000 5500 3000
$Comp
L 74xx:74HC04 U6
U 4 1 5D7E5182
P 5100 3000
F 0 "U6" H 5100 3317 50  0000 C CNN
F 1 "74HC04" H 5100 3226 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5100 3000 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 5100 3000 50  0001 C CNN
	4    5100 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 4000 4800 4000
Wire Wire Line
	4750 3750 4750 4000
Wire Wire Line
	5500 3750 4750 3750
Wire Wire Line
	5500 3500 5500 3750
Wire Wire Line
	5400 3500 5500 3500
$Comp
L 74xx:74HC04 U6
U 3 1 5D7D57B3
P 5100 4000
F 0 "U6" H 5100 4317 50  0000 C CNN
F 1 "74HC04" H 5100 4226 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5100 4000 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 5100 4000 50  0001 C CNN
	3    5100 4000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC04 U6
U 2 1 5D7D4758
P 5100 3500
F 0 "U6" H 5100 3817 50  0000 C CNN
F 1 "74HC04" H 5100 3726 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 5100 3500 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 5100 3500 50  0001 C CNN
	2    5100 3500
	1    0    0    -1  
$EndComp
NoConn ~ 7100 3100
Wire Wire Line
	7100 3200 7250 3200
Wire Wire Line
	7100 3300 7250 3300
Wire Wire Line
	7100 3400 7250 3400
Wire Wire Line
	7100 3500 7250 3500
Wire Wire Line
	7100 3600 7250 3600
Wire Wire Line
	7100 3700 7250 3700
Wire Wire Line
	7100 3800 7250 3800
$Comp
L power:GND #PWR0115
U 1 1 5D7C5A52
P 6600 6250
F 0 "#PWR0115" H 6600 6000 50  0001 C CNN
F 1 "GND" H 6605 6077 50  0000 C CNN
F 2 "" H 6600 6250 50  0001 C CNN
F 3 "" H 6600 6250 50  0001 C CNN
	1    6600 6250
	1    0    0    -1  
$EndComp
Connection ~ 6100 4400
$Comp
L power:GND #PWR0114
U 1 1 5D7C5593
P 6100 4400
F 0 "#PWR0114" H 6100 4150 50  0001 C CNN
F 1 "GND" H 6105 4227 50  0000 C CNN
F 2 "" H 6100 4400 50  0001 C CNN
F 3 "" H 6100 4400 50  0001 C CNN
	1    6100 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 4400 6600 4400
Wire Wire Line
	6100 4100 6100 4400
Connection ~ 6100 2550
$Comp
L power:GND #PWR0113
U 1 1 5D7C3B4B
P 6100 2550
F 0 "#PWR0113" H 6100 2300 50  0001 C CNN
F 1 "GND" H 6105 2377 50  0000 C CNN
F 2 "" H 6100 2550 50  0001 C CNN
F 3 "" H 6100 2550 50  0001 C CNN
	1    6100 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 2550 6600 2550
Wire Wire Line
	6100 2250 6100 2550
$Comp
L 74xx:74LS574 U2
U 1 1 5D79E393
P 6600 1750
F 0 "U2" H 6600 2731 50  0000 C CNN
F 1 "74LS574" H 6600 2640 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket_LongPads" H 6600 1750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS574" H 6600 1750 50  0001 C CNN
	1    6600 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	7900 2650 8000 2650
Wire Wire Line
	7900 2700 7900 2650
$Comp
L power:GND #PWR0104
U 1 1 5D7B05B0
P 7900 2700
F 0 "#PWR0104" H 7900 2450 50  0001 C CNN
F 1 "GND" H 7905 2527 50  0000 C CNN
F 2 "" H 7900 2700 50  0001 C CNN
F 3 "" H 7900 2700 50  0001 C CNN
	1    7900 2700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS574 U3
U 1 1 5D7A0CA0
P 6600 3600
F 0 "U3" H 6600 4581 50  0000 C CNN
F 1 "74LS574" H 6600 4490 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm_Socket_LongPads" H 6600 3600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS574" H 6600 3600 50  0001 C CNN
	1    6600 3600
	1    0    0    -1  
$EndComp
$Comp
L Device:CTRIM CV1
U 1 1 5DF8BFF1
P 1350 2850
F 0 "CV1" V 1603 2850 50  0000 C CNN
F 1 "5-50pF" V 1512 2850 50  0000 C CNN
F 2 "Potentiometer_THT:Potentiometer_ACP_CA9-V10_Vertical" H 1350 2850 50  0001 C CNN
F 3 "~" H 1350 2850 50  0001 C CNN
	1    1350 2850
	0    -1   -1   0   
$EndComp
Connection ~ 1750 2850
$Comp
L power:GND #PWR0129
U 1 1 5E069747
P 1750 3150
F 0 "#PWR0129" H 1750 2900 50  0001 C CNN
F 1 "GND" H 1755 2977 50  0000 C CNN
F 2 "" H 1750 3150 50  0001 C CNN
F 3 "" H 1750 3150 50  0001 C CNN
	1    1750 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 2550 2450 3200
Wire Wire Line
	2450 3200 3000 3200
Wire Wire Line
	3000 3300 1950 3300
Wire Wire Line
	1950 3300 1950 2850
Wire Wire Line
	1950 2850 1750 2850
Text HLabel 3150 5100 0    50   Output ~ 0
EXTV
Wire Wire Line
	3450 5100 3150 5100
Connection ~ 3450 5100
Text HLabel 2000 6600 0    50   Output ~ 0
COMVID
Wire Wire Line
	2000 6600 2200 6600
$Comp
L power:GND #PWR0138
U 1 1 5DF966DD
P 7550 1350
F 0 "#PWR0138" H 7550 1100 50  0001 C CNN
F 1 "GND" H 7555 1177 50  0000 C CNN
F 2 "" H 7550 1350 50  0001 C CNN
F 3 "" H 7550 1350 50  0001 C CNN
	1    7550 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	650  3650 2300 3650
$Comp
L Diode:1N4148 D1
U 1 1 5E052EE5
P 2650 3800
F 0 "D1" H 2650 3584 50  0000 C CNN
F 1 "1N4148" H 2650 3675 50  0000 C CNN
F 2 "Diode_THT:D_DO-35_SOD27_P7.62mm_Horizontal" H 2650 3625 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/1N4148_1N4448.pdf" H 2650 3800 50  0001 C CNN
	1    2650 3800
	-1   0    0    1   
$EndComp
Wire Wire Line
	2500 3800 2300 3800
Wire Wire Line
	2800 3800 3000 3800
Connection ~ 7700 3000
$Comp
L Z80MiniFrame-Sound_Graphics-rescue:AS6C62256-55PCN-Memory_RAM U5
U 1 1 5D7A4B8E
P 8000 1350
F 0 "U5" H 8500 1615 50  0000 C CNN
F 1 "AS6C62256-55PCN" H 8500 1524 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_LongPads" H 8850 1450 50  0001 L CNN
F 3 "https://componentsearchengine.com/Datasheets/1/AS6C62256-55PCN.pdf" H 8850 1350 50  0001 L CNN
F 4 "Alliance Memory AS6C62256-55PCN SRAM Memory, 256kbit, 2.7  5.5 V, 55ns 28-Pin PDIP" H 8850 1250 50  0001 L CNN "Description"
F 5 "3.81" H 8850 1150 50  0001 L CNN "Height"
F 6 "Alliance Memory" H 8850 1050 50  0001 L CNN "Manufacturer_Name"
F 7 "AS6C62256-55PCN" H 8850 950 50  0001 L CNN "Manufacturer_Part_Number"
F 8 "913-AS6C62256-55PCN" H 8850 850 50  0001 L CNN "Mouser Part Number"
F 9 "https://www.mouser.com/Search/Refine.aspx?Keyword=913-AS6C62256-55PCN" H 8850 750 50  0001 L CNN "Mouser Price/Stock"
F 10 "0538148" H 8850 650 50  0001 L CNN "RS Part Number"
F 11 "http://uk.rs-online.com/web/p/products/0538148" H 8850 550 50  0001 L CNN "RS Price/Stock"
	1    8000 1350
	1    0    0    -1  
$EndComp
Wire Bus Line
	7700 3000 9250 3000
Wire Wire Line
	3950 4100 4100 4100
Wire Wire Line
	4100 4100 4100 5800
Wire Wire Line
	4100 5800 3150 5800
Wire Wire Line
	3950 2350 4250 2350
Wire Wire Line
	9000 1450 9800 1450
Wire Wire Line
	9000 1950 9700 1950
Wire Wire Line
	7550 1350 8000 1350
Wire Bus Line
	7700 2450 7700 3000
Wire Bus Line
	9250 2350 9250 3000
Wire Bus Line
	9250 1050 9250 1950
Wire Bus Line
	7700 3000 7700 6850
Wire Bus Line
	4150 1050 4150 3050
Wire Bus Line
	2800 1050 2800 2950
Wire Bus Line
	4150 3350 4150 6850
Wire Bus Line
	7800 1050 7800 2150
Wire Bus Line
	7350 1050 7350 3700
Wire Bus Line
	5850 1050 5850 5550
Text HLabel 3150 5800 0    50   Output ~ 0
CPUCLK
$EndSCHEMATC
