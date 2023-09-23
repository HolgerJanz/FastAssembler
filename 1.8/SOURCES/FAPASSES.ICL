* Part 2 Passes

* next line
nxtLine lda flagCls ; check END in include
        bne rdAftrE
        clc
        lda PCURLIN
        adc curLiLn
        sta PCURLIN
        bcc B1L065F
        inc PCURLIN+1
B1L065F lda PCURLIN
        cmp bufUsed
        lda PCURLIN+1
        sbc bufUsed+1
        bcs B1L068E
        ldy #$00
B1L066D lda (PCURLIN),Y
        iny
        bne B1L0677
* ERROR: Truncated record
        lda #$89
        jmp jmpFAIL
B1L0677 cmp #$9B
        bne B1L066D
B1L067B sty curLiLn
        inc lineNum
        bne B1L0686
        inc lineNum+1
B1L0686 lda #$00
        sta B1L08D3
        jmp cPrLine
* fill source buffer
rdAftrE inc flagCls
B1L068E jsr prPrgs
* read source file
        lda bufReaV
        sta PCURLIN
        sta FAUX1
        lda bufReaV+1
        sta PCURLIN+1
        sta FAUX2
        lda <bufReaS
        sta FAUX4
        lda >bufReaS
        sta FAUX5
        lda #$00
        sta SYSCALL
        jsr FREAD
        bpl B1L06D3
* reached EOF, process END
        lda FAUX4
        ora FAUX5
        bne B1L06D3
        lda endStrV
        sta PCURLIN
        sta bufUsed
        lda endStrV+1
        sta PCURLIN+1
        sta bufUsed+1
        ldy #$04
        bne B1L067B
* buffer filled, set current line
B1L06D3 clc
        lda PCURLIN
        adc FAUX4
        sta bufUsed
        lda PCURLIN+1
        adc FAUX5
        sta bufUsed+1
        ldy #$00
        sty B1L062E
        sty B1L062E+1
B1L06EC lda (PCURLIN),Y
        inc PCURLIN
        bne *+4
        inc PCURLIN+1
        cmp #$9B
        bne B1L0702
        lda PCURLIN
        sta B1L062E
        lda PCURLIN+1
        sta B1L062E+1
B1L0702 lda PCURLIN
        cmp bufUsed
        lda PCURLIN+1
        sbc bufUsed+1
        bcc B1L06EC
        lda B1L062E
        ora B1L062E+1
        bne B1L071B
* ERROR: Truncated record
        lda #$89
        jmp jmpFAIL
B1L071B jsr B1L073C
        lda B1L062E
        sta bufUsed
        lda B1L062E+1
        sta bufUsed+1
        lda bufReaV
        sta PCURLIN
        lda bufReaV+1
        sta PCURLIN+1
        lda #$00
        sta curLiLn
        jmp nxtLine

B1L073C jsr FTELL
        sec
        lda bufUsed
        sbc B1L062E
        sta bufUsed
        lda bufUsed+1
        sbc B1L062E+1
        sta bufUsed+1
        sec
        lda FAUX1
        sbc bufUsed
        sta FAUX1
        lda FAUX2
        sbc bufUsed+1
        sta FAUX2
        bcs B1L076A
        dec FAUX3
B1L076A jmp FSEEK

* open source
openSRC ldx curFilX
        beq B1L07A0
        clc
        lda PCURLIN
        adc curLiLn
        sta B1L062E
        lda PCURLIN+1
        adc #$00
        sta B1L062E+1
        jsr B1L073C
        ldx curFilX
        lda FHANDLE
        sta arrFHDL,X
        lda FAUX1
        sta arrFAU1,X
        lda FAUX2
        sta arrFAU2,X
        lda FAUX3
        sta arrFAU3,X
B1L07A0 ldx #$00
        jsr syGetFl
        jsr stCFNAM
        lda #$04
        sta FMODE
        lda #$A0
        sta FATR1
        inc curFilX
        jsr initBuf
        jmp FOPEN

* close source
closSRC jsr FCLOSE
        dec curFilX
        ldx curFilX
        bne B1L07C7
        rts

