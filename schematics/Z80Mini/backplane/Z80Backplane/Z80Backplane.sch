EESchema Schematic File Version 4
EELAYER 29 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
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
L Connector_Generic:Conn_02x20_Odd_Even J1
U 1 1 60588EA6
P 2700 3650
F 0 "J1" H 2750 4767 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 2750 4676 50  0000 C CNN
F 2 "Battery:ConnectorEdge40_Female" H 2700 3650 50  0001 C CNN
F 3 "~" H 2700 3650 50  0001 C CNN
	1    2700 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 2750 2150 2750
Wire Wire Line
	2500 2850 2150 2850
Wire Wire Line
	2500 2950 2150 2950
Wire Wire Line
	2500 3050 2150 3050
Wire Wire Line
	2500 3250 2150 3250
Wire Wire Line
	2500 3350 2150 3350
Wire Wire Line
	2500 3450 2150 3450
Text Label 2150 2750 0    50   ~ 0
MREQ
Text Label 2150 2850 0    50   ~ 0
HALT
Text Label 2150 3050 0    50   ~ 0
M1
Text Label 2150 2950 0    50   ~ 0
RESET
Text Label 2150 3250 0    50   ~ 0
D1
Text Label 2150 3350 0    50   ~ 0
D3
Text Label 2150 3450 0    50   ~ 0
D5
Wire Wire Line
	2500 3550 2150 3550
Wire Wire Line
	2500 3650 2150 3650
Wire Wire Line
	2500 3750 2150 3750
Wire Wire Line
	2500 3850 2150 3850
Wire Wire Line
	2500 3950 2150 3950
Wire Wire Line
	2500 4050 2150 4050
Wire Wire Line
	2500 4150 2150 4150
Wire Wire Line
	2500 4250 2150 4250
Wire Wire Line
	2500 4450 2150 4450
Wire Wire Line
	2500 4550 2150 4550
Wire Wire Line
	2500 4650 2150 4650
$Comp
L Regulator_Linear:L7805 U1
U 1 1 605955CD
P 3050 1300
F 0 "U1" H 3050 1542 50  0000 C CNN
F 1 "L7805" H 3050 1451 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-126-3_Horizontal_TabDown" H 3075 1150 50  0001 L CIN
F 3 "http://www.st.com/content/ccc/resource/technical/document/datasheet/41/4f/b3/b0/12/d4/47/88/CD00000444.pdf/files/CD00000444.pdf/jcr:content/translations/en.CD00000444.pdf" H 3050 1250 50  0001 C CNN
	1    3050 1300
	1    0    0    -1  
$EndComp
$Comp
L pspice:DIODE D1
U 1 1 60596420
P 2300 1300
F 0 "D1" H 2300 1565 50  0000 C CNN
F 1 "DIODE" H 2300 1474 50  0000 C CNN
F 2 "Diode_THT:D_A-405_P7.62mm_Horizontal" H 2300 1300 50  0001 C CNN
F 3 "~" H 2300 1300 50  0001 C CNN
	1    2300 1300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 60596D8A
P 2600 1600
F 0 "C1" H 2715 1646 50  0000 L CNN
F 1 "47uF" H 2715 1555 50  0000 L CNN
F 2 "Capacitor_THT:C_Radial_D5.0mm_H11.0mm_P2.00mm" H 2638 1450 50  0001 C CNN
F 3 "~" H 2600 1600 50  0001 C CNN
	1    2600 1600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 60597546
P 3500 1600
F 0 "C2" H 3615 1646 50  0000 L CNN
F 1 "4.7uF" H 3615 1555 50  0000 L CNN
F 2 "Capacitor_THT:C_Radial_D5.0mm_H11.0mm_P2.00mm" H 3538 1450 50  0001 C CNN
F 3 "~" H 3500 1600 50  0001 C CNN
	1    3500 1600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 605978B7
P 3050 1900
F 0 "#PWR0101" H 3050 1650 50  0001 C CNN
F 1 "GND" H 3055 1727 50  0000 C CNN
F 2 "" H 3050 1900 50  0001 C CNN
F 3 "" H 3050 1900 50  0001 C CNN
	1    3050 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3050 1600 3050 1850
