# Z80MiniFrame

Z80MiniFrame is a Z80-based microcomputer project. This repository contains its firmware source, hardware schematics and previously built firmware images.

![Z80MiniFrame hardware](https://cdn.hackaday.io/images/9041991566431402353.jpg)

## Hardware

The design includes:

- Z80 CPU
- 32 KiB ROM/EEPROM and 32 KiB RAM
- TMS9918 video display processor (VDP)
- AY-3-8910 programmable sound generator (PSG)
- Serial console
- PPI-based I/O and a keyboard interface

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
The firmware build is configured for the `Z80AIO` target. In that configuration it also initializes the 8253 PIT. The source contains conditional code for other hardware configurations.

## Firmware

The firmware provides:

- A Z80 BASIC interpreter with VDP-aware console and graphics support
- A serial monitor for memory inspection, Intel HEX reception, execution at an address and keyboard testing
- VDP, PSG, keyboard, serial, cassette, PPI and PIT routines
- Interrupt-mode 2 support and firmware service routines at `RST $20`

At startup, the monitor offers these commands:

| Key | Function |
| --- | --- |
| `B` | Start BASIC |
| `M` | Dump memory |
| `R` | Receive Intel HEX records |
| `G` | Jump to an address |
| `T` | Run the keyboard test |
| `?` | Show help |

## Repository layout

| Path | Contents |
| --- | --- |
| `source/` | Assembly source, includes, Makefile and tests |
| `source/include/` | Hardware and firmware definitions |
| `source/tests/` | Assembly and BASIC test programs |
| `source/bin/` | Build output (`firmware.hex`, linker symbols and intermediate files) |
| `firmware/` | Checked-in firmware images from earlier releases |
| `schematics/` | Hardware schematics, PCB files and component libraries |


## Programming the ROM

The Makefile has a `burn` target that invokes `epromng`. Its defaults are `MEMTYPE=27256` and `COMEPROM=COM6`; change these in `source/Makefile` to match your programmer and port before using the target. You can also program `source/bin/firmware.hex` with a compatible programmer configured for the ROM fitted to your board.

## Hardware documentation

PDF schematics are available in `schematics/`, including `CPU_IO_Board.pdf`, `VDP.pdf`, `PSG.pdf` and `SIO_PIO.pdf`. The KiCad project for the Z80 All-in-One board is in `schematics/Z80Allinone/Z80AllInOne/`.
