* Music
* POKEY music using software timer
* example inspired by:
* Musik im VBI
* Die Hexenkueche by Peter Finzel

* System Equates
CDTMA2  equ $228
VVBLKD  equ $224
RUNAD   equ $2E0
ICCOM   equ $342
ICBADR  equ $344
ICBLEN  equ $348

AUDF1   equ $D200
AUDC1   equ $D201
AUDCTL  equ $D208
SKCTL   equ $D20F
CONSOL  equ $D01F

CIOV    equ $E456
SETVBV  equ $E45C

* Notes:
C3      equ 243
CIS3    equ 230
D3      equ 217
DIS3    equ 204
E3      equ 193
F3      equ 182
FIS3    equ 173
G3      equ 162
GIS3    equ 153
A3      equ 144
AIS3    equ 136
B3      equ 128
C4      equ 121
CIS4    equ 114
D4      equ 108
DIS4    equ 102
E4      equ 96
F4      equ 91
FIS4    equ 85
G4      equ 81
GIS4    equ 76
A4      equ 72
AIS4    equ 68
B4      equ 64
C5      equ 60
* Note Durations:
* sixteens,eighths,quarter,half
S       equ 8
E       equ S*2
Q       equ S*4
H       equ S*8
* Control Codes:
PAUSE   equ 255
BEGIN   equ 254
DONE    equ 253

* timer 2 value
TMR2VAL equ 1

* temporary zero page register
ZP_FRX  equ $CE

* main loop
        blk dos $2500
start   ldx <text
        ldy >text
        jsr print
        jsr musicon
* check start to quit
        lda #$08
        sta CONSOL
_chkstr lda CONSOL
        and #$01
        bne _chkstr
        jsr musicof
        rts

* print line via IOCB0
* text address in X,Y
print   lda #$09
        sta ICCOM
        stx ICBADR
        sty ICBADR+1
* max character to print
        lda #$20
        sta ICBLEN
        lda #$00
        sta ICBLEN+1
        ldx #$00
        jsr CIOV
        rts

text    dta c'press START to quit',b($9b)

* play music
domusic cld
* set timer, again
        jsr settmr
* play four voices
        ldx #$00
_munxkn jsr muxply
        jsr muxenv
        inx
        cpx #$04
        bne _munxkn
        rts

* music on
musicon lda #$00
        ldx #$03
* clear registers
_muson  sta AUDF1,X
        sta AUDF1+4,X
        sta MUDURA,X
        sta MUINDX,X
        sta MUENVL,X
        dex
        bpl _muson
* init POKEY
        lda #$03
        sta SKCTL
        lda #$00
        sta AUDCTL
* vector for timer 2
        lda <domusic
        sta CDTMA2
        lda >domusic
        sta CDTMA2+1
* value for timer 2
settmr  lda #$02
        ldx #$00
        ldy #TMR2VAL
        jsr SETVBV
        rts

* music off
musicof lda #$02
        ldx #$00
        ldy #$00
* reset timer 2
        jsr SETVBV
        lda #$00
        sta CDTMA2
        sta CDTMA2+1
        ldx #$03
* clear pokey registers
_musoff sta AUDF1,X
        sta AUDF1+4,X
        dex
        bpl _musoff
        rts

* play one voice, number in X
muxply  lda MUDURA,X
        beq _muxnew
* duration not yet finished
        dec MUDURA,X
        bne _muxcnt
* play new note
_muxnew lda #$00
        sta MUPAUS,X
        sta MUENVL,X
        lda VOICETBL,X
        sta ZP_FRX
        lda VOICETBH,X
        sta ZP_FRX+1
* check begin
        ldy MUINDX,X
        lda (ZP_FRX),Y
        cmp #BEGIN
        bne _muxnex
        lda #$00
        sta MUINDX,X
        jmp _muxnew
* cehck done
_muxnex cmp #DONE
        beq _muxrep
* play
        pha
        iny
        lda (ZP_FRX),Y
        sta MUDURA,X
        iny
        tya
        sta MUINDX,X
        txa
        asl @
        tay
        pla
        cmp #PAUSE
        beq _muxpau
        sta AUDF1,Y
* continue
_muxcnt rts
* pause
_muxpau lda #PAUSE
        sta MUPAUS,X
        rts
* repeat
_muxrep lda #$00
        sta MUINDX,X
        rts

* envelope generator
muxenv  lda MUPAUS,X
        cmp #PAUSE
        bne _muxen1
* pause
        lda #$00
        pha
        beq _muxen2
* envelop
_muxen1 lda ENVTBL,X
        sta ZP_FRX
        lda ENVTBH,X
        sta ZP_FRX+1
        ldy MUENVL,X
        lda (ZP_FRX),Y
        cmp #DONE
        beq _muxene
        pha
        iny
        tya
        sta MUENVL,X
