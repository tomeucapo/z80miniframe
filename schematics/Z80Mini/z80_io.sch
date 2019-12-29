EESchema Schematic File Version 4
LIBS:Z80Mini-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 2
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
L Interface:82C55A U7
U 1 1 5E568DA1
P 2250 3600
F 0 "U7" H 2250 5381 50  0000 C CNN
F 1 "82C55A" H 2250 5290 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_LongPads" H 2250 3900 50  0001 C CNN
F 3 "http://jap.hu/electronic/8255.pdf" H 2250 3900 50  0001 C CNN
	1    2250 3600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 5E568DA7
P 1950 1800
F 0 "C8" H 2065 1846 50  0000 L CNN
F 1 "100nF" H 2065 1755 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 1988 1650 50  0001 C CNN
F 3 "~" H 1950 1800 50  0001 C CNN
	1    1950 1800
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0124
U 1 1 5E568DB3
P 1750 1900
F 0 "#PWR0124" H 1750 1650 50  0001 C CNN
F 1 "GND" H 1755 1727 50  0000 C CNN
F 2 "" H 1750 1900 50  0001 C CNN
F 3 "" H 1750 1900 50  0001 C CNN
	1    1750 1900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0125
U 1 1 5E568DB9
P 2250 5300
F 0 "#PWR0125" H 2250 5050 50  0001 C CNN
F 1 "GND" H 2255 5127 50  0000 C CNN
F 2 "" H 2250 5300 50  0001 C CNN
F 3 "" H 2250 5300 50  0001 C CNN
	1    2250 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 5300 2250 5200
Wire Wire Line
	1750 1900 1750 1800
Wire Wire Line
	1750 1800 1800 1800
Wire Wire Line
	2100 1800 2250 1800
Text GLabel 1150 2300 0    50   Input ~ 0
IO_RESET
Wire Wire Line
	1150 2300 1550 2300
Wire Wire Line
	1150 2600 1550 2600
Wire Wire Line
	1550 2700 1150 2700
Wire Wire Line
	1550 2800 1150 2800
Text Label 1200 2700 0    50   ~ 0
RD
Text GLabel 1150 2800 0    50   Input ~ 0
WR
Text Label 1200 3100 0    50   ~ 0
A0
Text Label 1200 3200 0    50   ~ 0
A1
$Comp
L Interface_UART:16550 U8
U 1 1 5E5D0F8B
P 5850 3650
F 0 "U8" H 5850 5531 50  0000 C CNN
F 1 "16550" H 5850 5440 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_LongPads" H 5850 3650 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/pc16550d.pdf" H 5850 3650 50  0001 C CNN
	1    5850 3650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0120
U 1 1 5E5D4A75
P 5850 5550
F 0 "#PWR0120" H 5850 5300 50  0001 C CNN
F 1 "GND" H 5855 5377 50  0000 C CNN
F 2 "" H 5850 5550 50  0001 C CNN
F 3 "" H 5850 5550 50  0001 C CNN
	1    5850 5550
	1    0    0    -1  
$EndComp
$Comp
L Device:C C9
U 1 1 5E5D5D4E
P 5550 1650
F 0 "C9" H 5665 1696 50  0000 L CNN
F 1 "100nF" H 5665 1605 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 5588 1500 50  0001 C CNN
F 3 "~" H 5550 1650 50  0001 C CNN
	1    5550 1650
	0    -1   -1   0   
$EndComp
$Comp
L power:VCC #PWR0121
U 1 1 5E5D649E
P 5850 1500
F 0 "#PWR0121" H 5850 1350 50  0001 C CNN
F 1 "VCC" H 5867 1673 50  0000 C CNN
F 2 "" H 5850 1500 50  0001 C CNN
F 3 "" H 5850 1500 50  0001 C CNN
	1    5850 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 1500 5850 1650
$Comp
L power:GND #PWR0122
U 1 1 5E5D755F
P 5300 1750
F 0 "#PWR0122" H 5300 1500 50  0001 C CNN
F 1 "GND" H 5305 1577 50  0000 C CNN
F 2 "" H 5300 1750 50  0001 C CNN
F 3 "" H 5300 1750 50  0001 C CNN
	1    5300 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 1650 5850 1650
Wire Wire Line
	5400 1650 5300 1650
Wire Wire Line
	5300 1650 5300 1750
Wire Wire Line
	5850 1950 5850 1650
Connection ~ 5850 1650
Text Label 1400 3500 0    50   ~ 0
D0
Text Label 1400 3600 0    50   ~ 0
D1
Text Label 1400 3700 0    50   ~ 0
D2
Text Label 1400 3800 0    50   ~ 0
D3
Text Label 1400 3900 0    50   ~ 0
D4
Text Label 1400 4000 0    50   ~ 0
D5
Text Label 1400 4100 0    50   ~ 0
D6
Text Label 1400 4200 0    50   ~ 0
D7
Wire Wire Line
	4700 3650 4850 3650
Wire Wire Line
	4850 3550 4750 3550
Wire Wire Line
	4750 3550 4750 3450
Wire Wire Line
	4750 3450 4850 3450
Connection ~ 4750 3550
Wire Wire Line
	6850 4850 7000 4850