Wire Wire Line
	2600 1750 2600 1850
Wire Wire Line
	2600 1850 3050 1850
Connection ~ 3050 1850
Wire Wire Line
	3050 1850 3050 1900
Wire Wire Line
	3500 1750 3500 1850
Wire Wire Line
	3500 1850 3050 1850
Wire Wire Line
	2600 1450 2600 1300
Wire Wire Line
	2600 1300 2750 1300
Wire Wire Line
	2600 1300 2500 1300
Connection ~ 2600 1300
Wire Wire Line
	3350 1300 3500 1300
Wire Wire Line
	3500 1450 3500 1300
Connection ~ 3500 1300
Wire Wire Line
	3500 1300 3950 1300
$Comp
L power:VCC #PWR0102
U 1 1 6059CEFC
P 3950 1300
F 0 "#PWR0102" H 3950 1150 50  0001 C CNN
F 1 "VCC" H 3967 1473 50  0000 C CNN
F 2 "" H 3950 1300 50  0001 C CNN
F 3 "" H 3950 1300 50  0001 C CNN
	1    3950 1300
	1    0    0    -1  
$EndComp
$Comp
L Connector:Barrel_Jack_Switch JP1
U 1 1 6059DC44
P 1600 1300
F 0 "JP1" H 1370 1250 50  0000 R CNN
F 1 "Barrel_Jack_Switch" H 1370 1341 50  0000 R CNN
F 2 "Connector_BarrelJack:BarrelJack_Wuerth_6941xx301002" H 1650 1260 50  0001 C CNN
F 3 "~" H 1650 1260 50  0001 C CNN
	1    1600 1300
	1    0    0    1   
$EndComp
Connection ~ 2600 1850
Wire Wire Line
	1900 1300 2100 1300
$Comp
L power:VCC #PWR0103
U 1 1 605A4FC4
P 2050 3150
F 0 "#PWR0103" H 2050 3000 50  0001 C CNN
F 1 "VCC" H 2067 3323 50  0000 C CNN
F 2 "" H 2050 3150 50  0001 C CNN
F 3 "" H 2050 3150 50  0001 C CNN
	1    2050 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 3150 2500 3150
Text Label 2150 3550 0    50   ~ 0
D7
Text Label 2150 3650 0    50   ~ 0
A0
Text Label 2150 3750 0    50   ~ 0
A2
Text Label 2150 3850 0    50   ~ 0
A4
Text Label 2150 3950 0    50   ~ 0
A6
Text Label 2150 4050 0    50   ~ 0
A8
Text Label 2150 4150 0    50   ~ 0
A10
Text Label 2150 4250 0    50   ~ 0
A12
$Comp
L power:GND #PWR0104
U 1 1 605AAAC6
P 2050 4350
F 0 "#PWR0104" H 2050 4100 50  0001 C CNN
F 1 "GND" H 2055 4177 50  0000 C CNN
F 2 "" H 2050 4350 50  0001 C CNN
F 3 "" H 2050 4350 50  0001 C CNN
	1    2050 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 4350 2500 4350
Text Label 2150 4450 0    50   ~ 0
BUSRQ
Text Label 2150 4550 0    50   ~ 0
A13
Text Label 2150 4650 0    50   ~ 0
A15
Wire Wire Line
	3000 2750 3350 2750
Wire Wire Line
	3000 2850 3350 2850
Wire Wire Line
	3000 2950 3350 2950
Wire Wire Line
	3000 3050 3350 3050
Wire Wire Line
	3000 3150 3350 3150
Wire Wire Line
	3000 3250 3350 3250
Wire Wire Line
	3000 3350 3350 3350
Wire Wire Line
	3000 3450 3350 3450
Wire Wire Line
	3000 3550 3350 3550
Wire Wire Line
	3000 3650 3350 3650
Wire Wire Line
	3000 3750 3350 3750
Wire Wire Line
	3000 4650 3350 4650
Wire Wire Line
	3000 4550 3350 4550
Wire Wire Line
	3000 4450 3350 4450
Wire Wire Line
	3000 4250 3350 4250
