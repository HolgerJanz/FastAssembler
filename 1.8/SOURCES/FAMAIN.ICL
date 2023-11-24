* Part 1 Main

start   cld
        lda failTrP
        ldx failTrP+1
        jsr U_SFAIL
        lda #$01
        sta STATUS

        lda #$00
        ldx #$08
        sta flagEnd,X
        dex
        bpl *-4

        jsr initDat
        jsr initBuf
        lda MEMMIN
        sta $8A
        lda MEMMIN+1
        sta $8B
        sec
        lda MEMTOP
        sta MEMMAX
        lda MEMTOP+1
        sbc #$01
        sta MEMMAX+1
* init variables
        ldx #$00
        stx curFilX
        stx fileNum
        stx B1L1A55
        stx MEMHIGH
        stx MEMHIGH+1
        dex
        stx laUReLa
        stx laUReLa+1
        stx PASSNUM
* parse command line
        lda #$9b
        jsr PUTC
        jsr prsCmdL

* Pass loop
nxtPass jsr srtPass
* check for error
        lda errFlag
        beq B1L0052
failFa  lda cmdOptE
        beq *+11
* conv FA err to system err
        clc
        lda lastErr
        adc #$e0
        jmp jmpFAIL
* finish with error
        jsr prPrgsF
        jsr prFailN
        inc STATUS
        jmp exitFA
* check unresolved labels
B1L0052 lda unResLa
        ora unResLA+1
        bne B1L0067
* finish line without pending
        jsr prPrgsF
        lda #$9b
        jsr PUTC
        lda PASSNUM
        beq nxtPass
        jsr prCmpl
exitFA  jsr U_XFAIL
        jmp FCLOSEAL
* check diff with last pass
B1L0067 jsr prUnRSy
* first check too many passes
        lda PASSNUM
        cmp #$08
        bcc B1L04B1
* ERROR: Too many passes
        lda #$03
        jsr prErrMs
        jmp failFA
B1L04B1 ldy unResLa
        ldx unResLa+1
        lda unResLa
        cmp laUReLa
        sty laUReLa
        lda unResLa+1
        sbc laUReLa+1
        stx laUReLa+1
        bcc nxtPass
* no symbols resolved in current pass
        lda #$FF
        sta maskURS
        jmp nxtPass

* unresolved label count
unResLa dta a($0000)
* last unresolved label count
laUReLa dta a($0000)
failTrP dta v(failTr)
curFilX dta b($00)
startP  dta v(start)
e_bgn_P dta v(e_begin)
e_lst_P dta v(e_last)

prSum   jsr PRINTF
        dta c'Labels:%5d  SDX Symbols:%5d'
        dta b($9B)
        dta c'Blocks:%5b  SDX Blocks :%5b'
        dta b($9B)
        dta c'Memory: %4x-%4x-%4x %4x-%4x'
        dta b($9B,$00)
        dta v(labCnt)
        dta v(symbCnt)
        dta v(blkCnt)
        dta v(SblkCnt)
        dta v(startP)
        dta v(e_bgn_P)
        dta v(e_lst_P)
        dta v(MEMMIN)
        dta a(MEMHIGH)
        lda #$00
        sta cmdOptS
        rts

* kind of symboles
symKind dta c'SRC '
        dta c'OBJ '
        dta c'EQU '
        dta c'BLK '
        dta c'SMB '
        dta c'SMR '

* write two digit hex
wrSymHH pha
        lsr @
        lsr @
        lsr @
        lsr @
        sed
        clc
        adc #$90
        adc #$40
        cld
        sta bufWrit,X
        inx
        pla
        and #$0F
        sed
        clc
        adc #$90
        adc #$40
        cld
        sta bufWrit,X
        inx
        rts

* write byte to buffer
wrSymBy lda ($84),Y
        jsr wrSymHH
        iny
        rts

* write word to buffer
wrSymWd iny
        jsr wrSymBy
        dey
        dey
        jsr wrsymBy
        iny
        rts

