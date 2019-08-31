EESchema Schematic File Version 4
LIBS:Z80Mini-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 2
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
L CPU:Z80CPU U1
U 1 1 5D3D6136
P 3000 3700
F 0 "U1" H 3000 5381 50  0000 C CNN
F 1 "Z80CPU" H 3000 5290 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_LongPads" H 3000 5289 50  0001 C CNN
F 3 "www.zilog.com/manage_directlink.php?filepath=docs/z80/um0080" H 3000 4100 50  0001 C CNN
	1    3000 3700
	1    0    0    -1  
$EndComp
$Comp
L Z80Mini-rescue:AT28C64B-15PU-Memory_EEPROM U3
U 1 1 5D3D9F2C
P 6450 2650
F 0 "U3" H 7000 2915 50  0000 C CNN
F 1 "AT28C64B-15PU" H 7000 2824 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_LongPads" H 7400 2750 50  0001 L CNN
F 3 "https://componentsearchengine.com/Datasheets/1/AT28C64B-15PU.pdf" H 7400 2650 50  0001 L CNN
F 4 "AT28C64B-15PU, Parallel EEPROM Memory 64kbit, Parallel, 150ns 4.5  5.5 V, 28-Pin PDIP" H 7400 2550 50  0001 L CNN "Description"
F 5 "4.826" H 7400 2450 50  0001 L CNN "Height"
F 6 "556-AT28C64B15PU" H 7400 2350 50  0001 L CNN "Mouser Part Number"
F 7 "https://www.mouser.com/Search/Refine.aspx?Keyword=556-AT28C64B15PU" H 7400 2250 50  0001 L CNN "Mouser Price/Stock"
F 8 "Microchip" H 7400 2150 50  0001 L CNN "Manufacturer_Name"
F 9 "AT28C64B-15PU" H 7400 2050 50  0001 L CNN "Manufacturer_Part_Number"
	1    6450 2650
	1    0    0    -1  
$EndComp
$Comp
L Z80Mini-rescue:TC55257CPI-Memory_RAM U2
U 1 1 5D3DEAED
P 4950 2500
F 0 "U2" H 5000 2615 50  0000 C CNN
F 1 "TC55257CPI" H 5000 2524 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_LongPads" H 5000 2523 50  0001 C CNN
F 3 "" H 4950 2500 50  0001 C CNN
	1    4950 2500
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U5
U 1 1 5D3F21D1
P 2350 6500
F 0 "U5" H 2350 6183 50  0000 C CNN
F 1 "74HC14" H 2350 6274 50  0000 C CNN
F 2 "" H 2350 6500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 2350 6500 50  0001 C CNN
	1    2350 6500
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74HC14 U5
U 2 1 5D3F44A8
P 1450 6500
F 0 "U5" H 1450 6183 50  0000 C CNN
F 1 "74HC14" H 1450 6274 50  0000 C CNN
F 2 "" H 1450 6500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 1450 6500 50  0001 C CNN
	2    1450 6500
	-1   0    0    1   
$EndComp
Wire Wire Line
	1750 6500 1900 6500
$Comp
L power:GND #PWR0101
U 1 1 5D3F921F
P 3000 5350
F 0 "#PWR0101" H 3000 5100 50  0001 C CNN
F 1 "GND" H 3005 5177 50  0000 C CNN
F 2 "" H 3000 5350 50  0001 C CNN
F 3 "" H 3000 5350 50  0001 C CNN
	1    3000 5350
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 5350 3000 5200
Wire Wire Line
	750  6500 1150 6500
$Comp
L Device:R R2
U 1 1 5D3FF853
P 3000 6250
F 0 "R2" H 3070 6296 50  0000 L CNN
F 1 "10K" H 3070 6205 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 2930 6250 50  0001 C CNN
F 3 "~" H 3000 6250 50  0001 C CNN
	1    3000 6250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 5D400344
P 3000 6700
F 0 "C6" H 3115 6746 50  0000 L CNN
F 1 "100nF" H 3115 6655 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 3038 6550 50  0001 C CNN
F 3 "~" H 3000 6700 50  0001 C CNN
	1    3000 6700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5D400BB4
P 3000 6950
F 0 "#PWR0102" H 3000 6700 50  0001 C CNN
F 1 "GND" H 3005 6777 50  0000 C CNN
F 2 "" H 3000 6950 50  0001 C CNN
F 3 "" H 3000 6950 50  0001 C CNN
	1    3000 6950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 6500 3000 6500
Wire Wire Line
	3000 6500 3000 6400
Wire Wire Line
	3000 6500 3000 6550
Connection ~ 3000 6500
Wire Wire Line
	3000 6850 3000 6950
Wire Wire Line
	3000 6500 3200 6500
$Comp
L Device:R R3
U 1 1 5D40206D
P 3350 6500
F 0 "R3" V 3143 6500 50  0000 C CNN
F 1 "10" V 3234 6500 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 3280 6500 50  0001 C CNN
F 3 "~" H 3350 6500 50  0001 C CNN
	1    3350 6500
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR0103
U 1 1 5D402B40
P 3000 6050
F 0 "#PWR0103" H 3000 5900 50  0001 C CNN
F 1 "VCC" H 3017 6223 50  0000 C CNN
F 2 "" H 3000 6050 50  0001 C CNN
F 3 "" H 3000 6050 50  0001 C CNN
	1    3000 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 6100 3000 6050
$Comp
L power:GND #PWR0104
U 1 1 5D403650
P 4500 4100
F 0 "#PWR0104" H 4500 3850 50  0001 C CNN
F 1 "GND" H 4505 3927 50  0000 C CNN
F 2 "" H 4500 4100 50  0001 C CNN
F 3 "" H 4500 4100 50  0001 C CNN
	1    4500 4100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 5D403A49
P 6400 4100
F 0 "#PWR0105" H 6400 3850 50  0001 C CNN
F 1 "GND" H 6405 3927 50  0000 C CNN
F 2 "" H 6400 4100 50  0001 C CNN
F 3 "" H 6400 4100 50  0001 C CNN
	1    6400 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6450 3950 6400 3950
