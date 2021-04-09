* Fast Assembler 1.8 PD 2021

* SpartaDos Symbols

COMTAB  smb 'COMTAB'
U_FAIL  smb 'U_FAIL'
U_SFAIL smb 'U_SFAIL'
U_XFAIL smb 'U_XFAIL'
FCLOSEA smb 'FCLOSEAL'
PRINTF  smb 'PRINTF'
FREAD   smb 'FREAD'
FOPEN   smb 'FOPEN'
FCLOSE  smb 'FCLOSE'
PUTC    smb 'PUTC'
FPUTC   smb 'FPUTC'
FTELL   smb 'FTELL'
FSEEK   smb 'FSEEK'
U_GETPA smb 'U_GETPAR'
U_SLASH smb 'U_SLASH'
DIV_32  smb 'DIV_32'
MUL_32  smb 'MUL_32'
TOUPPER smb 'TOUPPER'
STATUS  smb 'STATUS'

* System equates

DSKFMS  equ $0018
MEMTOP  equ $02E5
MEMLO   equ $02E7
FHANDLE equ $0760
FMODE   equ $0778
FATR1   equ $0779
FATR2   equ $077A
FAUX1   equ $0782
FAUX2   equ $0783
FAUX3   equ $0784
FAUX4   equ $0785
FAUX5   equ $0786
SYSCALL equ $0787

* Program Variables Equates

PASSNUM equ $80

* Misc Equates

BIT_abs equ $2c
BIT_zp  equ $24

* Start of Main

        blk reloc main

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

prFAmsg jsr PRINTF
        dta b($9b)
        dta c'Fast Assembler 1.8 09-03-2021'
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

prUsage jsr PRINTF
        dta b($9B)
        dta c'Usage:'
        dta b($9B)
        dta c' FA sname [dname] [/AB]'
        dta b($9B,$9B)
        dta c' sname : source filename'
        dta b($9B)
        dta c' dname : destination filename'
        dta b($9B,$00)
        jsr PRINTF
        dta c' A     : list all program lines'
        dta b($9B)
        dta c' B     : list only bad lines'
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
        inx
        stx cmdOptA
        stx cmdOptB
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
B1L0591 lda errFlag
        eor cmdOptB
        bne B1L059E
B1L059E lda PASSNUM
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

B1L0653 clc
        lda $90
        adc B1L0630
        sta $90
        bcc B1L065F
        inc $91
B1L065F lda $90
        cmp bufSeek
        lda $91
        sbc bufSeek+1
        bcs B1L068E
        ldy #$00
B1L066D lda ($90),Y
        iny
        bne B1L0677
        lda #$89
        jmp jmpFAIL
B1L0677 cmp #$9B
        bne B1L066D
B1L067B sty B1L0630
        inc lineNum
        bne B1L0686
        inc lineNum+1
B1L0686 lda #$00
        sta B1L08D3
        jmp B1L0566
B1L068E jsr prPrgs
        lda bufRead
        sta $90
        sta FAUX1
        lda bufRead+1
        sta $91
        sta FAUX2
        lda bufSize
        sta FAUX4
        lda bufSize+1
        sta FAUX5
        lda #$00
        sta SYSCALL
        jsr FREAD
        bpl B1L06D3
        lda FAUX4
        ora FAUX5
        bne B1L06D3
        lda endStrV
        sta $90
        sta bufSeek
        lda endStrV+1
        sta $91
        sta bufSeek+1
        ldy #$04
        bne B1L067B
B1L06D3 clc
        lda $90
        adc FAUX4
        sta bufSeek
        lda $91
        adc FAUX5
        sta bufSeek+1
        ldy #$00
        sty B1L062E
        sty B1L062E+1
B1L06EC lda ($90),Y
        inc $90
        bne *+4
        inc $91
        cmp #$9B
        bne B1L0702
        lda $90
        sta B1L062E
        lda $91
        sta B1L062E+1
B1L0702 lda $90
        cmp bufSeek
        lda $91
        sbc bufSeek+1
        bcc B1L06EC
        lda B1L062E
        ora B1L062E+1
        bne B1L071B
        lda #$89
        jmp jmpFAIL
B1L071B jsr B1L073C
        lda B1L062E
        sta bufSeek
        lda B1L062E+1
        sta bufSeek+1
        lda bufRead
        sta $90
        lda bufRead+1
        sta $91
        lda #$00
        sta B1L0630
        jmp B1L0653
B1L073C jsr FTELL
        sec
        lda bufSeek
        sbc B1L062E
        sta bufSeek
        lda bufSeek+1
        sbc B1L062E+1
        sta bufSeek+1
        sec
        lda FAUX1
        sbc bufSeek
        sta FAUX1
        lda FAUX2
        sbc bufSeek+1
        sta FAUX2
        bcs B1L076A
        dec FAUX3
B1L076A jmp FSEEK
B1L076D ldx B1L0096
        beq B1L07A0
        clc
        lda $90
        adc B1L0630
        sta B1L062E
        lda $91
        adc #$00
        sta B1L062E+1
        jsr B1L073C
        ldx B1L0096
        lda FHANDLE
        sta bfL20CC,X
        lda FAUX1
        sta bfL20DC,X
        lda FAUX2
        sta bfL20EC,X
        lda FAUX3
        sta bfL20FC,X
B1L07A0 ldx #$00
        jsr B1L1B53
        jsr stCFNAM
B1L07A8 lda #$04
        sta FMODE
        lda #$A0
        sta FATR1
        inc B1L0096
        jsr initBuf
        jmp FOPEN

B1L07BB jsr FCLOSE
        dec B1L0096
        ldx B1L0096
        bne B1L07C7
        rts

B1L07C7 lda bfL20CC,X
        sta FHANDLE
        lda bfL20DC,X
        sta FAUX1
        lda bfL20EC,X
        sta FAUX2
        lda bfL20FC,X
        sta FAUX3
        jmp FSEEK

B1L07E2 dta b($00)

B1L07E3 lda PASSNUM
        beq B1L0807
        ldx #$01
        jsr B1L1B53
        jsr stCFNAM
        lda #$08
        sta FMODE
        lda #$A0
        sta FATR1
        lda #$00
        sta FATR2
        jsr FOPEN
        lda FHANDLE
        sta B1L07E2
B1L0807 rts

B1L0808 lda PASSNUM
        beq B1L081D
        lda FHANDLE
        pha
        lda B1L07E2
        sta FHANDLE
        jsr FCLOSE
        pla
        sta FHANDLE
B1L081D rts

B1L081E dta b($00)

B1L081F lda PASSNUM
        beq B1L0890
        lda B1L1D6A
        cmp #$02
        bcc B1L0890
        jsr B1L15F6
        bcs B1L0890
        ldy #$00
        txa
        sta ($92),Y
        ldx B1L1D64
        lda B1L1D6A
        cmp #$03
        bcs B1L0840
        ldx #$FF
B1L0840 txa
        iny
        sta ($92),Y
        lda $8C
        iny
        sta ($92),Y
        lda $8D
        iny
        sta ($92),Y
        lda B1L1D65
        and #$70
        bne B1L0867
        ldy #$02
        sec
        lda $8C
        sbc B1L1D66
        sta ($92),Y
        lda $8D
        sbc B1L1D67
        iny
        sta ($92),Y
B1L0867 sec
        lda B1L09AF
        sbc #$10
        sta B1L09AF
        clc
        lda $92
        adc #$04
        sta $92
        bcc B1L087B
        inc $93
B1L087B ldy #$00
        lda #$FF
        sta ($92),Y
        lda $92
        cmp $88
        lda $93
        sbc $89
        bcc B1L0890
        lda #$9E
        jmp jmpFAIL
B1L0890 lda B1L09AE
        jsr B1L0899
        lda B1L09AF
B1L0899 inc $8C
        bne B1L089F
        inc $8D
B1L089F pha
        lda PASSNUM
        beq B1L08C0
        lda errFlag
        bne B1L08C0
B1L08A9 lda FHANDLE
        sta B1L081E
        lda B1L07E2
        sta FHANDLE
        pla
        jsr FPUTC
        pha
        lda B1L081E
        sta FHANDLE
B1L08C0 pla
        rts

B1L08C2 ldx #$00
B1L08C4 lda bfCFNAM,X
        jsr TOUPPER
        jsr B1L089F
        inx
        cpx #$08
        bcc B1L08C4
        rts

