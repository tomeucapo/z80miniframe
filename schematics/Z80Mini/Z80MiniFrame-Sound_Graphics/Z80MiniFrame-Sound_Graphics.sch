EESchema Schematic File Version 4
LIBS:Z80MiniFrame-Sound_Graphics-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 3
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
U 1 1 5D7098FA
P 2100 5300
F 0 "J1" H 2150 6417 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 2150 6326 50  0000 C CNN
F 2 "Connector:Connector_CardEdge_40" H 2100 5300 50  0001 C CNN
F 3 "~" H 2100 5300 50  0001 C CNN
	1    2100 5300
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0101
U 1 1 5D71EB15
P 1800 4800
F 0 "#PWR0101" H 1800 4650 50  0001 C CNN
F 1 "VCC" V 1818 4927 50  0000 L CNN
F 2 "" H 1800 4800 50  0001 C CNN
F 3 "" H 1800 4800 50  0001 C CNN
	1    1800 4800
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2700 6550 2700 6000
Wire Wire Line
	2700 6000 2400 6000
$Comp
L power:GND #PWR0102
U 1 1 5D7227B9
P 2700 6550
F 0 "#PWR0102" H 2700 6300 50  0001 C CNN
F 1 "GND" H 2705 6377 50  0000 C CNN
F 2 "" H 2700 6550 50  0001 C CNN
F 3 "" H 2700 6550 50  0001 C CNN
	1    2700 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1700 4600 1900 4600
Wire Bus Line
	4800 2450 5050 2450
Wire Bus Line
	4800 3800 5050 3800
Wire Bus Line
	4800 2450 4800 3800
Text Label 4800 3550 1    50   ~ 0
D[0..7]
$Sheet
S 5050 3650 900  1250
U 5D79B46A
F0 "graphicsProcessor" 50
F1 "graphicsProcessor.sch" 50
F2 "D[0..7]" B L 5050 3800 50 
F3 "RESET" I L 5050 3950 50 
F4 "A1" I L 5050 4100 50 
F5 "RD" I L 5050 4250 50 
F6 "WR" I L 5050 4400 50 
F7 "IORQ" I L 5050 4550 50 
F8 "VD_SEL" I R 5950 4750 50 
F9 "INT" O L 5050 4750 50 
F10 "EXTV" O R 5950 4500 50 
F11 "COMVID" O R 5950 4650 50 
$EndSheet
$Sheet
S 5050 2100 900  1250
U 5D76ACBB
F0 "soundGeneration" 50
F1 "sound.sch" 50
F2 "RESET" I L 5050 2600 50 
F3 "D[0..7]" B L 5050 2450 50 
F4 "A0" I L 5050 2300 50 
F5 "SND_SEL" I R 5950 3200 50 
F6 "COMVID" I R 5950 3050 50 
F7 "EXTVDP" I R 5950 2900 50 
$EndSheet
Wire Wire Line
	1000 2300 5050 2300
Wire Wire Line
	1000 5300 1900 5300
Wire Wire Line
	1000 2300 1000 5300
Wire Wire Line
	5050 2600 4950 2600
Wire Wire Line
	1700 2600 1700 4600
Wire Bus Line
	4800 3800 2700 3800
Connection ~ 4800 3800
Entry Wire Line
	2700 5000 2600 5100
Entry Wire Line
	2700 4900 2600 5000
Entry Wire Line
	2700 4800 2600 4900
Entry Wire Line
	2700 4700 2600 4800
Wire Wire Line
	2600 5100 2400 5100
Wire Wire Line
	2600 5000 2400 5000
Wire Wire Line
	2600 4900 2400 4900
Wire Wire Line
	2600 4800 2400 4800
Text Label 4300 3800 0    50   ~ 0
D[0..7]
Text Label 2500 4800 0    50   ~ 0
D0
Text Label 2500 4900 0    50   ~ 0
D2
Text Label 2500 5000 0    50   ~ 0
D4
Text Label 2500 5100 0    50   ~ 0
D6
Wire Bus Line
	2700 3800 1600 3800
Connection ~ 2700 3800
Entry Wire Line
	1600 5100 1700 5200
