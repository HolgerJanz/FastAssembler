* Example for FA
* Reads SDX variable FLAG,
* MUL_32tiplies it with 8 and returns
* it as SDX STATUS
* This example is used with
* CALLER.ASM

* used SDX symbols
COMTAB   smb 'COMTAB'
PRINTF   smb 'PRINTF'
FLAG     smb 'FLAG'
STATUS   smb 'STATUS'
MUL_32   smb 'MUL_32'

* relocatable block
         blk reloc main
* display received FLAG
         jsr PRINTF
         dta c'CALLEE Received FLAG: $%2x'
         dta b($9B,0)
         dta v(FLAG)
* reset MUL_32tiplication registers
* var1 and var2 (3byte register)
         lda #$00
         ldx #$03
clr_loop sta COMTAB+$ff,x
         sta COMTAB+$103,x
         dex
         bpl clr_loop
* set MUL_32tiplication registers
         lda #$08
         sta COMTAB+$ff+3
         lda FLAG
         sta COMTAB+$103+3
* MUL_32tiplication
* see SDX Programming Guide
         jsr MUL_32
* set STATUS from result var3
         lda COMTAB+$107+3
         sta STATUS
         jsr PRINTF
         dta c'CALLEE Set STATUS: $%2x'
         dta b($9B,0)
         dta v(STATUS)
         rts

* update of addresses and symbols
         blk update addresses
         blk update symbols

         end