Wire Wire Line
	6400 3950 6400 4100
Wire Wire Line
	4550 3950 4500 3950
Wire Wire Line
	4500 3950 4500 4100
Entry Wire Line
	3850 3800 3950 3700
Entry Wire Line
	3850 3700 3950 3600
Entry Wire Line
	3850 3600 3950 3500
Entry Wire Line
	3850 3500 3950 3400
Entry Wire Line
	3850 3500 3950 3400
Wire Wire Line
	3850 3500 3700 3500
Wire Wire Line
	3700 3600 3850 3600
Wire Wire Line
	3700 3700 3850 3700
Wire Wire Line
	3700 3800 3850 3800
Entry Wire Line
	4250 3450 4350 3550
Entry Wire Line
	4250 3350 4350 3450
Entry Wire Line
	4250 3250 4350 3350
Entry Wire Line
	4250 3150 4350 3250
Entry Wire Line
	4250 3050 4350 3150
Entry Wire Line
	4250 2950 4350 3050
Entry Wire Line
	4250 2850 4350 2950
Entry Wire Line
	4250 2750 4350 2850
Entry Wire Line
	4250 2650 4350 2750
Entry Wire Line
	4250 2550 4350 2650
Wire Wire Line
	4350 2650 4550 2650
Wire Wire Line
	4550 2750 4350 2750
Wire Wire Line
	4350 2850 4550 2850
Wire Wire Line
	4550 2950 4350 2950
Wire Wire Line
	4350 3050 4550 3050
Wire Wire Line
	4550 3150 4350 3150
Wire Wire Line
	4350 3250 4550 3250
Wire Wire Line
	4350 3350 4550 3350
Wire Wire Line
	4350 3450 4550 3450
Wire Wire Line
	4350 3550 4550 3550
Entry Wire Line
	3850 4200 3950 4300
Entry Wire Line
	3850 4300 3950 4400
Entry Wire Line
	3850 4400 3950 4500
Entry Wire Line
	3850 4500 3950 4600
Entry Wire Line
	3850 4600 3950 4700
Entry Wire Line
	3850 4700 3950 4800
Entry Wire Line
	3850 4800 3950 4900
Entry Wire Line
	3850 4900 3950 5000
Entry Wire Line
	3850 4200 3950 4300
Wire Wire Line
	3700 4200 3850 4200
Wire Wire Line
	3850 4300 3700 4300
Wire Wire Line
	3700 4400 3850 4400
Wire Wire Line
	3850 4500 3700 4500
Wire Wire Line
	3700 4600 3850 4600
Wire Wire Line
	3700 4700 3850 4700
Wire Wire Line
	3700 4800 3850 4800
Wire Wire Line
	3700 4900 3850 4900
Entry Wire Line
	4250 3750 4350 3650
Entry Wire Line
	4250 3850 4350 3750
Entry Wire Line
	4250 3950 4350 3850
Wire Wire Line
	4350 3650 4550 3650
Wire Wire Line
	4550 3750 4350 3750
Wire Wire Line
	4350 3850 4550 3850
Entry Wire Line
	5550 3550 5650 3650
Entry Wire Line
	5550 3650 5650 3750
Entry Wire Line
	5550 3750 5650 3850
Entry Wire Line
	5550 3850 5650 3950
Entry Wire Line
	5550 3950 5650 4050
Wire Wire Line
	5450 3550 5550 3550
Wire Wire Line
	5550 3650 5450 3650
Wire Wire Line
	5450 3750 5550 3750
Wire Wire Line
	5450 3850 5550 3850
Wire Wire Line
	5450 3950 5550 3950
Entry Wire Line
	7700 3550 7800 3650
Entry Wire Line
	7700 3650 7800 3750
Entry Wire Line
	7700 3750 7800 3850
Entry Wire Line
	7700 3850 7800 3950
Entry Wire Line
	7700 3950 7800 4050
Wire Wire Line
	7550 3950 7700 3950
Wire Wire Line
	7550 3850 7700 3850
Wire Wire Line
	7550 3750 7700 3750
Wire Wire Line
	7700 3650 7550 3650
Wire Wire Line
	7550 3550 7700 3550
Entry Wire Line
	6150 3750 6250 3650
Entry Wire Line
	6150 3850 6250 3750
Entry Wire Line
	6150 3950 6250 3850
Wire Wire Line
	6250 3650 6450 3650
Wire Wire Line
	6250 3750 6450 3750
Wire Wire Line
	6450 3850 6250 3850
Entry Wire Line
	6150 3450 6250 3550
Entry Wire Line
	6150 3350 6250 3450
Entry Wire Line
	6150 3250 6250 3350
Entry Wire Line
	6150 3150 6250 3250
Entry Wire Line
	6150 3050 6250 3150
Entry Wire Line
	6150 2950 6250 3050
Entry Wire Line
	6150 2850 6250 2950
Entry Wire Line
	6150 2750 6250 2850
Entry Wire Line
	6150 2650 6250 2750
Wire Wire Line
	6250 3550 6450 3550
Wire Wire Line
	6450 3450 6250 3450
Wire Wire Line
	6250 3350 6450 3350
Wire Wire Line
	6450 3250 6250 3250
Wire Wire Line
	6250 3150 6450 3150
Wire Wire Line
	6450 3050 6250 3050
Wire Wire Line
	6250 2950 6450 2950
Wire Wire Line
	6450 2850 6250 2850
Wire Wire Line
	6250 2750 6450 2750
Wire Wire Line
	6150 800  6150 1150
Wire Wire Line
	6150 1350 6150 1600
Entry Wire Line
	3950 3300 3850 3400
Entry Wire Line
	3950 3200 3850 3300
Entry Wire Line
	3950 3100 3850 3200
Entry Wire Line
	3950 3000 3850 3100
Entry Wire Line
	3950 2900 3850 3000
Wire Wire Line
	3850 3400 3700 3400
Wire Wire Line
	3850 3300 3700 3300
Wire Wire Line
	3850 3200 3700 3200
Wire Wire Line
	3850 3100 3700 3100
