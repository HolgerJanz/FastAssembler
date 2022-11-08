* install trap
comp     lda vtrap
         ldx vtrap+1
         jsr U_SFAIL
* set program variables
         ldx #1
         stx fnum
         stx fileneof
         dex
         stx fdif
         stx fdif+1
         stx fmax+1
* buffer size $100 bytes => $00
         stx filersiz
         stx filersiz+1
* ftell 2 higher $FFFF => $0000 at first read
         dex
         stx ftellh2
         stx ftellh2+1
* default 16 diffs
         ldx #16
         stx fmax
* force read file with next increment
         lda <fbuffsiz-1
         sta compidx
* get parameter, open file, and print length
         jsr finit
         inc fnum
         jsr finit
* get the maximum differences
         jsr U_GETNUM
         beq comp_lp
* when 0 has been given (Z = 0)
         sta fmax
         stx fmax+1
* main comparison loop
comp_lp  jsr comploop
         beq comp_ex
* print diff
         jsr PRINTF
         dta c'Different at %6x : %2x %2x',b($9b,0)
         dta v(compidx,f1byte,f2byte)
* increase number of differences
         inc fdif
         bne *+5
         inc fdif+1
* if maximum unlimited number
         lda fmax
         ora fmax+1
         beq comp_lp
* when limited, check if the limit is reached
         lda fdif
         cmp fmax
         lda fdif+1
         sbc fmax+1
         bcc comp_lp
         jsr PRINTF
         dta c'Maximum differences reached: %d',b($9b,$00)
         dta v(fmax)
* if the maximum or end of file
comp_ex  lda fdif
         ora fdif+1
         beq comp_ok
* if so, display the message and
* STATUS 255 = DIFFERENT
         lda #$ff
         sta STATUS
         jmp U_FAIL
* if not, display a message, too
* set STATUS to 1 = OK
comp_ok  jsr PRINTF
         dta c'No differences',b($9B,0)
         lda #$01
         sta STATUS
* remove trap, close all files and exit
         jsr U_XFAIL
         jmp FCLOSEAL

* read parameter
finit    jsr U_GETPAR
         bne finit_0
* if the file name is missing
         lda #$9C
         jmp U_FAIL
* otherwise open the file for read
finit_0  lda #$04
         sta FMODE
         jsr FOPEN
* remember handle
         ldx fnum
         lda FHANDLE
         sta fileids-1,x
* now get its length
         jsr FILELENG
* display everything
         jsr PRINTF
         dta c'File #%2x length: %e bytes',b($9b,0)
         dta v(fnum),a(FAUX1)
         rts

* compare files
comploop inc compidx
         lda filersiz
         cmp compidx
         beq compceof
         lda filersiz+1
         cmp compidx
         bne compcomp
compceof lda fileneof
         beq compend
         ldx #$00
         jsr readf
         beq compend
         ldx #$01
         jsr readf
         beq compend
         lda #$00
         sta compidx
         inc ftellh2
         bne *+5
         inc ftellh2+1
* compare
compcomp ldx compidx
         lda fbuf1,X
         sta f1byte
         lda fbuf2,X
         cmp f1byte
         beq comploop
         sta f2byte
         lda #$01
compend  rts

fbufv    dta v(fbuf1,fbuf2)
* read next part file
readf    lda fileids,X
         sta FHANDLE
         txa
         pha
         asl @
         tax
         lda fbufv,X
         sta FAUX1
         lda fbufv+1,X
         sta FAUX2
         lda <fbuffsiz
         sta FAUX4
         lda >fbuffsiz
         sta FAUX5
         jsr FREAD
         bpl compne
         lda #$00
         sta fileneof
compne   pla
         tax
         lda FAUX4
         sta filersiz,X
         ora FAUX5
         rts

* vector for trap
vtrap    dta v(trap)
* checks for parameter error
trap     cmp #$9C
         bne trap_0
* info message about program
         jsr PRINTF
         dta b($9B),c'File COMParator v.1.2',b($9B)
         dta c'(c) MMMG Soft ''95, PD 2022'
         dta b($9B,0)
* if so, display message and
         jsr PRINTF
         dta c'COMP file1 file2 [max]',b($9b)
         dta c'file : file names',b($9b)
         dta c'max  : max number of diffs'
         dta b($9b,0)
* close all files and exit
trap_0   sta STATUS
         jmp FCLOSEAL
