#include "conio.h"
#include "dos.h"

void main(int argc, char *args[])
{
    puts("argc=");
    putdec8(argc);
    puts("\r\n");
    for (int i = 0; i < argc; i++) {
        puts("argument[");
        putdec8(i);
        puts("]=");
        puts(args[i]);
        puts("\r\n");
    }

    exit(0);
}