B1L08D3 dta b($00)
B1L08D4 dta b($00)

B1L08D5 lda #$FF
        dta b(BIT_abs)
B1L08D8 lda #$00
        sta B1L08D4
        lda #$00
        sta B1L093E
        sta B1L093F
        ldy B1L08D3
        cpy B1L0630
        beq B1L08F6
B1L08ED lda ($90),Y
        cmp #$20
        bne B1L08F7
        iny
        bne B1L08ED
B1L08F6 rts

B1L08F7 ldx #$00
B1L08F9 lda ($90),Y
        jsr B1L0940
        sta bfL1EAC,X
        jsr TOUPPER
        sta bfCFNAM,X
        inx
        iny
        cmp #$9B
        beq B1L092C
        bit B1L093E
        bne B1L08F9
        bit B1L093F
        bne B1L08F9
        bit B1L08D4
        beq B1L0920
        cmp #$2C
        beq B1L092C
B1L0920 cmp #$20
        bne B1L08F9
        lda B1L08D4
        beq B1L092C
        ldy B1L0630
B1L092C dex
        stx $82
        stx $83
        lda #$9B
        sta bfCFNAM,X
        sta bfL1EAC,X
        sty B1L08D3
        dey
        rts

B1L093E dta b($00)
B1L093F dta b($00)

B1L0940 cmp #$27
        beq B1L0959
        cmp #$22
        bne B1L0968
        bit B1L093E
        bne B1L0968
        lda B1L093F
        eor #$FF
        sta B1L093F
        lda #$22
        bne B1L0968
B1L0959 bit B1L093F
        bne B1L0968
        lda B1L093E
        eor #$FF
        sta B1L093E
        lda #$27
B1L0968 rts

B1L0969 dta b($00)

B1L096A lda bfL1EAC,X
        cmp #$27
        beq B1L097A
        cmp #$22
        beq B1L097A
B1L0975 lda #$05
        jmp prErrMs
B1L097A sta B1L0969
        ldy #$00
B1L097F inx
        cpx $83
        bcs B1L0975
        lda bfL1EAC,X
        cmp B1L0969
        bne B1L09A1
        inx
        lda bfL1EAC,X
        cmp B1L0969
        beq B1L09A1
        lda #$9B
        sta bfCFNAM,Y
        sty $82
        tya
        beq B1L0975
        clc
        rts
B1L09A1 sta bfCFNAM,Y
        iny
        bne B1L097F

B1L09A7 dta b($00)
B1L09A8 dta b($00)
B1L09A9 dta b($00)
B1L09AA dta b($00)
B1L09AB dta b($00)
B1L09AC dta b($00)
B1L09AD dta b($00)
B1L09AE dta b($00)
B1L09AF dta b($00)
B1L09B0 dta b($00)
B1L09B1 dta b($00)

B1L09B2 jsr B1L08D8
        bne B1L09BC
        lda #$02
        jmp prErrMs
B1L09BC ldx #$00
        stx B1L09AA
        stx B1L09AC
        stx B1L093E
        stx B1L093F
        stx B1L09AB
        stx B1L09A7
        dex
        stx B1L09A9
        lda $83
        sta B1L09A8
B1L09D9 jsr B1L0AF7
        bcc B1L09E1
        jmp B1L0AA7
B1L09E1 jsr B1L0940
        ldy B1L093E
        bne B1L09D9
        ldy B1L093F
        bne B1L09D9
        cmp #$40
        beq B1L0A12
        cmp #$23
        beq B1L0A0F
        cmp #$28
        bne B1L09FF
        dec B1L09AC
        bne B1L0A15
B1L09FF cmp #$3C
        beq B1L0A0A
        cmp #$3E
        bne B1L0A27
        inc B1L09AB
B1L0A0A lda #$DF
        sta B1L09A9
B1L0A0F lda #$10
        dta b(BIT_abs)
B1L0A12 lda #$08
        dta b(BIT_abs)
B1L0A15 lda #$00
        sta B1L09AA
        txa
        beq B1L0A22
        lda #$06
        jmp prErrMs
B1L0A22 inc B1L09A7
        bne B1L09D9
B1L0A27 cmp #$2C
        beq B1L0A6A
        cmp #$29
        bne B1L09D9
        stx B1L09A8
        inc B1L09AC
        lda B1L09AA
        ora #$04
        sta B1L09AA
        jsr B1L0AF7
        bcs B1L0A5F
        cmp #$2C
        bne B1L0A65
        jsr B1L0AF7
        bcs B1L0A62
        jsr TOUPPER
        cmp #$59
        bne B1L0A65
        jsr B1L0AF7
        bcc B1L0A65
B1L0A57 lda B1L09AA
        ora #$01
        sta B1L09AA
B1L0A5F jmp B1L0AA7
B1L0A62 lda #$02
        dta b(BIT_abs)
B1L0A65 lda #$06
        jmp prErrMs
B1L0A6A stx B1L09A8
        jsr B1L0AF7
        bcs B1L0A62
        jsr TOUPPER
        cmp #$59
        bne B1L0A80
        jsr B1L0AF7
        bcc B1L0A65
        bcs B1L0A57
B1L0A80 cmp #$58
        bne B1L0A65
        lda B1L09AA
        ora #$02
        sta B1L09AA
        jsr B1L0AF7
        bcs B1L0AA7
        cmp #$29
        bne B1L0A65
        inc B1L09AC
        lda B1L09AA
        ora #$04
        sta B1L09AA
        jsr B1L0AF7
        bcs B1L0AA7
        bcc B1L0A65
B1L0AA7 lda B1L093E
        bne B1L0AB1
        lda B1L093F
        beq B1L0ABC
B1L0AB1 lda #$05
        dta b(BIT_abs)
B1L0AB4 lda #$0f
        dta b(BIT_abs)
B1L0AB7 lda #$06
        jmp prErrMs
B1L0ABC lda B1L09AC
        bne B1L0AB4
        lda B1L09AA
        and #$08
        beq B1L0AD3
        lda $83
        cmp #$01
        bne B1L0AB7
        lda B1L09AA
        clc
        rts
B1L0AD3 ldy B1L09A7
        lda B1L09A8
        jsr B1L0B29
        bcs B1L0AF6
        ldx B1L09AB
        lda B1L09AE,X
        sta B1L09AE
        lda B1L09AD
        and #$E0
        ora B1L09AA
        and B1L09A9
        sta B1L09AA
        clc
B1L0AF6 rts
B1L0AF7 inx
        lda bfL1EAC,X
        cpx $83
        rts

B1L0AFE dta b($00)
B1L0AFF dta b($00)
B1L0B00 dta b($00)
B1L0B01 dta b($00)
B1L0B02 dta b($00)
B1L0B03 dta b($2D,$2B,$2F,$2A)
        dta b($5E,$7C,$26)

B1L0B0A dta v(B1L0CA5)
        dta v(B1L0CA5)
        dta v(B1L0D95)
        dta v(B1L0D6F)
        dta v(B1L0CDB)
        dta v(B1L0D0C)
        dta v(B1L0D3D)

B1L0B18 jsr B1L08D8
        bne B1L0B22
        lda #$02
        jmp prErrMs
B1L0B22 ldy #$00
        lda $83
        ldx #$00
        dta b(BIT_abs)
B1L0B29 ldx #$01
        stx B1L0B01
        ldx #$FF
        stx $81
        ldx bfL1EAC,Y
        cpx #$2A
        bne B1L0B40
        pha
        lda #$21
        sta bfL1EAC,Y
        pla
B1L0B40 ldx #$01
B1L0B42 stx B1L0B02
        ldx #$00
        stx B1L093E
        stx B1L093F
        stx B1L0AFE
        ldx #$07
        stx B1L0AFF
        inc $81
        ldx $81
        cpx #$20
        bcc B1L0B65
        lda #$10
        dta b(BIT_abs)
B1L0B60 lda #$0a
        jmp prErrMs
B1L0B65 sta bfL1FCC,X
        tya
        sta bfL1FAC,X
        cmp bfL1FCC,X
        bcs B1L0B60
        lda B1L0B02
        sta bfL20AC,X
