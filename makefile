DEVICE = attiny85
CLOCK = 8000000
PROGRAMMER = -c buspirate -P /dev/buspirate
OBJECTS = main.o
FUSES = -U lfuse:w:0xE2:m -U hfuse:w:0xdf:m -U efuse:w:0xff:m

AVRDUDE = avrdude $(PROGRAMMER) -p $(DEVICE)
COMPILE = avr-gcc -Wall -Os -DF_CPU=$(CLOCK) -mmcu=$(DEVICE)

all: main.hex

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@

.c.s:
	$(COMPILE) -S $< -o $@

flash: all
	sudo $(AVRDUDE) -U flash:w:main.hex:i

fuse:
	sudo $(AVRDUDE) $(FUSES)

install: flash fuse

load: all
	bootloadHID main.hex

clean:
	rm -f main.hex main.elf $(OBJECTS)

# file targets:
main.elf: $(OBJECTS)
	$(COMPILE) -o main.elf $(OBJECTS)

main.hex: main.elf
	rm -f main.hex
	avr-objcopy -j .text -j .data -O ihex main.elf main.hex
	avr-size --format=avr --mcu=$(DEVICE) main.elf

disasm: main.elf
	avr-objdump -d main.elf

cpp:
	$(COMPILE) -E main.c
