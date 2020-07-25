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
L power:VCC #PWR0101
U 1 1 5F179ABD
P 2100 1100
F 0 "#PWR0101" H 2100 950 50  0001 C CNN
F 1 "VCC" H 2117 1273 50  0000 C CNN
F 2 "" H 2100 1100 50  0001 C CNN
F 3 "" H 2100 1100 50  0001 C CNN
	1    2100 1100
	-1   0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 5F17B7EF
P 6250 1150
F 0 "C1" V 5998 1150 50  0000 C CNN
F 1 "100nF" V 6089 1150 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 6288 1000 50  0001 C CNN
F 3 "~" H 6250 1150 50  0001 C CNN
	1    6250 1150
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5F17C890
P 6650 1150
F 0 "#PWR0102" H 6650 900 50  0001 C CNN
F 1 "GND" H 6655 977 50  0000 C CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 6650 1150 50  0001 C CNN
F 3 "" H 6650 1150 50  0001 C CNN
	1    6650 1150
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x06_Female J1
U 1 1 5F176035
P 1500 2050
F 0 "J1" H 1392 2435 50  0000 C CNN
F 1 "TTL Serial" H 1392 2344 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical" H 1500 2050 50  0001 C CNN
F 3 "~" H 1500 2050 50  0001 C CNN
	1    1500 2050
	-1   0    0    -1  
$EndComp
$Comp
L Interface_UART:MAX3222CPN+ U1
U 1 1 5F185A71
P 5350 2450
F 0 "U1" H 5350 3620 50  0000 C CNN
F 1 "MAX3222CPN+" H 5350 3529 50  0000 C CNN
F 2 "Package_DIP:DIP-18_W7.62mm" H 5350 2450 50  0001 L BNN
F 3 "IPC 7351B" H 5350 2450 50  0001 L BNN
F 4 "Maxim Integrated" H 5350 2450 50  0001 L BNN "Field4"
F 5 "10" H 5350 2450 50  0001 L BNN "Field5"
F 6 "4.57mm" H 5350 2450 50  0001 L BNN "Field6"
	1    5350 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 1150 2100 1100
Wire Wire Line
	6250 2350 6050 2350
Wire Wire Line
	6150 2450 6050 2450
Connection ~ 2100 1150
Wire Wire Line
	6050 3350 6500 3350
$Comp
L power:GND #PWR0103
U 1 1 5F1958B1
P 6500 3350
F 0 "#PWR0103" H 6500 3100 50  0001 C CNN
F 1 "GND" H 6505 3177 50  0000 C CNN
F 2 "" H 6500 3350 50  0001 C CNN
F 3 "" H 6500 3350 50  0001 C CNN
	1    6500 3350
	1    0    0    -1  
$EndComp
$Comp
L Connector:DB9_Male J2
U 1 1 5F19758D
P 7350 1550
F 0 "J2" H 7530 1596 50  0000 L CNN
F 1 "RS232" H 7530 1505 50  0000 L CNN
F 2 "Connector_Dsub:DSUB-9_Male_Horizontal_P2.77x2.84mm_EdgePinOffset4.94mm_Housed_MountingHolesOffset7.48mm" H 7350 1550 50  0001 C CNN
F 3 " ~" H 7350 1550 50  0001 C CNN
	1    7350 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7050 1150 6650 1150
Wire Wire Line
	4650 2350 4300 2350
Wire Wire Line
	4300 2350 4300 4000
Wire Wire Line
	4300 4000 6850 4000
Wire Wire Line
	6850 4000 6850 1550
Wire Wire Line
	6850 1550 7050 1550
Wire Wire Line
	6050 2050 6700 2050
Wire Wire Line
	6700 2050 6700 1750
Wire Wire Line
	6700 1750 7050 1750
Wire Wire Line
	6050 2150 6950 2150
Wire Wire Line
	6950 2150 6950 1850
