* File Campare
* equal, status=0
* not equal, status=255

printf   smb 'printf'
getatr   smb 'u_getatr'
getnum   smb 'u_getnum'
fopen    smb 'fopen'
fgetc    smb 'fgetc'
fcloseal smb 'fcloseal'
ftell    smb 'ftell'
filelen  smb 'fileleng'
dos      smb '_DOS'
sfail    smb 'u_sfail'
fail     smb 'u_fail'
xfail    smb 'u_xfail'
status   smb 'status'
putc     smb 'putc'

fhandle  equ $760
fmode    equ $778
faux1    equ $782

         blk reloc main

comp     lda vtrap
         ldx vtrap+1
         jsr sfail

         ldx #1
         stx fnum
         dex
         stx fdif
         stx fdif+1
         stx fmax+1
         ldx #3
         stx fmax

         jsr finit
         lda #','
         jsr putc
         lda #' '
         jsr putc
         inc fnum
         jsr finit
         lda #$9b
         jsr putc

         jsr getnum
         beq comp_lp

         sta fmax
         stx fmax+1

comp_lp  ldx fileids
         stx fhandle
         jsr fgetc
         bmi comp_ex

         sta f1byte
         ldx fileids+1
         stx fhandle
         jsr fgetc
         bmi comp_ex

         cmp f1byte
         beq comp_lp
         sta f2byte

         jsr ftell
         jsr printf
         dta c'Different at %e : $%2x $%2x',b($9b,0)
         dta a(faux1),v(f1byte,f2byte)

         inc fdif
         bne *+5
         inc fdif+1

         lda fmax
         ora fmax+1
         beq comp_lp

         lda fdif
         cmp fmax
         lda fdif+1
         sbc fmax+1
         bcc comp_lp

comp_ex  lda #00
         sta status
         lda fdif
         ora fdif+1
         beq comp_ok

         jsr printf
         dta c'Files are different',b($9B,0)
         lda #$ff
         jmp fail

comp_ok  jsr printf
         dta c'Files are equal',b($9B,0)


comp_ed  jsr xfail
         jmp fcloseal

finit    lda #$A0
         jsr getatr
         bne finit_0

         lda #$9C
         jmp fail

finit_0  lda #$04
         sta fmode
         jsr fopen

         ldx fnum
         lda fhandle
         sta fileids-1,x

         jsr filelen

         jsr printf
         dta c'File%1x %e Bytes',b(0)
         dta v(fnum),a(faux1)
         rts

vtrap    dta v(trap)

trap     cmp #$9C
         beq trap_0
         jmp trap_1

trap_0   jsr printf
         dta c'Usage:',b($9b)
         dta c' [atr] fspec1 [atr] fspec2 [max]'
         dta b($9b)
         dta c'atr   : file attributes,',b($9B)
         dta c'fspec : file name,',b($9b)
         dta c'max   : maximum number of mismatches,',b($9B)
         dta c'        0 allows an unlimited number.',b($9B,0)

trap_1   sta status
         jmp fcloseal

estr     equ *
fileids  equ estr       2
f1byte   equ fileids+2  1
f2byte   equ f1byte+1   1
fnum     equ f2byte+1   1
fdif     equ fnum+1     2
fmax     equ fdif+2     2
eend     equ fmax+2
         blk empty eend-estr+1 main

         blk update adress
         blk update symbols
         blk update new comp '@T_COMP'

         end

