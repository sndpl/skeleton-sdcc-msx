        ;--- crt0.s for MSX-DOS - by Konami Man, 11/2004
        ;    Modified by algodesigner, 09/2021
        ;
        ;    Advanced version: allows "int main(int argc, char** argv)",
        ;    the returned value will be passed to _TERM on DOS 2,
        ;    argv is always 0x100 (the startup code memory is recycled).
        ;    Overhead: 112 bytes.
        ;
        ;    Compile programs with --code-loc 0x170 --data-loc X
        ;    X=0  -> global vars will be placed immediately after code
        ;    X!=0 -> global vars will be placed at address X
        ;            (make sure that X>0x100+code size)

    .globl  _main

    .area _HEADER (ABS)

        .org    0x0100  ;MSX-DOS .COM programs start address

        ;--- Step 1: Initialize globals

init:   call    gsinit

        ;--- Step 2: Build the parameter pointers table on 0x100,
        ;    and terminate each parameter with 0.
        ;    MSX-DOS places the command line length at 0x80 (one byte),
        ;    and the command line itself at 0x81 (up to 127 characters).
        
        ; Retrieve the full program path, our first parameter

        ld      hl,#0x100
        ld      de,#_HEAP_start
        ld      (hl),e
        inc     hl
        ld      (hl),d
        ld      hl,#envvar
        ld      bc,#0xff6b
        call    #5

        ;* Check if there are any command line parameters

        ld      a,(#0x80)
        or      a
        ld      c,#1            ; c <- number of parameters
        jr      z,cont
        
        ;* Terminate command line with 0
        ;  (DOS 2 does this automatically but DOS 1 does not)
        
        ld      hl,#0x81
        ld      bc,(#0x80)
        ld      b,#0
        add     hl,bc
        ld      (hl),#0
        
        ;* Copy the command line processing code to 0xC000 and
        ;  execute it from there, this way the memory of the original code
        ;  can be recycled for the parameter pointers table.
        ;  (The space from 0x100 up to "cont" can be used,
        ;   this is room for about 40 parameters.
        ;   No real world application will handle so many parameters.)
        
        ld      hl,#parloop
        ld      de,#0xC000
        ld      bc,#parloopend-#parloop
        ldir

        ;* Initialize registers and jump to the loop routine
        
        ld      hl,#0x81        ;Command line pointer
        ld      c,#1            ;Number of params found
        ld      ix,#0x102       ;Params table pointer +2 as the first entry
                                ;is taken by the program name
        ld      de,#cont        ;To continue execution at "cont"
        push    de              ;when the routine RETs
        jp      0xC000
        
envvar: .asciz  "PROGRAM"

        ;>>> Command line processing routine begin
        
        ;* Loop over the command line: skip spaces
        
parloop:
        ld      a,(hl)
        or      a       ;Command line end found?
        ret     z

        cp      #32
        jr      nz,parfnd
        inc     hl
        jr      parloop

        ;* Parameter found: add its address to params table...

parfnd: ld      (ix),l
        ld      1(ix),h
        inc     ix
        inc     ix
        inc     c
        
        ld      a,c     ;protection against too many parameters
        cp      #40
        ret     nc
        
        ;* ...and skip chars until finding a space or command line end
        
parloop2:       ld      a,(hl)
        or      a       ;Command line end found?
        ret     z
        
        cp      #32
        jr      nz,nospc        ;If space found, set it to 0
                                ;(string terminator)...
        ld      (hl),#0
        inc     hl
        jr      parloop         ;...and return to space skipping loop

nospc:  inc     hl
        jr      parloop2

parloopend:
        
        ;>>> Command line processing routine end
        
        ;* Command line processing done. Here, C=number of parameters.

cont:   ld      hl,#0x100
        ld      b,#0
        push    hl
        push    bc      ;Pass info as parameters to "main"

        ;--- Step 3: Call the "main" function
    push de
    ld de,#_HEAP_start + 256    ; 256 bytes reserved for the program name
    ld (_heap_top),de
    pop de

    call    _main

        ;--- Step 4: Program termination.
        ;    Termination code for DOS 2 was returned on L.
                
        ld      c,#0x62   ;DOS 2 function for program termination (_TERM)
        ld      b,l
        call    5      ;On DOS 2 this terminates; on DOS 1 this returns...
        ld      c,#0x0
        jp      5      ;...and then this one terminates
                       ;(DOS 1 function for program termination).

        ;--- Program code and data (global vars) start here

    ;* Place data after program code, and data init code after data

    .area   _CODE
    .area   _DATA
_heap_top::
    .dw 0

gsinit: .area   _GSINIT

        .area   _GSFINAL
        ret

    ;* These doesn't seem to be necessary... (?)

        ;.area  _OVERLAY
    ;.area  _HOME
        ;.area  _BSS
    .area   _HEAP

_HEAP_start::