B1L0B77 lda bfL1EAC,Y
        jsr B1L0940
        ldx B1L093E
        bne B1L0BB5
        ldx B1L093F
        bne B1L0BB5
        cmp #$5B
        bne B1L0B91
        dec B1L0AFE
        jmp B1L0BB5
B1L0B91 cmp #$5D
        bne B1L0B9B
        inc B1L0AFE
        jmp B1L0BB5
B1L0B9B ldx B1L0AFE
        bne B1L0BB5
        ldx #$06
B1L0BA2 cmp B1L0B03,X
        bne B1L0BB2
        cpx B1L0AFF
        bcs B1L0BB5
        stx B1L0AFF
        sty B1L0B00
B1L0BB2 dex
        bpl B1L0BA2
B1L0BB5 iny
        tya
        ldx $81
        cmp bfL1FCC,X
        bcc B1L0B77
        lda B1L093E
        bne B1L0BC8
        lda B1L093F
        beq B1L0BD0
B1L0BC8 lda #$05
        dta b(BIT_abs)
B1L0BCB lda #$0f
        jmp prErrMs
B1L0BD0 lda B1L0AFE
        bne B1L0BCB
        lda B1L0AFF
        cmp #$07
        bne B1L0C1A
        dey
        lda bfL1EAC,Y
        cmp #$5D
        bne B1L0C0E
        ldy bfL1FAC,X
        lda bfL1EAC,Y
        cmp #$5B
        beq B1L0BF3
        lda #$06
        jmp prErrMs
B1L0BF3 iny
        lda bfL1FCC,X
        sec
        sbc #$01
        ldx #$01
        jsr B1L0B42
        bcs B1L0C0B
B1L0C01 ldx $81
        lda bfL20AC,X
        bne B1L0C0B
        jsr B1L0C7E
B1L0C0B dec $81
        rts
B1L0C0E iny
        tya
        ldy bfL1FAC,X
        jsr B1L0DFE
        bcs B1L0C0B
        bcc B1L0C01
B1L0C1A sta bfL1FEC,X
        ldy bfL1FCC,X
        lda B1L0B00
        sta bfL1FCC,X
        lda bfL1FEC,X
        tax
        tya
        ldy B1L0B00
        iny
        jsr B1L0B42
        bcs B1L0C7B
        ldx $81
        lda B1L09AE
        sta bfL202C,X
        lda B1L09AF
        sta bfL204C,X
        lda B1L09B0
        sta bfL206C,X
        lda B1L09B1
        sta bfL208C,X
        lda B1L09AD
        sta bfL200C,X
        ldy bfL1FAC,X
        lda bfL1FCC,X
        pha
        lda bfL20AC,X
        tax
        pla
        jsr B1L0B42
        bcs B1L0C7B
        ldy $81
        lda bfL1FEC,Y
        asl @
        tax
        lda B1L0B0A,X
        sta B1L0C78+1
        lda B1L0B0A+1,X
        sta B1L0C78+2
B1L0C78 jsr $FFFF
B1L0C7B dec $81
        rts

B1L0C7E jsr B1L0C85
        clc
        jmp B1L0F9F
B1L0C85 ldx #$03
B1L0C87 lda B1L09AE,X
        eor #$FF
        sta B1L09AE,X
        dex
        bpl B1L0C87
        inc B1L09AE
        bne B1L0CA4
        inc B1L09AF
        bne B1L0CA4
        inc B1L09B0
        bne B1L0CA4
        inc B1L09B1
B1L0CA4 rts

B1L0CA5 lda B1L09AD
        ora bfL200C,Y
        sta B1L09AD
        clc
        lda B1L09AE
        adc bfL202C,Y
        sta B1L09AE
        lda B1L09AF
        adc bfL204C,Y
        sta B1L09AF
        lda B1L09B0
        adc bfL206C,Y
        sta B1L09B0
        lda B1L09B1
        adc bfL208C,Y
        sta B1L09B1
        bvs B1L0CD7
        clc
        dta b(BIT_zp)
B1L0CD7 sec
        jmp B1L0F9F

B1L0CDB lda B1L09AD
        ora bfL200C,Y
        sta B1L09AD
        lda B1L09AE
        eor bfL202C,Y
        sta B1L09AE
        lda B1L09AF
        eor bfL204C,Y
        sta B1L09AF
        lda B1L09B0
        eor bfL206C,Y
        sta B1L09B0
        lda B1L09B1
        eor bfL208C,Y
        sta B1L09B1
        clc
        jmp B1L0F9F

B1L0D0C lda B1L09AD
        ora bfL200C,Y
        sta B1L09AD
        lda B1L09AE
        ora bfL202C,Y
        sta B1L09AE
        lda B1L09AF
        ora bfL204C,Y
        sta B1L09AF
        lda B1L09B0
        ora bfL206C,Y
        sta B1L09B0
        lda B1L09B1
        ora bfL208C,Y
        sta B1L09B1
        clc
        jmp B1L0F9F

B1L0D3D lda B1L09AD
        ora bfL200C,Y
        sta B1L09AD
        lda B1L09AE
        and bfL202C,Y
        sta B1L09AE
        lda B1L09AF
        and bfL204C,Y
        sta B1L09AF
        lda B1L09B0
        and bfL206C,Y
        sta B1L09B0
        lda B1L09B1
        and bfL208C,Y
        sta B1L09B1
        clc
        jmp B1L0F9F

B1L0D6E dta b($00)

B1L0D6F jsr B1L0D9E
        jsr MUL_32
B1L0D75 ldx #$03
        ldy #$00
B1L0D79 lda COMTAB+$107,X
        sta B1L09AE,Y
        iny
        dex
        bpl B1L0D79
        bit $00
        bmi B1L0D91
        lda B1L0D6E
        bpl B1L0D8F
        jsr B1L0C85
B1L0D8F clc
        dta b(BIT_zp)
B1L0D91 sec
        jmp B1L0F9F

B1L0D95 jsr B1L0D9E
        jsr DIV_32
        jmp B1L0D75

B1L0D9E lda B1L09B1
        sta B1L0D6E
        bpl B1L0DA9
        jsr B1L0C85
B1L0DA9 lda B1L09B1
        sta COMTAB+$FF
        lda B1L09B0
        sta COMTAB+$FF+1
        lda B1L09AF
        sta COMTAB+$FF+2
        lda B1L09AE
        sta COMTAB+$FF+3
        lda B1L09AD
        ora bfL200C,Y
        sta B1L09AD
        lda bfL202C,Y
        sta B1L09AE
        lda bfL204C,Y
        sta B1L09AF
        lda bfL206C,Y
        sta B1L09B0
        lda bfL208C,Y
        sta B1L09B1
        php
        eor B1L0D6E
        sta B1L0D6E
        plp
        bpl B1L0DEF
        jsr B1L0C85
B1L0DEF ldx #$00
        ldy #$03
B1L0DF3 lda B1L09AE,Y
        sta COMTAB+$103,X
        inx
        dey
        bpl B1L0DF3
        rts

B1L0DFE sta $82
        cpy $82
        bcc B1L0E09
        lda #$0A
        jmp prErrMs
B1L0E09 lda #$00
        ldx #$04
B1L0E0D sta B1L09AD,X
        dex
        bpl B1L0E0D
        lda bfL1EAC,Y
        cmp #$27
        beq B1L0E1E
        cmp #$22
        bne B1L0E21
B1L0E1E jmp B1L0E7A
B1L0E21 cmp #$21
        bne B1L0E28
        jmp B1L0EA2
B1L0E28 cmp #$24
        bne B1L0E2F
        jmp B1L0EBA
B1L0E2F cmp #$25
        bne B1L0E36
        jmp B1L0EF9
B1L0E36 cmp #$30
        bcc B1L0E41
        cmp #$3A
        bcs B1L0E41
        jmp B1L0F69
B1L0E41 ldx #$00
B1L0E43 lda bfL1EAC,Y
        jsr TOUPPER
        sta bfCFNAM,X
        inx
        iny
        cpy $82
        bcc B1L0E43
        lda #$9B
        sta bfCFNAM,X
        stx $82
        jsr B1L1BC5
        ldx #$02
B1L0E5E lda B1L1BBF,X
        sta B1L09AD,X
        dex
        bpl B1L0E5E
        and #$80
        bpl B1L0E78
        dec B1L0B01
        bpl B1L0E75
        lda #$11
        jmp prErrMs