Wire Wire Line
	3850 3000 3700 3000
Text GLabel 1900 7050 3    50   Output ~ 0
IO_RESET
Wire Wire Line
	1900 7050 1900 6500
Connection ~ 1900 6500
Wire Wire Line
	1900 6500 2050 6500
Wire Wire Line
	750  2500 750  6500
$Comp
L Device:C C1
U 1 1 5D4C5F70
P 2700 1900
F 0 "C1" H 2815 1946 50  0000 L CNN
F 1 "100nF" H 2815 1855 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 2738 1750 50  0001 C CNN
F 3 "~" H 2700 1900 50  0001 C CNN
	1    2700 1900
	0    1    1    0   
$EndComp
Wire Wire Line
	2850 1900 3000 1900
Wire Wire Line
	3000 1900 3000 2200
$Comp
L power:GND #PWR0109
U 1 1 5D4D0232
P 2400 2000
F 0 "#PWR0109" H 2400 1750 50  0001 C CNN
F 1 "GND" H 2405 1827 50  0000 C CNN
F 2 "" H 2400 2000 50  0001 C CNN
F 3 "" H 2400 2000 50  0001 C CNN
	1    2400 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 2000 2400 1900
Wire Wire Line
	2400 1900 2550 1900
Wire Bus Line
	3950 5050 4250 5050
$Comp
L Device:C C2
U 1 1 5D50FC2E
P 5000 2250
F 0 "C2" H 5115 2296 50  0000 L CNN
F 1 "100nF" H 5115 2205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 5038 2100 50  0001 C CNN
F 3 "~" H 5000 2250 50  0001 C CNN
	1    5000 2250
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C3
U 1 1 5D510869
P 7000 2250
F 0 "C3" H 7115 2296 50  0000 L CNN
F 1 "100nF" H 7115 2205 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 7038 2100 50  0001 C CNN
F 3 "~" H 7000 2250 50  0001 C CNN
	1    7000 2250
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 5D52E5F6
P 4600 2300
F 0 "#PWR0110" H 4600 2050 50  0001 C CNN
F 1 "GND" H 4605 2127 50  0000 C CNN
F 2 "" H 4600 2300 50  0001 C CNN
F 3 "" H 4600 2300 50  0001 C CNN
	1    4600 2300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0111
U 1 1 5D52EA7B
P 6550 2300
F 0 "#PWR0111" H 6550 2050 50  0001 C CNN
F 1 "GND" H 6555 2127 50  0000 C CNN
F 2 "" H 6550 2300 50  0001 C CNN
F 3 "" H 6550 2300 50  0001 C CNN
	1    6550 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6850 2250 6550 2250
Wire Wire Line
	6550 2250 6550 2300
Wire Wire Line
	4850 2250 4600 2250
Wire Wire Line
	4600 2250 4600 2300
NoConn ~ 6450 2650
NoConn ~ 7550 2850
Text GLabel 5550 2750 2    50   Input ~ 0
WR
Wire Wire Line
	5550 2750 5450 2750
Text GLabel 5550 3250 2    50   Input ~ 0
RD
Wire Wire Line
	5450 3250 5550 3250
Entry Wire Line
	5850 3250 5750 3350
Entry Wire Line
	5850 3050 5750 3150
Entry Wire Line
	5850 2950 5750 3050
Wire Wire Line
	5750 3350 5450 3350
Wire Wire Line
	5750 3150 5450 3150
Wire Wire Line
	5450 3050 5750 3050
Wire Wire Line
	5450 2950 5750 2950
Wire Wire Line
	5450 2850 5750 2850
Entry Wire Line
	5850 2850 5750 2950
Entry Wire Line
	5850 2750 5750 2850
Entry Wire Line
	3950 2800 3850 2900
Entry Wire Line
	3950 2700 3850 2800
Entry Wire Line
	3950 2600 3850 2700
Entry Wire Line
	3950 2400 3850 2500
Wire Wire Line
	3700 4000 3850 4000
Entry Wire Line
	3850 4000 3950 3900
Wire Wire Line
	3700 3900 3850 3900
Entry Wire Line
	3850 3900 3950 3800
Wire Wire Line
	3700 2900 3850 2900
Wire Wire Line
	3700 2800 3850 2800
Wire Wire Line
	3700 2700 3850 2700
Entry Wire Line
	3950 2500 3850 2600
Wire Wire Line
	3700 2500 3850 2500
Wire Wire Line
	3850 2600 3700 2600
Wire Wire Line
	7700 3250 7550 3250
Text GLabel 2100 4200 0    50   Input ~ 0
RD
Text GLabel 2100 4300 0    50   Input ~ 0
WR
Text GLabel 2100 4400 0    50   Input ~ 0
MREQ
Wire Wire Line
	2100 4400 2300 4400
Wire Wire Line
	2300 4300 2100 4300
Wire Wire Line
	2100 4200 2300 4200
Text Label 3700 4000 0    50   ~ 0
A15
Text Label 3700 3900 0    50   ~ 0
A14
Text Label 3700 3800 0    50   ~ 0
A13
Text Label 3700 3200 0    50   ~ 0
A7
Text Label 4400 2650 0    50   ~ 0
A14
Text Label 5450 2850 0    50   ~ 0
A13
Text Label 4400 2850 0    50   ~ 0
A7
Text Label 6300 2850 0    50   ~ 0
A7
Text Label 3700 3700 0    50   ~ 0
A12
Text Label 4400 2750 0    50   ~ 0
A12
Text Label 6300 2750 0    50   ~ 0
A12
Connection ~ 6150 1850
Wire Wire Line
	7550 3450 8250 3450
Wire Bus Line
	6150 1850 8100 1850
Wire Wire Line
	7550 2950 8000 2950
Wire Wire Line
	7550 3050 8000 3050
Wire Wire Line
	7550 3150 8000 3150
Wire Wire Line
	7550 3350 8000 3350
Text GLabel 7700 3250 2    50   Input ~ 0
RD
Entry Wire Line
	8000 3350 8100 3250
Entry Wire Line
	8000 3150 8100 3050