Wire Wire Line
	6950 1850 7050 1850
Wire Wire Line
	4650 2450 4400 2450
Wire Wire Line
	4400 2450 4400 4100
Wire Wire Line
	4400 4100 6750 4100
Wire Wire Line
	6750 4100 6750 1350
Wire Wire Line
	6750 1350 7050 1350
Text Label 2650 5400 0    50   ~ 0
ENABLE
Text Label 4300 1750 0    50   ~ 0
ENABLE
Wire Wire Line
	4650 1750 4300 1750
Wire Wire Line
	1700 1850 2100 1850
Wire Wire Line
	2100 1150 2100 1850
Wire Wire Line
	1700 2350 1700 4450
Wire Wire Line
	1800 2250 1700 2250
Wire Wire Line
	1700 2150 1900 2150
Wire Wire Line
	1900 2150 1900 4900
Wire Wire Line
	1900 4900 3000 4900
Wire Wire Line
	4000 4900 4500 4900
Wire Wire Line
	4500 2050 4650 2050
Wire Wire Line
	1700 2050 2000 2050
Wire Wire Line
	2000 2050 2000 5000
Wire Wire Line
	2000 5000 3000 5000
Wire Wire Line
	4000 5000 4600 5000
Wire Wire Line
	4600 2150 4650 2150
$Comp
L Device:C C2
U 1 1 5F1D39A6
P 6350 1850
F 0 "C2" V 6098 1850 50  0000 C CNN
F 1 "100nF" V 6189 1850 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 6388 1700 50  0001 C CNN
F 3 "~" H 6350 1850 50  0001 C CNN
	1    6350 1850
	0    1    1    0   
$EndComp
Wire Wire Line
	6050 1850 6200 1850
$Comp
L power:GND #PWR0104
U 1 1 5F1D529E
P 6600 1850
F 0 "#PWR0104" H 6600 1600 50  0001 C CNN
F 1 "GND" H 6605 1677 50  0000 C CNN
F 2 "" H 6600 1850 50  0001 C CNN
F 3 "" H 6600 1850 50  0001 C CNN
	1    6600 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	6500 1850 6600 1850
$Comp
L Device:C C3
U 1 1 5F1D6A91
P 6350 1500
F 0 "C3" V 6098 1500 50  0000 C CNN
F 1 "100nF" V 6189 1500 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 6388 1350 50  0001 C CNN
F 3 "~" H 6350 1500 50  0001 C CNN
	1    6350 1500
	0    1    1    0   
$EndComp
Wire Wire Line
	6200 1500 6200 1750
Wire Wire Line
	6200 1750 6050 1750
Wire Wire Line
	6500 1500 6600 1500
Wire Wire Line
	6600 1500 6600 1850
Connection ~ 6600 1850
$Comp
L Device:C C4
U 1 1 5F1DA101
P 4050 2650
F 0 "C4" V 3798 2650 50  0000 C CNN
F 1 "100nF" V 3889 2650 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 4088 2500 50  0001 C CNN
F 3 "~" H 4050 2650 50  0001 C CNN
	1    4050 2650
	0    1    1    0   
$EndComp
Wire Wire Line
	4650 2650 4200 2650
Wire Wire Line
	3900 2650 3850 2650
Wire Wire Line
	3850 2650 3850 2750
Wire Wire Line
	3850 2750 4650 2750
$Comp
L Device:C C5
U 1 1 5F1DDE8B
P 4050 3050
F 0 "C5" V 4302 3050 50  0000 C CNN
F 1 "100nF" V 4211 3050 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 4088 2900 50  0001 C CNN
F 3 "~" H 4050 3050 50  0001 C CNN
	1    4050 3050
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4200 3050 4650 3050
Wire Wire Line
	4650 2950 3900 2950
Wire Wire Line
	3900 2950 3900 3050
Wire Wire Line
	1700 1950 2100 1950