B1L0E75 jsr B1L1C46
B1L0E78 clc
        rts

B1L0E7A lda $82
        sta B1L09AE
        tya
        tax
        jsr B1L096A
        bcs B1L0EA1
        cpx B1L09AE
        beq B1L0E90
        lda #$05
        jmp prErrMs
B1L0E90 lda bfCFNAM
        ldx B1L0969
        cpx #$27
        beq B1L0E9D
        jsr B1L0FC8
B1L0E9D sta B1L09AE
        clc
B1L0EA1 rts

B1L0EA2 iny
        cpy $82
        beq B1L0EAC
        lda #$06
        jmp prErrMs
B1L0EAC lda $8C
        sta B1L09AE
        lda $8D
        sta B1L09AF
        clc
        jmp B1L0F9F

B1L0EBA iny
        cpy $82
        bcc B1L0EC4
        lda #$0A
        jsr prErrMs
B1L0EC4 dey
B1L0EC5 iny
        cpy $82
        bcs B1L0EED
        ldx #$03
        jsr B1L0F8B
        bne B1L0EF1
        lda bfL1EAC,Y
        jsr TOUPPER
        sec
        sbc #$30
        cmp #$0A
        bcc B1L0EE4
        sbc #$07
        cmp #$10
        bcs B1L0EF4
B1L0EE4 ora B1L09AE
        sta B1L09AE
        jmp B1L0EC5
B1L0EED clc
        jmp B1L0F9F
B1L0EF1 lda #$04
        dta b(BIT_abs)
B1L0EF4 lda #$06
        jmp prErrMs
B1L0EF9 iny
        cpy $82
        bcc B1L0F03
        lda #$0A
        jsr prErrMs
B1L0F03 dey
B1L0F04 iny
        cpy $82
        bcs B1L0EED
        ldx #$00
        jsr B1L0F8B
        bne B1L0EF1
        lda bfL1EAC,Y
        sec
        sbc #$30
        cmp #$02
        bcs B1L0EF4
        ora B1L09AE
        sta B1L09AE
        jmp B1L0F04
B1L0F23 iny
        cpy $82
        bcs B1L0EED
        lda B1L09B1
        pha
        lda B1L09B0
        pha
        lda B1L09AF
        pha
        lda B1L09AE
        pha
        ldx #$01
        jsr B1L0F8B
        clc
        pla
        adc B1L09AE
        sta B1L09AE
        pla
        adc B1L09AF
        sta B1L09AF
        pla
        adc B1L09B0
        sta B1L09B0
        pla
        adc B1L09B1
        sta B1L09B1
        bcs B1L0EF1
        txa
        bne B1L0EF1
        ldx #$00
        jsr B1L0F8B
        bne B1L0EF1
        lda bfL1EAC,Y
B1L0F69 sec
        sbc #$30
        cmp #$0A
        bcs B1L0EF4
        clc
        adc B1L09AE
        sta B1L09AE
        bcc B1L0F23
        inc B1L09AF
        bne B1L0F23
        inc B1L09B0
        bne B1L0F23
        inc B1L09B1
        bne B1L0F23
        jmp B1L0EF1

B1L0F8B lda #$00
B1L0F8D asl B1L09AE
        rol B1L09AF
        rol B1L09B0
        rol B1L09B1
        rol @
        dex
        bpl B1L0F8D
        tax
        rts

B1L0F9F bcc B1L0FA6
        lda #$04
        jmp prErrMs
B1L0FA6 lda B1L09AD
B1L0FA9 and #$C0
        beq B1L0FAF
        ora #$20
B1L0FAF ldx B1L09B1
        beq B1L0FB6
        ora #$38
B1L0FB6 ldx B1L09B0
        beq B1L0FBD
        ora #$30
B1L0FBD ldx B1L09AF
        beq B1L0FC4
        ora #$20
B1L0FC4 sta B1L09AD
        rts

B1L0FC8 asl @
        php
        cmp #$C0
        bcs B1L0FD4
        sbc #$3F
        bcs B1L0FD4
        adc #$C0
B1L0FD4 plp
        ror @
        rts

opCode1 dta c'CNBRSPBSPBTTCEBRTOTR'
        dta c'CCCTDSCIBLPDPAASDTBS'
        dta c'SIIABBLBBLCRJJSDL'
opCode2 dta c'LOVTEHRELVSXLOIOXRYO'
        dta c'PLPAEELNMSLEHNSTEACT'
        dta c'BNNDCPDNEDMTMSTTD'
opCode3 dta c'VPCIIPKDPSXSDRTRAAAL'
        dta c'XIYYCCCXIRAYADLXXXSY'
        dta c'CCYCCLYEQXPSPRAAA'

B1L10F2 dta b($B8,$EA,$50,$40)
        dta b($78,$08,$00,$F8)
        dta b($28,$70,$BA,$9A)
        dta b($D8,$41,$20,$62)
        dta b($8A,$01,$98,$22)
        dta b($E0,$58,$C0,$A8)
        dta b($C2,$38,$18,$E8)
        dta b($30,$42,$68,$88)
        dta b($48,$21,$02,$82)
        dta b($CA,$AA,$B0,$80)
        dta b($E1,$E2,$C8,$61)
        dta b($90,$10,$A0,$D0)
        dta b($F0,$A2,$C1,$60)
        dta b($40,$20,$81,$00)
        dta b($A1)
B1L112B dta b($08,$08,$06,$08)
        dta b($08,$08,$08,$08)
        dta b($08,$06,$08,$08)
        dta b($08,$00,$04,$04)
        dta b($08,$00,$08,$04)
        dta b($04,$08,$04,$08)
        dta b($04,$08,$08,$08)
        dta b($06,$04,$08,$08)
        dta b($08,$00,$04,$04)
        dta b($08,$08,$06,$04)
        dta b($00,$04,$08,$00)
        dta b($06,$06,$04,$06)
        dta b($06,$04,$00,$08)
        dta b($0C,$0A,$00,$02)
        dta b($00)
B1L1164 dta b($00,$00,$00,$00)
        dta b($00,$00,$00,$00)
        dta b($00,$00,$00,$00)
        dta b($00,$00,$50,$75)
        dta b($00,$00,$00,$75)
        dta b($D0,$00,$D0,$00)
        dta b($55,$00,$00,$00)
        dta b($00,$75,$00,$00)
        dta b($00,$00,$75,$58)
        dta b($00,$00,$00,$54)
        dta b($00,$55,$00,$00)
        dta b($00,$00,$D5,$00)
        dta b($00,$DA,$00,$00)
        dta b($00,$00,$00,$00)
        dta b($00)

B1L119D dta v(B1L12A7)
        dta v(prsDatK)
        dta v(B1L12F1)
        dta v(B1L11F9)
        dta v(B1L11F3)
        dta v(B1L1263)
        dta v(B1L1278)

B1L11AB dta b($00)

prsOprt lda $82
        cmp #$03
        beq B1L11B4
B1L11B2 sec
        rts
B1L11B4 ldx #$39
B1L11B6 dex
        bmi B1L11B2
        lda bfCFNAM
        cmp opCode1,X
        bne B1L11B6
        lda bfCFNAM+1
        cmp opCode2,X
        bne B1L11B6
        lda bfCFNAM+2
        cmp opCode3,X
        bne B1L11B6
        ldy B1L112B,X
        lda B1L10F2,X
        sta B1L11AB
        lda B1L119D,Y
        sta B1L11EE+1
        lda B1L119D+1,Y
        sta B1L11EE+2
        lda #$01
B1L11E8 sta B1L1C45
        sta B1L1A55
B1L11EE jsr $FFFF
        clc
B1L11F2 rts

B1L11F3 lda B1L11AB
        jmp B1L0899

B1L11F9 jsr B1L09B2
        bcs B1L11F2
        and #$9F
        beq B1L120A
        lda #$08
        dta b(BIT_abs)
B1L1205 lda #$07
        jmp prErrMs
B1L120A jsr B1L11F3
        lda B1L09AD
        and #$40
        bne B1L1260
        clc
        lda B1L09AE
        sbc $8C
        sta B1L09AE
        lda B1L09AF
        sbc $8D
        sta B1L09AF
        lda B1L09B0
        sbc #$00
        sta B1L09B0
        bcs B1L1232
        dec B1L09B1
