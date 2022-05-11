ASM=zmac
SREC=srec_cat
MEMTYPE=27256
COMEPROM=COM3

all: core.hex bas32k.hex cbios.hex firmware.hex

clean:
	rm -f bin/*.hex

burn:
	epromng -mem $(MEMTYPE) -spi y -auto y bin/firmware.hex $(COMEPROM)

core.hex: 
	$(ASM) core.asm -o bin/core.hex  

bas32k.hex:
	$(ASM) bas32k.asm -o bin/bas32k.hex

cbios.hex:
	$(ASM) cbios.asm -o bin/cbios.hex

firmware.hex:
	$(SREC) bin/core.hex -Intel bin/bas32k.hex -Intel bin/cbios.hex -Intel -o bin/firmware.hex -Intel