Wire Wire Line
	7000 4850 7000 5050
Wire Wire Line
	7000 5050 6850 5050
Text GLabel 4700 4450 0    50   Input ~ 0
WR
Wire Wire Line
	4700 4450 4850 4450
Wire Wire Line
	4850 4750 4700 4750
Text Label 4700 4750 0    50   ~ 0
RD
Wire Wire Line
	5850 5550 5850 5350
Wire Wire Line
	4850 4550 4550 4550
Wire Wire Line
	4550 4550 4550 4650
Wire Wire Line
	4550 4650 4850 4650
Wire Wire Line
	4850 4850 4550 4850
Wire Wire Line
	4550 4850 4550 4650
Connection ~ 4550 4650
$Comp
L power:GND #PWR0127
U 1 1 5E5FB5D8
P 4550 4900
F 0 "#PWR0127" H 4550 4650 50  0001 C CNN
F 1 "GND" H 4555 4727 50  0000 C CNN
F 2 "" H 4550 4900 50  0001 C CNN
F 3 "" H 4550 4900 50  0001 C CNN
	1    4550 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4550 4900 4550 4850
Connection ~ 4550 4850
Text GLabel 4850 5550 3    50   Input ~ 0
IO_RESET
Wire Wire Line
	4850 4950 4650 4950
Wire Wire Line
	4650 4950 4650 5550
Wire Wire Line
	4850 5550 4850 5050
Text Label 4450 3250 0    50   ~ 0
A1
Text Label 4450 3350 0    50   ~ 0
A2
Text Label 4450 3150 0    50   ~ 0
A0
Wire Wire Line
	4850 3850 4400 3850
Text Label 4400 2250 0    50   ~ 0
D0
Text Label 4400 2350 0    50   ~ 0
D1
Text Label 4400 2450 0    50   ~ 0
D2
Text Label 4400 2550 0    50   ~ 0
D3
Text Label 4400 2650 0    50   ~ 0
D4
Text Label 4400 2750 0    50   ~ 0
D5
Text Label 4400 2850 0    50   ~ 0
D6
Text Label 4400 2950 0    50   ~ 0
D7
NoConn ~ 4850 4150
$Comp
L Interface_USB:FT232RL U9
U 1 1 5E605A62
P 9050 3750
F 0 "U9" H 9050 4931 50  0000 C CNN
F 1 "FT232RL" H 9050 4840 50  0000 C CNN
F 2 "Package_SO:SSOP-28_5.3x10.2mm_P0.65mm" H 9050 3750 50  0001 C CNN
F 3 "http://www.ftdichip.com/Products/ICs/FT232RL.htm" H 9050 3750 50  0001 C CNN
	1    9050 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 3850 7350 3850
Wire Wire Line
	7350 3850 7350 2100
Wire Wire Line
	7350 2100 7800 2100
Wire Wire Line
	10100 2100 10100 3050
Wire Wire Line
	10100 3050 9850 3050
Wire Wire Line
	6850 3950 7450 3950
Wire Wire Line
	7450 3950 7450 2200
Wire Wire Line
	7450 2200 7900 2200
Wire Wire Line
	10200 2200 10200 3150
Wire Wire Line
	10200 3150 9850 3150
Wire Wire Line
	6850 3250 7250 3250
Wire Wire Line
	7250 3250 7250 2000
Wire Wire Line
	7250 2000 10350 2000
Wire Wire Line
	10350 2000 10350 3350
Wire Wire Line
	10350 3350 9850 3350
Wire Wire Line
	6850 2750 7150 2750
Wire Wire Line
	7150 2750 7150 1900
Wire Wire Line
	7150 1900 10450 1900
Wire Wire Line
	10450 1900 10450 3250
Wire Wire Line
	10450 3250 9850 3250
Wire Wire Line
	6850 2650 6950 2650
Wire Wire Line
	10550 1800 10550 3450
Wire Wire Line
	10550 3450 9850 3450
NoConn ~ 8250 4150
NoConn ~ 8250 3950
$Comp
L Connector:USB_B_Micro J3
U 1 1 5E61EB87
P 7900 5750
F 0 "J3" V 8003 6080 50  0000 L CNN
F 1 "USB_B_Micro" V 7912 6080 50  0000 L CNN
F 2 "Connector_USB:USB_Mini-B_Lumberg_2486_01_Horizontal" H 8050 5700 50  0001 C CNN
F 3 "~" H 8050 5700 50  0001 C CNN
	1    7900 5750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7900 3350 8250 3350
Wire Wire Line
	8250 3450 8000 3450
NoConn ~ 8100 5450
$Comp
L Device:C C10
U 1 1 5E6284D2
P 8400 6050
F 0 "C10" H 8515 6096 50  0000 L CNN
F 1 "0.47uF" H 8515 6005 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 8438 5900 50  0001 C CNN
F 3 "~" H 8400 6050 50  0001 C CNN
	1    8400 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8300 5850 8400 5850
Wire Wire Line
	8400 5850 8400 5900
Wire Wire Line
	8300 5750 8750 5750
