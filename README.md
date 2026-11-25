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
- CompactFlash IDE PIO routines for 512-byte LBA28 sector reads and writes
- Interrupt-mode 2 support and firmware service routines at `RST $20`

The CompactFlash routines use the `$A0-$A7` I/O ports. Call `CF_INIT` before
transfers, then set the four-byte little-endian `CF_LBA` and two-byte
little-endian `CF_BUFFER` values and call `CF_READ_SECTOR` or
`CF_WRITE_SECTOR`. These routines provide raw sector access; they do not
implement a filesystem.

The FAT32 support validates a FAT32 superfloppy or a primary MBR partition
(`0x0B`/`0x0C`/`0x1B`/`0x1C`) and lists its root directory in BASIC with `FILES`. The BASIC
statement invokes the directory routine through the firmware `RST $20`
service dispatcher. Names are displayed in 8.3 format; file read/write
operations are not implemented yet. Monitor command `F` initializes the CF
and mounts the volume. In BASIC, enter `FILES` to initialize, mount and list
the root directory.

At startup, the monitor offers these commands:

| Key | Function |
| --- | --- |
| `B` | Start BASIC |
| `M` | Dump memory |
| `R` | Receive Intel HEX records |
| `G` | Jump to an address |
| `T` | Run the keyboard test |
| `C` | Initialize the CompactFlash card |
| `F` | Initialize the CF and mount a FAT32 volume |
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

The PCB project is also available on PCBWay:

<a href="https://www.pcbway.com/project/shareproject/Z80_MiniFrame_All_in_one_Computer_9e265b09.html"><img src="https://www.pcbway.com/project/img/images/frompcbway-1220.png" alt="PCB from PCBWay" /></a>