B1L1232 bpl B1L124C
        lda #$FF
        cmp B1L09B1
        bne B1L1205
        cmp B1L09B0
        bne B1L1205
        cmp B1L09AF
        bne B1L1205
        lda B1L09AE
        bpl B1L1205
        bmi B1L1260
B1L124C lda B1L09B1
        bne B1L1205
        lda B1L09B0
        bne B1L1205
        lda B1L09AF
        bne B1L1205
        lda B1L09AE
        bmi B1L1205
B1L1260 jmp B1L0899
B1L1263 jsr B1L09B2
        bcc B1L1269
B1L1268 rts
B1L1269 and #$1F
        beq B1L1272
B1L126D lda #$08
        jmp prErrMs
B1L1272 jsr B1L11F3
        jmp B1L081F

B1L1278 jsr B1L09B2
        bcs B1L1268
        and #$1F
        beq B1L128A
        cmp #$04
        bne B1L126D
        lda #$60
        sta B1L11AB
B1L128A lda B1L11AB
        ora #$0C
        jsr B1L0899
        jmp B1L081F

B1L1295 dta b($10,$00,$02,$06)
        dta b($05,$20,$22,$21)
        dta b($01)
B1L129E dta b($08,$04,$14,$00)
        dta b($10,$0C,$1C,$18)
        dta b($18)

B1L12A7 jsr B1L09B2
        bcs B1L12D7
        and #$3F
        ldx #$08
B1L12B0 cmp B1L1295,X
        beq B1L12BD
        dex
        bpl B1L12B0
B1L12B8 lda #$08
        jmp prErrMs
B1L12BD lda B1L11AB
        ora B1L129E,X
        cmp #$89
        beq B1L12B8
        jsr B1L0899
B1L12CA cpx #$05
        bcc B1L12D1
        jmp B1L081F
B1L12D1 lda B1L09AE
        jmp B1L0899
B1L12D7 rts

B1L12D8 dta b($08,$10,$00,$02)
        dta b($01,$20,$22,$21)
B1L12E0 dta b($08,$00,$04,$14)
        dta b($14,$0C,$1C,$1C)
B1L12E8 dta b($20,$80,$40,$04)
        dta b($08,$10,$01,$02)
B1L12F0 dta b($00)

B1L12F1 lda B1L1164,X
        sta B1L12F0
        jsr B1L09B2
        bcs B1L12D7
        and #$3F
        ldx #$07
B1L1300 cmp B1L12D8,X
        beq B1L130D
        dex
        bpl B1L1300
B1L1308 lda #$08
        jmp prErrMs
B1L130D lda B1L12F0
        and B1L12E8,X
        beq B1L1308
        lda B1L11AB
        ora B1L12E0,X
        jsr B1L0899
        cpx #$00
        beq B1L12D7
        bne B1L12CA

datKind dta c'BAVEFGLHCD'

datKndV dta v(datByte)
        dta v(datAddr)
        dta v(datVect)
        dta v(datByt3)
        dta v(datByt4)
        dta v(datBy4R)
        dta v(datLowB)
        dta v(datHigh)
        dta v(datChar)
        dta v(datIntD)

prsDatK dec B1L1C45
        jsr B1L08D5
        bne B1L134F
        lda #$02
        jmp prErrMs
B1L134F lda bfCFNAM
        ldx #$09
B1L1354 cmp datKind,X
        beq B1L1361
        dex
        bpl B1L1354
        lda #$08
        jmp prErrMs
B1L1361 txa
        asl @
        tax
        lda datKndV,X
        sta B1L13C3+1
        sta B1L138A+1
        lda datKndV+1,X
        sta B1L13C3+2
        sta B1L138A+2
        cpx #$10
        bcc B1L1393
        ldx #$01
        jsr B1L096A
        bcs B1L1392
        cpx $83
        beq B1L138A
        lda #$05
        jmp prErrMs
B1L138A jsr $FFFF
        jsr B1L08D5
        bne B1L134F
B1L1392 rts

B1L1393 lda bfL1EAD
        cmp #$28
        beq B1L139F
        lda #$06
        jmp prErrMs
B1L139F lda #$FF
        sta B1L09AC
        ldy #$02
B1L13A6 lda B1L09AC
        beq B1L134F
        ldx $83
        dex
        lda bfL1EAC,X
        cmp #$29
        bne B1L13B9
        inc B1L09AC
        dta b(BIT_zp)
B1L13B9 inx
        txa
        jsr B1L0B29
        bcs B1L1392
        lda B1L09AD
B1L13C3 jsr $FFFF
        jsr B1L08D5
        beq B1L13CF
        ldy #$00
        beq B1L13A6
B1L13CF lda B1L09AC
        beq B1L1392
        lda #$0F
        jmp prErrMs

datByte and #$3C
        bne B1L1400
        ldy #$00
B1L13DF ldx #$00
B1L13E1 lda B1L09AE,X
        jsr B1L0899
        inx
        dey
        bpl B1L13E1
        rts

datAddr and #$1C
        bne B1L1400
        ldy #$01
        bne B1L13DF

datByt3 and #$0C
        bne B1L1400
        ldy #$02
        bne B1L13DF

datByt4 ldy #$03
        bne B1L13DF
B1L1400 lda #$04
        jmp prErrMs

datVect and #$1C
        bne B1L1400
        jmp B1L081F

datLowB and #$1C
        bne B1L1400
        lda B1L09AE
        jmp B1L0899

datHigh and #$1C
        bne B1L1400
        lda B1L09AF
        jmp B1L0899

datBy4R ldx #$03
B1L1422 lda B1L09AE,X
        jsr B1L0899
        dex
        bpl B1L1422
        rts

B1L142C dta b($00)

datIntD lda #$FF
        dta b(BIT_abs)
datChar lda #$00
        sta B1L142C
        ldx #$00
B1L1437 lda bfCFNAM,X
        ldy B1L142C
        beq B1L1442
        jsr B1L0FC8
B1L1442 jsr B1L0899
        inx
        cpx $82
        bcc B1L1437
        rts

psCode1 dta c'OOEIBLES'
psCode2 dta c'PRNCLSQM'
psCode3 dta c'TGDLKTUB'

psCodeV dta v(optCode)
        dta v(orgCode)
        dta v(endCode)
        dta v(iclCode)
        dta v(blkCode)
        dta v(lstCode)
        dta v(errCode)
        dta v(errCode)

prsPseu lda $82
        cmp #$03
        beq B1L147B
B1L1479 sec
        rts
B1L147B ldx #$08
B1L147D dex
        bmi B1L1479
        lda bfCFNAM
        cmp psCode1,X
        bne B1L147D
        lda bfCFNAM+1
        cmp psCode2,X
        bne B1L147D
        lda bfCFNAM+2
        cmp psCode3,X
        bne B1L147D
        txa
        asl @
        tax
        lda psCodeV,X
        sta B1L14A7+1
        lda psCodeV+1,X
        sta B1L14A7+2
B1L14A7 jsr $FFFF
        clc
        rts

lstCode jsr B1L08D8
        bne B1L14B6
B1L14B1 lda #$02
        jmp prErrMs
B1L14B6 ldx #$00
        lda bfCFNAM
        cmp #$4E
        bne B1L14C6
        stx cmdOptA
        stx cmdOptB
        rts
B1L14C6 dex
        cmp #$41
        bne B1L14CF
        stx cmdOptA
        rts

B1L14CF cmp #$42
        bne B1L14D7
        stx cmdOptB
        rts
B1L14D7 lda #$06
        jmp prErrMs

iclCode inc B1L1AD2
        lda PASSNUM
        bne B1L14F5
        jsr B1L08D8
        beq B1L14B1
        ldx #$00
        jsr B1L096A
        bcc B1L14F0
        rts
B1L14F0 ldx #$00
        jsr B1L1AD3
B1L14F5 jmp B1L076D

endCode lda B1L0096
        cmp #$02
        bcs B1L1503
        dec B1L0463
        rts
B1L1503 jmp B1L07BB

errCode lda #$09
        jmp prErrMs

B1L150B dta b($00)

optCode jsr B1L0B18
        bcs B1L1547
        lda B1L09AD
        and #$7C
        beq B1L151D
        lda #$0C
        jmp prErrMs
B1L151D lda B1L09AE
        and #$03
        bne B1L152A
        sta cmdOptA
        sta cmdOptB