Wire Wire Line
	2100 1950 2100 2200
$Comp
L power:GND #PWR0105
U 1 1 5F1E4975
P 2100 2200
F 0 "#PWR0105" H 2100 1950 50  0001 C CNN
F 1 "GND" H 2105 2027 50  0000 C CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 2100 2200 50  0001 C CNN
F 3 "" H 2100 2200 50  0001 C CNN
	1    2100 2200
	1    0    0    -1  
$EndComp
Connection ~ 2100 1850
Wire Wire Line
	2100 1850 4650 1850
$Comp
L power:GND #PWR0106
U 1 1 5F1EB695
P 3500 5850
F 0 "#PWR0106" H 3500 5600 50  0001 C CNN
F 1 "GND" H 3505 5677 50  0000 C CNN
F 2 "" H 3500 5850 50  0001 C CNN
F 3 "" H 3500 5850 50  0001 C CNN
	1    3500 5850
	1    0    0    -1  
$EndComp
NoConn ~ 7050 1250
NoConn ~ 7050 1450
NoConn ~ 7050 1650
NoConn ~ 7050 1950
Text Label 2850 4450 0    50   ~ 0
RX
Text Label 2800 4900 0    50   ~ 0
TX
Wire Wire Line
	9750 4700 10150 4700
Wire Wire Line
	9750 4600 10150 4600
Text Label 10150 4700 0    50   ~ 0
RX
Text Label 10150 4600 0    50   ~ 0
TX
Wire Wire Line
	9750 5500 10200 5500
$Comp
L power:GND #PWR0110
U 1 1 5F208DD8
P 10200 5800
F 0 "#PWR0110" H 10200 5550 50  0001 C CNN
F 1 "GND" H 10205 5627 50  0000 C CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 10200 5800 50  0001 C CNN
F 3 "" H 10200 5800 50  0001 C CNN
	1    10200 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	9750 4300 10150 4300
Wire Wire Line
	10150 4300 10150 3950
$Comp
L power:VCC #PWR0111
U 1 1 5F20BCCF
P 10150 3750
F 0 "#PWR0111" H 10150 3600 50  0001 C CNN
F 1 "VCC" H 10167 3923 50  0000 C CNN
F 2 "" H 10150 3750 50  0001 C CNN
F 3 "" H 10150 3750 50  0001 C CNN
	1    10150 3750
	1    0    0    -1  
$EndComp
$Comp
L Connector:USB_B J3
U 1 1 5F20CBD6
P 8150 5750
F 0 "J3" V 8253 6080 50  0000 L CNN
F 1 "USB_B" V 8162 6080 50  0000 L CNN
F 2 "Connector_USB:USB_B_OST_USB-B1HSxx_Horizontal" H 8300 5700 50  0001 C CNN
F 3 " ~" H 8300 5700 50  0001 C CNN
	1    8150 5750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8550 5200 8150 5200
Wire Wire Line
	8150 5200 8150 5450
Wire Wire Line
	8250 5450 8250 5100
Wire Wire Line
	8250 5100 8550 5100
Connection ~ 10200 5750
Wire Wire Line
	10200 5750 10200 5800
Wire Wire Line
	10200 5500 10200 5750
Wire Wire Line
	8550 4600 8150 4600
Text Label 8150 4600 0    50   ~ 0
ENABLE
NoConn ~ 9750 5100
NoConn ~ 9750 5200
$Comp
L Connector:Conn_01x03_Male JP1
U 1 1 5F233453
P 9650 1550
F 0 "JP1" H 9758 1831 50  0000 C CNN
F 1 "USB_SEL" H 9758 1740 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 9650 1550 50  0001 C CNN
F 3 "~" H 9650 1550 50  0001 C CNN
	1    9650 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	9850 1550 10300 1550
Text Label 10300 1550 0    50   ~ 0
ENABLE
Wire Wire Line
	9850 1450 10150 1450