* write text to buffer
wrSymTx txa
        clc
        adc ($84),Y
        sta wrSyTxL+1
        iny
wrSyLop lda ($84),Y
        sta bufWrit,X
        inx
        iny
wrSyTxL cpx #$00
        bcs *+6
        cpx #$FE
        bcc wrSyLop
        rts

* write space to buffer
wrSymSp lda #' '
        sta bufWrit,X
        inx
        rts

* write file symbole
wrSymFi jsr wrSymBy
        jsr wrSymSp
        jsr wrSymTx
        rts

* write equate symbole
wrSymEq jsr wrSymBy
        jsr wrSymSp
        jsr wrSymWd
        jsr wrSymSp
        jsr wrSymTx
        rts

* write block symbole
wrSymBl jsr wrSymBy
        jsr wrSymSp
        jsr wrSymBy
        jsr wrSymSp
        jsr wrSymBy
        jsr wrSymSp
        jsr wrSymWd
        jsr wrSymSp
        jsr wrSymWd
        rts

* write SpartaDOS X symbole
wrSymSb jsr wrSymWd
        jsr wrSymSp
        jsr wrSymTx
        rts

* write reference symbole
wrSymRe lda $85
        jsr wrSymHH
        lda $84
        jsr wrSymHH
        jsr wrSymSp
        jsr wrSymWd
        jsr wrSymSp
        jsr wrSymBy
        jsr wrSymSp
        jsr wrSymBy
        jsr wrSymSp
        jsr wrSymBy
        jsr wrSymSp
        jsr wrSymWd
        rts

* write symbole entry
wrSymEn ldy #$01
        lda ($84),Y
        pha
        asl @
        asl @
        tay
kindLp  lda symKind,Y
        sta bufWrit,X
        iny
        inx
        cpx #$04
        bne kindLp
        ldy #$02
        pla
        cmp #$00
        bne *+5
        jmp wrSymFi
        cmp #$01
        bne *+5
        jmp wrSymFi
        cmp #$02
        bne *+5
        jmp wrSymEq
        cmp #$03
        bne *+5
        jmp wrSymBl
        cmp #$04
        bne *+5
        jmp wrSymSb
        cmp #$05
        bne *+5
        jmp wrSymRe
        jmp prsCErr

* write symbole table
wrSymb  jsr PRINTF
        dta c'Write symbole table'
        dta b($9B,$00)
        lda #$00
        sta cmdOptY
* cloase all files to free file handle
        jsr FCLOSEAL
* get obj file and set extension
        ldx #$00
        stx fileNum
        inx
        jsr syGetFl
        jsr findDot
        ldx #$02
        jsr setDEXT
        jsr stCFNAM
* open symbole file for write
        lda #$08
        sta FMODE
        lda #$A0
        sta FATR1
        lda #$00
        sta FATR2
        jsr FOPEN
* set write buffe
        lda bufWriV
        sta FAUX1
        lda bufWriV+1
        sta FAUX2
        lda #$00
        sta FAUX4
        sta FAUX5
        sta SYSCALL
* loop at symbole table
        ldy MEMMIN
        sty $84
        ldy MEMMIN+1
        sty $85
wrSymLp ldx #$00
        jsr wrSymEn
* write line
        lda #$9b
        sta bufWrit,X
        inx
        stx FAUX4
        jsr FWRITE
* next symbole entry
        ldy #$00
        clc
        lda ($84),Y
        adc $84
        sta $84
        bcc *+4
        inc $85
        lda $84
        cmp $8A
        lda $85
        sbc $8B
        bcc wrSymLp
* close file
        jsr FCLOSE
        rts

prCmpl  lda cmdOptS
        beq *+5
        jsr prSum
        lda cmdOptY
        beq *+5 
        jsr wrSymb
        jsr PRINTF
        dta c'Completed'
        dta b($9B,$00)
        rts

prFailN lda #$9b
        jsr PUTC
