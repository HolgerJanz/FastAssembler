* Scrolling Demo

* system equates
RTCLOK equ $14
RUNAD  equ $02e0
SDLST  equ $0230
HSCROL equ $d404

       blk dos $2500
* main program
start  lda <dlist
* set display list
       sta SDLST
       lda >dlist
       sta SDLST+1
* scrolling loop
       ldx #$00
loop   ldy RTCLOK
* wait 2/60 seconds
       iny
       iny
* and sync with vblank
wait   cpy RTCLOK
       bne wait
* deccrement hardware scrolling
* register, values 0-3 (color clocks)
       dex
       txa
       and #$03
       sta HSCROL
       cmp #$03
       bne loop
* increment screen memory pointer
* only low part, wrap around
       inc taddr
       jmp loop

* new block at next page
       blk dos *&$FF00+$100
* screen memory, must start at page
* 299 bytes, 256 plus line length 40,
* plus 4 for hardware scrolling
text   dta d'                                        '
       dta d'atari 8-bit - scrolling demo - without m'
       dta d'emory move - only by increment pointer a'
       dta d'nd using hardware scrolling - developed '
       dta d'with Fast Assembler and SpartaDOS X     '
       dta d'           /|\ ATARI                    '
       dta d'press reset to abort                    '
       dta d'                   '
* display list
*          12x8 blank lines
dlist  dta b($70,$70,$70,$70,$70,$70)
       dta b($70,$70,$70,$70,$70,$70)
*          one line GR.0 with scrolling
       dta b($52)
*          screen memory address
taddr  dta a(text)
*          jump back
       dta b($41),a(dlist)

* Run Block for Atari DOS
       blk dos RUNAD
       dta a(start)

       end