Wire Wire Line
	10150 1450 10150 1350
Wire Wire Line
	9850 1650 10150 1650
Wire Wire Line
	10150 1650 10150 1850
$Comp
L power:VCC #PWR0112
U 1 1 5F23D42C
P 10150 1350
F 0 "#PWR0112" H 10150 1200 50  0001 C CNN
F 1 "VCC" H 10167 1523 50  0000 C CNN
F 2 "" H 10150 1350 50  0001 C CNN
F 3 "" H 10150 1350 50  0001 C CNN
	1    10150 1350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 5F23DBFE
P 10150 1850
F 0 "#PWR0113" H 10150 1600 50  0001 C CNN
F 1 "GND" H 10155 1677 50  0000 C CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 10150 1850 50  0001 C CNN
F 3 "" H 10150 1850 50  0001 C CNN
	1    10150 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 1150 6100 1150
Wire Wire Line
	6050 1550 6100 1550
Wire Wire Line
	6100 1550 6100 1150
Connection ~ 6100 1150
$Comp
L Device:C C6
U 1 1 5F24C556
P 10450 4400
F 0 "C6" V 10198 4400 50  0000 C CNN
F 1 "100nF" V 10289 4400 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 10488 4250 50  0001 C CNN
F 3 "~" H 10450 4400 50  0001 C CNN
	1    10450 4400
	0    1    1    0   
$EndComp
Wire Wire Line
	9750 4400 10300 4400
Wire Wire Line
	10600 4400 10700 4400
Wire Wire Line
	10700 4400 10700 4600
$Comp
L power:GND #PWR0114
U 1 1 5F2527FC
P 10700 4600
F 0 "#PWR0114" H 10700 4350 50  0001 C CNN
F 1 "GND" H 10705 4427 50  0000 C CNN
F 2 "" H 10700 4600 50  0001 C CNN
F 3 "" H 10700 4600 50  0001 C CNN
	1    10700 4600
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0115
U 1 1 5F2535A5
P 3500 4000
F 0 "#PWR0115" H 3500 3850 50  0001 C CNN
F 1 "VCC" H 3500 4150 50  0000 C CNN
F 2 "" H 3500 4000 50  0001 C CNN
F 3 "" H 3500 4000 50  0001 C CNN
	1    3500 4000
	1    0    0    -1  
$EndComp
Connection ~ 6650 1150
Wire Wire Line
	6400 1150 6650 1150
$Comp
L Device:C C7
U 1 1 5F286353
P 10450 3950
F 0 "C7" V 10198 3950 50  0000 C CNN
F 1 "100nF" V 10289 3950 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 10488 3800 50  0001 C CNN
F 3 "~" H 10450 3950 50  0001 C CNN
	1    10450 3950
	0    1    1    0   
$EndComp
Wire Wire Line
	10150 3950 10300 3950
Wire Wire Line
	10600 3950 10700 3950
Wire Wire Line
	10700 3950 10700 4400
Connection ~ 10700 4400
$Comp
L Device:C C8
U 1 1 5F28E779
P 3800 4100
F 0 "C8" V 3548 4100 50  0000 C CNN
F 1 "100nF" V 3639 4100 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 3838 3950 50  0001 C CNN
F 3 "~" H 3800 4100 50  0001 C CNN
	1    3800 4100
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 5F293254
P 4100 4100
F 0 "#PWR0116" H 4100 3850 50  0001 C CNN
F 1 "GND" H 4105 3927 50  0000 C CNN
F 2 "" H 4100 4100 50  0001 C CNN
F 3 "" H 4100 4100 50  0001 C CNN
	1    4100 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 4000 3500 4100
Wire Wire Line
	3500 4100 3650 4100
Wire Wire Line
	3950 4100 4100 4100
