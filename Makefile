AS=sdasz80
CC=sdcc
CCFLAGS=-V -mz80 --code-loc 0x0107 --data-loc 0 --no-std-crt0
HEXBIN=hex2bin
INCLUDEDIR=include
LIBDIR=lib
SRCDIR=src
OBJECTS=crt0msx_msxdos.s putchar.s getchar.s dos.s conio.c
SOURCES=main.c
BINARY=main.com


.PHONY: all

all: $(OBJECTS) $(SOURCES)

%.s:
	$(AS) -o $(notdir $(@:.s=.rel)) $(LIBDIR)/$@
%.c:
	$(CC) -V -mz80 -c -o $(notdir $(@:.c=.rel)) $(LIBDIR)/$@

$(SOURCES):
	$(CC) -I$(INCLUDEDIR) $(CCFLAGS) $(addsuffix .rel, $(basename $(notdir $(OBJECTS)))) $(SRCDIR)/$(SOURCES)
	$(HEXBIN) $(SOURCES:.c=.ihx)
	mv main.bin ${BINARY}

clean:
	rm -f *.asm *.bin *.cdb *.ihx *.lk *.lst *.map *.mem *.omf *.rst *.rel *.sym *.noi