Entry Wire Line
	8000 3050 8100 2950
Entry Wire Line
	8000 2950 8100 2850
$Comp
L 74xx:74LS32 U4
U 5 1 5D7A5007
P 9200 1800
F 0 "U4" H 9430 1846 50  0000 L CNN
F 1 "74LS32" H 9430 1755 50  0000 L CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 9200 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 9200 1800 50  0001 C CNN
	5    9200 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5D7A97E6
P 8800 1800
F 0 "C4" H 8915 1846 50  0000 L CNN
F 1 "100nF" H 8915 1755 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 8838 1650 50  0001 C CNN
F 3 "~" H 8800 1800 50  0001 C CNN
	1    8800 1800
	-1   0    0    1   
$EndComp
Wire Wire Line
	8800 1650 8800 1300
Wire Wire Line
	8800 1300 9200 1300
Wire Wire Line
	8800 1950 8800 2300
Wire Wire Line
	8800 2300 9200 2300
$Comp
L 74xx:74HC14 U5
U 7 1 5D7BCD08
P 10400 1800
F 0 "U5" H 10630 1846 50  0000 L CNN
F 1 "74HC14" H 10630 1755 50  0000 L CNN
F 2 "" H 10400 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 10400 1800 50  0001 C CNN
	7    10400 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 5D7C6A30
P 10050 1800
F 0 "C5" H 10165 1846 50  0000 L CNN
F 1 "100nF" H 10165 1755 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 10088 1650 50  0001 C CNN
F 3 "~" H 10050 1800 50  0001 C CNN
	1    10050 1800
	-1   0    0    1   
$EndComp
Wire Wire Line
	9200 1300 10050 1300
Connection ~ 9200 1300
Wire Wire Line
	9200 2300 10050 2300
Connection ~ 9200 2300
$Comp
L power:GND #PWR0112
U 1 1 5D7E1EF3
P 10400 2300
F 0 "#PWR0112" H 10400 2050 50  0001 C CNN
F 1 "GND" H 10405 2127 50  0000 C CNN
F 2 "" H 10400 2300 50  0001 C CNN
F 3 "" H 10400 2300 50  0001 C CNN
	1    10400 2300
	1    0    0    -1  
$EndComp
Connection ~ 10400 2300
$Comp
L power:VCC #PWR0113
U 1 1 5D7E2931
P 10400 1200
F 0 "#PWR0113" H 10400 1050 50  0001 C CNN
F 1 "VCC" H 10417 1373 50  0000 C CNN
F 2 "" H 10400 1200 50  0001 C CNN
F 3 "" H 10400 1200 50  0001 C CNN
	1    10400 1200
	1    0    0    -1  
$EndComp
Wire Wire Line
	10050 1650 10050 1300
Connection ~ 10050 1300
Wire Wire Line
	10050 1300 10400 1300
Wire Wire Line
	10050 1950 10050 2300
Connection ~ 10050 2300
Wire Wire Line
	10050 2300 10400 2300
$Comp
L Oscillator:CXO_DIP8 X1
U 1 1 5D8381D9
P 1250 1350
F 0 "X1" H 1594 1396 50  0000 L CNN
F 1 "4MHz" H 1594 1305 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-8" H 1700 1000 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 1150 1350 50  0001 C CNN
	1    1250 1350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 5D838F68
P 1250 1750
F 0 "#PWR0114" H 1250 1500 50  0001 C CNN
F 1 "GND" H 1255 1577 50  0000 C CNN
F 2 "" H 1250 1750 50  0001 C CNN
F 3 "" H 1250 1750 50  0001 C CNN
	1    1250 1750
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0115
U 1 1 5D839928
P 1250 800
F 0 "#PWR0115" H 1250 650 50  0001 C CNN
F 1 "VCC" H 1267 973 50  0000 C CNN
F 2 "" H 1250 800 50  0001 C CNN
F 3 "" H 1250 800 50  0001 C CNN
	1    1250 800 
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 1650 1250 1700
Wire Wire Line
	2100 1350 2100 2800
NoConn ~ 950  1350
$Comp
L Device:C C7
U 1 1 5D85F4CB
P 850 1000
F 0 "C7" H 965 1046 50  0000 L CNN
F 1 "100nF" H 965 955 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D7.0mm_W2.5mm_P5.00mm" H 888 850 50  0001 C CNN
F 3 "~" H 850 1000 50  0001 C CNN
	1    850  1000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	700  1000 650  1000
Wire Wire Line
	650  1000 650  1700
Wire Wire Line
	650  1700 1250 1700
Connection ~ 1250 1700
Wire Wire Line
	1250 1700 1250 1750
