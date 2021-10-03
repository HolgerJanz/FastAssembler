* Part 2 Passes

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
B1L076D ldx V1L0096
        beq B1L07A0
        clc
        lda $90
        adc B1L0630
        sta B1L062E
        lda $91
        adc #$00
        sta B1L062E+1
        jsr B1L073C
        ldx V1L0096
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
        inc V1L0096
        jsr initBuf
        jmp FOPEN

B1L07BB jsr FCLOSE
        dec V1L0096
        ldx V1L0096
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