B1L152A ldx #$FF
        cmp #$01
        bne B1L1535
        stx cmdOptB
        beq B1L1538
B1L1535 stx cmdOptA
B1L1538 ldx #$01
        lda B1L09AE
        and #$60
        cmp #$60
        bne B1L1544
        dex
B1L1544 stx B1L150B
B1L1547 rts

orgCode jsr B1L15AE
        ldx B1L150B
        jmp B1L1582

blkKind dta c'NDSREU'

blkKndV dta v(blkNone)
        dta v(blkADOS)
        dta v(blkSpar)
        dta v(blkRelo)
        dta v(blkEmpt)
        dta v(blkUpdt)

blkCode jsr B1L08D8
        bne B1L156D
        lda #$02
        jmp prErrMs
B1L156D jsr B1L15AE
        lda bfCFNAM
        ldx #$05
        cmp blkKind,X
        beq B1L1582
        dex
        bpl *-6
        lda #$06
        jmp prErrMs
B1L1582 stx B1L1D6A
        inc B1L1D63
        bne B1L158F
        lda #$0B
        jmp prErrMs
B1L158F txa
        asl @
        tax
        lda blkKndV,X
        sta B1L15AA+1
        lda blkKndV+1,X
        sta B1L15AA+2
        jsr B1L08D8
        bne B1L15A8
        lda #$02
        jmp prErrMs
B1L15A8 lda PASSNUM
B1L15AA jmp $FFFF

B1L15AD dta b($00)

B1L15AE lda B1L1D63
        beq B1L15F5
        lda B1L1D6A
        sta B1L1D6B
        jsr B1L1D6C
        lda PASSNUM
        bne B1L15F5
        ldy #$07
        lda $8C
        sta ($84),Y
        iny
        lda $8D
        sta ($84),Y
        lda B1L1D65
        and #$70
        bne B1L15F5
        ldx B1L1D64
        cpx B1L15AD
        beq B1L15F5
        stx B1L15AD
        lda $8E
        sta bfL210C,X
        lda $8F
        sta bfL2114,X
        lda $8C
        sta $8E
        sta bfL211C,X
        lda $8D
        sta $8F
        sta bfL2124,X
B1L15F5 rts

B1L15F6 ldx #$07
B1L15F8 lda B1L09AE
        cmp bfL211C,X
        lda B1L09AF
        sbc bfL2124,X
        bcs B1L1617
        lda B1L09AE
        cmp bfL210C,X
        lda B1L09AF
        sbc bfL2114,X
        bcs B1L1619
        dex
        bne B1L15F8
B1L1617 sec
        dta b(BIT_zp)
B1L1619 clc
        rts

initDat ldx #$07
        lda #$00
        sta bfL210C,X
        sta bfL211C,X
        lda #$A0
        sta bfL2114,X
        sta bfL2124,X
        dex
        bne *-17
        rts

B1L1631 lda B1L1D66
        cmp B1L1D68
        lda B1L1D67
        sbc B1L1D69
        bcc B1L1645
        lda B1L1D6B
        sta B1L1D6A
B1L1645 rts

blkNone bne B1L1671
B1L1648 lda #$FF
B1L164A sta B1L1D65
        jsr B1L0B22
        bcs B1L167E
        lda B1L09AD
        and #$5C
        beq B1L165E
        lda #$0C
        jmp prErrMs
B1L165E lda B1L09AE
        sta $8C
        sta B1L1D66
        lda B1L09AF
        sta $8D
        sta B1L1D67
        jmp B1L1D91
B1L1671 jsr B1L1D6C
        lda B1L1D66
        sta $8C
        lda B1L1D67
        sta $8D
B1L167E rts

blkADOS beq B1L1648
        jsr B1L1671
        jsr B1L1631
        bcs B1L167E
        lda B1L1D6B
        cmp #$01
        beq B1L1698
        lda #$FF
        jsr B1L089F
        jsr B1L089F
B1L1698 sec
        lda B1L1D68
        sbc #$01   
        sta B1L1D68
        bcs B1L16A6
        dec B1L1D69
B1L16A6 ldx #$00
B1L16A8 lda B1L1D66,X
        jsr B1L089F
        inx
        cpx #$04
        bcc B1L16A8
        jmp B1L1D6C

blkSpar bne B1L16BD
        lda #$FE
        jmp B1L164A
B1L16BD jsr B1L1671
        jsr B1L1631
        bcs B1L167E
        lda #$FA
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        jmp B1L1698

blkRelo bne B1L1715
        lda $8E
        sta B1L1D66
        sta $8C
        lda $8F
        sta B1L1D67
        sta $8D
        ldx #$00
        stx B1L1D65
B1L16E7 ldx #$00
        lda bfCFNAM
        cmp #$4D
        beq B1L16F6
        cmp #$45
        bne B1L170F
        inx
        inx
B1L16F6 txa
        ora B1L1D65
        sta B1L1D65
        inc B1L1D64
        lda B1L1D64
        cmp #$08
        bcc B1L170C
        lda #$0B
        jmp prErrMs
B1L170C jmp B1L1D91
B1L170F lda #$06
        jmp prErrMs
B1L1714 rts
B1L1715 jsr B1L1671
B1L1718 jsr B1L1631
        bcs B1L1714
        lda #$FE
        jsr B1L089F
        lda #$FF   
        jsr B1L089F
        sec
        lda B1L1D68
        sbc B1L1D66
        sta B1L1D68
        lda B1L1D69
        sbc B1L1D67
        sta B1L1D69
        sec
        lda B1L1D67
        sbc #$10
        sta B1L1D67
        ldx #$00
B1L1745 lda B1L1D64,X
        jsr B1L089F
        inx
        cpx #$06
        bcc B1L1745
        jmp B1L1D6C

blkEmpt bne B1L178D
        jsr B1L0B22
        bcs B1L1714
        lda B1L09AD
        and #$5C
        beq B1L1766
        lda #$0C
        jmp prErrMs
B1L1766 clc
        lda $8E
        sta B1L1D66
        adc B1L09AE
        sta $8C
        lda $8F
        sta B1L1D67
        adc B1L09AF
        sta $8D
        lda #$80
        sta B1L1D65
        jsr B1L08D8
        beq B1L1788
        jmp B1L16E7
B1L1788 lda #$02
        jmp prErrMs
B1L178D jsr B1L1671
        jmp B1L1718

blkUpdt dec B1L1D63
        lda B1L1D63
        bne B1L17A0
        lda #$0D
        jmp prErrMs
B1L17A0 lda bfCFNAM
        cmp #$4E
        bne B1L17AA
        jmp B1L197B
B1L17AA cmp #$53
        bne B1L17B1
        jmp B1L18A1
B1L17B1 cmp #$41
        bne B1L17B8
        jmp B1L17BE
B1L17B8 lda #$06
        jmp prErrMs

B1L17BD dta b($00)

B1L17BE lda PASSNUM
        bne B1L17C3
B1L17C2 rts
B1L17C3 lda B1L0090
        ora B1L0091
        bne B1L17C2
        lda B1L1D64
        sta B1L17BD
        inc B1L17BD
B1L17D4 dec B1L17BD
        bne B1L17DC
        jmp B1L1CD9
B1L17DC jsr B1L1CE8
        bmi B1L17D4
B1L17E1 cmp B1L17BD
        beq B1L17ED
        jsr B1L1CF5
        bpl B1L17E1
        bmi B1L17D4
B1L17ED sta B1L1863
        lda #$FD
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        lda B1L1863
        jsr B1L089F
        lda #$00
        jsr B1L089F
        jsr B1L089F
        sta B1L1863
B1L180B ldy #$00
        lda ($92),Y
        cmp B1L17BD
        bne B1L184B
        iny
        lda ($92),Y
        bpl B1L182D
        lda #$FD   
        jsr B1L089F
        iny
        lda ($92),Y
        jsr B1L089F
        iny
        lda ($92),Y
        jsr B1L089F
        jmp B1L184B
B1L182D jsr B1L1864
        sec
        iny
        lda ($92),Y
        sbc $96
        sta $94
        iny
        lda ($92),Y
        sbc $97
        sta $95
        lda ($92),Y
        sta $97
        dey
        lda ($92),Y
        sta $96
        jsr B1L187A