$Comp
L power:GND #PWR0128
U 1 1 5E62D526
P 8400 6300
F 0 "#PWR0128" H 8400 6050 50  0001 C CNN
F 1 "GND" H 8405 6127 50  0000 C CNN
F 2 "" H 8400 6300 50  0001 C CNN
F 3 "" H 8400 6300 50  0001 C CNN
	1    8400 6300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0129
U 1 1 5E62DCD2
P 8750 6300
F 0 "#PWR0129" H 8750 6050 50  0001 C CNN
F 1 "GND" H 8755 6127 50  0000 C CNN
F 2 "" H 8750 6300 50  0001 C CNN
F 3 "" H 8750 6300 50  0001 C CNN
	1    8750 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 6200 8400 6300
Wire Wire Line
	8750 5750 8750 6300
Wire Wire Line
	6850 3150 7550 3150
Wire Wire Line
	10000 3550 9850 3550
NoConn ~ 9850 4450
NoConn ~ 9850 4250
NoConn ~ 9850 4150
NoConn ~ 9850 4050
Wire Wire Line
	8250 4450 8250 4750
Wire Wire Line
	8250 4750 8850 4750
Connection ~ 8850 4750
Wire Wire Line
	8850 4750 9050 4750
Connection ~ 9050 4750
Wire Wire Line
	9050 4750 9150 4750
Connection ~ 9150 4750
Wire Wire Line
	9150 4750 9250 4750
$Comp
L power:GND #PWR0130
U 1 1 5E64B586
P 8250 4750
F 0 "#PWR0130" H 8250 4500 50  0001 C CNN
F 1 "GND" H 8255 4577 50  0000 C CNN
F 2 "" H 8250 4750 50  0001 C CNN
F 3 "" H 8250 4750 50  0001 C CNN
	1    8250 4750
	1    0    0    -1  
$EndComp
Connection ~ 8250 4750
NoConn ~ 6850 3050
NoConn ~ 6850 3350
NoConn ~ 6850 4450
NoConn ~ 6850 4350
NoConn ~ 6850 4250
Wire Wire Line
	9850 3650 10000 3650
Wire Wire Line
	10000 3650 10000 3550
NoConn ~ 9850 3750
Wire Wire Line
	7900 3350 7900 5150
Wire Wire Line
	8000 3450 8000 5350
$Comp
L Device:C C11
U 1 1 5E6738BC
P 8550 5350
F 0 "C11" H 8665 5396 50  0000 L CNN
F 1 "47pF" H 8665 5305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 8588 5200 50  0001 C CNN
F 3 "~" H 8550 5350 50  0001 C CNN
	1    8550 5350
	0    1    1    0   
$EndComp
$Comp
L Device:C C12
U 1 1 5E67FAEA
P 8950 5150
F 0 "C12" H 9065 5196 50  0000 L CNN
F 1 "47pF" H 9065 5105 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 8988 5000 50  0001 C CNN
F 3 "~" H 8950 5150 50  0001 C CNN
	1    8950 5150
	0    1    1    0   
$EndComp
Wire Wire Line
	8400 5350 8000 5350
Connection ~ 8000 5350
Wire Wire Line
	8000 5350 8000 5450
Wire Wire Line
	8800 5150 7900 5150
Connection ~ 7900 5150
Wire Wire Line
	7900 5150 7900 5450
Wire Wire Line
	8700 5350 9250 5350
Wire Wire Line
	9250 5350 9250 5150
Wire Wire Line
	9250 5150 9100 5150
$Comp
L power:GND #PWR0131
U 1 1 5E68A257
P 9250 5450
F 0 "#PWR0131" H 9250 5200 50  0001 C CNN
F 1 "GND" H 9255 5277 50  0000 C CNN
F 2 "" H 9250 5450 50  0001 C CNN
F 3 "" H 9250 5450 50  0001 C CNN
	1    9250 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9250 5450 9250 5350
Connection ~ 9250 5350
Text Notes 7350 7500 0    50   ~ 0
Mini Z80 IO Module
Text Notes 8150 7650 0    50   ~ 0
05/08/2019
$Comp
L Device:Ferrite_Bead FB1
U 1 1 5E6AB76C
P 8400 2500
F 0 "FB1" V 8126 2500 50  0000 C CNN
F 1 "600Ohm" V 8217 2500 50  0000 C CNN
F 2 "Inductor_SMD:L_0805_2012Metric" V 8330 2500 50  0001 C CNN
F 3 "~" H 8400 2500 50  0001 C CNN
	1    8400 2500
	0    1    1    0   
$EndComp
Wire Wire Line
	7700 2500 7800 2500
$Comp
L power:GND #PWR0133
U 1 1 5E74BDF7
P 7800 3150
F 0 "#PWR0133" H 7800 2900 50  0001 C CNN
F 1 "GND" H 7805 2977 50  0000 C CNN
F 2 "" H 7800 3150 50  0001 C CNN
F 3 "" H 7800 3150 50  0001 C CNN
	1    7800 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 3150 7800 3050
Wire Wire Line
	7800 3050 7900 3050
Wire Wire Line
	8200 3050 8250 3050
Wire Bus Line
	650  1200 4050 1200
Entry Wire Line
	4050 3250 4150 3350
Entry Wire Line
	4050 3150 4150 3250
Entry Wire Line
	4050 3050 4150 3150