prFail  lda cmdOptS
        beq *+5 
        jsr prSum
        lda cmdOptY
        beq *+5 
        jsr wrSymb
        jsr PRINTF
        dta c'Failed'
        dta b($9B,$00)
        rts

prUnRSy jsr prPrgsF
        jsr PRINTF
        dta c' Pending %d'
        dta b($9B,$00)
        dta v(unResLa)
        rts

blkCnt  dta b($00)
SblkCnt dta b($00)
labCnt  dta a($0000)
symbCnt dta a($0000)

* error handler
failTr  sta STATUS
        cmp #$9C
        bne failTr1
* if parameter error then only write usage
        jsr prUsage
        jmp FCLOSEAL
*   it was a compile error >= $E0
* then no DOS error message
failTr1 lda STATUS
        cmp #$E0
        bcs failTr2
failTr4 lda #$89
        cmp STATUS
        bne failTr3
* if truncated record then add 1 to line number
        inc CURICLN
        bne *+4
        inc CURICLN+1
failTr3 lda #$14
        jsr prErrMs
        jsr prFail
        jmp FCLOSEAL
* just failed and close
failTr2 jsr prPrgsF
        jsr prFailN
        jmp FCLOSEAL

* print version and usage info
prUsage jsr PRINTF
        dta c'Fast Assembler 1.8 23-11-2023'
        dta b($9b)
        dta c'(c) MMMG Soft ''95, Public Domain 2023'
        dta b($9b,$00)
        jsr PRINTF
        dta c'Usage: FA [/LSEY] src [dst]'
        dta b($9B)
        dta c' src: source filename'
        dta b($9B)
        dta c' dst: destination filename'
        dta b($9B,$00)
        jsr PRINTF
        dta c' L  : list combined source'
        dta b($9B)
        dta c' S  : print summary'
        dta b($9B)
        dta c' E  : set error if compile failed'
        dta b($9B)
        dta c' Y  : write symbole table'
        dta b($9B)
        dta c' Q  : quite, no line progress messages'
        dta b($9B,$00)
        rts

* get CFNAME to buffer
gtCFNAM ldy COMTAB+CT_TRAILS
        sty BFCFNAL
        lda COMTAB+CT_COMFNAM,Y
        sta bfCFNAM,Y
        dey
        bpl *-7
        rts

* store buffer to CFNAME
stCFNAM ldy BFCFNAL
        sty COMTAB+CT_TRAILS
        cpy #$20
        bcc B1L0253
        ldy #$1F
        lda #$9B
        bne B1L0256
B1L0253 lda bfCFNAM,Y
B1L0256 sta COMTAB+CT_COMFNAM,Y
        dey
        bpl B1L0253
        rts

* store buffer to current include name
stCRICL ldy BFCFNAL
        cpy #$20
        bcc B2L0253
        ldy #$1F
        lda #$9B
        bne B2L0256
B2L0253 lda bfCFNAM,Y
B2L0256 sta currICL,Y
        dey
        bpl B2L0253
        rts


cmdOptL dta b($00)
cmdOptS dta b($00)
cmdOptE dta b($00)
cmdOptY dta b($00)
cmdOptQ dta b($00)
cmdOpt  dta b($00),c'L'
        dta b($00),c'S'
        dta b($00),c'E'
        dta b($00),c'Y'
        dta b($00),c'Q'
cmdOptv dta v(cmdOpt)
cmdPCnt dta b($ff)

* parse command line
prsCmdL lda #$00
        ldx #$04
* clear options
        sta cmdOptL,X
        dex
        bpl *-4
        stx cmdPCnt

* check for options
prsCmdN lda cmdOptv
        ldx cmdOptv+1
        ldy #$0A
        jsr U_SLASH
        ldy #$08
        ldx #$04
* set flags for options
prsOptN lda cmdOptL,X
        ora cmdOpt,Y
        sta cmdOptL,X
        dey
        dey
        dex
        bpl prsOptN
