**************************
* Example Raster Graphic *
**************************
* use dli screen address update for scrolling
* complete scrolling in vblk
* horizontal hardware scrolling
* players to cover noise 
* only memory $2000-$28BB used (2235bytes)
* supports all DOSs with MEMLO<=$2000

******************
* System Equates *
******************
RTCLOK      equ $0012

VDSLST      equ $0200
SDMCTL      equ $022F
SDLST       equ $0230
GPRIOR      equ $026F
COLOR4      equ $02C8
RUNAD       equ $02e0

HPOSP0      equ $D000
HPOSP1      equ $D001
SIZEP0      equ $D008
SIZEP1      equ $D009
COLBK       equ $D01A
GRACTL      equ $D01D
RANDOM      equ $D20A
HSCROL      equ $d404
PMBASE      equ $D407
NMIEN       equ $D40E

SETVBV      equ $E45C
XITVBV      equ $E462

****************
* Code Segment *
****************
* pm starts at 1k page
pm_mem      equ $2000
* start of code
            blk dos pm_mem+$400
* switch off dma for setup
start       lda #$00
            sta SDMCTL
* hide noise at left and rigth
* using player
            lda >pm_mem
            sta PMBASE
* set screen memory for player
            lda #$FF
            tax
_pm_mem_lp  sta pm_mem,X
            sta pm_mem+$100,X
            sta pm_mem+$200,X
            sta pm_mem+$300,X
            dex
            bne _pm_mem_lp
* setup player
            lda #$03
            sta GRACTL
            lda #$14
            sta HPOSP0
            lda #$D0
            sta HPOSP1
            lda #$03
            sta SIZEP0
            sta SIZEP1
* setup GITA mode GR.9, and prio
            lda #$43
            sta GPRIOR
* setup DL
            lda #$00
            sta COLOR4
            lda #$00
            sta RTCLOK+2
            lda <disp_lst
            sta SDLST
            lda >disp_lst
            sta SDLST+1
            lda <dli
            sta VDSLST
            lda >dli
            sta VDSLST+1
            lda #$C0 
            sta NMIEN
            ldy <vbi
            ldx >vbi
            lda #$07
            jsr SETVBV
* switch on dma
            lda #$2A
            sta SDMCTL
* everything is done in vblki
endless     jmp endless

* vertical blank interrupt
vbi         lda #$00
* reset dli count
            sta dli_cnt
* revert HSCROL for part 1, see dli
            lda _hscrol
            sta HSCROL
* set color array every 256/60 seconds
            lda RTCLOK+2
            bne _no_set_col
* last color X=6, always black for
* boarder at top and bottom
            ldx #$05
_next_color lda RANDOM
            and #$F0
            sta color_array,X
            dex
            bpl _next_color
_no_set_col ldx _hscrol
* do hardware scrolling
            beq _mv_start
* in GR.9 one pixel is two color clocks
            dex
            dex
            stx _hscrol
* HSCROL is a write only register!
            stx HSCROL
            beq _end_vbi
_mv_start   inx
            inx
            stx _hscrol
            stx HSCROL
* modify dl addresses
* calc low byte for part 1 and 6
            inc mv_cnt
            lda mv_cnt
            cmp #$10
            bcc _mv_no_res
            lda #$00
            sta mv_cnt
_mv_no_res  lsr @
            bcc _mv_no_s2
            ora #$80
_mv_no_s2   rol @
* set low byte for part 1 and 6
            ldx #$00
* part 1 and 6 uses inverted value
* of each other
_next_16    sta dl_part1+1,X
            eor #$0f
            sta dl_part6+1,X
            eor #$0f
            inx
            inx
            inx
            cpx #$20*3
            bne _next_16
* set low byte for part 2 and 4
            lda dl_part2+1
            tay
            ldx #$00
_next_24    lda dl_part2+1+3,X
            sta dl_part2+1,X
            sta dl_part4+1,X
            inx
            inx
            inx
            cpx #$1F*3
            bne _next_24
            tya
            sta dl_part2+1,X
            sta dl_part4+1,X
* set low byte for part 3 and 5
            lda dl_part3+1+$1f*3
            tay
            ldx #$1E*3
_next_35    lda dl_part3+1,X
            sta dl_part3+1+3,X
            sta dl_part5+1+3,X
            dex
            dex
            dex
            bpl _next_35
            tya
            sta dl_part3+1
            sta dl_part5+1
