#include "conio.h"
#include "dos.h"

void main(int argc, char *args[])
{
    puts("argc=");
    putdec16(argc);
    puts("\r\n");
    for (int i = 0; i < argc; i++) {
        puts("argument[");
        putdec16(i);
        puts("]=");
        puts(args[i]);
        puts("\r\n");
    }

    exit(0);
}