Wire Wire Line
	3000 4150 3350 4150
Wire Wire Line
	3000 4050 3350 4050
Wire Wire Line
	3000 3950 3350 3950
Wire Wire Line
	3000 3850 3350 3850
Text Label 3150 2750 0    50   ~ 0
IORQ
Text Label 3200 2850 0    50   ~ 0
NMI
Text Label 3200 2950 0    50   ~ 0
WAIT
Text Label 3200 3050 0    50   ~ 0
RD
Text Label 3200 3150 0    50   ~ 0
D0
Text Label 3200 3250 0    50   ~ 0
D2
Text Label 3200 3350 0    50   ~ 0
D4
Text Label 3200 3450 0    50   ~ 0
D6
Text Label 3200 3550 0    50   ~ 0
WR
Text Label 3200 3650 0    50   ~ 0
A1
Text Label 3200 3750 0    50   ~ 0
A3
Text Label 3200 3850 0    50   ~ 0
A5
Text Label 3200 3950 0    50   ~ 0
A7
Text Label 3200 4050 0    50   ~ 0
A9
Text Label 3200 4150 0    50   ~ 0
A11
Text Label 3050 4250 0    50   ~ 0
BUSACK
$Comp
L power:GND #PWR0105
U 1 1 605C0137
P 3450 4350
F 0 "#PWR0105" H 3450 4100 50  0001 C CNN
F 1 "GND" H 3455 4177 50  0000 C CNN
F 2 "" H 3450 4350 50  0001 C CNN
F 3 "" H 3450 4350 50  0001 C CNN
	1    3450 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 4350 3450 4350
Text Label 3150 4450 0    50   ~ 0
IORQ
Text Label 3200 4550 0    50   ~ 0
A14
Text Label 3200 4650 0    50   ~ 0
INT
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J2
U 1 1 605C6FDE
P 4600 3650
F 0 "J2" H 4650 4767 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 4650 4676 50  0000 C CNN
F 2 "Battery:ConnectorEdge40_Female" H 4600 3650 50  0001 C CNN
F 3 "~" H 4600 3650 50  0001 C CNN
	1    4600 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 2750 4050 2750
Wire Wire Line
	4400 2850 4050 2850
Wire Wire Line
	4400 2950 4050 2950
Wire Wire Line
	4400 3050 4050 3050
Wire Wire Line
	4400 3250 4050 3250
Wire Wire Line
	4400 3350 4050 3350
Wire Wire Line
	4400 3450 4050 3450
Text Label 4050 2750 0    50   ~ 0
MREQ
Text Label 4050 2850 0    50   ~ 0
HALT
Text Label 4050 3050 0    50   ~ 0
M1
Text Label 4050 2950 0    50   ~ 0
RESET
Text Label 4050 3250 0    50   ~ 0
D1
Text Label 4050 3350 0    50   ~ 0
D3
Text Label 4050 3450 0    50   ~ 0
D5
Wire Wire Line
	4400 3550 4050 3550
Wire Wire Line
	4400 3650 4050 3650
Wire Wire Line
	4400 3750 4050 3750
Wire Wire Line
	4400 3850 4050 3850
Wire Wire Line
	4400 3950 4050 3950
Wire Wire Line
	4400 4050 4050 4050
Wire Wire Line
	4400 4150 4050 4150
Wire Wire Line
	4400 4250 4050 4250
Wire Wire Line
	4400 4450 4050 4450
Wire Wire Line
	4400 4550 4050 4550
Wire Wire Line
	4400 4650 4050 4650
$Comp
L power:VCC #PWR0106
U 1 1 605C7001
P 3950 3150
F 0 "#PWR0106" H 3950 3000 50  0001 C CNN
F 1 "VCC" H 3967 3323 50  0000 C CNN
F 2 "" H 3950 3150 50  0001 C CNN
F 3 "" H 3950 3150 50  0001 C CNN
	1    3950 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 3150 4400 3150
