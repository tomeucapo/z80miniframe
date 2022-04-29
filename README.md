# Z80MiniFrame
Core firmware source code and schematics from Z80MiniFrame hardware. This is a Z80 based microcomputer based system.

## Features

### Hardware 

* 32KBytes EEPROM for Firmware routines and Z80 MS-BASIC
* 32KBytes RAM
* VDP TMS9918
* PSG AY-3-8910
* UART 16550D
* USB-Serial Console Interface 

### Software

* Integrated monitor
* Extend BASIC instructions to support VDP capabilities like: COLOR, SCREEN or LOCATE instructions.
* Created RST $20 routine service to call firmware routines like VDP routines, serial, ...

## Required tools
This project uses SDCC Compiler for Z80 and MAC Z80 Assembler compiler and SREC utilities to concatenate hex files. And finally needs make or nmake to build project.

## Build software
```
nmake all
```

This produces firmware.hex into bin directory and this file can burn into 32KBytes EEPROM like AT28C256.

