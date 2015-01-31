# Skeleton C project for MSX
Will create a "hello world" program running on MSX Z80 platform and emulated hardware. Following packages are required:

  * make
  * [hex2bin](http://sourceforge.net/projects/hex2bin/) (1)
  * [sdcc](http://sdcc.sourceforge.net/)

(1) To compile hex2bin on OSX, download the source. Extract the archive and delete the hex2bin, mot2bin and hex2bin.1 files (they are for Linux). Then go to the directory on the command line and rebuild the binaries for OS X by typing: ```make```
To do a system-wide install: ```make install MAN_DIR=/usr/local/share/man/man1```


## Compiling
A build run should result in the following output:
```
sdasz80 -o crt0msx_msxdos.rel lib/crt0msx_msxdos.s
sdasz80 -o putchar.rel lib/putchar.s
sdasz80 -o getchar.rel lib/getchar.s
sdasz80 -o dos.rel lib/dos.s
sdcc -V -mz80 -c -o conio.rel lib/conio.c
+ /usr/local/bin/sdcpp -nostdinc -Wall -obj-ext=.rel -D__SDCC_STACK_AUTO -DSDCC_STACK_AUTO -D__SDCC_INT_LONG_REENT -DSDCC_INT_LONG_REENT -D__SDCC_FLOAT_REENT -DSDCC_FLOAT_REENT -D__SDCC=3_4_0 -DSDCC=340 -D__SDCC_REVISION=8981 -DSDCC_REVISION=8981 -D__SDCC_z80 -DSDCC_z80 -D__z80 -D__STDC_NO_COMPLEX__ -D__STDC_NO_THREADS__ -D__STDC_NO_ATOMICS__ -D__STDC_NO_VLA__ -isystem /usr/local/bin/../share/sdcc/include/z80 -isystem /usr/local/Cellar/sdcc/3.4.0/share/sdcc/include/z80 -isystem /usr/local/bin/../share/sdcc/include -isystem /usr/local/Cellar/sdcc/3.4.0/share/sdcc/include  lib/conio.c
+ /usr/local/bin/sdasz80 -plosgffw conio.rel conio.asm
sdcc -Iinclude -V -mz80 --code-loc 0x0107 --data-loc 0 --no-std-crt0 crt0msx_msxdos.rel putchar.rel getchar.rel dos.rel conio.rel src/main.c
+ /usr/local/bin/sdcpp -nostdinc -Wall -Iinclude -obj-ext=.rel -D__SDCC_STACK_AUTO -DSDCC_STACK_AUTO -D__SDCC_INT_LONG_REENT -DSDCC_INT_LONG_REENT -D__SDCC_FLOAT_REENT -DSDCC_FLOAT_REENT -D__SDCC=3_4_0 -DSDCC=340 -D__SDCC_REVISION=8981 -DSDCC_REVISION=8981 -D__SDCC_z80 -DSDCC_z80 -D__z80 -D__STDC_NO_COMPLEX__ -D__STDC_NO_THREADS__ -D__STDC_NO_ATOMICS__ -D__STDC_NO_VLA__ -isystem /usr/local/bin/../share/sdcc/include/z80 -isystem /usr/local/Cellar/sdcc/3.4.0/share/sdcc/include/z80 -isystem /usr/local/bin/../share/sdcc/include -isystem /usr/local/Cellar/sdcc/3.4.0/share/sdcc/include  src/main.c
+ /usr/local/bin/sdasz80 -plosgffw main.rel main.asm
+ /usr/local/bin/sdldz80 -nf main.lk
hex2bin main.ihx
hex2bin v1.0.12, Copyright (C) 2012 Jacques Pelletier & contributors

Lowest address  = 00000100
Highest address = 0000039A
Pad Byte        = FF
8-bit Checksum = 76
mv main.bin main.com
```
And this will result in a main.com file which can be run under MSX-DOS.

## Thanks
- [Avelino Herrera Morales](http://msx.atlantes.org/index_en.html]) for providing the basic files needed to create a MSX-DOS executable.
- [Laurens Holst](http://map.grauw.nl/) for helping with hex2bin.