_end_vbi    jmp XITVBV

* display list interrupt
dli         pha
            txa
            pha
* update color registe
            ldx dli_cnt
            lda color_array,X
            sta COLBK
* invert hardware scrolling for part 5
            cpx #$05
            bne *+10
            lda _hscrol
            eor #$02
            sta HSCROL
* incerement dli count
            inc dli_cnt
            pla
            tax
            pla
            rti

* Some Variables:
* at every 16th byte fall back to 0
mv_cnt      dta b($00)
* needed because HSCROL is write only
_hscrol     dta b($02)
* color array for part 1-6 and
* last color for top/bottom
color_array dta b($10,$20,$30,$40,$50,$60,$00)
* dli counter to identify dli line
dli_cnt     dta b($00)

* Display List
disp_lst    dta b($70,$70,$60)
* use empty line for dli, looks nicer and gives time for dli
            dta b($80)
* first part with horizontal scrolling
dl_part1    dta b($5F)
            dta a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($80)
* part 2-5, vertical scrolling is not
* needed because line equals scan line
dl_part2    dta b($4F),a(scr_l1+$00),b($4F),a(scr_l2+$00),b($4F),a(scr_l1+$01),b($4F),a(scr_l2+$01)
            dta b($4F),a(scr_l1+$02),b($4F),a(scr_l2+$02),b($4F),a(scr_l1+$03),b($4F),a(scr_l2+$03)
            dta b($4F),a(scr_l1+$04),b($4F),a(scr_l2+$04),b($4F),a(scr_l1+$05),b($4F),a(scr_l2+$05)
            dta b($4F),a(scr_l1+$06),b($4F),a(scr_l2+$06),b($4F),a(scr_l1+$07),b($4F),a(scr_l2+$07)
            dta b($4F),a(scr_l1+$08),b($4F),a(scr_l2+$08),b($4F),a(scr_l1+$09),b($4F),a(scr_l2+$09)
            dta b($4F),a(scr_l1+$0A),b($4F),a(scr_l2+$0A),b($4F),a(scr_l1+$0B),b($4F),a(scr_l2+$0B)
            dta b($4F),a(scr_l1+$0C),b($4F),a(scr_l2+$0C),b($4F),a(scr_l1+$0D),b($4F),a(scr_l2+$0D)
            dta b($4F),a(scr_l1+$0E),b($4F),a(scr_l2+$0E),b($4F),a(scr_l1+$0F),b($4F),a(scr_l2+$0F)
            dta b($80)
dl_part3    dta b($4F),a(scr_l1+$00),b($4F),a(scr_l2+$00),b($4F),a(scr_l1+$01),b($4F),a(scr_l2+$01)
            dta b($4F),a(scr_l1+$02),b($4F),a(scr_l2+$02),b($4F),a(scr_l1+$03),b($4F),a(scr_l2+$03)
            dta b($4F),a(scr_l1+$04),b($4F),a(scr_l2+$04),b($4F),a(scr_l1+$05),b($4F),a(scr_l2+$05)
            dta b($4F),a(scr_l1+$06),b($4F),a(scr_l2+$06),b($4F),a(scr_l1+$07),b($4F),a(scr_l2+$07)
            dta b($4F),a(scr_l1+$08),b($4F),a(scr_l2+$08),b($4F),a(scr_l1+$09),b($4F),a(scr_l2+$09)
            dta b($4F),a(scr_l1+$0A),b($4F),a(scr_l2+$0A),b($4F),a(scr_l1+$0B),b($4F),a(scr_l2+$0B)
            dta b($4F),a(scr_l1+$0C),b($4F),a(scr_l2+$0C),b($4F),a(scr_l1+$0D),b($4F),a(scr_l2+$0D)
            dta b($4F),a(scr_l1+$0E),b($4F),a(scr_l2+$0E),b($4F),a(scr_l1+$0F),b($4F),a(scr_l2+$0F)
            dta b($80)