Connection ~ 3000 1900
Text Label 3700 3600 0    50   ~ 0
A11
Text Label 3700 3500 0    50   ~ 0
A10
Text Label 3700 3400 0    50   ~ 0
A9
Text Label 3700 3300 0    50   ~ 0
A8
Text Label 3700 3100 0    50   ~ 0
A6
Text Label 3700 3000 0    50   ~ 0
A5
Text Label 3700 2900 0    50   ~ 0
A4
Text Label 3700 2800 0    50   ~ 0
A3
Text Label 3700 2700 0    50   ~ 0
A2
Text Label 3700 2600 0    50   ~ 0
A1
Text Label 3700 2500 0    50   ~ 0
A0
Text Label 4400 2950 0    50   ~ 0
A6
Text Label 4400 3050 0    50   ~ 0
A5
Text Label 4400 3150 0    50   ~ 0
A4
Text Label 4400 3250 0    50   ~ 0
A3
Text Label 4400 3350 0    50   ~ 0
A2
Text Label 4400 3450 0    50   ~ 0
A1
Text Label 4400 3550 0    50   ~ 0
A0
Text Label 4400 3650 0    50   ~ 0
D0
Text Label 4400 3750 0    50   ~ 0
D1
Text Label 4400 3850 0    50   ~ 0
D2
Text Label 3750 4200 0    50   ~ 0
D0
Text Label 3750 4300 0    50   ~ 0
D1
Text Label 3750 4400 0    50   ~ 0
D2
Text Label 3750 4500 0    50   ~ 0
D3
Text Label 3750 4600 0    50   ~ 0
D4
Text Label 3750 4700 0    50   ~ 0
D5
Text Label 3750 4800 0    50   ~ 0
D6
Text Label 3750 4900 0    50   ~ 0
D7
Text Label 5500 3950 0    50   ~ 0
D3
Text Label 5500 3850 0    50   ~ 0
D4
Text Label 5500 3750 0    50   ~ 0
D5
Text Label 5500 3650 0    50   ~ 0
D6
Text Label 5500 3550 0    50   ~ 0
D7
Text Label 5500 3350 0    50   ~ 0
A10
Text Label 5500 3150 0    50   ~ 0
A11
Text Label 5500 3050 0    50   ~ 0
A9
Text Label 5500 2950 0    50   ~ 0
A8
Text Label 6300 2950 0    50   ~ 0
A6
Text Label 6300 3050 0    50   ~ 0
A5
Text Label 6300 3150 0    50   ~ 0
A4
Text Label 6300 3250 0    50   ~ 0
A3
Text Label 6300 3350 0    50   ~ 0
A2
Text Label 6300 3450 0    50   ~ 0
A1
Text Label 6300 3550 0    50   ~ 0
A0
Text Label 6300 3650 0    50   ~ 0
D0
Text Label 6300 3750 0    50   ~ 0
D1
Text Label 6300 3850 0    50   ~ 0
D2
Text Label 7600 2950 0    50   ~ 0
A8
Text Label 7600 3050 0    50   ~ 0
A9
Text Label 7600 3150 0    50   ~ 0
A11
Text Label 7600 3350 0    50   ~ 0
A10
Text Label 7550 3550 0    50   ~ 0
D7
Text Label 7550 3650 0    50   ~ 0
D6
Text Label 7550 3750 0    50   ~ 0
D5
Text Label 7550 3850 0    50   ~ 0
D4
Text Label 7550 3950 0    50   ~ 0
D3
Wire Wire Line
	10050 4500 9700 4500
Wire Wire Line
	10050 5700 9700 5700
Wire Wire Line
	9700 6250 10300 6250
Wire Wire Line
	10900 5700 10550 5700
$Comp
L power:GND #PWR0117
U 1 1 5D8C9B45
P 10300 6300
F 0 "#PWR0117" H 10300 6050 50  0001 C CNN
F 1 "GND" H 10305 6127 50  0000 C CNN
F 2 "" H 10300 6300 50  0001 C CNN
F 3 "" H 10300 6300 50  0001 C CNN
	1    10300 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	10300 6300 10300 6250
Wire Wire Line
	10550 4900 10900 4900
Text GLabel 10900 4900 2    50   Input ~ 0
WR
Wire Wire Line
	10050 4600 9700 4600
Wire Wire Line
	10050 4700 9700 4700
Wire Wire Line
	10050 4800 9700 4800
Wire Wire Line
	10050 4900 9700 4900
Wire Wire Line
	10050 5000 9700 5000
Wire Wire Line
	10050 5100 9700 5100
Text Label 9800 4600 0    50   ~ 0
D1
Text Label 9800 4700 0    50   ~ 0
D3
Text Label 9800 4800 0    50   ~ 0
D5
Text Label 9800 4900 0    50   ~ 0
D7
Text Label 9800 5000 0    50   ~ 0
A0
Text Label 9800 5100 0    50   ~ 0
A2
Wire Wire Line
	10050 5200 9700 5200
Wire Wire Line
	10050 5300 9700 5300
Wire Wire Line
	10050 5400 9700 5400
Wire Wire Line
	10050 5500 9700 5500
Text Label 9800 5200 0    50   ~ 0
A4
Text Label 9800 5300 0    50   ~ 0
A6
Text Label 9800 5400 0    50   ~ 0
A8
Text Label 9800 5500 0    50   ~ 0
A10
Wire Wire Line
	10550 4500 10900 4500
Text Label 10650 4500 0    50   ~ 0
D0
Wire Wire Line
	10550 4600 10900 4600
Text Label 10650 4600 0    50   ~ 0
D2
Wire Wire Line
	10550 4700 10900 4700
Text Label 10650 4700 0    50   ~ 0
D4
Wire Wire Line
	10550 4800 10900 4800
Text Label 10650 4800 0    50   ~ 0
D6
Wire Wire Line
	10550 5000 10900 5000
Wire Wire Line
	10550 5100 10900 5100
Wire Wire Line
	10550 5200 10900 5200
Wire Wire Line
	10550 5300 10900 5300
Text Label 10600 5000 0    50   ~ 0
A1
Text Label 10600 5100 0    50   ~ 0
A3
Text Label 10600 5200 0    50   ~ 0
A5
Text Label 10600 5300 0    50   ~ 0
A7
Wire Wire Line
	10550 5400 10900 5400
Text Label 10600 5400 0    50   ~ 0
A9
Wire Wire Line
	10550 5500 10900 5500
Text Label 10600 5500 0    50   ~ 0
A11
Wire Wire Line
	10050 5600 9700 5600
Text Label 9800 5600 0    50   ~ 0
A12
Wire Wire Line
	10050 6000 9750 6000
Text Label 9800 6000 0    50   ~ 0
A15
Text GLabel 1000 3100 0    50   Input ~ 0
NMI
Wire Wire Line
	10550 4200 10900 4200
Text GLabel 10900 4200 2    50   Input ~ 0
NMI
$Comp
L Device:R R4
U 1 1 5DA8559D
P 1150 2850
F 0 "R4" H 1220 2896 50  0000 L CNN
F 1 "3.3K" H 1220 2805 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 1080 2850 50  0001 C CNN
F 3 "~" H 1150 2850 50  0001 C CNN
	1    1150 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 3000 1150 3100
$Comp
L power:VCC #PWR0118
U 1 1 5DAA10A5
P 1150 2650
F 0 "#PWR0118" H 1150 2500 50  0001 C CNN
F 1 "VCC" H 1167 2823 50  0000 C CNN
F 2 "" H 1150 2650 50  0001 C CNN
F 3 "" H 1150 2650 50  0001 C CNN
	1    1150 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 2650 1150 2700