Text Label 4050 3550 0    50   ~ 0
D7
Text Label 4050 3650 0    50   ~ 0
A0
Text Label 4050 3750 0    50   ~ 0
A2
Text Label 4050 3850 0    50   ~ 0
A4
Text Label 4050 3950 0    50   ~ 0
A6
Text Label 4050 4050 0    50   ~ 0
A8
Text Label 4050 4150 0    50   ~ 0
A10
Text Label 4050 4250 0    50   ~ 0
A12
$Comp
L power:GND #PWR0107
U 1 1 605C7014
P 3950 4350
F 0 "#PWR0107" H 3950 4100 50  0001 C CNN
F 1 "GND" H 3955 4177 50  0000 C CNN
F 2 "" H 3950 4350 50  0001 C CNN
F 3 "" H 3950 4350 50  0001 C CNN
	1    3950 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	3950 4350 4400 4350
Text Label 4050 4450 0    50   ~ 0
BUSRQ
Text Label 4050 4550 0    50   ~ 0
A13
Text Label 4050 4650 0    50   ~ 0
A15
Wire Wire Line
	4900 2750 5250 2750
Wire Wire Line
	4900 2850 5250 2850
Wire Wire Line
	4900 2950 5250 2950
Wire Wire Line
	4900 3050 5250 3050
Wire Wire Line
	4900 3150 5250 3150
Wire Wire Line
	4900 3250 5250 3250
Wire Wire Line
	4900 3350 5250 3350
Wire Wire Line
	4900 3450 5250 3450
Wire Wire Line
	4900 3550 5250 3550
Wire Wire Line
	4900 3650 5250 3650
Wire Wire Line
	4900 3750 5250 3750
Wire Wire Line
	4900 4650 5250 4650
Wire Wire Line
	4900 4550 5250 4550
Wire Wire Line
	4900 4450 5250 4450
Wire Wire Line
	4900 4250 5250 4250
Wire Wire Line
	4900 4150 5250 4150
Wire Wire Line
	4900 4050 5250 4050
Wire Wire Line
	4900 3950 5250 3950
Wire Wire Line
	4900 3850 5250 3850
Text Label 5050 2750 0    50   ~ 0
IORQ
Text Label 5100 2850 0    50   ~ 0
NMI
Text Label 5100 2950 0    50   ~ 0
WAIT
Text Label 5100 3050 0    50   ~ 0
RD
Text Label 5100 3150 0    50   ~ 0
D0
Text Label 5100 3250 0    50   ~ 0
D2
Text Label 5100 3350 0    50   ~ 0
D4
Text Label 5100 3450 0    50   ~ 0
D6
Text Label 5100 3550 0    50   ~ 0
WR
Text Label 5100 3650 0    50   ~ 0
A1
Text Label 5100 3750 0    50   ~ 0
A3
Text Label 5100 3850 0    50   ~ 0
A5
Text Label 5100 3950 0    50   ~ 0
A7
Text Label 5100 4050 0    50   ~ 0
A9
Text Label 5100 4150 0    50   ~ 0
A11
Text Label 4950 4250 0    50   ~ 0
BUSACK
$Comp
L power:GND #PWR0108
U 1 1 605C7045
P 5350 4350
F 0 "#PWR0108" H 5350 4100 50  0001 C CNN
F 1 "GND" H 5355 4177 50  0000 C CNN
F 2 "" H 5350 4350 50  0001 C CNN
F 3 "" H 5350 4350 50  0001 C CNN
	1    5350 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 4350 5350 4350
Text Label 5050 4450 0    50   ~ 0
IORQ
Text Label 5100 4550 0    50   ~ 0
A14
Text Label 5100 4650 0    50   ~ 0
INT
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J3
U 1 1 605D18D4
P 6500 3650
F 0 "J3" H 6550 4767 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 6550 4676 50  0000 C CNN
F 2 "Battery:ConnectorEdge40_Female" H 6500 3650 50  0001 C CNN
F 3 "~" H 6500 3650 50  0001 C CNN
	1    6500 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6300 2750 5950 2750
Wire Wire Line
	6300 2850 5950 2850
Wire Wire Line
	6300 2950 5950 2950
Wire Wire Line
	6300 3050 5950 3050
Wire Wire Line
	6300 3250 5950 3250
Wire Wire Line
	6300 3350 5950 3350