Wire Wire Line
	4150 3150 4850 3150
Wire Wire Line
	4150 3250 4850 3250
Wire Wire Line
	4150 3350 4850 3350
Entry Wire Line
	650  3000 750  3100
Entry Wire Line
	650  3100 750  3200
Wire Wire Line
	750  3100 1550 3100
Wire Wire Line
	750  3200 1550 3200
Text GLabel 1150 2700 0    50   Input ~ 0
RD
Text GLabel 1150 2700 0    50   Input ~ 0
RD
Text GLabel 4700 4750 0    50   Input ~ 0
RD
Text Label 650  1200 0    50   ~ 0
A[0..15]
Wire Bus Line
	1250 5700 4250 5700
Entry Wire Line
	4250 2350 4350 2250
Entry Wire Line
	1250 3600 1350 3500
Wire Wire Line
	4350 2250 4850 2250
Wire Wire Line
	1350 3500 1550 3500
Wire Bus Line
	1250 5700 1100 5700
Connection ~ 1250 5700
Text HLabel 1100 5700 0    50   BiDi ~ 0
D[0..7]
Connection ~ 4050 1200
Text HLabel 4150 1200 2    50   BiDi ~ 0
A[0..15]
Wire Bus Line
	4050 1200 4150 1200
Text Label 1250 5700 0    50   ~ 0
D[0..7]
$Comp
L Switch:SW_DIP_x04 SW2
U 1 1 5EF298E4
P 3650 2500
F 0 "SW2" H 3650 2967 50  0000 C CNN
F 1 "SW_DIP_x04" H 3650 2876 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm_LongPads" H 3650 2500 50  0001 C CNN
F 3 "~" H 3650 2500 50  0001 C CNN
	1    3650 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 2600 3950 2500
Connection ~ 3950 2300
Wire Wire Line
	3950 2300 3950 1950
Connection ~ 3950 2400
Wire Wire Line
	3950 2400 3950 2300
Connection ~ 3950 2500
Wire Wire Line
	3950 2500 3950 2400
$Comp
L power:VCC #PWR0144
U 1 1 5EF72315
P 3950 1950
F 0 "#PWR0144" H 3950 1800 50  0001 C CNN
F 1 "VCC" H 3967 2123 50  0000 C CNN
F 2 "" H 3950 1950 50  0001 C CNN
F 3 "" H 3950 1950 50  0001 C CNN
	1    3950 1950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R11
U 1 1 5EF72899
P 2950 1800
F 0 "R11" H 2880 1754 50  0000 R CNN
F 1 "R" H 2880 1845 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2880 1800 50  0001 C CNN
F 3 "~" H 2950 1800 50  0001 C CNN
	1    2950 1800
	-1   0    0    1   
$EndComp
$Comp
L Device:R R12
U 1 1 5EF733AC
P 3100 1800
F 0 "R12" H 3030 1754 50  0000 R CNN
F 1 "R" H 3030 1845 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3030 1800 50  0001 C CNN
F 3 "~" H 3100 1800 50  0001 C CNN
	1    3100 1800
	-1   0    0    1   
$EndComp
$Comp
L Device:R R13
U 1 1 5EF737EA
P 3250 1800
F 0 "R13" H 3180 1754 50  0000 R CNN
F 1 "R" H 3180 1845 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3180 1800 50  0001 C CNN
F 3 "~" H 3250 1800 50  0001 C CNN
	1    3250 1800
	-1   0    0    1   
$EndComp
$Comp
L Device:R R14
U 1 1 5EF73A5E
P 3400 1800
F 0 "R14" H 3330 1754 50  0000 R CNN
F 1 "R" H 3330 1845 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3330 1800 50  0001 C CNN
F 3 "~" H 3400 1800 50  0001 C CNN
	1    3400 1800
	-1   0    0    1   
$EndComp
Wire Wire Line
	2950 2300 3350 2300
Wire Wire Line
	2950 2400 3100 2400
Wire Wire Line
	2950 2500 3250 2500
Wire Wire Line
	2950 2600 3350 2600
Wire Wire Line
	2950 1950 2950 2300
Connection ~ 2950 2300
Wire Wire Line
	3100 1950 3100 2400
Connection ~ 3100 2400
Wire Wire Line
	3100 2400 3350 2400
Wire Wire Line
	3250 1950 3250 2500
Connection ~ 3250 2500
Wire Wire Line
	3250 2500 3350 2500
Wire Wire Line
	3400 1950 3400 2600
Wire Wire Line
	3400 2600 3350 2600
Connection ~ 3350 2600
Wire Wire Line
	2950 1650 2950 1550
Wire Wire Line
	2950 1550 3100 1550
Wire Wire Line
	3100 1550 3100 1650
Connection ~ 3100 1550
Wire Wire Line
	3100 1550 3250 1550
Wire Wire Line
	3250 1650 3250 1550
Connection ~ 3250 1550
Wire Wire Line
	3250 1550 3400 1550
Wire Wire Line
	3400 1650 3400 1550
Connection ~ 3400 1550
Wire Wire Line
	3400 1550 3650 1550