dl_part4    dta b($4F),a(scr_l1+$00),b($4F),a(scr_l2+$00),b($4F),a(scr_l1+$01),b($4F),a(scr_l2+$01)
            dta b($4F),a(scr_l1+$02),b($4F),a(scr_l2+$02),b($4F),a(scr_l1+$03),b($4F),a(scr_l2+$03)
            dta b($4F),a(scr_l1+$04),b($4F),a(scr_l2+$04),b($4F),a(scr_l1+$05),b($4F),a(scr_l2+$05)
            dta b($4F),a(scr_l1+$06),b($4F),a(scr_l2+$06),b($4F),a(scr_l1+$07),b($4F),a(scr_l2+$07)
            dta b($4F),a(scr_l1+$08),b($4F),a(scr_l2+$08),b($4F),a(scr_l1+$09),b($4F),a(scr_l2+$09)
            dta b($4F),a(scr_l1+$0A),b($4F),a(scr_l2+$0A),b($4F),a(scr_l1+$0B),b($4F),a(scr_l2+$0B)
            dta b($4F),a(scr_l1+$0C),b($4F),a(scr_l2+$0C),b($4F),a(scr_l1+$0D),b($4F),a(scr_l2+$0D)
            dta b($4F),a(scr_l1+$0E),b($4F),a(scr_l2+$0E),b($4F),a(scr_l1+$0F),b($4F),a(scr_l2+$0F)
            dta b($80)
dl_part5    dta b($4F),a(scr_l1+$00),b($4F),a(scr_l2+$00),b($4F),a(scr_l1+$01),b($4F),a(scr_l2+$01)
            dta b($4F),a(scr_l1+$02),b($4F),a(scr_l2+$02),b($4F),a(scr_l1+$03),b($4F),a(scr_l2+$03)
            dta b($4F),a(scr_l1+$04),b($4F),a(scr_l2+$04),b($4F),a(scr_l1+$05),b($4F),a(scr_l2+$05)
            dta b($4F),a(scr_l1+$06),b($4F),a(scr_l2+$06),b($4F),a(scr_l1+$07),b($4F),a(scr_l2+$07)
            dta b($4F),a(scr_l1+$08),b($4F),a(scr_l2+$08),b($4F),a(scr_l1+$09),b($4F),a(scr_l2+$09)
            dta b($4F),a(scr_l1+$0A),b($4F),a(scr_l2+$0A),b($4F),a(scr_l1+$0B),b($4F),a(scr_l2+$0B)
            dta b($4F),a(scr_l1+$0C),b($4F),a(scr_l2+$0C),b($4F),a(scr_l1+$0D),b($4F),a(scr_l2+$0D)
            dta b($4F),a(scr_l1+$0E),b($4F),a(scr_l2+$0E),b($4F),a(scr_l1+$0F),b($4F),a(scr_l2+$0F)
            dta b($80)
* last part with horizontal scrolling
dl_part6    dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
            dta b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1),b($5F),a(scr_l1)
* last dli to reset color for bottom
* and top after vblk
            dta b($80)
            dta b($41),a(disp_lst)

**************************
* Screen Memory Segments *
**************************
* screen memory 1, starts at new page
* see modify dl addresses
            blk dos *&$FF00+$100
scr_l1      dta b($01,$23,$45,$67,$89,$AB,$CD,$EF,$FE,$DC,$BA,$98,$76,$54,$32,$10)
            dta b($01,$23,$45,$67,$89,$AB,$CD,$EF,$FE,$DC,$BA,$98,$76,$54,$32,$10)
            dta b($01,$23,$45,$67,$89,$AB,$CD,$EF,$FE,$DC,$BA,$98,$76,$54,$32,$10)
            dta b($01,$23,$45,$67,$89,$AB,$CD,$EF,$FE,$DC,$BA,$98)
* screen memory 2, starts at screen memory 1 + $80
            blk dos scr_l1+$80
scr_l2      dta b($12,$34,$56,$78,$9A,$BC,$DE,$FF,$ED,$CB,$A9,$87,$65,$43,$21,$00)
            dta b($12,$34,$56,$78,$9A,$BC,$DE,$FF,$ED,$CB,$A9,$87,$65,$43,$21,$00)
            dta b($12,$34,$56,$78,$9A,$BC,$DE,$FF,$ED,$CB,$A9,$87,$65,$43,$21,$00)
            dta b($12,$34,$56,$78,$9A,$BC,$DE,$FF,$ED,$CB,$A9,$87)

**************************
* Start Address Segment *
**************************
* set start address for Atari DOS
            blk dos RUNAD
            dta a(start)

            end