Wire Wire Line
	6300 3450 5950 3450
Text Label 5950 2750 0    50   ~ 0
MREQ
Text Label 5950 2850 0    50   ~ 0
HALT
Text Label 5950 3050 0    50   ~ 0
M1
Text Label 5950 2950 0    50   ~ 0
RESET
Text Label 5950 3250 0    50   ~ 0
D1
Text Label 5950 3350 0    50   ~ 0
D3
Text Label 5950 3450 0    50   ~ 0
D5
Wire Wire Line
	6300 3550 5950 3550
Wire Wire Line
	6300 3650 5950 3650
Wire Wire Line
	6300 3750 5950 3750
Wire Wire Line
	6300 3850 5950 3850
Wire Wire Line
	6300 3950 5950 3950
Wire Wire Line
	6300 4050 5950 4050
Wire Wire Line
	6300 4150 5950 4150
Wire Wire Line
	6300 4250 5950 4250
Wire Wire Line
	6300 4450 5950 4450
Wire Wire Line
	6300 4550 5950 4550
Wire Wire Line
	6300 4650 5950 4650
$Comp
L power:VCC #PWR0109
U 1 1 605D18F7
P 5850 3150
F 0 "#PWR0109" H 5850 3000 50  0001 C CNN
F 1 "VCC" H 5867 3323 50  0000 C CNN
F 2 "" H 5850 3150 50  0001 C CNN
F 3 "" H 5850 3150 50  0001 C CNN
	1    5850 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 3150 6300 3150
Text Label 5950 3550 0    50   ~ 0
D7
Text Label 5950 3650 0    50   ~ 0
A0
Text Label 5950 3750 0    50   ~ 0
A2
Text Label 5950 3850 0    50   ~ 0
A4
Text Label 5950 3950 0    50   ~ 0
A6
Text Label 5950 4050 0    50   ~ 0
A8
Text Label 5950 4150 0    50   ~ 0
A10
Text Label 5950 4250 0    50   ~ 0
A12
$Comp
L power:GND #PWR0110
U 1 1 605D190A
P 5850 4350
F 0 "#PWR0110" H 5850 4100 50  0001 C CNN
F 1 "GND" H 5855 4177 50  0000 C CNN
F 2 "" H 5850 4350 50  0001 C CNN
F 3 "" H 5850 4350 50  0001 C CNN
	1    5850 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 4350 6300 4350
Text Label 5950 4450 0    50   ~ 0
BUSRQ
Text Label 5950 4550 0    50   ~ 0
A13
Text Label 5950 4650 0    50   ~ 0
A15
Wire Wire Line
	6800 2750 7150 2750
Wire Wire Line
	6800 2850 7150 2850
Wire Wire Line
	6800 2950 7150 2950
Wire Wire Line
	6800 3050 7150 3050
Wire Wire Line
	6800 3150 7150 3150
Wire Wire Line
	6800 3250 7150 3250
Wire Wire Line
	6800 3350 7150 3350
Wire Wire Line
	6800 3450 7150 3450
Wire Wire Line
	6800 3550 7150 3550
Wire Wire Line
	6800 3650 7150 3650
Wire Wire Line
	6800 3750 7150 3750
Wire Wire Line
	6800 4650 7150 4650
Wire Wire Line
	6800 4550 7150 4550
Wire Wire Line
	6800 4450 7150 4450
Wire Wire Line
	6800 4250 7150 4250
Wire Wire Line
	6800 4150 7150 4150
Wire Wire Line
	6800 4050 7150 4050
Wire Wire Line
	6800 3950 7150 3950
Wire Wire Line
	6800 3850 7150 3850