$Comp
L power:GND #PWR0145
U 1 1 5EFDC802
P 3650 1650
F 0 "#PWR0145" H 3650 1400 50  0001 C CNN
F 1 "GND" H 3655 1477 50  0000 C CNN
F 2 "" H 3650 1650 50  0001 C CNN
F 3 "" H 3650 1650 50  0001 C CNN
	1    3650 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 1650 3650 1550
Wire Wire Line
	3700 4450 3700 4350
$Comp
L power:GND #PWR0140
U 1 1 5EA8C140
P 3700 4450
F 0 "#PWR0140" H 3700 4200 50  0001 C CNN
F 1 "GND" H 3705 4277 50  0000 C CNN
F 2 "" H 3700 4450 50  0001 C CNN
F 3 "" H 3700 4450 50  0001 C CNN
	1    3700 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 3950 3700 4050
Wire Wire Line
	3400 3400 3400 3650
Wire Wire Line
	2950 3500 3700 3500
Wire Wire Line
	3700 3500 3700 3650
$Comp
L Device:LED D2
U 1 1 5EA6C340
P 3700 4200
F 0 "D2" V 3739 4083 50  0000 R CNN
F 1 "LED" V 3648 4083 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3700 4200 50  0001 C CNN
F 3 "~" H 3700 4200 50  0001 C CNN
	1    3700 4200
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R9
U 1 1 5EA6B9A4
P 3700 3800
F 0 "R9" H 3630 3754 50  0000 R CNN
F 1 "R" H 3630 3845 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3630 3800 50  0001 C CNN
F 3 "~" H 3700 3800 50  0001 C CNN
	1    3700 3800
	-1   0    0    1   
$EndComp
Wire Wire Line
	3400 4450 3400 4350
Wire Wire Line
	3400 3400 2950 3400
$Comp
L power:GND #PWR0139
U 1 1 5EA02518
P 3400 4450
F 0 "#PWR0139" H 3400 4200 50  0001 C CNN
F 1 "GND" H 3405 4277 50  0000 C CNN
F 2 "" H 3400 4450 50  0001 C CNN
F 3 "" H 3400 4450 50  0001 C CNN
	1    3400 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3400 3950 3400 4050
$Comp
L Device:LED D1
U 1 1 5E9FC64B
P 3400 4200
F 0 "D1" V 3439 4083 50  0000 R CNN
F 1 "LED" V 3348 4083 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3400 4200 50  0001 C CNN
F 3 "~" H 3400 4200 50  0001 C CNN
F 4 "GREEN" V 3400 4200 50  0001 C CNN "Color"
	1    3400 4200
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R8
U 1 1 5E9F67AE
P 3400 3800
F 0 "R8" H 3330 3754 50  0000 R CNN
F 1 "R" H 3330 3845 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3330 3800 50  0001 C CNN
F 3 "~" H 3400 3800 50  0001 C CNN
	1    3400 3800
	-1   0    0    1   
$EndComp
$Comp
L Connector_Generic:Conn_02x10_Counter_Clockwise J4
U 1 1 5F00F362
P 1850 6800
F 0 "J4" H 1900 7417 50  0000 C CNN
F 1 "Conn_02x10_Counter_Clockwise" H 1900 7326 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x10_P2.54mm_Horizontal" H 1850 6800 50  0001 C CNN
F 3 "~" H 1850 6800 50  0001 C CNN
	1    1850 6800
	1    0    0    -1  
$EndComp
Text Label 2950 4100 0    50   ~ 0
PC0
Text Label 2950 4200 0    50   ~ 0
PC1
Text Label 2950 4300 0    50   ~ 0
PC2
Text Label 2950 4400 0    50   ~ 0
PC3
Text Label 2950 4500 0    50   ~ 0
PC4
Text Label 2950 4600 0    50   ~ 0
PC5
Text Label 2950 4700 0    50   ~ 0
PC6
Text Label 2950 4800 0    50   ~ 0
PC7
Wire Wire Line
	2950 4100 3150 4100
Wire Wire Line
	2950 4200 3150 4200
Wire Wire Line
	2950 4300 3150 4300
Wire Wire Line
	2950 4400 3150 4400
Wire Wire Line
	2950 4500 3150 4500
Wire Wire Line
	2950 4600 3150 4600
Wire Wire Line
	2950 4700 3150 4700
Wire Wire Line
	2950 4800 3150 4800
Wire Wire Line
	1650 6500 1450 6500
Wire Wire Line
	1650 6600 1450 6600
Wire Wire Line
	1650 6700 1450 6700
Wire Wire Line
	1650 6800 1450 6800
Wire Wire Line
	1450 6900 1650 6900
Wire Wire Line
	1450 7000 1650 7000
Text Label 1450 6500 0    50   ~ 0
PC0
Text Label 1450 6600 0    50   ~ 0
PC1
Text Label 1450 6700 0    50   ~ 0
PC2
Text Label 1450 6800 0    50   ~ 0
PC3
Text Label 1450 6900 0    50   ~ 0
PC4
Text Label 1450 7000 0    50   ~ 0
PC5
Wire Wire Line
	1650 7100 1450 7100
Wire Wire Line
	1650 7200 1450 7200
Wire Wire Line
	1650 7300 1450 7300