Entry Wire Line
	1600 5000 1700 5100
Entry Wire Line
	1600 4900 1700 5000
Entry Wire Line
	1600 4800 1700 4900
Wire Wire Line
	1700 4900 1900 4900
Wire Wire Line
	1900 5000 1700 5000
Wire Wire Line
	1700 5100 1900 5100
Wire Wire Line
	1900 5200 1700 5200
Text Label 1750 4900 0    50   ~ 0
D1
Text Label 1750 5000 0    50   ~ 0
D3
Text Label 1750 5100 0    50   ~ 0
D5
Text Label 1750 5200 0    50   ~ 0
D7
Wire Wire Line
	1800 4800 1900 4800
Wire Wire Line
	5050 3950 4950 3950
Wire Wire Line
	4950 3950 4950 2600
Connection ~ 4950 2600
Wire Wire Line
	4950 2600 1700 2600
Wire Wire Line
	2400 5300 4200 5300
Wire Wire Line
	4200 5300 4200 4100
Wire Wire Line
	5050 4250 2950 4250
Wire Wire Line
	2950 4250 2950 4700
Wire Wire Line
	7000 3200 5950 3200
Wire Wire Line
	6600 4750 5950 4750
NoConn ~ 2400 6200
NoConn ~ 2400 5900
NoConn ~ 2400 5800
NoConn ~ 2400 5700
NoConn ~ 2400 5600
NoConn ~ 2400 5400
NoConn ~ 2400 4500
NoConn ~ 1900 4400
NoConn ~ 1900 4500
NoConn ~ 1900 4700
NoConn ~ 1900 5400
NoConn ~ 1900 5600
NoConn ~ 1900 5700
NoConn ~ 1900 5800
NoConn ~ 1900 5900
NoConn ~ 1900 6100
NoConn ~ 1900 6200
NoConn ~ 1900 6300
Wire Wire Line
	4300 5200 4300 4400
Wire Wire Line
	2400 5200 4300 5200
Wire Wire Line
	4300 4400 5050 4400
Wire Wire Line
	4200 4100 5050 4100
NoConn ~ 2400 5500
NoConn ~ 1900 5500
NoConn ~ -2400 5000
Wire Wire Line
	6600 4750 6600 6950
Wire Wire Line
	6600 6950 1650 6950
Wire Wire Line
	1650 6950 1650 6000
Wire Wire Line
	1650 6000 1900 6000
Wire Wire Line
	2400 6100 7000 6100
Wire Wire Line
	7000 6100 7000 3200
Wire Wire Line
	5950 3050 6100 3050
Wire Wire Line
	6100 3050 6100 4650
Wire Wire Line
	6100 4650 5950 4650
Wire Wire Line
	5950 4500 6200 4500
Wire Wire Line
	6200 4500 6200 2900
Wire Wire Line
	6200 2900 5950 2900
Wire Wire Line
	2500 4600 2400 4600
Wire Wire Line
	2500 4550 2500 4600
Wire Wire Line
	2500 4550 5050 4550
Wire Wire Line
	3100 4400 2400 4400
$Comp
L Device:Jumper_NC_Dual JP3
U 1 1 5DF3C247
P 4500 5500
F 0 "JP3" H 4500 5647 50  0000 C CNN
F 1 "Jumper_NC_Dual" H 4500 5738 50  0000 C CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_1x03_P2.00mm_Vertical" H 4500 5500 50  0001 C CNN
F 3 "~" H 4500 5500 50  0001 C CNN
	1    4500 5500
	-1   0    0    1   
$EndComp
Wire Wire Line
	3100 5500 4250 5500
Wire Wire Line
	3100 4400 3100 5500
Wire Wire Line
	4500 5400 4500 4750
Wire Wire Line
	4500 4750 5050 4750
Wire Wire Line
	4750 5500 5100 5500
Wire Wire Line
	5100 5500 5100 6300
Wire Wire Line
	5100 6300 2400 6300
Wire Wire Line
	2400 4700 2950 4700
Wire Bus Line
	1600 3800 1600 5100
Wire Bus Line
	2700 3800 2700 5000
$EndSCHEMATC