Text Label 6950 2750 0    50   ~ 0
IORQ
Text Label 7000 2850 0    50   ~ 0
NMI
Text Label 7000 2950 0    50   ~ 0
WAIT
Text Label 7000 3050 0    50   ~ 0
RD
Text Label 7000 3150 0    50   ~ 0
D0
Text Label 7000 3250 0    50   ~ 0
D2
Text Label 7000 3350 0    50   ~ 0
D4
Text Label 7000 3450 0    50   ~ 0
D6
Text Label 7000 3550 0    50   ~ 0
WR
Text Label 7000 3650 0    50   ~ 0
A1
Text Label 7000 3750 0    50   ~ 0
A3
Text Label 7000 3850 0    50   ~ 0
A5
Text Label 7000 3950 0    50   ~ 0
A7
Text Label 7000 4050 0    50   ~ 0
A9
Text Label 7000 4150 0    50   ~ 0
A11
Text Label 6850 4250 0    50   ~ 0
BUSACK
$Comp
L power:GND #PWR0111
U 1 1 605D193B
P 7250 4350
F 0 "#PWR0111" H 7250 4100 50  0001 C CNN
F 1 "GND" H 7255 4177 50  0000 C CNN
F 2 "" H 7250 4350 50  0001 C CNN
F 3 "" H 7250 4350 50  0001 C CNN
	1    7250 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	6800 4350 7250 4350
Text Label 6950 4450 0    50   ~ 0
IORQ
Text Label 7000 4550 0    50   ~ 0
A14
Text Label 7000 4650 0    50   ~ 0
INT
Wire Wire Line
	1900 1850 2600 1850
Wire Wire Line
	1900 1400 1900 1850
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J4
U 1 1 605FFC97
P 8550 3650
F 0 "J4" H 8600 4767 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 8600 4676 50  0000 C CNN
F 2 "Battery:ConnectorEdge40_Female" H 8550 3650 50  0001 C CNN
F 3 "~" H 8550 3650 50  0001 C CNN
	1    8550 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	8350 2750 8000 2750
Wire Wire Line
	8350 2850 8000 2850
Wire Wire Line
	8350 2950 8000 2950
Wire Wire Line
	8350 3050 8000 3050
Wire Wire Line
	8350 3250 8000 3250
Wire Wire Line
	8350 3350 8000 3350
Wire Wire Line
	8350 3450 8000 3450
Text Label 8000 2750 0    50   ~ 0
MREQ
Text Label 8000 2850 0    50   ~ 0
HALT
Text Label 8000 3050 0    50   ~ 0
M1
Text Label 8000 2950 0    50   ~ 0
RESET
Text Label 8000 3250 0    50   ~ 0
D1
Text Label 8000 3350 0    50   ~ 0
D3
Text Label 8000 3450 0    50   ~ 0
D5
Wire Wire Line
	8350 3550 8000 3550
Wire Wire Line
	8350 3650 8000 3650
Wire Wire Line
	8350 3750 8000 3750
Wire Wire Line
	8350 3850 8000 3850
Wire Wire Line
	8350 3950 8000 3950
Wire Wire Line
	8350 4050 8000 4050
Wire Wire Line
	8350 4150 8000 4150
Wire Wire Line
	8350 4250 8000 4250
Wire Wire Line
	8350 4450 8000 4450
Wire Wire Line
	8350 4550 8000 4550
Wire Wire Line
	8350 4650 8000 4650
$Comp
L power:VCC #PWR0112
U 1 1 605FFCBA
P 7900 3150
F 0 "#PWR0112" H 7900 3000 50  0001 C CNN
F 1 "VCC" H 7917 3323 50  0000 C CNN
F 2 "" H 7900 3150 50  0001 C CNN
F 3 "" H 7900 3150 50  0001 C CNN
	1    7900 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7900 3150 8350 3150
Text Label 8000 3550 0    50   ~ 0
D7
Text Label 8000 3650 0    50   ~ 0
A0
Text Label 8000 3750 0    50   ~ 0
A2
Text Label 8000 3850 0    50   ~ 0
A4
Text Label 8000 3950 0    50   ~ 0
A6
Text Label 8000 4050 0    50   ~ 0
A8
Text Label 8000 4150 0    50   ~ 0
A10
Text Label 8000 4250 0    50   ~ 0
A12
$Comp
L power:GND #PWR0113
U 1 1 605FFCCD
P 7900 4350
F 0 "#PWR0113" H 7900 4100 50  0001 C CNN
F 1 "GND" H 7905 4177 50  0000 C CNN
F 2 "" H 7900 4350 50  0001 C CNN
F 3 "" H 7900 4350 50  0001 C CNN
	1    7900 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	7900 4350 8350 4350