Text Label 1450 7100 0    50   ~ 0
PC6
Text Label 1450 7200 0    50   ~ 0
PC7
Wire Wire Line
	2150 6400 2350 6400
Wire Wire Line
	2150 6500 2350 6500
Wire Wire Line
	2150 6600 2350 6600
Wire Wire Line
	2150 6700 2350 6700
Wire Wire Line
	2150 6800 2350 6800
Wire Wire Line
	2150 6900 2350 6900
Wire Wire Line
	2150 7100 2350 7100
Wire Wire Line
	2150 7200 2350 7200
Wire Wire Line
	2150 7300 2350 7300
Text Label 2200 6400 0    50   ~ 0
PB0
Text Label 2200 6500 0    50   ~ 0
PB1
Wire Wire Line
	2950 3200 3150 3200
Wire Wire Line
	2950 3300 3150 3300
Text Label 3000 3200 0    50   ~ 0
PB0
Text Label 3000 3300 0    50   ~ 0
PB1
Text Label 2200 6600 0    50   ~ 0
PB4
Text Label 2200 6700 0    50   ~ 0
PB5
Text Label 2200 6800 0    50   ~ 0
PB6
Text Label 2200 6900 0    50   ~ 0
PB7
Wire Wire Line
	2950 3600 3150 3600
Wire Wire Line
	2950 3700 3150 3700
Wire Wire Line
	2950 3800 3150 3800
Wire Wire Line
	2950 3900 3150 3900
Text Label 3000 3600 0    50   ~ 0
PB4
Text Label 3000 3700 0    50   ~ 0
PB5
Text Label 3000 3800 0    50   ~ 0
PB6
Text Label 3000 3900 0    50   ~ 0
PB7
Wire Wire Line
	1550 6400 1650 6400
$Comp
L power:GND #PWR0147
U 1 1 5F1BB776
P 1450 7300
F 0 "#PWR0147" H 1450 7050 50  0001 C CNN
F 1 "GND" H 1455 7127 50  0000 C CNN
F 2 "" H 1450 7300 50  0001 C CNN
F 3 "" H 1450 7300 50  0001 C CNN
	1    1450 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2150 7000 2350 7000
Text Label 2200 7000 0    50   ~ 0
PA4
Text Label 2200 7100 0    50   ~ 0
PA5
Text Label 2200 7200 0    50   ~ 0
PA6
Text Label 2200 7300 0    50   ~ 0
PA7
Wire Wire Line
	2950 3000 3150 3000
Text Label 3050 3000 0    50   ~ 0
PA7
Wire Wire Line
	2950 2900 3150 2900
Text Label 3050 2900 0    50   ~ 0
PA6
Wire Wire Line
	2950 2800 3150 2800
Text Label 3050 2800 0    50   ~ 0
PA5
Wire Wire Line
	2950 2700 3150 2700
Text Label 3050 2700 0    50   ~ 0
PA4
Text HLabel 1150 2600 0    50   Input ~ 0
IO_CE
Text HLabel 4700 3650 0    50   Input ~ 0
UART_CE
Entry Wire Line
	1250 3700 1350 3600
Entry Wire Line
	1250 3800 1350 3700
Entry Wire Line
	1250 3900 1350 3800
Entry Wire Line
	1250 4000 1350 3900
Entry Wire Line
	1250 4100 1350 4000
Entry Wire Line
	1250 4200 1350 4100
Entry Wire Line
	1250 4300 1350 4200
Wire Wire Line
	1350 3600 1550 3600
Wire Wire Line
	1350 3700 1550 3700
Wire Wire Line
	1350 3800 1550 3800
Wire Wire Line
	1350 3900 1550 3900
Wire Wire Line
	1350 4000 1550 4000
Wire Wire Line
	1350 4100 1550 4100
Wire Wire Line
	1350 4200 1550 4200
Entry Wire Line
	4250 2450 4350 2350
Entry Wire Line
	4250 2550 4350 2450
Entry Wire Line
	4250 2650 4350 2550
Entry Wire Line
	4250 2750 4350 2650
Entry Wire Line
	4250 2850 4350 2750
Entry Wire Line
	4250 2950 4350 2850
Entry Wire Line
	4250 3050 4350 2950
Wire Wire Line
	4350 2350 4850 2350
Wire Wire Line
	4350 2450 4850 2450
Wire Wire Line
	4350 2550 4850 2550
Wire Wire Line
	4350 2650 4850 2650
Wire Wire Line
	4350 2750 4850 2750
Wire Wire Line
	4350 2850 4850 2850
Wire Wire Line
	4350 2950 4850 2950
Wire Wire Line
	2250 1800 2250 2000
Text HLabel 1300 900  0    50   Input ~ 0
VCC
$Comp
L power:VCC #PWR0149
U 1 1 5FD2E2FF
P 1500 850
F 0 "#PWR0149" H 1500 700 50  0001 C CNN
F 1 "VCC" H 1517 1023 50  0000 C CNN
F 2 "" H 1500 850 50  0001 C CNN
F 3 "" H 1500 850 50  0001 C CNN
	1    1500 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1500 850  1500 900 
Wire Wire Line
	1500 900  1300 900 
