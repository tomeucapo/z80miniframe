# Z80MiniFrame
Core firmware source code and schematics from Z80MiniFrame hardware. This is a Z80 based microcomputer based system.

## Features

### Hardware 

* 32KBytes EEPROM for Firmware routines and Z80 MS-BASIC
* 32KBytes RAM
* VDP TMS9918
* PSG AY-3-8910
* USB-Serial Console Interface
 
![alt text](https://cdn.hackaday.io/images/9041991566431402353.jpg)

### Software

* Extend BASIC instructions to support VDP capabilities like: COLOR, SCREEN or LOCATE instructions.
* Created RST $20 routine service to call firmware routines like VDP routines.

## Required tools
This project uses the ZMAC Z80 Macro assembler and LD80 linker from
http://48k.ca/zmac.html, as well as CMake.

## Build software
```
cmake -S . -B build
cmake --build build
```

This produces `build/bin/firmware.hex`. To program an EPROM, install `epromng`
and run `cmake --build build --target burn`.

The firmware system and EPROM programming settings can be changed at configure
time, for example with `-DFIRMWARE_SYSTEM=Z80AIO`,
`-DEPROM_MEMTYPE=27256`, and `-DEPROM_COM_PORT=COM6`.