Text Label 8000 4450 0    50   ~ 0
BUSRQ
Text Label 8000 4550 0    50   ~ 0
A13
Text Label 8000 4650 0    50   ~ 0
A15
Wire Wire Line
	8850 2750 9200 2750
Wire Wire Line
	8850 2850 9200 2850
Wire Wire Line
	8850 2950 9200 2950
Wire Wire Line
	8850 3050 9200 3050
Wire Wire Line
	8850 3150 9200 3150
Wire Wire Line
	8850 3250 9200 3250
Wire Wire Line
	8850 3350 9200 3350
Wire Wire Line
	8850 3450 9200 3450
Wire Wire Line
	8850 3550 9200 3550
Wire Wire Line
	8850 3650 9200 3650
Wire Wire Line
	8850 3750 9200 3750
Wire Wire Line
	8850 4650 9200 4650
Wire Wire Line
	8850 4550 9200 4550
Wire Wire Line
	8850 4450 9200 4450
Wire Wire Line
	8850 4250 9200 4250
Wire Wire Line
	8850 4150 9200 4150
Wire Wire Line
	8850 4050 9200 4050
Wire Wire Line
	8850 3950 9200 3950
Wire Wire Line
	8850 3850 9200 3850
Text Label 9000 2750 0    50   ~ 0
IORQ
Text Label 9050 2850 0    50   ~ 0
NMI
Text Label 9050 2950 0    50   ~ 0
WAIT
Text Label 9050 3050 0    50   ~ 0
RD
Text Label 9050 3150 0    50   ~ 0
D0
Text Label 9050 3250 0    50   ~ 0
D2
Text Label 9050 3350 0    50   ~ 0
D4
Text Label 9050 3450 0    50   ~ 0
D6
Text Label 9050 3550 0    50   ~ 0
WR
Text Label 9050 3650 0    50   ~ 0
A1
Text Label 9050 3750 0    50   ~ 0
A3
Text Label 9050 3850 0    50   ~ 0
A5
Text Label 9050 3950 0    50   ~ 0
A7
Text Label 9050 4050 0    50   ~ 0
A9
Text Label 9050 4150 0    50   ~ 0
A11
Text Label 8900 4250 0    50   ~ 0
BUSACK
$Comp
L power:GND #PWR0114
U 1 1 605FFCFE
P 9300 4350
F 0 "#PWR0114" H 9300 4100 50  0001 C CNN
F 1 "GND" H 9305 4177 50  0000 C CNN
F 2 "" H 9300 4350 50  0001 C CNN
F 3 "" H 9300 4350 50  0001 C CNN
	1    9300 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	8850 4350 9300 4350
Text Label 9000 4450 0    50   ~ 0
IORQ
Text Label 9050 4550 0    50   ~ 0
A14
Text Label 9050 4650 0    50   ~ 0
INT
$Comp
L Device:LED D2
U 1 1 6060F62C
P 4650 1300
F 0 "D2" H 4643 1045 50  0000 C CNN
F 1 "LED" H 4643 1136 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm" H 4650 1300 50  0001 C CNN
F 3 "~" H 4650 1300 50  0001 C CNN
	1    4650 1300
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 606106F8
P 4300 1300
F 0 "R1" V 4507 1300 50  0000 C CNN
F 1 "R" V 4416 1300 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 4230 1300 50  0001 C CNN
F 3 "~" H 4300 1300 50  0001 C CNN
	1    4300 1300
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3950 1300 4150 1300
Connection ~ 3950 1300
Wire Wire Line
	4450 1300 4500 1300
$Comp
L power:GND #PWR0115
U 1 1 60633432
P 4900 1900
F 0 "#PWR0115" H 4900 1650 50  0001 C CNN
F 1 "GND" H 4905 1727 50  0000 C CNN
F 2 "" H 4900 1900 50  0001 C CNN
F 3 "" H 4900 1900 50  0001 C CNN
	1    4900 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 1900 4900 1300
Wire Wire Line
	4900 1300 4800 1300
NoConn ~ 1900 1200
$EndSCHEMATC