B1L07C7 lda arrFHDL,X
        sta FHANDLE
        lda arrFAU1,X
        sta FAUX1
        lda arrFAU2,X
        sta FAUX2
        lda arrFAU3,X
        sta FAUX3
        jmp FSEEK

fhdlDst dta b($00)

* open destination for write
openDST lda PASSNUM
        beq B1L0807
        ldx #$01
        jsr syGetFl
        jsr stCFNAM
        lda #$08
        sta FMODE
        lda #$A0
        sta FATR1
        lda #$00
        sta FATR2
        jsr FOPEN
        lda FHANDLE
        sta fhdlDst
        lda #$00
        sta bufWrit+$FF
B1L0807 rts

* close destination
closDst lda PASSNUM
        beq B1L081D
        lda FHANDLE
        pha
        lda fhdlDst
        sta FHANDLE
        jsr wrtFlsh
        jsr FCLOSE
        pla
        sta FHANDLE
B1L081D rts

fhdlTMP dta b($00)

bufWriV dta v(bufWrit)

* flusch write buffer
wrtFlsh lda bufWrit+$FF
        beq wrtFlsE
        sta FAUX4
        lda #$00
        sta FAUX5
        sta SYSCALL
        sta bufWrit+$FF
        lda bufWriV
        sta FAUX1
        lda bufWriV+1
        sta FAUX2
        jsr FWRITE
wrtFlsE rts

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
        lda PROGCNT
        iny
        sta ($92),Y
        lda PROGCNT+1
        iny
        sta ($92),Y
        lda B1L1D65
        and #$70
        bne B1L0867
        ldy #$02
        sec
        lda PROGCNT
        sbc B1L1D66
        sta ($92),Y
        lda PROGCNT+1
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
* save and check high mem
        lda $92
        sta MEMHIGH
        cmp MEMMAX
        lda $93
        sta MEMHIGH+1
        sbc MEMMAX+1
        bcc B1L0890
* ERROR: Out of memory
        lda #$9E
        jmp jmpFAIL
B1L0890 lda B1L09AE
        jsr outByte
        lda B1L09AF
outByte inc PROGCNT
        bne B1L089F
        inc PROGCNT+1
B1L089F pha
        lda PASSNUM
        beq B1L08C0
        lda errFlag
        bne B1L08C0
        lda FHANDLE
        sta fhdlTMP
        lda fhdlDst
        sta FHANDLE
        pla
        pha
*        jsr FPUTC
* use buffer for performance
        stx wrtSavX+1
        sty wrtSavy+1
        ldx bufWrit+$FF
        sta bufWrit,X
        inx
        stx bufWrit+$FF
        cpx #$FF
        bne *+5
        jsr wrtFlsh
wrtSavX ldx #$00
wrtSavY ldy #$00
        lda fhdlTMP
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
        cpy curLiLn
        beq B1L08F6
B1L08ED lda (PCURLIN),Y
        cmp #$20
        bne B1L08F7
        iny
        bne B1L08ED
B1L08F6 rts
B1L08F7 ldx #$00
B1L08F9 lda (PCURLIN),Y
        jsr B1L0940
        sta bfCLINE,X
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
        ldy curLiLn
B1L092C dex
        stx BFCFNAL
        stx $83
        lda #$9B
        sta bfCFNAM,X
        sta bfCLINE,X
        sty B1L08D3
        dey
        rts

B1L093E dta b($00)
B1L093F dta b($00)

* check ' and "
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

B1L096A lda bfCLINE,X
        cmp #$27
        beq B1L097A
        cmp #$22
        beq B1L097A
* ERROR: String error
B1L0975 lda #$05
        jmp prErrMs
B1L097A sta B1L0969
        ldy #$00
B1L097F inx
        cpx $83
        bcs B1L0975
        lda bfCLINE,X
        cmp B1L0969
        bne B1L09A1
        inx
        lda bfCLINE,X
        cmp B1L0969
        beq B1L09A1
        lda #$9B
        sta bfCFNAM,Y
        sty BFCFNAL
        tya
        beq B1L0975
        clc
        rts
B1L09A1 sta bfCFNAM,Y
        iny
        bne B1L097F