Text HLabel 1850 900  0    50   Input ~ 0
GND
$Comp
L power:GND #PWR0151
U 1 1 5FD6AFE4
P 2100 900
F 0 "#PWR0151" H 2100 650 50  0001 C CNN
F 1 "GND" H 2105 727 50  0000 C CNN
F 2 "" H 2100 900 50  0001 C CNN
F 3 "" H 2100 900 50  0001 C CNN
	1    2100 900 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 900  2100 900 
$Comp
L power:VCC #PWR0126
U 1 1 5FECEFD1
P 4150 3550
F 0 "#PWR0126" H 4150 3400 50  0001 C CNN
F 1 "VCC" V 4168 3677 50  0000 L CNN
F 2 "" H 4150 3550 50  0001 C CNN
F 3 "" H 4150 3550 50  0001 C CNN
	1    4150 3550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4150 3550 4750 3550
$Comp
L power:VCC #PWR0123
U 1 1 5FEF063C
P 2250 1500
F 0 "#PWR0123" H 2250 1350 50  0001 C CNN
F 1 "VCC" H 2267 1673 50  0000 C CNN
F 2 "" H 2250 1500 50  0001 C CNN
F 3 "" H 2250 1500 50  0001 C CNN
	1    2250 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 1800 2250 1500
Connection ~ 2250 1800
$Comp
L power:VCC #PWR0146
U 1 1 5FF11538
P 1550 6200
F 0 "#PWR0146" H 1550 6050 50  0001 C CNN
F 1 "VCC" H 1567 6373 50  0000 C CNN
F 2 "" H 1550 6200 50  0001 C CNN
F 3 "" H 1550 6200 50  0001 C CNN
	1    1550 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 6400 1550 6200
Text HLabel 4650 5550 3    50   Input ~ 0
UART_INTR
Text HLabel 4400 5550 3    50   Input ~ 0
MAIN_CLK
Wire Wire Line
	4400 5550 4400 3850
$Comp
L Device:C C17
U 1 1 5DADC784
P 7500 4400
F 0 "C17" H 7615 4446 50  0000 L CNN
F 1 "100nF" H 7615 4355 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 7538 4250 50  0001 C CNN
F 3 "~" H 7500 4400 50  0001 C CNN
	1    7500 4400
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0119
U 1 1 5DAEE0EC
P 7500 4700
F 0 "#PWR0119" H 7500 4450 50  0001 C CNN
F 1 "GND" H 7505 4527 50  0000 C CNN
F 2 "" H 7500 4700 50  0001 C CNN
F 3 "" H 7500 4700 50  0001 C CNN
	1    7500 4700
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 4700 7500 4550
Wire Wire Line
	7500 4250 7500 4200
Wire Wire Line
	7500 4200 8100 4200
Wire Wire Line
	8100 4200 8100 3750
Wire Wire Line
	8100 3750 8250 3750
Wire Wire Line
	8550 2500 8950 2500
$Comp
L Device:CP C14
U 1 1 5DBCF4F6
P 7800 2750
F 0 "C14" H 7915 2796 50  0000 L CNN
F 1 "10uF" H 7915 2705 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 7838 2600 50  0001 C CNN
F 3 "~" H 7800 2750 50  0001 C CNN
	1    7800 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	8950 2750 8950 2500
Wire Wire Line
	8950 2500 9150 2500
Wire Wire Line
	9150 2500 9150 2750
Connection ~ 8950 2500
Wire Wire Line
	7800 2600 7800 2500
Connection ~ 7800 2500
Wire Wire Line
	7800 2900 7800 3050
Connection ~ 7800 3050
Wire Wire Line
	7800 2500 8250 2500
$Comp
L Device:C C15
U 1 1 5DC8400D
P 8050 3050
F 0 "C15" H 8165 3096 50  0000 L CNN
F 1 "100nF" H 8165 3005 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 8088 2900 50  0001 C CNN
F 3 "~" H 8050 3050 50  0001 C CNN
	1    8050 3050
	0    1    1    0   
$EndComp
$Comp
L Transistor_FET:IRLML6402 Q2
U 1 1 5E9FA872
P 10650 1100
F 0 "Q2" H 10856 1146 50  0000 L CNN
F 1 "IRLML6402" H 10856 1055 50  0000 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 10850 1025 50  0001 L CIN
F 3 "https://www.infineon.com/dgdl/irlml6402pbf.pdf?fileId=5546d462533600a401535668d5c2263c" H 10650 1100 50  0001 L CNN
	1    10650 1100
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R18
U 1 1 5EA0C7A8
P 10650 1550
F 0 "R18" H 10580 1504 50  0000 R CNN
F 1 "1K" H 10580 1595 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 10580 1550 50  0001 C CNN
F 3 "~" H 10650 1550 50  0001 C CNN
	1    10650 1550
	-1   0    0    1   
$EndComp
Wire Wire Line
	10650 1400 10650 1300
$Comp
L Device:C C4
U 1 1 5EA2C632
P 10400 1250
F 0 "C4" H 10515 1296 50  0000 L CNN
F 1 "0.1uF" H 10515 1205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 10438 1100 50  0001 C CNN
F 3 "~" H 10400 1250 50  0001 C CNN
	1    10400 1250
	-1   0    0    1   
