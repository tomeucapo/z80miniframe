ASM=zmac
LD=ld80
OPTS=-I include --rel7
SREC=srec_cat
MEMTYPE=27256
COMEPROM=COM3

all: firmware.hex

clean:
	rm -f bin/*

burn:
	epromng -mem $(MEMTYPE) -spi y -auto y bin/firmware.hex $(COMEPROM)

ppi.rel: ppi.asm
	$(ASM) ppi.asm $(OPTS) -o bin/ppi.rel

ctc.rel: ctc.asm
	$(ASM) ctc.asm $(OPTS) -o bin/ctc.rel

vdp.rel: vdp.asm
	$(ASM) vdp.asm $(OPTS) -o bin/vdp.rel

buffer.rel: buffer.asm
	$(ASM) buffer.asm $(OPTS) -o bin/buffer.rel

serial.rel: serial.asm 
	$(ASM) serial.asm $(OPTS) -o bin/serial.rel

monitor.rel: monitor.asm
	$(ASM) monitor.asm $(OPTS) -o bin/monitor.rel

common.rel: common.asm
	$(ASM) common.asm $(OPTS) -o bin/common.rel

svcroutine.rel: svcroutine.asm 
	$(ASM) svcroutine.asm $(OPTS) -o bin/svcroutine.rel

main.rel: main.asm 
	$(ASM) main.asm $(OPTS) -o bin/main.rel

bas32K.rel: bas32K.asm 
	$(ASM) bas32K.asm $(OPTS) -o bin/bas32K.rel

firmware.hex: main.rel svcroutine.rel monitor.rel bas32K.rel common.rel ppi.rel ctc.rel vdp.rel buffer.rel serial.rel
	pushd
	cd bin
	$(LD) -O hex -o firmware.hex -s symbols.sym main.rel svcroutine.rel monitor.rel bas32K.rel common.rel ppi.rel ctc.rel vdp.rel buffer.rel serial.rel
	dos2unix firmware.hex