$Comp
L 74xx:74LS365 U2
U 1 1 5F2AE17D
P 3500 5100
F 0 "U2" H 3500 5981 50  0000 C CNN
F 1 "74LS365" H 3500 5890 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 3500 5100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS365" H 3500 5100 50  0001 C CNN
	1    3500 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 2350 6250 4550
Wire Wire Line
	4500 4900 4500 2050
Wire Wire Line
	4600 5000 4600 2150
Wire Wire Line
	3500 4100 3500 4400
Connection ~ 3500 4100
Wire Wire Line
	3500 5800 3500 5850
Wire Wire Line
	2650 5400 3000 5400
Connection ~ 3000 5400
Wire Wire Line
	3000 5400 3000 5500
$Comp
L Connector:Conn_01x03_Male J4
U 1 1 5F313146
P 7450 4900
F 0 "J4" H 7558 5181 50  0000 C CNN
F 1 "I2C" H 7558 5090 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 7450 4900 50  0001 C CNN
F 3 "~" H 7450 4900 50  0001 C CNN
	1    7450 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 4800 7750 4800
Wire Wire Line
	8550 4900 7950 4900
$Comp
L power:GND #PWR0107
U 1 1 5F31E7D8
P 7750 5000
F 0 "#PWR0107" H 7750 4750 50  0001 C CNN
F 1 "GND" H 7755 4827 50  0000 C CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 7750 5000 50  0001 C CNN
F 3 "" H 7750 5000 50  0001 C CNN
	1    7750 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 5000 7750 5000
$Comp
L Device:R R1
U 1 1 5F3220B5
P 7750 4500
F 0 "R1" H 7820 4546 50  0000 L CNN
F 1 "4k7" H 7820 4455 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 7680 4500 50  0001 C CNN
F 3 "~" H 7750 4500 50  0001 C CNN
	1    7750 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F322DCC
P 7950 4500
F 0 "R2" H 8020 4546 50  0000 L CNN
F 1 "4k7" H 8020 4455 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 7880 4500 50  0001 C CNN
F 3 "~" H 7950 4500 50  0001 C CNN
	1    7950 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7750 4350 7750 4250
Wire Wire Line
	7750 4250 7950 4250
Wire Wire Line
	7950 4250 7950 4350
Wire Wire Line
	7750 4650 7750 4800
Connection ~ 7750 4800
Wire Wire Line
	7750 4800 8550 4800
Wire Wire Line
	7950 4650 7950 4900
Connection ~ 7950 4900
Wire Wire Line
	7950 4900 7650 4900
$Comp
L power:VCC #PWR0108
U 1 1 5F32DB8E
P 7950 4100
F 0 "#PWR0108" H 7950 3950 50  0001 C CNN
F 1 "VCC" H 7967 4273 50  0000 C CNN
F 2 "" H 7950 4100 50  0001 C CNN
F 3 "" H 7950 4100 50  0001 C CNN
	1    7950 4100
	1    0    0    -1  
$EndComp
NoConn ~ 3000 5100
NoConn ~ 3000 5200
NoConn ~ 4000 5200
NoConn ~ 4000 5100
Wire Wire Line
	8550 5750 10200 5750
Wire Wire Line
	8550 5850 8700 5850
Wire Wire Line
	8700 5850 8700 6000
$Comp
L Device:C C9
U 1 1 5F3626B9
P 8700 6150
F 0 "C9" H 8585 6104 50  0000 R CNN
F 1 "47uF" H 8585 6195 50  0000 R CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 8738 6000 50  0001 C CNN
F 3 "~" H 8700 6150 50  0001 C CNN
	1    8700 6150
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0109
U 1 1 5F362F8C
P 8700 6300
F 0 "#PWR0109" H 8700 6050 50  0001 C CNN
F 1 "GND" H 8705 6127 50  0000 C CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 8700 6300 50  0001 C CNN
F 3 "" H 8700 6300 50  0001 C CNN
	1    8700 6300
	1    0    0    -1  