Text GLabel 9750 4200 0    50   Input ~ 0
HALT
Text Label 750  2500 0    50   ~ 0
RESET
Wire Wire Line
	10050 4400 9750 4400
Text Label 9800 4400 0    50   ~ 0
M1
Wire Wire Line
	10550 4300 10900 4300
Text GLabel 10900 4300 2    50   Input ~ 0
WAIT
Wire Wire Line
	10550 4400 10900 4400
Text GLabel 1300 3700 0    50   Input ~ 0
WAIT
Text GLabel 1300 3800 0    50   Input ~ 0
HALT
Wire Wire Line
	2300 3500 2100 3500
NoConn ~ 2300 3600
Text Label 2150 3500 0    50   ~ 0
M1
Wire Wire Line
	1400 3700 1300 3700
$Comp
L Device:R R5
U 1 1 5DC477F4
P 1400 2850
F 0 "R5" H 1470 2896 50  0000 L CNN
F 1 "3.3K" H 1470 2805 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 1330 2850 50  0001 C CNN
F 3 "~" H 1400 2850 50  0001 C CNN
	1    1400 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 2700 1400 2650
Connection ~ 1150 2650
Wire Wire Line
	1400 2650 1150 2650
Wire Wire Line
	1000 3100 1150 3100
Text Label 10650 4400 0    50   ~ 0
RD
Wire Wire Line
	10550 6000 10850 6000
Wire Wire Line
	2300 4900 2100 4900
Text Label 2100 4900 0    50   ~ 0
BUSACK
Wire Wire Line
	750  2500 2300 2500
Wire Wire Line
	1150 3100 2300 3100
Connection ~ 1150 3100
Wire Wire Line
	1400 3000 1400 3700
Wire Wire Line
	1400 3700 2300 3700
Connection ~ 1400 3700
Wire Wire Line
	1300 3800 2300 3800
Wire Wire Line
	1650 4800 1650 3000
Wire Wire Line
	1650 4800 2300 4800
$Comp
L Device:R R6
U 1 1 5DE6F28F
P 1650 2850
F 0 "R6" H 1720 2896 50  0000 L CNN
F 1 "3.3K" H 1720 2805 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 1580 2850 50  0001 C CNN
F 3 "~" H 1650 2850 50  0001 C CNN
	1    1650 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 2650 1650 2650
Wire Wire Line
	1650 2650 1650 2700
Connection ~ 1400 2650
Wire Wire Line
	2100 2800 2300 2800
Wire Wire Line
	1550 1350 2100 1350
Text Label 2000 4800 0    50   ~ 0
BUSRQ
$Comp
L power:VCC #PWR0108
U 1 1 5D4C53BB
P 3000 1750
F 0 "#PWR0108" H 3000 1600 50  0001 C CNN
F 1 "VCC" H 3017 1923 50  0000 C CNN
F 2 "" H 3000 1750 50  0001 C CNN
F 3 "" H 3000 1750 50  0001 C CNN
	1    3000 1750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC14 U5
U 3 1 5D48CF58
P 4900 1350
F 0 "U5" H 4900 1667 50  0000 C CNN
F 1 "74HC14" H 4900 1576 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 4900 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 4900 1350 50  0001 C CNN
	3    4900 1350
	1    0    0    -1  
$EndComp
Text GLabel 4250 800  0    50   Input ~ 0
MREQ
Wire Wire Line
	4600 1350 4500 1350
Wire Wire Line
	4500 1600 4500 1350
Connection ~ 4500 1350
Text Label 4300 1350 0    50   ~ 0
A15
Wire Wire Line
	4500 1350 4250 1350
Wire Wire Line
	5300 1150 5300 800 
Wire Wire Line
	5300 800  6150 800 
Wire Wire Line
	5900 1250 6000 1250
Wire Wire Line
	4500 1600 6150 1600
Wire Wire Line
	4250 800  5300 800 
Connection ~ 5300 800 
Wire Wire Line
	5200 1350 5300 1350
Wire Wire Line
	2300 3200 2100 3200
Text Label 2150 3200 0    50   ~ 0
INT
Text Label 10550 6000 0    50   ~ 0
INT
$Comp
L 74xx:74LS32 U4
U 1 1 5D46502A
P 5600 1250
F 0 "U4" H 5600 1575 50  0000 C CNN
F 1 "74LS32" H 5600 1484 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 5600 1250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 5600 1250 50  0001 C CNN
	1    5600 1250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U4
U 2 1 5D45CA5D
P 6450 1250
F 0 "U4" H 6450 1575 50  0000 C CNN
F 1 "74LS32" H 6450 1484 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 6450 1250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 6450 1250 50  0001 C CNN
	2    6450 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	10550 5600 10900 5600
Text Label 10550 5600 0    50   ~ 0
BUSACK
Connection ~ 10300 6250
Wire Wire Line
	10300 6250 10900 6250
$Comp
L power:+5V #PWR0134
U 1 1 5E77A78A
P 8650 3200
F 0 "#PWR0134" H 8650 3050 50  0001 C CNN
F 1 "+5V" H 8665 3373 50  0000 C CNN
F 2 "" H 8650 3200 50  0001 C CNN
F 3 "" H 8650 3200 50  0001 C CNN
	1    8650 3200
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0135
U 1 1 5E77B274
P 8950 3200
F 0 "#PWR0135" H 8950 3050 50  0001 C CNN
F 1 "VCC" H 8967 3373 50  0000 C CNN
F 2 "" H 8950 3200 50  0001 C CNN
F 3 "" H 8950 3200 50  0001 C CNN
	1    8950 3200
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW1
U 1 1 5E791412
P 3850 6500
F 0 "SW1" H 3850 6785 50  0000 C CNN
F 1 "RESET" H 3850 6694 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm_H5mm" H 3850 6700 50  0001 C CNN
F 3 "~" H 3850 6700 50  0001 C CNN
	1    3850 6500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 6500 3650 6500