* check for text parameter
        jsr U_GETPAR
        beq prsCEnd
        inc cmdPCnt
        ldx cmdPCnt
        cpx #$02
        bcc prsFilN
* ERROR: Bad parameter
prsCErr lda #$9C
jmpFAIL jmp U_FAIL
* get file name
prsFilN jsr gtCFNAM
        jsr syAFile
        jmp prsCmdN

prsCEnd ldx cmdPCnt
        bmi hlpExit
        bne prsCRTS
        jsr syGetFl
        jsr findDot
        ldx #$01
        jsr setDEXT
        ldx #$01
        jsr syAFile
prsCRTS rts

hlpExit jsr prUsage
        jsr exitFA
        jmp (DOSVEC)

* print error message
prErrMs eor maskURS
        beq noErrMs
* check mask for unresolved symbols
        eor maskURS
* check highest valid
        cmp #$15
        bcc *+4
        lda #$12
* set only first last error
        ldx errFlag
        bne *+5
        sta lastErr
* set error flag
        ldx #$FF
        stx errFlag
* print error message
        asl @
        tax
        lda errMsTa,X
        sta ptErrMs
        lda errMsTa+1,X
        sta ptErrMs+1
        lda cmdOptQ
        bne *+7
        lda #$9C
        jsr PUTC
        jsr PRINTF
        dta c'Error at %s:%d:%4x',b($9b),c'  %s',b($9b,$00)
        dta v(currICL)
        dta a(CURICLN)
        dta a(PROGCNT)
ptErrMs dta a($0000)
noErrMs sec
        rts

* error messages
* undeclared label must be first
errMs00 dta c'Undeclared label'
        dta b($9B)
errMs01 dta c'Label declared twice'
        dta b($9B)
errMs02 dta c'Unexpected end of line'
        dta b($9B)
errMs03 dta c'Too many passes'
        dta b($9B)
errMs04 dta c'Too big number'
        dta b($9B)
errMs05 dta c'String error'
        dta b($9B)
errMs06 dta c'Illegal symbol'
        dta b($9B)
errMs07 dta c'Branch to far'
        dta b($9B)
errMs08 dta c'Improper type'
        dta b($9B)
errMs09 dta c'Label missing'
        dta b($9B)
errMs0A dta c'Expression expected'
        dta b($9B)
errMs0B dta c'Too many blocks'
        dta b($9B)
errMs0C dta c'Undefined or too long'
        dta b($9B)
errMs0D dta c'Improper block type'
        dta b($9B)
errMs0E dta c'Overflow or invalid symbol'
        dta b($9B)
errMs0F dta c'Parenthesis not balanced'
        dta b($9B)
errMs10 dta c'Too many operations'
        dta b($9B)
errMs11 dta c'Unexpected symbol'
        dta b($9B)
errMs12 dta c'Internal error'
        dta b($9B)
errMs13 dta c'Program counter overflow'
        dta b($9B)
errMs14 dta c'DOS error'
        dta b($9B)

* error message pointer tab
errMsTa dta v(errMs00)
        dta v(errMs01)
        dta v(errMs02)
        dta v(errMs03)
        dta v(errMs04)
        dta v(errMs05)
        dta v(errMs06)
        dta v(errMs07)
        dta v(errMs08)
        dta v(errMs09)
        dta v(errMs0A)
        dta v(errMs0B)
        dta v(errMs0C)
        dta v(errMs0D)
        dta v(errMs0E)
        dta v(errMs0F)
        dta v(errMs10)
        dta v(errMs11)
        dta v(errMs12)
        dta v(errMs13)
        dta v(errMs14)

* these 9 bytes are init togehter
flagEnd dta b($00)
flagCls dta b($00)
* flag error occurs
errFlag dta b($00)
* mask unresolved symbols
maskURS dta b($00)
B1L0465 dta b($00)
B1L0466 dta b($00)
B1L0467 dta b($00)
B1L0468 dta b($00)
lastErr dta b($00)
* these 9 bytes are init togehter

