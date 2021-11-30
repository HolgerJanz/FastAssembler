* Part 1 Main

start   cld
        lda failTrP
        ldx failTrP+1
        jsr U_SFAIL
        lda #$01
        sta STATUS

        lda #$00
        ldx #$07
        sta B1L0463,X
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
        stx V1L0096
        stx B1L1AD2
        stx B1L1A55
        stx MEMHIGH
        stx MEMHIGH+1
        dex
        stx laUReLa
        stx laUReLa+1
        stx PASSNUM
* parse command line
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
        jsr prFail
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
        jmp FCLOSEA
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
V1L0096 dta b($00)
startP  dta v(start)
e_bgn_P dta v(e_begin)
e_lst_P dta v(e_last)

prSum   jsr PRINTF
        dta c'Labels:%5d  SDX Symbols:%5d'
        dta b($9B)
        dta c'Blocks:%5b  SDX Blocks :%5b'
        dta b($9B)
        dta c'Memory: $%4x-$%4x-$%4x $%4x-$%4x'
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
        rts

prCmpl  lda cmdOptS
        beq *+5
        jsr prSum
        jsr PRINTF
        dta c'Completed'
        dta b($9B,$00)
        rts

prFail  lda #$9c
        jsr PUTC
        lda cmdOptS
        beq *+5 
        jsr prSum
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
        bne *+8
        jsr prUsage
        jmp FCLOSEA
        jsr prFail
        jmp FCLOSEA

* print version and usage info
prUsage jsr PRINTF
        dta c'Fast Assembler 1.8 2021-12-01'
        dta b($9b)
        dta c'(c) MMMG Soft ''95, Public Domain 2021'
        dta b($9b,$00)
        jsr PRINTF
        dta c'Parameters: src [dst] [/LSE]'
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
        dta b($9B,$00)
        rts

* get CFNAME to buffer
gtCFNAM ldy COMTAB+$1a
        sty BFCFNAL
        lda COMTAB+$21,Y
        sta bfCFNAM,Y
        dey
        bpl *-7
        rts

* store buffer to CFNAME
stCFNAM ldy BFCFNAL
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
cmdOptE dta b($00)
cmdOpt  dta b($00),c'L'
        dta b($00),c'S'
        dta b($00),c'E'
cmdOptP dta v(cmdOpt)
cmdPCnt dta b($ff)

* parse command line
* check for options
prsCmdL ldx #$00
        stx cmdOptL
        stx cmdOptS
        stx cmdOptE
        dex
        stx cmdPCnt

prsCmdN lda cmdOptP
        ldx cmdOptP+1
        ldy #$06
        jsr U_SLASH
        ldy #$04
        ldx #$02
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
* ERROR: Bad parameter
prsCErr lda #$9C
jmpFAIL jmp U_FAIL
* get file name
prsFilN jsr gtCFNAM
        jsr B1L1AD3
        jmp prsCmdN
prsCEnd ldx cmdPCnt
        bmi prsCErr
        bne prsCRTS
        jsr B1L1B53
        jsr findDot
        ldx #$01
        jsr setDEXT
        ldx #$01
        jsr B1L1AD3
prsCRTS rts

* print error message
prErrMs eor maskURS
        beq noErrMs
* check mask for unresolved symbols
        eor maskURS
* check highest valid
        cmp #$12
        bcc *+4
        lda #$12
* set only first last error
        ldx errFlag
        bne *+5
        sta lastErr
* set error flag
        ldx #$FF
        stx errFlag
* check option L
        ldx cmdOptL
        beq yeErLMs
        ldx PASSNUM
        beq yeErrMs
        bne yeErLMs
* print line and error msg
yeErLMs cmp #$03
* no line at too many passes
        beq yeErrMs
        jsr prtLine
* check max error number
yeErrMs asl @
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
* undeclared label must be first
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
errMs0C dta c'Undefined or too long'
        dta b($9B)
errMs0D dta c'Improper block type'
        dta b($9B)
errMs0E dta c'Too long or invalid symbol'
        dta b($9B)
errMs0F dta c'Parenthesis not balanced'
        dta b($9B)
errMs10 dta c'Too many operations'
        dta b($9B)
errMs11 dta c'Unexpected symbol'
        dta b($9B)
* internal error have to be last
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
lastErr dta b($00)

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
        stx B1L0463
        stx V1L0096
        stx B1L1AD2
        stx lineNum
        stx lineNum+1
        inx
        stx B1L150B
        ldx #$10
        stx BLKPCNT+1
        inc PASSNUM
        jsr B1L1CD9
        jsr openDST
        jsr openSRC
B1L04BD lda B1L0463
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
        dta v(curLiLn)
        dta a(PCURLIN)
        rts

* print pass progress
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

* current line number
lineNum dta b($00,$00,$00,$00)
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