$Comp
L power:GND #PWR0136
U 1 1 5E7A6980
P 4150 6600
F 0 "#PWR0136" H 4150 6350 50  0001 C CNN
F 1 "GND" H 4155 6427 50  0000 C CNN
F 2 "" H 4150 6600 50  0001 C CNN
F 3 "" H 4150 6600 50  0001 C CNN
	1    4150 6600
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 6500 4150 6500
Wire Wire Line
	4150 6500 4150 6600
Wire Wire Line
	1250 1050 1250 1000
Wire Wire Line
	1000 1000 1250 1000
Connection ~ 1250 1000
Wire Wire Line
	1250 1000 1250 800 
Wire Wire Line
	3000 1750 3000 1900
Wire Wire Line
	8950 3200 8950 3350
Wire Wire Line
	8650 3200 8650 3350
Text Notes 7350 7500 0    50   ~ 0
Mini Z80 CPU and memory
$Comp
L Device:R R?
U 1 1 5EB8AD66
P 9150 3350
AR Path="/5E4A1927/5EB8AD66" Ref="R?"  Part="1" 
AR Path="/5EB8AD66" Ref="R10"  Part="1" 
F 0 "R10" V 8943 3350 50  0000 C CNN
F 1 "R" V 9034 3350 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 9080 3350 50  0001 C CNN
F 3 "~" H 9150 3350 50  0001 C CNN
	1    9150 3350
	0    1    1    0   
$EndComp
$Comp
L Device:LED D?
U 1 1 5EB8AD6C
P 9550 3350
AR Path="/5E4A1927/5EB8AD6C" Ref="D?"  Part="1" 
AR Path="/5EB8AD6C" Ref="D3"  Part="1" 
F 0 "D3" H 9543 3095 50  0000 C CNN
F 1 "LED" H 9543 3186 50  0000 C CNN
F 2 "LED_THT:LED_D3.0mm" H 9550 3350 50  0001 C CNN
F 3 "~" H 9550 3350 50  0001 C CNN
	1    9550 3350
	-1   0    0    1   
$EndComp
Wire Wire Line
	9300 3350 9400 3350
$Comp
L power:GND #PWR?
U 1 1 5EB8AD74
P 9800 3350
AR Path="/5E4A1927/5EB8AD74" Ref="#PWR?"  Part="1" 
AR Path="/5EB8AD74" Ref="#PWR0141"  Part="1" 
F 0 "#PWR0141" H 9800 3100 50  0001 C CNN
F 1 "GND" H 9805 3177 50  0000 C CNN
F 2 "" H 9800 3350 50  0001 C CNN
F 3 "" H 9800 3350 50  0001 C CNN
	1    9800 3350
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9800 3350 9700 3350
Wire Wire Line
	8650 3350 8950 3350
Connection ~ 8950 3350
Wire Wire Line
	8950 3350 9000 3350
Text Label 5550 5300 2    50   ~ 0
INT
$Comp
L 74xx:74HC14 U5
U 5 1 5DB892B7
P 5950 5300
F 0 "U5" H 5950 5600 50  0000 C CNN
F 1 "74HC14" H 5950 5500 50  0000 C CNN
F 2 "" H 5950 5300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 5950 5300 50  0001 C CNN
	5    5950 5300
	-1   0    0    1   
$EndComp
Text GLabel 9750 4100 0    50   Input ~ 0
MREQ
Wire Wire Line
	10550 4100 10900 4100
Text Label 10650 4100 0    50   ~ 0
IORQ
Text Label 8100 4850 0    50   ~ 0
A[0..15]
Wire Bus Line
	3950 1850 4250 1850
Text Label 8150 5050 0    50   ~ 0
D[0..7]
Wire Wire Line
	10050 4100 9750 4100
Text Label 9800 4300 0    50   ~ 0
RESET
Wire Wire Line
	10050 4300 9750 4300
Wire Wire Line
	10050 4200 9750 4200
$Comp
L 74xx:74LS32 U4
U 3 1 5D6B2446
P 7750 5600
F 0 "U4" H 7750 5925 50  0000 C CNN
F 1 "74LS32" H 7750 5834 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 7750 5600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 7750 5600 50  0001 C CNN
	3    7750 5600
	1    0    0    -1  
$EndComp
Text Label 6900 5700 0    50   ~ 0
IORQ
$Comp
L 74xx:74HC14 U5
U 4 1 5D73CD34
P 7000 6200
F 0 "U5" H 7000 5883 50  0000 C CNN
F 1 "74HC14" H 7000 5974 50  0000 C CNN
F 2 "" H 7000 6200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC14" H 7000 6200 50  0001 C CNN
	4    7000 6200
	1    0    0    -1  
$EndComp
Connection ~ 4250 1850
Connection ~ 4250 5050
Connection ~ 5650 5050
Connection ~ 5850 1850
Wire Bus Line
	4250 5050 5650 5050
Wire Bus Line
	5650 5050 6150 5050
Wire Bus Line
	4250 1850 5850 1850
Wire Bus Line
	5300 1850 5850 1850
Wire Wire Line
	5450 3450 6000 3450
Wire Wire Line
	6000 3450 6000 1250
Connection ~ 6150 5050
Wire Bus Line
	5850 1850 6150 1850
Wire Wire Line
	8250 3450 8250 1250
Wire Wire Line
	8250 1250 6750 1250
Wire Bus Line
	6150 5050 7800 5050
Wire Bus Line
	7800 5050 8400 5050
Connection ~ 7800 5050
Wire Bus Line
	8100 4850 8400 4850
$Comp
L 74xx:74LS32 U4
U 4 1 5D6B59A0
P 7750 6100
F 0 "U4" H 7750 6425 50  0000 C CNN
F 1 "74LS32" H 7750 6334 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_LongPads" H 7750 6100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 7750 6100 50  0001 C CNN
	4    7750 6100
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x20_Odd_Even J1
U 1 1 5D8B104B
P 10250 5000
F 0 "J1" H 10300 6117 50  0000 C CNN
F 1 "Conn_02x20_Odd_Even" H 10300 6026 50  0000 C CNN
F 2 "Connector:Connector_CardEdge_40" H 10250 5000 50  0001 C CNN
F 3 "~" H 10250 5000 50  0001 C CNN
	1    10250 5000
	1    0    0    -1  