* start new pass
srtPass jsr initBuf
        ldx #$FF
        stx B1L1D65
        stx B1L1D6B
        inx
        stx B1L15AD
        stx B1L18A0
        stx B1L1D63
        stx B1L1D64
        stx PROGCNT
        stx PROGCNT+1
        stx BLKPCNT
        stx unResLa
        stx unResLa+1
        stx flagEnd
        stx flagCls
        stx curFilX
        stx fileNum
        stx lineNum
        stx lineNum+1
* set current include and line number
        stx CURICLX
        stx CURICLN
        stx CURICLN+1
        stx CURICLF
        jsr syGetFl
        jsr stCRICL
        ldx #$01
        stx B1L150B
        ldx #$10
        stx BLKPCNT+1
        inc PASSNUM
        jsr B1L1CD9
* open source and object file
        jsr openDST
        jsr openSRC
B1L04BD lda flagEnd
        beq B1L04EA
        jsr B1L15AE
        jsr closDST
        jsr closSRC
        lda B1L1D63
        sta blkCnt
        lda B1L1D64
        sta SblkCnt
        rts
B1L04EA jsr nxtLine
        jsr B1L08D8
        beq B1L04BD
        lda bfCFNAM
        cmp #$2A
        beq B1L04BD
        jsr prsOprt
        bcc B1L04BD
        jsr prsPseu
        bcc B1L04BD
        jsr B1L1BC2
        lda $84
        sta B1L0465
        lda $85
        sta B1L0466
        lda PROGCNT
        sta B1L0467
        lda PROGCNT+1
        sta B1L0468
        lda B1L1BBF
        and #$01
        beq B1L0525
        lda PASSNUM
        beq B1L052D
B1L0525 jsr B1L08D8
        bne B1L0534
        lda #$02
        dta b(BIT_abs)
B1L052D lda #$01
        jsr prErrMs
        bcs B1L04BD
B1L0534 jsr prsOprt
        bcs B1L055A
        lda B1L0465
        sta $84
        lda B1L0466
        sta $85
        lda #$21
        sta B1L1BBF
        lda B1L0467
        sta B1L1BC0
        lda B1L0468
        sta B1L1BC1
        jsr B1L1B96
B1L0557 jmp B1L04BD
B1L055A jsr prsSymb
        bcc B1L0557
        lda #$08
        jsr prErrMs
        bcs B1L0557
cPrLine lda cmdOptL
        beq B1L056F
        lda PASSNUM
        beq prtLine
B1L056F rts

* print source line
prtLine jsr PRINTF
        dta b($9c)
        dta c'%d:%4x:%*p'
        dta b($9B,$00)
        dta v(lineNum)
        dta a(PROGCNT)
        dta v(curLiLn)
        dta a(PCURLIN)
        rts

* print pass progress
prPrgs  lda PASSNUM
* no progress in pass 0 if option L
        bne *+7
        lda cmdOptL
        bne prPrgsE
        lda cmdOptQ
        bne prPrgsE
prPrgsF lda cmdOptQ
        bne *+7
        lda #$9C
        jsr PUTC
        jsr PRINTF
        dta c'Pass %b Lines %d'
        dta b($00)
        dta v(PASSNUM)
        dta v(lineNum)
prPrgsE rts

endStrg dta c'end'
        dta b($9b)
endStrV dta v(endStrg)

* current line number
lineNum dta a($0000)
*        dta b($00,$00) ; unused
* source buffer
bufReaV dta v(bufRead)
* used source buffer
bufUsed dta a($0000)
* ???
B1L062E dta a($0000)
* length of current line
curLiLn dta b($00)

initBuf clc
        lda MEMLO
        sta MEMMIN
        lda MEMLO+1
        sta MEMMIN+1
        lda bufReaV
        adc <bufReaS
        sta bufUsed
        sta PCURLIN
        lda bufReaV+1
        adc >bufReaS
        sta bufUsed+1
        sta PCURLIN+1
        rts

        end
