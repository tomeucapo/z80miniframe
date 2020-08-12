EESchema Schematic File Version 4
EELAYER 30 0
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
U 1 1 5F33370D
P 3650 3900
F 0 "J1" H 3700 5017 50  0000 C CNN
F 1 "Z80MiniFrame BUS" H 3700 4926 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x20_P2.54mm_Vertical" H 3650 3900 50  0001 C CNN
F 3 "~" H 3650 3900 50  0001 C CNN
	1    3650 3900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x20_Male J2
U 1 1 5F336D68
P 2750 3900
F 0 "J2" H 2858 4981 50  0000 C CNN
F 1 "ROW1" H 2858 4890 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x20_P2.54mm_Vertical" H 2750 3900 50  0001 C CNN
F 3 "~" H 2750 3900 50  0001 C CNN
	1    2750 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 3000 2950 3000
Wire Wire Line
	2950 3100 3450 3100
Wire Wire Line
	3450 3200 2950 3200
Wire Wire Line
	2950 3300 3450 3300
Wire Wire Line
	2950 3400 3200 3400
Wire Wire Line
	2950 3500 3450 3500
Wire Wire Line
	2950 3600 3450 3600
Wire Wire Line
	3450 3700 2950 3700
Wire Wire Line
	2950 3800 3450 3800
Wire Wire Line
	3450 3900 2950 3900
Wire Wire Line
	2950 4000 3450 4000
Wire Wire Line
	2950 4100 3450 4100
Wire Wire Line
	2950 4200 3450 4200
Wire Wire Line
	3450 4300 2950 4300
Wire Wire Line
	2950 4400 3450 4400
Wire Wire Line
	3450 4500 2950 4500
Wire Wire Line
	2950 4600 3450 4600
Wire Wire Line
	2950 4700 3450 4700
Wire Wire Line
	2950 4800 3450 4800
Wire Wire Line
	3450 4900 2950 4900
$Comp
L Connector:Conn_01x20_Male J3
U 1 1 5F33DCDB
P 4650 3900
F 0 "J3" H 4622 3874 50  0000 R CNN
F 1 "ROW2" H 4622 3783 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x20_P2.54mm_Vertical" H 4650 3900 50  0001 C CNN
F 3 "~" H 4650 3900 50  0001 C CNN
	1    4650 3900
	-1   0    0    -1  
$EndComp
Wire Wire Line
	3950 3000 4450 3000
Wire Wire Line
	4450 3100 3950 3100
Wire Wire Line
	3950 3200 4450 3200
Wire Wire Line
	4450 3300 3950 3300
Wire Wire Line
	3950 3400 4450 3400
Wire Wire Line
	4450 3500 3950 3500
Wire Wire Line
	3950 3600 4450 3600
Wire Wire Line
	4450 3700 3950 3700
Wire Wire Line
	3950 3800 4450 3800
Wire Wire Line
	3950 3900 4450 3900
Wire Wire Line
	3950 4000 4450 4000
Wire Wire Line
	3950 4100 4450 4100
Wire Wire Line
	3950 4200 4450 4200
Wire Wire Line
	3950 4300 4450 4300
Wire Wire Line
	3950 4400 4450 4400
Wire Wire Line
	3950 4500 4450 4500
Wire Wire Line
	3950 4600 4200 4600
Wire Wire Line
	3950 4700 4450 4700
Wire Wire Line
	3950 4800 4450 4800
Wire Wire Line
	4450 4900 3950 4900
$Comp
L power:GND #PWR0101
U 1 1 5F352F6F
P 4200 5000
F 0 "#PWR0101" H 4200 4750 50  0001 C CNN
F 1 "GND" H 4205 4827 50  0000 C CNN
F 2 "" H 4200 5000 50  0001 C CNN
F 3 "" H 4200 5000 50  0001 C CNN
	1    4200 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4200 5000 4200 4600
Connection ~ 4200 4600
Wire Wire Line
	4200 4600 4450 4600
$Comp
L power:VCC #PWR0102
U 1 1 5F35432A
P 3200 2850
F 0 "#PWR0102" H 3200 2700 50  0001 C CNN
F 1 "VCC" H 3217 3023 50  0000 C CNN
F 2 "" H 3200 2850 50  0001 C CNN
F 3 "" H 3200 2850 50  0001 C CNN
	1    3200 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 2850 3200 3400
Connection ~ 3200 3400
Wire Wire Line
	3200 3400 3450 3400
$Comp
L Connector:Conn_01x08_Female J4
U 1 1 5F357049
P 5350 3300
F 0 "J4" H 5378 3276 50  0000 L CNN
F 1 "DATA" H 5378 3185 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 5350 3300 50  0001 C CNN
F 3 "~" H 5350 3300 50  0001 C CNN
	1    5350 3300
	1    0    0    -1  
$EndComp
Text Label 4100 3400 0    50   ~ 0
D0
Text Label 4100 3500 0    50   ~ 0
D2
Text Label 4100 3600 0    50   ~ 0
D4
Text Label 4100 3700 0    50   ~ 0
D6
Wire Wire Line
	5150 3000 5000 3000
Text Label 5000 3000 0    50   ~ 0
D0
Wire Wire Line
	5150 3200 5000 3200
Text Label 5000 3200 0    50   ~ 0
D2
Wire Wire Line
	5150 3400 5000 3400
Text Label 5000 3400 0    50   ~ 0
D4
Wire Wire Line
	5150 3600 5000 3600
Text Label 5000 3600 0    50   ~ 0
D6
Text Label 3200 3500 0    50   ~ 0
D1
Text Label 3200 3600 0    50   ~ 0
D3
Text Label 3200 3700 0    50   ~ 0
D5
Text Label 3200 3800 0    50   ~ 0
D7
Wire Wire Line
	5150 3100 5000 3100
Wire Wire Line
	5150 3300 5000 3300
Wire Wire Line
	5150 3500 5000 3500
Wire Wire Line
	5150 3700 5000 3700
Text Label 5000 3100 0    50   ~ 0
D1
Text Label 5000 3300 0    50   ~ 0
D3
Text Label 5000 3500 0    50   ~ 0
D5
Text Label 5000 3700 0    50   ~ 0
D7
$EndSCHEMATC
