* Part 1 Main

start   cld
        lda failTrP
        ldx failTrP+1
        jsr U_SFAIL
        lda #$01
        sta STATUS
        jsr initDat
        jsr initBuf
        lda $86
        sta $8A
        lda $87
        sta $8B
        sec
        lda MEMTOP
        sta $88
        lda MEMTOP+1
        sbc #$01
        sta $89
* init variables
        ldx #$00
        stx V1L0096
        stx B1L1AD2
        stx B1L1A55
        dex
        stx laUReSy
        stx laUReSy+1
        stx PASSNUM
* parse command line
        jsr prsCmdL

* Pass loop
nxtPass jsr srtPass
* check for error
        lda errFlag
        beq B1L0052
        inc STATUS
        jmp B1L0061
* check unresolved symbols
B1L0052 lda unResSy
        ora unResSy+1
        bne B1L0067
* finish line without pending
        jsr prPrgsF
        lda #$9b
        jsr PUTC
        lda PASSNUM
        beq nxtPass
        jsr prSum
B1L0061 jsr U_XFAIL
        jmp FCLOSEA
* check diff with last pass
B1L0067 jsr prUnRSy
        ldy unResSy
        ldx unResSy+1
        lda unResSy
        cmp laUReSy
        sty laUReSy
        lda unResSy+1
        sbc laUReSy+1
        stx laUReSy+1
        bcc nxtPass
* no symbols resolved in current pass
        lda #$FF
        sta maskURS
        jmp nxtPass

* unresolved symbol count
unResSy dta a($0000)
* last unresolved symbol count
laUReSy dta a($0000)
failTrP dta v(failTr)
V1L0096 dta b($00)

prSum   jsr PRINTF
        dta c'Completed'
        dta b($9B,$00)
        lda cmdOptS
        beq prSumE
        jsr PRINTF
        dta c'Labels:%5d  SDX Symbols:%5d'
        dta b($9B)
        dta c'Blocks:%5b  SDX Blocks :%5b'
        dta b($9B,$00)
        dta v(labCnt)
        dta v(symbCnt)
        dta v(blkCnt)
        dta v(SblkCnt)
prSumE  rts

prUnRSy jsr prPrgsF
        jsr PRINTF
        dta c' Pending Labels %d'
        dta b($9B,$00)
        dta v(unResSy)
        rts

blkCnt  dta b($00)
SblkCnt dta b($00)
labCnt  dta a($0000)
symbCnt dta a($0000)

failTr  sta STATUS
        cmp #$9C
        beq prUsage
        jmp FCLOSEA

* print version and usage info
prUsage jsr PRINTF
        dta c'Fast Assembler 1.8 03-10-2021'
        dta b($9b)
        dta c'(c) MMMG Soft ''95, Public Domain 2021'
        dta b($9b,$00)
        jsr PRINTF
        dta c'Usage:'
        dta b($9B)
        dta c' FA src [dst] [/LS]'
        dta b($9B)
        dta c' src: source filename'
        dta b($9B)
        dta c' dst: destination filename'
        dta b($9B,$00)
        jsr PRINTF
        dta c' L  : list combined source'
        dta b($9B)
        dta c' S  : print summary'
        dta b($9B,$00)
        lda #$00
        sta STATUS
        jmp FCLOSEA

gtCFNAM ldy COMTAB+$1a
        sty $82
        lda COMTAB+$21,Y
        sta bfCFNAM,Y
        dey
        bpl *-7
        rts

stCFNAM ldy $82
        sty COMTAB+$1a
        cpy #$64
        bcc B1L0253
        ldy #$63
        lda #$9B
        bne B1L0256
B1L0253 lda bfCFNAM,Y
B1L0256 sta COMTAB+$21,Y
        dey
        bpl B1L0253
        rts

cmdOptL dta b($00)
cmdOptS dta b($00)
cmdOpt  dta b($00),c'L'
        dta b($00),c'S'
cmdOptP dta v(cmdOpt)
cmdPCnt dta b($ff)

* parse command line
* check for options
prsCmdL lda cmdOptP
        ldx cmdOptP+1
        ldy #$04
        jsr U_SLASH
        ldy #$02
        ldx #$01
* set flags for options
prsOptN lda cmdOptL,X
        ora cmdOpt,Y
        sta cmdOptL,X
        dey
        dey
        dex
        bpl prsOptN
* check for text parameter
        jsr U_GETPA
        beq prsCEnd
        inc cmdPCnt
        ldx cmdPCnt
        cpx #$02
        bcc prsFilN
