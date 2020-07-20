# z80miniframe
Core firmware source code of Z80MiniFrame. Z80 based microcomputer

Its a microcomputer based on Z80 CPU with 32KB RAM and 8KB ROM with little monitor and Z80 BASIC version. The original init routines for Nascom BASIC
are developed by Grant Searlet

## Required tools

This project uses ZMAC Z80 Assembler compiler and SREC utilities to concatenate hex files. And finally needs make or nmake to build project.

## Build

nmake all

This produces firmware.hex into bin directory and this file can burn into 32KBytes EEPROM like AT28C256.