* set audio register
_muxen2 txa
        asl @
        tay
        pla
        ora #$A0
        sta AUDC1,Y
_muxene rts

* address tables for voices
VOICETBL dta l(VOICE1,VOICE2,VOICE3,VOICE4)
VOICETBH dta h(VOICE1,VOICE2,VOICE3,VOICE4)

* address tables for envelopes
ENVTBL dta l(ENVEL1,ENVEL2,ENVEL3,ENVEL4)
ENVTBH dta h(ENVEL1,ENVEL2,ENVEL3,ENVEL4)

* Note Tables:
* note1,duration1,note2,duration2,...,DONE
VOICE1 dta b(E4,Q,E4,Q,D4,Q,D4,E,E4,E)
       dta b(F4,Q,F4,Q,E4,Q,E4,Q)
       dta b(E4,E,D4,E,E4,E,F4,E,G4,Q,F4,E,E4,E)
       dta b(D4,Q+E,C4,E,C4,H)
       dta b(E4,Q,E4,Q,F4,Q,F4,E,E4,E)
       dta b(D4,Q,D4,Q,E4,Q,E4,E,D4,E)
       dta b(C4,E,B3,E,C4,E,D4,E,E4,Q,D4,E,C4,E)
       dta b(B3,Q+E,A3,E,A3,H)
       dta b(G4,Q,G4,Q,A4,Q,F4,E,E4,E)
       dta b(D4,Q,D4,Q,G4,Q,F4,E,D4,E)
       dta b(C4,E,D4,E,E4,E,F4,E,G4,Q,F4,E,E4,E)
       dta b(D4,Q+E,C4,E,C4,H)
       dta b(DONE)

VOICE2 dta b(C4,Q,C4,Q,B3,Q,B3,E,C4,E)
       dta b(D4,Q,D4,Q,C4,Q,C4,Q)
       dta b(C4,E,B3,E,C4,E,D4,E,E4,Q,D4,E,C4,E)
       dta b(C4,Q,B3,Q,C4,H)
       dta b(C4,Q,C4,Q,D4,Q,D4,E,C4,E)
       dta b(B3,Q,B3,Q,C4,Q,C4,E,B3,E)
       dta b(A3,E,GIS3,E,A3,E,B3,E,C4,Q,B3,E,A3,E)
       dta b(A3,Q,GIS3,Q,A3,H)
       dta b(E4,Q,E4,Q,F4,Q,D4,E,C4,E)
       dta b(B3,Q,B3,Q,E4,Q,C4,E,B3,E)
       dta b(A3,E,B3,E,C4,E,D4,E,E4,Q,D4,E,C4,E)
       dta b(C4,Q,B3,Q,C4,H)
       dta b(DONE)

VOICE3 dta b(C3,E,D3,E,E3,E,F3,E,G3,Q,G3,Q)
       dta b(D3,E,E3,E,F3,E,G3,E,A3,Q,A3,Q)
       dta b(G3,Q,F3,Q,E3,Q,F3,Q)
       dta b(G3,Q,G3,Q,C3,H)
       dta b(A3,E,G3,E,F3,E,E3,E,D3,Q,D3,Q)
       dta b(G3,E,F3,E,E3,E,D3,E,C3,Q,C3,Q)
       dta b(F3,Q,F3,Q,E3,Q,A3,Q)
       dta b(D3,Q,E3,Q,A3,H)
       dta b(C4,E,B3,E,A3,E,G3,E,F3,Q,F3,Q)
       dta b(G3,E,F3,E,E3,E,D3,E,C3,Q,C3,Q)
       dta b(A3,Q,G3,E,F3,E,E3,E,C3,E,D3,E,E3,E)
       dta b(F3,Q,G3,Q,C3,H)
       dta b(DONE)
* voice four is not used in this example
VOICE4 dta b(DONE)

* Envelope Tables:
* volum1, volume2,...,DONE
ENVEL1 dta b(10,10,8,7,6,9,8,8,8,7,7,7)
       dta b(6,6,6,5,5,4,3,2,1,1,0,DONE)

ENVEL2 dta b(2,6,8,8,8,7,7,7,6,6,6,6)
       dta b(5,5,4,4,4,3,2,2,2,1,0,DONE)

ENVEL3 dta b(2,4,6,8,9,10,9,8,8,7,7,6)
       dta b(6,6,6,6,5,5,5,5,5,5,5,5,5,5)
       dta b(4,4,4,4,4,4,4,4,4,4,2,1,0,DONE)
* voice four is not used in this example
ENVEL4 dta b(DONE)

* Variables:
* current indexes in voice tables
MUINDX dta b(0,0,0,0)
* durations
MUDURA dta b(0,0,0,0)
* pause flags
MUPAUS dta b(0,0,0,0)
* envelope
MUENVL dta b(0,0,0,0)

* Run Block for Atari DOS
         blk dos RUNAD 
         dta a(start)

         end
