MEMTYPE=27256
COMEPROM=COM3
Z80ASM=sdasz80
Z80ASMOPTS=-l -o -s -Iinclude
SDCC=sdcc
ZASM=zmac
SREC=srec_cat

all: firmware.hex

clean:
	rm -f *.ihx
	rm -f *.bin
	rm -f *.lst
	rm -f *.rel
	rm -f *.map
	rm -f *.sym
	rm -f *.noi

common.rel: common.s
	$(Z80ASM) $(Z80ASMOPTS) common.rel common.s

pio.rel: pio.s
	$(Z80ASM) $(Z80ASMOPTS) pio.rel pio.s

serial.rel: serial.s
	$(Z80ASM) $(Z80ASMOPTS) serial.rel serial.s

vdp.rel: vdp.s
	$(Z80ASM) $(Z80ASMOPTS) vdp.rel vdp.s

psg.rel: psg.s
	$(Z80ASM) $(Z80ASMOPTS) psg.rel psg.s

monitor.rel: monitor.s
	$(Z80ASM) $(Z80ASMOPTS) monitor.rel monitor.s

serviceroutine.rel: serviceroutine.s
	$(Z80ASM) $(Z80ASMOPTS) serviceroutine.rel serviceroutine.s

main.rel: main.s
	$(Z80ASM) $(Z80ASMOPTS) main.rel main.s

bas32k.hex:
	$(ZASM) bas32k.asm -o bin/bas32k.hex

firmware.ihx: common.rel pio.rel serial.rel vdp.rel psg.rel main.rel monitor.rel serviceroutine.rel
	$(SDCC) -V -mz80 --no-std-crt0 common.rel pio.rel serial.rel vdp.rel psg.rel monitor.rel serviceroutine.rel main.rel -o bin/firmware.ihx

firmware.hex: firmware.ihx bas32k.hex
	$(SREC) -Disable_Sequence_Warnings bin\firmware.ihx -Intel bin\bas32k.hex -Intel -o bin\firmware.hex -Intel

burn: firmware.hex
	epromng -mem $(MEMTYPE) -spi y -auto y bin/firmware.hex $(COMEPROM)