$EndComp
$Sheet
S 8400 4750 850  1600
U 5E4A1927
F0 "IO_UART" 50
F1 "z80_io.sch" 50
F2 "A[0..15]" B L 8400 4850 50 
F3 "D[0..7]" B L 8400 5050 50 
F4 "IO_CE" I L 8400 5750 50 
F5 "UART_CE" I L 8400 6100 50 
F6 "VCC" I R 9250 4850 50 
F7 "GND" I R 9250 5000 50 
F8 "UART_INTR" O L 8400 5300 50 
F9 "MAIN_CLK" I R 9250 5550 50 
$EndSheet
Text Label 10550 5800 0    50   ~ 0
IORQ
Text Label 9800 5800 0    50   ~ 0
BUSRQ
Wire Wire Line
	10550 5800 10850 5800
Wire Wire Line
	10050 5800 9750 5800
Text Label 10650 5900 0    50   ~ 0
A14
Wire Wire Line
	10550 5900 10850 5900
Text Label 9800 5900 0    50   ~ 0
A13
Wire Wire Line
	10050 5900 9750 5900
Wire Wire Line
	10900 6250 10900 5700
Wire Wire Line
	9700 5700 9700 6250
Wire Wire Line
	7300 6200 7450 6200
Text Label 6450 5500 0    50   ~ 0
A7
Wire Wire Line
	8100 5750 8400 5750
Wire Wire Line
	7300 5700 6900 5700
Wire Wire Line
	6600 5500 6450 5500
Wire Wire Line
	7300 5700 7450 5700
Connection ~ 7300 5700
Wire Wire Line
	7450 6000 7300 6000
Wire Wire Line
	2300 4500 2100 4500
Text Label 2100 4500 0    50   ~ 0
IORQ
$Comp
L power:VCC #PWR0148
U 1 1 5FD16DBA
P 9400 4750
F 0 "#PWR0148" H 9400 4600 50  0001 C CNN
F 1 "VCC" H 9417 4923 50  0000 C CNN
F 2 "" H 9400 4750 50  0001 C CNN
F 3 "" H 9400 4750 50  0001 C CNN
	1    9400 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	9400 4750 9400 4850
Wire Wire Line
	9400 4850 9250 4850
Wire Wire Line
	10400 1200 10400 1300
Connection ~ 10400 1300
Wire Wire Line
	9250 5000 9400 5000
Wire Wire Line
	9400 5000 9400 5100
$Comp
L power:GND #PWR0150
U 1 1 5FD92FB3
P 9400 5100
F 0 "#PWR0150" H 9400 4850 50  0001 C CNN
F 1 "GND" H 9405 4927 50  0000 C CNN
F 2 "" H 9400 5100 50  0001 C CNN
F 3 "" H 9400 5100 50  0001 C CNN
	1    9400 5100
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0116
U 1 1 5FDC066A
P 9700 4500
F 0 "#PWR0116" H 9700 4350 50  0001 C CNN
F 1 "VCC" V 9718 4627 50  0000 L CNN
F 2 "" H 9700 4500 50  0001 C CNN
F 3 "" H 9700 4500 50  0001 C CNN
	1    9700 4500
	0    -1   -1   0   
$EndComp
$Comp
L power:VCC #PWR0106
U 1 1 5FE15B79
P 5550 2150
F 0 "#PWR0106" H 5550 2000 50  0001 C CNN
F 1 "VCC" H 5567 2323 50  0000 C CNN
F 2 "" H 5550 2150 50  0001 C CNN
F 3 "" H 5550 2150 50  0001 C CNN
	1    5550 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 2650 5550 2650
Wire Wire Line
	5550 2650 5550 2250
Wire Wire Line
	5150 2250 5550 2250
Connection ~ 5550 2250
Wire Wire Line
	5550 2250 5550 2150
$Comp
L power:VCC #PWR0107
U 1 1 5FE6BCB1
P 7650 2150
F 0 "#PWR0107" H 7650 2000 50  0001 C CNN
F 1 "VCC" H 7667 2323 50  0000 C CNN
F 2 "" H 7650 2150 50  0001 C CNN
F 3 "" H 7650 2150 50  0001 C CNN
	1    7650 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 2750 7650 2750
Wire Wire Line
	7650 2750 7650 2650
Wire Wire Line
	7150 2250 7650 2250
Connection ~ 7650 2250
Wire Wire Line
	7650 2250 7650 2150
Wire Wire Line
	7550 2650 7650 2650
Connection ~ 7650 2650
Wire Wire Line
	7650 2650 7650 2250
Wire Wire Line
	6600 6200 6600 5500
Wire Wire Line
	7300 6000 7300 5700
Wire Wire Line
	8100 5600 8100 5750
Wire Wire Line
	6600 6200 6700 6200
Wire Wire Line
	6600 5500 7450 5500
Connection ~ 6600 5500
Wire Wire Line
	8050 5600 8100 5600
Wire Wire Line
	8050 6100 8400 6100
Wire Wire Line
	6250 5300 8400 5300
Wire Wire Line
	5650 5300 5400 5300
Text Label 1950 1350 0    50   ~ 0
OSC
Wire Wire Line
	9250 5550 9450 5550
Text Label 9300 5550 0    50   ~ 0
OSC
Wire Bus Line
	4250 3750 4250 5050
Wire Bus Line
	6150 3750 6150 5050
Wire Bus Line
	7800 3650 7800 5050
Wire Bus Line
	5650 3650 5650 5050
Wire Bus Line
	5850 1850 5850 3250
Wire Bus Line
	8100 1850 8100 4850
Wire Bus Line
	3950 4300 3950 5050
Wire Bus Line
	4250 1850 4250 3450
Wire Bus Line
	6150 1850 6150 3450
Wire Bus Line
	3950 1850 3950 3900
$EndSCHEMATC
