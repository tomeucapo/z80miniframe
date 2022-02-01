MEMTYPE=27256
COMEPROM=COM4
Z80ASM=sdasz80
Z80ASMOPTS=-l -o -s -Iinclude
SDCC=sdcc

all: main.ihx

clean:
	rm -f *.ihx
	rm -f *.bin
	rm -f *.lst
	rm -f *.rel
	rm -f *.map
	rm -f *.sym
	rm -f *.noi

common.rel:
	$(Z80ASM) $(Z80ASMOPTS) common.rel common.s

pio.rel:
	$(Z80ASM) $(Z80ASMOPTS) pio.rel pio.s

vdp.rel:
	$(Z80ASM) $(Z80ASMOPTS) vdp.rel vdp.s

serial.rel:
	$(Z80ASM) $(Z80ASMOPTS) serial.rel serial.s

main.rel:
	$(Z80ASM) $(Z80ASMOPTS) main.rel main.s

main.ihx: common.rel pio.rel serial.rel vdp.rel main.rel
	$(SDCC) -mz80 common.rel pio.rel serial.rel vdp.rel main.rel -o main.ihx

burn: main.ihx
	epromng -mem $(MEMTYPE) -spi y -auto y main.ihx $(COMEPROM)