prsCErr lda #$9C
jmpFAIL jmp U_FAIL
* get file name
prsFilN jsr gtCFNAM
        jsr B1L1AD3
        jmp prsCmdL
prsCEnd ldx cmdPCnt
        bmi prsCErr
        bne prsCRTS
        jsr B1L1B53
        jsr B1L1A93
        ldx #$01
        jsr B1L1AB6
        ldx #$01
        jsr B1L1AD3
prsCRTS rts

* print error message
prErrMs eor maskURS
        beq noErrMs
* check mask for unresolved symbols
        eor maskURS
        ldx #$FF
        stx errFlag
* check option A
        ldx cmdOptL
        beq yeErLMs
        ldx PASSNUM
        beq yeErrMs
        bne yeErLMs
* print line and error msg
yeErLMs jsr prtLine
* check max error number
yeErrMs cmp #$12
        bcc *+4
        lda #$12
        asl @
        tax
        lda errMsTa,X
        sta ptErrMs
        lda errMsTa+1,X
        sta ptErrMs+1
        jsr PRINTF
        dta b($9c)
        dta c'ERROR: %s'
        dta b($9b,$00)
ptErrMs dta a($0000)
noErrMs sec
        rts

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

* error messages
* undeclared symbol must be first
errMs00 dta c'Undeclared label'
        dta b($9B)
errMs01 dta c'Label declared twice'
        dta b($9B)
errMs02 dta c'Unexpected eol'
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
errMs0C dta c'Undefined or long'
        dta b($9B)
errMs0D dta c'Improper block type'
        dta b($9B)
errMs0E dta c'Long or symbol'
        dta b($9B)
errMs0F dta c'Parenthesis not balanced'
        dta b($9B)
errMs10 dta c'Too many operations'
        dta b($9B)
errMs11 dta c'Unexpected symbol'
        dta b($9B)
* internal error mast be last
errMs12 dta c'Internal error'
        dta b($9B)

B1L0463 dta b($00)
* flag error occurs
errFlag dta b($00)
* mask unresolved symbols
maskURS dta b($00)
B1L0465 dta b($00)
B1L0466 dta b($00)
B1L0467 dta b($00)
B1L0468 dta b($00)

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
        stx $8C
        stx $8D
        stx $8E
        stx unResSy
        stx unResSy+1
        stx B1L0463
        stx V1L0096
        stx B1L1AD2
        stx lineNum
        stx lineNum+1
        inx
        stx B1L150B
        ldx #$10
        stx $8F
        inc PASSNUM
        lda PASSNUM
        cmp #$FF
        bcc B1L04B1
        lda #$03
        jsr prErrMs
B1L04B1 jsr B1L1CD9
        jsr B1L07E3
        jsr B1L076D
B1L04BD lda B1L0463
        beq B1L04EA
        jsr B1L15AE
        jsr B1L0808
        jsr B1L07BB
        lda lineNum
        sta lineCnt
        lda lineNum+1
        sta lineCnt+1
        lda B1L1D63
        sta blkCnt
        lda B1L1D64
        sta SblkCnt
        rts
B1L04EA jsr B1L0653
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
        lda $8C
        sta B1L0467
        lda $8D
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
B1L0566 lda cmdOptL
        beq B1L056F
        lda PASSNUM
        beq prtLine
B1L056F rts

* print source line
prtLine jsr PRINTF
        dta b($9c)
        dta c'%d:%*p'
        dta b($9B,$00)
        dta v(lineNum)
        dta v(B1L0630)
        dta a($90)
        rts

prPrgs  lda PASSNUM
* no progress in pass 0 if option L
        bne *+7
        lda cmdOptL
        bne prPrgsE
prPrgsF jsr PRINTF
        dta b($9C)
        dta c'Pass %b Lines %d'
        dta b($00)
        dta v(PASSNUM)
        dta v(lineNum)
prPrgsE rts


endStrg dta c'end'
        dta b($9b)
endStrV dta v(endStrg)

lineNum dta b($00,$00,$00,$00)
lineCnt dta b($00,$00,$00,$00)
lineInc dta b($64,$00,$00,$00)
bufRead dta a($0000)
bufSeek dta a($0000)
bufSize dta a($0400)
B1L062E dta a($0000)
B1L0630 dta b($00)

initBuf clc
        lda MEMLO
        sta bufRead
        adc bufSize
        sta bufSeek
        sta $90
        sta $86
        lda MEMLO+1
        sta bufRead+1
        adc bufSize+1
        sta bufSeek+1
        sta $91
        sta $87
        rts
