ASM=zmac
SREC=srec_cat

all: core.hex bas32k.hex firmware.hex

clean:
	rm -f bin/*.hex

core.hex: 
	$(ASM) core.asm -o bin/core.hex  

bas32k.hex:
	$(ASM) bas32k.asm -o bin/bas32k.hex

firmware.hex:
	$(SREC) bin/core.hex -Intel bin/bas32k.hex -Intel -o bin/firmware.hex -Intel