$EndComp
Wire Wire Line
	10400 1400 10650 1400
Connection ~ 10650 1400
Wire Wire Line
	10400 1100 10400 1000
Wire Wire Line
	10400 1000 10450 1000
$Comp
L Device:C C20
U 1 1 5EA4B1DC
P 10050 1250
F 0 "C20" H 10165 1296 50  0000 L CNN
F 1 "0.1uF" H 10165 1205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 10088 1100 50  0001 C CNN
F 3 "~" H 10050 1250 50  0001 C CNN
	1    10050 1250
	-1   0    0    1   
$EndComp
Wire Wire Line
	10050 1100 10050 1000
Wire Wire Line
	10050 1000 10400 1000
Connection ~ 10400 1000
$Comp
L power:GND #PWR0102
U 1 1 5EA6BF43
P 10050 1450
F 0 "#PWR0102" H 10050 1200 50  0001 C CNN
F 1 "GND" H 10055 1277 50  0000 C CNN
F 2 "" H 10050 1450 50  0001 C CNN
F 3 "" H 10050 1450 50  0001 C CNN
	1    10050 1450
	1    0    0    -1  
$EndComp
Wire Wire Line
	10050 1400 10050 1450
$Comp
L Device:Jumper_NO_Small JP3
U 1 1 5EABC98E
P 7700 4950
F 0 "JP3" V 7654 4998 50  0000 L CNN
F 1 "USB_POWER" V 7745 4998 50  0000 L CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_1x02_P2.00mm_Vertical" H 7700 4950 50  0001 C CNN
F 3 "~" H 7700 4950 50  0001 C CNN
	1    7700 4950
	0    1    1    0   
$EndComp
Wire Wire Line
	7700 5050 7700 5450
$Comp
L power:VCC #PWR0103
U 1 1 5EAC606A
P 9450 850
F 0 "#PWR0103" H 9450 700 50  0001 C CNN
F 1 "VCC" H 9450 1000 50  0000 C CNN
F 2 "" H 9450 850 50  0001 C CNN
F 3 "" H 9450 850 50  0001 C CNN
	1    9450 850 
	1    0    0    -1  
$EndComp
$Comp
L Device:Jumper_NC_Dual JP4
U 1 1 5EAC6911
P 9450 1000
F 0 "JP4" H 9450 1147 50  0000 C CNN
F 1 "SELF_POWER" H 9450 1238 50  0000 C CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_1x03_P2.00mm_Vertical" H 9450 1000 50  0001 C CNN
F 3 "~" H 9450 1000 50  0001 C CNN
	1    9450 1000
	-1   0    0    1   
$EndComp
Wire Wire Line
	9450 900  9450 850 
Wire Wire Line
	7700 2500 7700 4850
$Comp
L power:VCC #PWR0132
U 1 1 5EBF7733
P 7500 4150
F 0 "#PWR0132" H 7500 4000 50  0001 C CNN
F 1 "VCC" H 7500 4300 50  0000 C CNN
F 2 "" H 7500 4150 50  0001 C CNN
F 3 "" H 7500 4150 50  0001 C CNN
	1    7500 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 4200 7500 4150
Connection ~ 7500 4200
Wire Wire Line
	6850 2450 6850 1650
Wire Wire Line
	6850 1650 5850 1650
Wire Wire Line
	6950 2650 6950 2550
Wire Wire Line
	7800 2100 7800 1250
Connection ~ 7800 2100
Wire Wire Line
	7800 2100 10100 2100
Wire Wire Line
	7900 2200 7900 1250
Connection ~ 7900 2200
Wire Wire Line
	7900 2200 10200 2200
Text HLabel 6950 1250 1    50   Output ~ 0
DSR
Text HLabel 7550 1250 1    50   Output ~ 0
DTR
Text HLabel 7800 1250 1    50   Output ~ 0
RX
Text HLabel 7900 1250 1    50   Output ~ 0
TX
Connection ~ 6950 2550
Wire Wire Line
	6950 2550 6950 1800
Wire Wire Line
	6950 2550 6850 2550
Wire Wire Line
	6950 1800 10550 1800
Connection ~ 6950 1800
Wire Wire Line
	6950 1800 6950 1250
Wire Wire Line
	9700 1000 10050 1000
Connection ~ 10050 1000
Wire Wire Line
	10850 1000 11000 1000
Wire Wire Line
	9850 4350 10650 4350
Connection ~ 10000 3550
Wire Wire Line
	10000 2300 10000 3550
Wire Wire Line
	7550 3150 7550 2300
Wire Wire Line
	7550 2300 7550 1250
Connection ~ 7550 2300
Wire Wire Line
	7550 2300 10000 2300
Wire Wire Line
	10650 1700 10650 4350
Wire Wire Line
	9150 2500 11000 2500
Wire Wire Line
	11000 1000 11000 2500
Connection ~ 9150 2500
Wire Wire Line
	8950 1000 8950 2500
Wire Wire Line
	8950 1000 9200 1000
Wire Bus Line
	650  1200 650  3100
Wire Bus Line
	4050 1200 4050 3250
Wire Bus Line
	4250 2350 4250 5700
Wire Bus Line
	1250 3600 1250 5700
$EndSCHEMATC
