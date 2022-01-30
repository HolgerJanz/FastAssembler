* Tha Atari Color Massacre
* GTIA programming example
* including noise via GTIA key click
* inspired by the demo
* Dieter und Gisela bumsen wie die wilden Tiere in Nachbars Whirlpool
* (no, I do not translate this)
* by JAC! from 06.06.2007 see wudsn.com

* System Equates
RTCLOK    equ $12

GPRIOR    equ $026F
SDMCTL    equ $022F
RUNAD     equ $02E0

HPOSP0    equ $D000
HPOSP1    equ $D001
SIZEP0    equ $D008
SIZEP1    equ $D009
COLPM0    equ $D012
COLPM1    equ $D013
COLBK     equ $D01A
GRAFP0    equ $D00D
GRAFP1    equ $D00E
CONSOL    equ $D01F
WSYNC     equ $D40A
VCOUNT    equ $D40B

* zero page
NOISECNT  equ $80

* Code Block
          blk dos $2000
start     ldx #$00
* sitwch off ANTIC (no DMA)
          stx SDMCTL
* init noise count
          stx NOISECNT
* reset clock
          stx RTCLOK+1
          stx RTCLOK+2
          dex
* full size player 0/1
          stx SIZEP0
          stx SIZEP1
          stx GRAFP0
          stx GRAFP1
* overlap color for player 0/1
          ldx #$20
          stx GPRIOR
* race the beam:
* sync line begin
loop      sta WSYNC
* time critical,
* first position than color
          sty HPOSP0
          stx HPOSP1
          sty COLPM0
          stx COLPM1
          sta COLBK
* now there is time to calc,
* first make some noise with GTIA
          dec NOISECNT
          bne _nonoise
          lda #$0F
          sta CONSOL
          lda #$07
          sta CONSOL
          lda RTCLOK+1
          sta NOISECNT
* player 0 pos and color in Y 
_nonoise  lda VCOUNT
          clc
          adc #$80
          adc RTCLOK+2
          eor RTCLOK+1
          tay
* player 1 pos and color in X 
          lda VCOUNT
          eor #$FF
          clc
          adc RTCLOK+2
          eor RTCLOK+1
          tax
* back color in A
          lda VCOUNT
          clc
          adc #$40
          asl @
          bpl *+4
          eor #$FF
* wait for next line begin
          jmp loop

* Run Block for Atari DOS
          blk dos RUNAD
          dta a(start)

          end
