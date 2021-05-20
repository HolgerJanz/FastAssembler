* Part 1 Main

start   cld
        lda failTrP
        ldx failTrP+1
        jsr U_SFAIL
        jsr prFAmsg
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
        ldx #$00
        stx B1L0096
        stx B1L1AD2
        stx B1L1A55
        dex
        stx B1L0092
        stx B1L0093
        stx PASSNUM
        jsr prsCmdL
* Pass loop
nxtPass jsr srtPass
        lda errFlag
        beq B1L0052
        jsr prFail
        jmp B1L0061
B1L0052 lda B1L0090
        ora B1L0091
        bne B1L0067
        lda PASSNUM
        beq nxtPass
        jsr prSum
B1L0061 jsr U_XFAIL
        jmp FCLOSEA
B1L0067 jsr prUnLab
        ldy B1L0090
        ldx B1L0091
        lda B1L0090
        cmp B1L0092
        sty B1L0092
        lda B1L0091
        sbc B1L0093
        stx B1L0093
        bcc nxtPass
        lda #$FF
        sta errFlag
        jmp nxtPass

B1L0090 dta b($00)
B1L0091 dta b($00)
B1L0092 dta b($00)
B1L0093 dta b($00)
failTrP dta v(failTr)
B1L0096 dta b($00)

* print version info
prFAmsg jsr PRINTF
        dta b($9b)
        dta c'Fast Assembler 1.8 19-05-2021'
        dta b($9b)
        dta c'(c) MMMG Soft ''95, Public Domain 2021'
        dta b($9b,$00)
        rts

prFail  inc STATUS
        jsr PRINTF
        dta b($9B)
        dta c'Failed'
        dta b($9B,$00)
        rts

prSum   jsr PRINTF
        dta b($9B)
        dta c'Labels:%5d  SDX Symbols:%5d'
        dta b($9B)
        dta c'Blocks:%5b  SDX Blocks :%5b'
        dta b($9B)
        dta b($9B)
        dta c'Completed'
        dta b($9B,$00)
        dta v(labCnt)
        dta v(symbCnt)
        dta v(blkCnt)
        dta v(SblkCnt)
        rts

prUnLab jsr PRINTF
        dta c'Symbols to resolve %d'
        dta b($9B,$00)
        dta v(B1L0090)
        rts

blkCnt  dta b($00)
SblkCnt dta b($00)
labCnt  dta a($0000)
symbCnt dta a($0000)

prPass  jsr PRINTF
        dta b($9b)
        dta c'Pass %b'
        dta b($9B,$00)
        dta v(PASSNUM)
        rts

putEOL  lda #$9B
        jmp PUTC

failTr  sta STATUS
        cmp #$9C
        beq prUsage
        jmp FCLOSEA

* print usage info
prUsage jsr PRINTF
        dta b($9B)
        dta c'Usage:'
        dta b($9B)
        dta c' FA sname [dname] [/AB]'
        dta b($9B,$9B)
        dta c' sname: source filename'
        dta b($9B)
        dta c' dname: destination filename'
        dta b($9B,$00)
        jsr PRINTF
        dta c' A    : list all program lines'
        dta b($9B)
        dta c' B    : list bad lines (default)'
        dta b($9B)
        dta c' Drives, paths and extentions are'
        dta b($9B)
        dta c' optional.'
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

cmdOptA dta b($00)
cmdOptB dta b($00)
cmdOpts dta b($00),c'A'
        dta b($00),c'B'
cmdOptP dta v(cmdOpts)
cmdPCnt dta b($00)

* parse command line
prsCmdL ldx #$FF
        stx cmdPCnt
        stx cmdOptB
        inx
        stx cmdOptA
chkCmdO lda cmdOptP
        ldx cmdOptP+1
        ldy #$04
        jsr U_SLASH
        ldy #$02
        ldx #$01
B1L0282 lda cmdOptA,X
        ora cmdOpts,Y
        sta cmdOptA,X
        dey
        dey
        dex
        bpl B1L0282
        jsr U_GETPA
        beq B1L02B0
        inc cmdPCnt
        ldx cmdPCnt
        cpx #$02
        bcc B1L02A7
B1L02A2 lda #$9C
jmpFAIL jmp U_FAIL
B1L02A7 jsr gtCFNAM
        jsr B1L1AD3
        jmp chkCmdO
B1L02B0 ldx cmdPCnt
        bmi B1L02A2
        bne B1L02C7
        jsr B1L1B53
        jsr B1L1A93
        ldx #$01
        jsr B1L1AB6
        ldx #$01
        jsr B1L1AD3
B1L02C7 rts

* print error message
prErrMs eor errFlag
        beq noErrMs
        eor errFlag
        ldx #$FF
        stx errFlag

        ldx PASSNUM
        bne errOptA
        cmp #$00
        beq noErrMs

errOptA ldx cmdOptA
        beq errOptB
        ldx PASSNUM
        beq yeErrMs
        bne yeErLMs

errOptB ldx cmdOptB
        beq yeErrMs

yeErLMs jsr prELine
yeErrMs cmp #$12
        bcs noErrMs
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

* error messages
errMs00 dta c'Undeclared label or symbol'
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

B1L0463 dta b($00)
errFlag dta b($00)
B1L0465 dta b($00)
B1L0466 dta b($00)
B1L0467 dta b($00)
B1L0468 dta b($00)

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
        stx B1L0090
        stx B1L0091
        stx B1L0463
        stx B1L0096
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
B1L04B1 jsr prPass
        jsr B1L1CD9
        jsr B1L07E3
        jsr B1L076D
B1L04BD lda B1L0463
        beq B1L04EA
        jsr prPrgs
        jsr putEOL
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
B1L0566 lda cmdOptA
        beq B1L056F
        lda PASSNUM
        beq prELine
B1L056F rts

prELine jsr PRINTF
        dta b($9c)
        dta c'%d:%*p'
        dta b($9B,$00)
        dta v(lineNum)
        dta v(B1L0630)
        dta a($90)
        rts

prPrgs  lda PASSNUM
        ora cmdOptA
        beq B1L0591
        lda PASSNUM
        bne B1L0591
B1L0590 rts
B1L0591 lda PASSNUM
        bne B1L05B2
        jsr PRINTF
        dta b($9C)
        dta c'Lines processed %d'
        dta b($00)
        dta v(lineNum)
        rts
B1L05B2 ldx #$00
        ldy #$03
B1L05B6 lda lineInc,Y
        sta COMTAB+$103,X
        lda lineNum,Y
        sta COMTAB+$FF,X
        inx
        dey
        bpl B1L05B6
        jsr MUL_32
        ldx #$00
        ldy #$03
B1L05CD lda COMTAB+$107,X
        sta COMTAB+$FF,X
        lda lineCnt,Y
        sta COMTAB+$103,X
        inx
        dey
        bpl B1L05CD
        jsr DIV_32
        ldx #$00
        ldy #$03
B1L05E4 lda COMTAB+$107,X
        sta linePrc,Y
        inx
        dey
        bpl B1L05E4
        jsr PRINTF
        dta b($9C)
        dta c'Lines processed %d, %d%% of file'
        dta b($00)
        dta v(lineNum)
        dta v(linePrc)
        rts

endStrg dta c'end'
        dta b($9b)
endStrV dta v(endStrg)

lineNum dta b($00,$00,$00,$00)
lineCnt dta b($00,$00,$00,$00)
lineInc dta b($64,$00,$00,$00)
linePrc dta b($00,$00,$00,$00)
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
