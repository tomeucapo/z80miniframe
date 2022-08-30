ASM=zmac
LD=ld80
SYSTEM=Z80AIO
OPTS=-I include --rel7 -D$(SYSTEM) -DVDP_DISABLE -DIM_1
SREC=srec_cat
MEMTYPE=27256
COMEPROM=COM3


all: firmware.hex

clean:
	rm -Force bin/*

burn: 
	epromng -mem $(MEMTYPE) -spi y -auto y bin/firmware.hex $(COMEPROM)

ppi.rel: ppi.asm
	$(ASM) ppi.asm $(OPTS) -o bin/ppi.rel

psg.rel: psg.asm
	$(ASM) psg.asm $(OPTS) -o bin/psg.rel

ctc.rel: ctc.asm
	$(ASM) ctc.asm $(OPTS) -o bin/ctc.rel

vdp.rel: vdp.asm
	$(ASM) vdp.asm $(OPTS) -o bin/vdp.rel

buffer.rel: buffer.asm
	$(ASM) buffer.asm $(OPTS) -o bin/buffer.rel

serial.rel: serial.asm 
	$(ASM) serial.asm $(OPTS) -o bin/serial.rel

keyboard.rel: keyboard.asm
	$(ASM) keyboard.asm $(OPTS) -o bin/keyboard.rel

conio.rel: common.asm conio.asm
	$(ASM) conio.asm $(OPTS) -o bin/conio.rel

casette.rel: ppi.asm casette.asm
	$(ASM) casette.asm $(OPTS) -o bin/casette.rel

monitor.rel: common.asm conio.asm monitor.asm 
	$(ASM) monitor.asm $(OPTS) -o bin/monitor.rel

common.rel: common.asm
	$(ASM) common.asm $(OPTS) -o bin/common.rel

svcroutine.rel: svcroutine.asm 
	$(ASM) svcroutine.asm $(OPTS) -o bin/svcroutine.rel

main.rel: main.asm 
	$(ASM) main.asm $(OPTS) -o bin/main.rel

bas32K.rel: bas32K.asm 
	$(ASM) bas32K.asm $(OPTS) -o bin/bas32K.rel

firmware.hex: main.rel svcroutine.rel monitor.rel bas32K.rel conio.rel common.rel ppi.rel psg.rel ctc.rel vdp.rel buffer.rel serial.rel keyboard.rel casette.rel
	pushd
	cd bin
	$(LD) -O hex -o firmware.hex -s symbols.sym main.rel svcroutine.rel monitor.rel common.rel conio.rel ppi.rel ctc.rel psg.rel vdp.rel buffer.rel serial.rel keyboard.rel casette.rel bas32K.rel 
	dos2unix firmware.hex
