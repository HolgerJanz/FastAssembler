*************************************
* Example program 3 for FA
*
* This program compares the content
* of 2 files. The state is returned
* to the parent program (usually
* command.com). 
*          0 parameter error,
*          1 files are equal
*          2 files are different
*      other IO error.
*
* When called from the command line,
* it expects following parameters:
*
* Attributes and names of two files
* and optional the maximum number of
* differences to dsiplay,
* 0 is taken as an unlimited number
* of differences.
*
* Like every good program, it
* returns error messages for bad
* parameters.
*
* To compile use:
* FA EX3COMP.ASM EX3COMP.COM
*
* To run program:
* EX3COMP file1 file2 [diff_cnt]
* e.g.
* EX3COMP TEST1.TXT TEST2.TXT 3

*************************************
* And here is the program:

* lisT only at errors
         lst bad

* definition of SDX symbols used
* in the program

pf       smb 'printf'
gatr     smb 'u_getatr'
gnum     smb 'u_getnum'
fopen    smb 'fopen'
fget     smb 'fgetc'
fca      smb 'fcloseal'
ftell    smb 'ftell'
flen     smb 'fileleng'
dos      smb '_DOS'
sfail    smb 'u_sfail'
fail     smb 'u_fail'
xfail    smb 'u_xfail'
status   smb 'status'
putc     smb 'putc'

* definition of SDX register labels

siocbidx equ $760
faux1    equ $782

* relocatable block

         blk reloc main

* start of the program,
* (default start)

* instal trap whose address is
* in vtrap (due to code
* relocatability you cannot use
* lda <trap and ldx >trap because at
* compile time we do not know where
* the program will be located!)

comp     lda vtrap
         ldx vtrap+1
         jsr sfail

* display the program header

         jsr pf
         dta b($9B),c'File Comparator v.1.0',b($9B)
         dta c'(c) MMMG Soft ''95'
         dta b($9B,$9b,0)

* set program variables, file
* numbers, the number of
* differences and the maximum number
* of differences (default)

         ldx #1
         stx fnum
         dex
         stx fdif
         stx fdif+1
         stx fmax+1
         ldx #16
         stx fmax

* display attributes and name
* for both files

         jsr finit
         inc fnum
         jsr finit

* display the EOL sign for
* "aesthetic" purposes

         lda #$9B
         jsr putc

* get the maximum number of
* differences

         jsr gnum
         beq comp_lp

* when 0 has been given (Z = 0)

         sta fmax
         stx fmax+1

* main comparison loop

* get the first byte from the
* channel of the first file, if
* end of file (N = 1) jump out
* of the loop

comp_lp  ldx fileids
         stx siocbidx
         jsr fget
         bmi comp_ex

* repeat operations for second file

         sta f1byte
         ldx fileids+1
         stx siocbidx
         jsr fget
         bmi comp_ex

* compare bytes and loop
* if they are the same

         cmp f1byte
         beq comp_lp
         sta f2byte

* check the file entries, if
* different, display an
* appropriate message

         jsr ftell
         jsr pf
         dta c'Different at %e : $%2x $%2x',b($9b,0)
         dta v(faux1,f1byte,f2byte)

* increase number of differences

         inc fdif
         bne *+5
         inc fdif+1

* if maximum unlimited number
* (fmax = 0) continue loop

         lda fmax
         ora fmax+1
         beq comp_lp

* when limited, check if the limit is
* reached, if so do not continue loop

         lda fdif
         cmp fmax
         lda fdif+1
         sbc fmax+1
         bcc comp_lp

* if the maximum or end of one of the
* files is reached, check for
* differences (set status to 1 = OK)

comp_ex  lda #1
         sta status
         lda fdif
         ora fdif+1
         beq comp_ok

* if so, display the message and
* increase the status (2 = DIFFERENT)

         jsr pf
         dta b($9b),c'Files are different',b($9B,0)
         inc status
         jmp comp_ed

* if not, display a message, too

comp_ok  jsr pf
         dta b($9b),c'No differences',b($9B,0)

* remove trap, close all files and
* exit the program

comp_ed  jsr xfail
         jmp fca

* procedure takes attributes (default
* attributes in A)

finit    lda #$A0
         jsr gatr
         bne finit_0

* if the file name is missing
* (Z = 1), give an error: bad
* parameters

         lda #$9C
         jmp fail

* otherwise open the file

finit_0  jsr fopen

* and remember its channel number in
* the corresponding variable

         ldx fnum
         lda siocbidx
         sta fileids-1,x

* now get its length

         jsr flen

* display everything nicely and
* finish

         jsr pf
         dta c'File #%1x len: %e bytes',b($9b,0)
         dta v(fnum,faux1)
         rts

* vector for trap

vtrap    dta v(trap)

* trap, sets status, checks for
* parameter error


trap     cmp #$9C
         beq trap_0
         jmp trap_1

* if so, display message and
* clear state

trap_0   jsr pf
         dta c'Usage:',b($9b)
         dta c' EX3COMP [atr] fspec1 [atr] fspec2 [max]'
         dta b($9b,$9b)
         dta c'atr   : file attributes,',b($9B)
         dta c'fspec : file name,',b($9b)
         dta c'max   : maximum number of mismatches,',b($9B)
         dta c'        0 allows an unlimited number.',b($9B,0)

         lda #0

* close all files and exit

trap_1   sta status
         jmp fca

* reserve data area in empty block

estr     equ *

fileids  equ estr       2
f1byte   equ fileids+2  1
f2byte   equ f1byte+1   1
fnum     equ f2byte+1   1
fdif     equ fnum+1     2
fmax     equ fdif+2     2

eend     equ fmax+2

* empty block immediately increments
* the PC pointer so the labels in
* that block are defined before it

         blk empty eend-estr+1 main

* address update

         blk update adress

* symbol update

         blk update symbols

* define a new symbol

         blk update new comp '@EX3COMP'

         end

