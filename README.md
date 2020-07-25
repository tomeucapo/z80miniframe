# Z80MiniFrame
Core firmware source code and schematics from Z80MiniFrame hardware. This is a Z80 based microcomputer based system.

## Required tools
This project uses ZMAC Z80 Assembler compiler and SREC utilities to concatenate hex files. And finally needs make or nmake to build project.

## Build
```
nmake all
```

This produces firmware.hex into bin directory and this file can burn into 32KBytes EEPROM like AT28C256.
