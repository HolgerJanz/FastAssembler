* Example for FA
* Demo Atari Rainbow Color
* Atari DOS executable
* press START to end

RTCLK   equ $14
RUNAD   equ $02e0
COLPF2  equ $d018
CONSOL  equ $d01f
WSYNC   equ $d40a
VCOUNT  equ $d40b

* main program Atari DOS block
        blk DOS $3000
* reset console keys
start   lda #$08
        sta CONSOL
loop    clc
* calc next color
        lda VCOUNT
        adc RTCLK
* wait for sync
        sta WSYNC
* set color
        sta COLPF2
* check START
        lda CONSOL
        and #$01
        bne loop
        rts

* run address Atari DOS block
        blk DOS RUNAD
        dta a(start)

        end