B1L184B jsr B1L1CF5
        bpl B1L180B
        lda #$FC
        jsr B1L089F
        jmp B1L17D4
B1L1858 lda #$00
        sta $94
        sta $96
        sta $95
        sta $97
B1L1862 rts

B1L1863 dta b($00)

B1L1864 cmp B1L1863
        beq B1L1862
        sta B1L1863
        lda #$FE
        jsr B1L089F
        lda B1L1863
        jsr B1L089F
        jmp B1L1858
B1L187A lda $94
        cmp #$FC
        lda $95
        sbc #$00
        bcc B1L1897
        sec
        lda $94
        sbc #$FA
        sta $94
        bcs B1L188F
        dec $95
B1L188F lda #$FF
        jsr B1L089F
        jmp B1L187A
B1L1897 lda $94
        jmp B1L089F

B1L189C dta b($00)
B1L189D dta b($00)
B1L189E dta b($00)
B1L189F dta b($00)
B1L18A0 dta b($00)

B1L18A1 lda PASSNUM
        bne B1L18A6
B1L18A5 rts
B1L18A6 lda B1L0090
        ora B1L0091
        bne B1L18A5
        lda #$FF
        sta B1L189C
        lda $86
        sta B1L189E
        lda $87
        sta B1L189F
B1L18BD lda B1L189E
        sta $84
        lda B1L189F
        sta $85
        lda #$FF
        sta B1L189D
        jsr B1L1D43
        php
        lda $98
        sta B1L189E
        lda $99
        sta B1L189F
        plp
        bcc B1L18F1
        lda B1L1D63
        sta B1L18A0
B1L18E3 lda B1L189C
        bne B1L18ED
        lda #$FC
        jsr B1L089F
B1L18ED rts

B1L18EE jsr B1L1C25
B1L18F1 beq B1L18BD
        jsr B1L1CCB
        lda B1L18A0
        cmp B1L1C40
        bcs B1L18EE
        lda B1L1D63
        cmp B1L1C40
        bcs B1L1912
        lda B1L189E
        sta $98
        lda B1L189F
        sta $99
        bne B1L18BD
B1L1912 lda B1L189D
        beq B1L193B
        jsr B1L18E3
        ldx #$FF
        stx B1L1863
        inx
        stx B1L189C
        stx B1L189D
        lda #$FB
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        jsr B1L08C2
        lda #$00
        jsr B1L089F
        jsr B1L089F
B1L193B lda B1L1C42
        and #$70
        beq B1L1956
        lda #$FD
        jsr B1L089F
        lda B1L1C43
        jsr B1L089F
        lda B1L1C44
        jsr B1L089F
        jmp B1L18EE
B1L1956 lda B1L1C41
        jsr B1L1864
        sec
        lda B1L1C43
        sbc $96
        sta $94
        lda B1L1C44
        sbc $97
        sta $95
        lda B1L1C43
        sta $96
        lda B1L1C44
        sta $97
        jsr B1L187A
        jmp B1L18EE
B1L197B jsr B1L0B18
        bcs B1L1992
        lda B1L09AD
        and #$5C
        beq B1L1993
        lda #$0C
        dta b(BIT_abs)
B1L198A lda #$0d
        dta b(BIT_abs)
B1L198D lda #$02
        jmp prErrMs
B1L1992 rts
B1L1993 jsr B1L08D8
        beq B1L198D
        jsr B1L1D21
        bcs B1L1992
        lda PASSNUM
        beq B1L1992
        lda #$FC
        jsr B1L089F
        lda #$FF
        jsr B1L089F
        jsr B1L15F6
        bcs B1L198A
        txa
        jsr B1L089F
        lda B1L09AE
        jsr B1L089F
        sec
        lda B1L09AF
        sbc #$10
        jsr B1L089F
        jmp B1L08C2

syCode1 dta c'ES'
syCode2 dta c'QM'
syCode3 dta c'UB'
syCodeV dta v(equCode),v(smbCode)

prsSymb lda $82
        cmp #$03
        beq B1L19D8
B1L19D6 sec
        rts
B1L19D8 ldx #$02
B1L19DA dex
        bmi B1L19D6 
        lda bfCFNAM
        cmp syCode1,X 
        bne B1L19DA
        lda bfCFNAM+1
        cmp syCode2,X
        bne B1L19DA
        lda bfCFNAM+2
        cmp syCode3,X 
        bne B1L19DA
        txa
        asl @
        tax
        lda syCodeV,X
        sta B1L1A0E+1
        lda syCodeV+1,X
        sta B1L1A0E+2
        jsr B1L08D8
        bne B1L1A0E
        lda #$02
        jmp prErrMs
B1L1A0E jsr $FFFF
        clc
        rts

equCode lda #$FF
        sta B1L1A55
        jsr B1L1A78
        bcs B1L1A54
        jsr B1L0B22
        bcs B1L1A54
        lda B1L09AD
        and #$9C
        beq B1L1A2E
        lda #$0E
        jmp prErrMs
B1L1A2E lda B1L0465
        sta $84
        lda B1L0466
        sta $85
        jsr B1L1BAA
        lda B1L09AD
        and #$EC
        ora #$01
        sta B1L1BBF
        lda B1L09AE
        sta B1L1BC0
        lda B1L09AF
        sta B1L1BC1
            jsr B1L1B96
B1L1A54     rts

B1L1A55 dta b($00)

smbCode jsr B1L1A78
        bcs B1L1A54
        lda B1L1A55
        beq B1L1A65
        lda #$11
        jsr prErrMs
B1L1A65 lda #$A1
        sta B1L1BBF
        lda #$00
        sta B1L1BC0
        sta B1L1BC1
        jsr B1L1B96
        jmp B1L1D05

B1L1A78 lda B1L1BBF
        and #$01
        beq B1L1A88
        lda PASSNUM
        bne B1L1A88
        lda #$01
        jmp prErrMs
B1L1A88 lda B1L1BBF
        and #$40
        bne B1L1A91
        sec
        dta b(BIT_zp)
B1L1A91 clc
        rts

B1L1A93 ldy #$00
B1L1A95 lda bfCFNAM,Y
        cmp #$2E
        bne B1L1A9F
        clc
        bcc B1L1AA8
B1L1A9F cmp #$9B
        beq B1L1AA8
        iny
        cpy $82
        bcc B1L1A95
B1L1AA8 rts

dfltExt dta c'.ASM'
        dta b($9B)
        dta c'.OBJ'
        dta b($9B)
dfltIdx dta b($00,$05,$0A)

B1L1AB6 inx
        lda dfltIdx,X
        sta B1L1ACA+1
        dex
        lda dfltIdx,X
        tax
B1L1AC2 lda dfltExt,X
        sta bfCFNAM,Y
        iny
        inx
B1L1ACA cpx #$00
        bcc B1L1AC2
        dey
        sty $82
        rts

B1L1AD2 dta b($00)

B1L1AD3 txa
        pha
        jsr B1L1A93
        bcc B1L1ADD
        jsr B1L1AB6
B1L1ADD pla
        jsr B1L1B0C
        iny
        lda B1L1AD2
        sta ($84),Y
        jmp B1L1AEA
B1L1AEA iny
        lda $82
        sta ($84),Y
        ldx #$00
B1L1AF1 iny
        lda bfCFNAM,X
        sta ($84),Y
        inx
        cpx $82
        bcc B1L1AF1
        iny
        tya
        ldy #$00
        sta ($84),Y
        clc
        adc $8A
        sta $8A
        bcc B1L1B0B
        inc $8B
B1L1B0B rts

B1L1B0C tax
        lda $8A
        sta $84
        cmp $88
        lda $8B
        sta $85
        sbc $89
        bcc B1L1B20
        lda #$9C
        jmp jmpFAIL
B1L1B20 ldy #$01
        txa
        sta ($84),Y
        rts

B1L1B26 ldy $86
        sty $84
        ldy $87
        sty $85
B1L1B2E sta B1L1B35+1
B1L1B31 ldy #$01
        lda ($84),Y
B1L1B35 cmp #$00
        beq B1L1B51
B1L1B39 ldy #$00
        clc
        lda ($84),Y
        adc $84
        sta $84
        bcc B1L1B46
        inc $85
B1L1B46 lda $84
        cmp $8A
        lda $85
        sbc $8B
        bcc B1L1B31
        dta b(BIT_zp)
