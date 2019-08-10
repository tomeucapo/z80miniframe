zmac int32k.asm -o int32k.hex
zmac bas32k.asm -o bas32k.hex
srec_cat int32k.hex -Intel bas32k.hex -Intel -o rom.hex -Intel
