zmac int32k.asm -o bin/int32k.hex
zmac bas32k.asm -o bin/bas32k.hex
srec_cat bin/int32k.hex -Intel bin/bas32k.hex -Intel -o bin/rom.hex -Intel