B1L1B51 clc
        rts

B1L1B53 txa
        jsr B1L1B26
        bcs B1L1B67
B1L1B59 ldy #$02
        lda ($84),Y
        cmp B1L1AD2
        beq B1L1B68
        jsr B1L1B39
        bcc B1L1B59
B1L1B67 rts

B1L1B68 iny
        lda ($84),Y
        sta $82
        ldx #$00
B1L1B6F iny
        lda ($84),Y
        sta bfCFNAM,X
        inx
        cpx $82
        bcc B1L1B6F
        lda #$9B
        sta bfCFNAM,X
        clc
        rts

B1L1B81 inc labCnt
        bne B1L1B89
        inc labCnt+1
B1L1B89 lda #$02
        jsr B1L1B0C
        jsr B1L1B96
        ldy #$04
        jmp B1L1AEA
B1L1B96 ldy #$02
        lda B1L1BBF
        sta ($84),Y
        iny
        lda B1L1BC0
        sta ($84),Y
        iny
        lda B1L1BC1
        sta ($84),Y
        rts

B1L1BAA ldy #$02
        lda ($84),Y
        sta B1L1BBF
        iny
        lda ($84),Y
        sta B1L1BC0
        iny
        lda ($84),Y
        sta B1L1BC1
        rts

B1L1BBE dta b($00)
B1L1BBF dta b($00)
B1L1BC0 dta b($00)
B1L1BC1 dta b($00)

B1L1BC2 lda #$FF
        dta b(BIT_abs)
B1L1BC5 lda #$00
        sta B1L1BBE
        lda #$02
        jsr B1L1B26
        bcs B1L1BDD
B1L1BD1 ldy #$04
        jsr B1L1C0E
        beq B1L1C00
        jsr B1L1B39
        bcc B1L1BD1
B1L1BDD lda #$60
        sta B1L1BBF
        lda #$00
        sta B1L1BC0
        sta B1L1BC1
        jsr B1L1B81
B1L1BED lda B1L1BBE
        beq B1L1BF3
        rts
B1L1BF3 inc B1L0090
        bne B1L1BFB
        inc B1L0091
B1L1BFB lda #$00
        jmp prErrMs
B1L1C00 jsr B1L1BAA
        lda B1L1BBF
        and #$40
        beq B1L1C0D
        jmp B1L1BED
B1L1C0D rts

B1L1C0E iny
        lda $82
        cmp ($84),Y
        bne B1L1C24
        ldx #$00
B1L1C17 iny
        lda bfCFNAM,X
        cmp ($84),Y
        bne B1L1C24
        inx
        cpx $82
        bcc B1L1C17
B1L1C24 rts

B1L1C25 lda $84
        sta $98
        lda $85
        sta $99
        ldy #$03
        lda ($84),Y
        tax
        dey
        lda ($84),Y
        sta $84
        stx $85
        ora $85
B1L1C3B rts

B1L1C3C dta b($09,$05,$00,$00)
B1L1C40 dta b($00)
B1L1C41 dta b($00)
B1L1C42 dta b($00)
B1L1C43 dta b($00)
B1L1C44 dta b($00)
B1L1C45 dta b($00)

B1L1C46 lda PASSNUM
        bne B1L1C3B
        lda B1L1D65
        and #$70
        beq B1L1C5D
        lda B1L1D65
        and #$01
        beq B1L1C5D
        lda #$11
        jmp prErrMs
B1L1C5D jsr B1L1D43
        bcs B1L1CCA
        beq B1L1C69
B1L1C64 jsr B1L1C25
        bne B1L1C64
B1L1C69 lda #$05
        jsr B1L1B0C
        ldy #$02
        lda $84
        sta ($98),Y
        iny
        lda $85
        sta ($98),Y
        lda $8C
        sta B1L1C43
        lda $8D
        sta B1L1C44
        lda B1L1D65
        and #$70
        bne B1L1C9B
        sec
        lda $8C
        sbc B1L1D66
        sta B1L1C43
        lda $8D
        sbc B1L1D67
        sta B1L1C44
B1L1C9B clc
        lda B1L1C43
        adc B1L1C45
        sta B1L1C43
        bcc B1L1CAA
        inc B1L1C44
B1L1CAA ldy #$02
B1L1CAC lda B1L1D63,Y
        sta B1L1C40,Y
        dey
        bpl B1L1CAC
        ldy #$08
B1L1CB7 lda B1L1C3C,Y
        sta ($84),Y
        dey
        bpl B1L1CB7
        clc
        lda $8A
        adc #$09
        sta $8A
        bcc B1L1CCA
        inc $8B
B1L1CCA rts

B1L1CCB ldy #$08
        ldx #$04
B1L1CCF lda ($84),Y
        sta B1L1C40,X
        dey
        dex
        bpl B1L1CCF
        rts

B1L1CD9 ldy #$FF
        lda $8A
        sta $92
        lda $8B
        sta $93
        tya
        iny
        sta ($92),Y
        rts

B1L1CE8 sec
        lda $8A
        sbc #$04
        sta $92
        lda $8B
        sbc #$00
        sta $93
B1L1CF5 clc
        lda $92
        adc #$04
        sta $92
        bcc B1L1D00
        inc $93
B1L1D00 ldy #$00
        lda ($92),Y
        rts

B1L1D05 inc symbCnt
        bne *+5
        inc symbCnt+1
        lda #$04
        jsr B1L1B0C
        jsr B1L1D21
        ldy #$02
        lda #$00
        sta ($84),Y
        iny
        sta ($84),Y
        jmp B1L1AEA
B1L1D21 ldx #$00
        jsr B1L096A
        bcs B1L1D42
        ldx $82
        cpx #$08
        bcs B1L1D38
        lda #$20
B1L1D30 sta bfCFNAM,X
        inx
        cpx #$08
        bcc B1L1D30
B1L1D38 ldx #$08
        stx $82
        lda #$9B
        sta bfCFNAM,X
        clc
B1L1D42 rts

B1L1D43 clc
        ldy #$00
        lda ($84),Y
        adc $84
        sta $84
        bcc B1L1D50
        inc $85
B1L1D50 lda #$04
        jsr B1L1B2E
        bcs B1L1D60
        ldy #$03
        jsr B1L1B68
        jsr B1L1C25
        clc
B1L1D60 rts

B1L1D61 dta b($09,$03)
B1L1D63 dta b($00)
B1L1D64 dta b($00)
B1L1D65 dta b($00)
B1L1D66 dta b($00)
B1L1D67 dta b($00)
B1L1D68 dta b($00)
B1L1D69 dta b($00)
B1L1D6A dta b($00)
B1L1D6B dta b($00)

B1L1D6C lda B1L1D63
        sta B1L1D7B+1
        lda #$03
        jsr B1L1B26
B1L1D77 ldy #$02
        lda ($84),Y
B1L1D7B cmp #$00
        beq B1L1D85
        jsr B1L1B39
        bcc B1L1D77
        rts
B1L1D85 ldy #$08
B1L1D87 lda ($84),Y
        sta B1L1D61,Y
        dey
        bpl B1L1D87
        clc
        rts

B1L1D91 lda #$03
        jsr B1L1B0C
        ldy #$08
B1L1D98 lda B1L1D61,Y
        sta ($84),Y
        dey
        bpl B1L1D98
        clc
        lda $8A
        adc #$09
        sta $8A
        bcc B1L1DAB
        inc $8B
B1L1DAB rts

* Data Alloc Block

        blk empty $381 main

bfCFNAM equ *-$0381
bfL1EAC equ *-$0281
bfL1EAD equ *-$0280
bfL1FAC equ *-$0181
bfL1FCC equ *-$0161
bfL1FEC equ *-$0141
bfL200C equ *-$0121
bfL202C equ *-$0101
bfL204C equ *-$00E1
bfL206C equ *-$00C1
bfL208C equ *-$00A1
bfL20AC equ *-$0081
bfL20CC equ *-$0061
bfL20DC equ *-$0051
bfL20EC equ *-$0041
bfL20FC equ *-$0031
bfL210C equ *-$0021
bfL2114 equ *-$0019
bfL211C equ *-$0011
bfL2124 equ *-$0009

* Update Blocks

        blk update addresses

        blk update symbols

        blk update new start '@FA'

        end
