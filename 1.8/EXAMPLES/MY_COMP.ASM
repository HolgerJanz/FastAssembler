* Example for FA
* This program compares the content
* of 2 files. The state is returned
* to the parent program (usually
* command.com). 
*          1 files are equal
*        255 files are different
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
* To run program:
* MY_COMP file1 file2 [diff_cnt]
* e.g.
* MY_COMP TEST1.TXT TEST2.TXT 3

* definition of SDX symbols used
* in the program
PRINTF   smb 'PRINTF'
U_GETATR smb 'U_GETATR'
U_GETNUM smb 'U_GETNUM'
FOPEN    smb 'FOPEN'
FGETC    smb 'FGETC'
FCLOSEAL smb 'FCLOSEAL'
FTELL    smb 'FTELL'
FILELENG smb 'FILELENG'
U_SFAIL  smb 'U_SFAIL'
U_FAIL   smb 'U_FAIL'
U_XFAIL  smb 'U_XFAIL'
STATUS   smb 'STATUS'
* definition of SDX register labels
FHANDLE  equ $760
FMODE    equ $778
FAUX1    equ $782

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
         jsr U_SFAIL
* info message about program
         jsr PRINTF
         dta b($9B),c'MY File COMParator v.1.1',b($9B)
         dta c'(c) MMMG Soft ''95, PD 2021'
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
* get the maximum number of
* differences
         jsr U_GETNUM
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
         stx FHANDLE
         jsr FGETC
         bmi comp_ex
* repeat operations for second file
         sta f1byte
         ldx fileids+1
         stx FHANDLE
         jsr FGETC
         bmi comp_ex
* compare bytes and loop
* if they are the same
         cmp f1byte
         beq comp_lp
         sta f2byte
* check the file entries, if
* different, display an
* appropriate message
         jsr FTELL
         jsr PRINTF
         dta c'Different at %e : $%2x $%2x',b($9b,0)
         dta a(FAUX1),v(f1byte,f2byte)
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
* differences
comp_ex  lda fdif
         ora fdif+1
         beq comp_ok
* if so, display the message and
* STATUS 255 = DIFFERENT
* system error, can be used
* with IF ERROR in batch
         jsr PRINTF
         dta c'Files are different',b($9B,0)
         lda #$ff
         sta STATUS
         jmp comp_ed
* if not, display a message, too
* set STATUS to 1 = OK
comp_ok  jsr PRINTF
         dta c'No differences',b($9B,0)
         lda #$01
         sta STATUS
* remove trap, close all files and
* exit the program
comp_ed  jsr U_XFAIL
         jmp FCLOSEAL

* procedure takes attributes (default
* attributes in A)
finit    lda #$A0
         jsr U_GETATR
         bne finit_0
* if the file name is missing
* (Z = 1), give an error: bad
* parameters
         lda #$9C
         jmp U_FAIL
* otherwise open the file
* for read
finit_0  lda #$04
         sta FMODE
         jsr FOPEN
* and remember its channel number in
* the corresponding variable
         ldx fnum
         lda FHANDLE
         sta fileids-1,x
* now get its length
         jsr FILELENG
* display everything nicely
         jsr PRINTF
         dta c'File #%1x len: %e bytes',b($9b,0)
         dta v(fnum),a(FAUX1)
         rts
* vector for trap
vtrap    dta v(trap)

* trap, sets STATUS, checks for
* parameter error
trap     cmp #$9C
         bne trap_0
* if so, display message and
         jsr PRINTF
         dta c'Parameters:',b($9b)
         dta c'[atr] file1 [atr] file2 [max]',b($9b)
         dta c'atr  : file attributes,',b($9b)
         dta c'file : file name,',b($9b)
         dta c'max  : max number of diffs,'
         dta b($9b,0)
* close all files and exit
trap_0   sta STATUS
         jmp FCLOSEAL

* allocate data area in empty block
e_start  equ *
fnum     equ e_start
fileids  equ fnum+1
f1byte   equ fileids+2
f2byte   equ f1byte+1
fdif     equ f2byte+1
fmax     equ fdif+2
e_end    equ fmax+2
* empty block immediately increments
* the PC pointer so the labels in
* that block are defined before it
         blk empty e_end-e_start main

* addresses, symbols update
         blk update addresses
         blk update symbols
         blk update new comp '@MY_COMP'

         end
