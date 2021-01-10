* Example program 1 for FA
* To assembly:
* FA EX1READ.ASM EX1READ.COM

* Reads SDX variable FLAG,
* multiplies it with 8 and returns
* it as SDX execution STATUS

* This example can be used with
* EX2CALL

         lst bad

* definition of SDX symbols

comtab   smb 'comtab'
printf   smb 'printf'
flag     smb 'flag'
status   smb 'status'
mul      smb 'mul_32'

* relocatable block

         blk reloc main

* display received flag

odb      jsr printf
         dta b($9b),c' Received flag: %2x',b($9B,0)
         dta v(flag)

* reset multiplication registers

         lda #0

         ldx #3
odb_0    sta comtab+$ff,x  var1
         sta comtab+$103,x var2
         dex
         bpl odb_0

* set multiplication registers

         lda #8
         sta comtab+$ff+3  var1
         lda flag
         sta comtab+$103+3 var2

* multiplication

         jsr mul

* set status

         lda comtab+$107+3 var3
         sta status
         rts

* update of addresses, symbols and
* new symbol

         blk update adress
         blk update symbols
         blk update new odb '@ex1read'

         end