$EndComp
$Comp
L Interface_USB:MCP2221A-I_SL U3
U 1 1 5F200371
P 9150 4900
F 0 "U3" H 9150 5767 50  0000 C CNN
F 1 "MCP2221A-I_SL" H 9150 5676 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket" H 9150 4900 50  0001 L BNN
F 3 "IPC7351B" H 9150 4900 50  0001 L BNN
F 4 "Microchip" H 9150 4900 50  0001 L BNN "Field4"
	1    9150 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	9750 4900 10150 4900
Wire Wire Line
	9750 5000 10150 5000
Text Label 10150 4900 0    50   ~ 0
LED_URX
Text Label 10150 5000 0    50   ~ 0
LED_UTX
$Comp
L Device:R R3
U 1 1 5F372BC6
P 8750 2800
F 0 "R3" H 8820 2846 50  0000 L CNN
F 1 "4k7" H 8820 2755 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 8680 2800 50  0001 C CNN
F 3 "~" H 8750 2800 50  0001 C CNN
	1    8750 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5F37338B
P 9250 2800
F 0 "R4" H 9320 2846 50  0000 L CNN
F 1 "4k7" H 9320 2755 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P10.16mm_Horizontal" V 9180 2800 50  0001 C CNN
F 3 "~" H 9250 2800 50  0001 C CNN
	1    9250 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5F37A803
P 8750 3200
F 0 "D1" V 8789 3083 50  0000 R CNN
F 1 "URX" V 8698 3083 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 8750 3200 50  0001 C CNN
F 3 "~" H 8750 3200 50  0001 C CNN
	1    8750 3200
	0    -1   -1   0   
$EndComp
$Comp
L Device:LED D2
U 1 1 5F3895ED
P 9250 3200
F 0 "D2" V 9289 3083 50  0000 R CNN
F 1 "UTX" V 9198 3083 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 9250 3200 50  0001 C CNN
F 3 "~" H 9250 3200 50  0001 C CNN
	1    9250 3200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	8750 3050 8750 2950
Wire Wire Line
	9250 3050 9250 2950
Wire Wire Line
	8750 3350 8750 3550
Wire Wire Line
	9250 3350 9250 3550
$Comp
L power:VCC #PWR0117
U 1 1 5F3980F0
P 8750 2500
F 0 "#PWR0117" H 8750 2350 50  0001 C CNN
F 1 "VCC" H 8767 2673 50  0000 C CNN
F 2 "" H 8750 2500 50  0001 C CNN
F 3 "" H 8750 2500 50  0001 C CNN
	1    8750 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	8750 2650 8750 2550
Wire Wire Line
	8750 2550 9250 2550
Wire Wire Line
	9250 2550 9250 2650
Connection ~ 8750 2550
Wire Wire Line
	8750 2550 8750 2500
Text Label 8750 3550 0    50   ~ 0
LED_URX
Text Label 9250 3550 0    50   ~ 0
LED_UTX
Wire Wire Line
	4100 4450 4100 4700
Wire Wire Line
	4100 4700 4000 4700
Wire Wire Line
	1700 4450 4100 4450
Wire Wire Line
	3000 4700 3000 4550
Wire Wire Line
	3000 4550 6250 4550
Wire Wire Line
	6150 6150 2450 6150
Wire Wire Line
	2450 6150 2450 4800
Wire Wire Line
	2450 4800 3000 4800
Wire Wire Line
	6150 2450 6150 6150
Wire Wire Line
	1800 6300 4100 6300
Wire Wire Line
	4100 6300 4100 4800
Wire Wire Line
	4100 4800 4000 4800
Wire Wire Line
	1800 2250 1800 6300
NoConn ~ 7950 5450
Wire Wire Line
	10150 3950 10150 3750
Connection ~ 10150 3950
Wire Wire Line
	7950 4250 7950 4100
Connection ~ 7950 4250
$EndSCHEMATC
