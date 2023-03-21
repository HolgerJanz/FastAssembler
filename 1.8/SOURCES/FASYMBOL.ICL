* Part 6  Symbols

syCode1 dta c'ES'
syCode2 dta c'QM'
syCode3 dta c'UB'
syCodeV dta v(equCode),v(smbCode)

prsSymb lda BFCFNAL
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

* find . or $9b (>,:) in file name
* -> offset in Y
findDot ldy BFCFNAL
nxtDot  dey
        lda bfCFNAM,Y
        cmp #'.'
        bne noDot
        clc
        bcc dotFnt
noDot   cmp #'>'
        beq dotNfnd
        cmp #':'
        beq dotNfnd
        cpy #$00
        bne nxtDot
dotNfnd ldy BFCFNAL
dotFnt  rts

dfltExt dta c'.ASM'
        dta b($9B)
        dta c'.OBJ'
        dta b($9B)
        dta c'.SYM'
        dta b($9B)
dfltIdx dta b($00,$05,$0A,$0F)

* set default ext
* src X=0, obj X=1
setDEXT inx
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
        sty BFCFNAL
        rts

fileNum dta b($00)

* add file name to symbol table
* src X=0, obj X=1
syAFile txa
        pha
        jsr findDot
        bcc B1L1ADD
* set missing ext
        jsr setDEXT
B1L1ADD pla
        jsr B1L1B0C
        iny
        lda fileNum
        sta ($84),Y
B1L1AEA iny
        lda BFCFNAL
        sta ($84),Y
        ldx #$00
B1L1AF1 iny
        lda bfCFNAM,X
        sta ($84),Y
        inx
        cpx BFCFNAL
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
        sta MEMHIGH
        cmp MEMMAX 
        lda $8B
        sta $85
        sta MEMHIGH+1
        sbc MEMMAX+1
        bcc B1L1B20
* ERROR: Out of memory
        lda #$9E
        jmp jmpFAIL
B1L1B20 ldy #$01
        txa
        sta ($84),Y
        rts

B1L1B26 ldy MEMMIN
        sty $84
        ldy MEMMIN+1
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

* symbol table get file name
syGetFl txa
        jsr B1L1B26
        bcs B1L1B67
B1L1B59 ldy #$02
        lda ($84),Y
        cmp fileNum
        beq B1L1B68
        jsr B1L1B39
        bcc B1L1B59
B1L1B67 rts

B1L1B68 iny
        lda ($84),Y
        sta BFCFNAL
        ldx #$00
B1L1B6F iny
        lda ($84),Y
        sta bfCFNAM,X
        inx
        cpx BFCFNAL
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

* unresolved symbol
B1L1BF3 inc unResLa
        bne *+5
        inc unResLa+1
        lda #$00
        jmp prErrMs

B1L1C00 jsr B1L1BAA
        lda B1L1BBF
        and #$40
        beq B1L1C0D
        jmp B1L1BED
B1L1C0D rts

B1L1C0E iny
        lda BFCFNAL
        cmp ($84),Y
        bne B1L1C24
        ldx #$00
B1L1C17 iny
        lda bfCFNAM,X
        cmp ($84),Y
        bne B1L1C24
        inx
        cpx BFCFNAL
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
        lda PROGCNT
        sta B1L1C43
        lda PROGCNT+1
        sta B1L1C44
        lda B1L1D65
        and #$70
        bne B1L1C9B
        sec
        lda PROGCNT
        sbc B1L1D66
        sta B1L1C43
        lda PROGCNT+1
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
* check max mem
        lda $92
        cmp MEMMAX
        lda $93
        sbc MEMMAX+1
        bcc *+10
* ERROR: Out of memory
        jsr B1L1Cyy
        lda #$9E
        jmp jmpFAIL
        tya
        iny
        sta ($92),Y
* check and save high mem
        lda $92
        cmp MEMHIGH
        lda $93
        sbc MEMHIGH+1
        bcc *+10
B1L1Cyy lda $92
        sta MEMHIGH
        lda $93
        sta MEMHIGH+1
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
        ldx BFCFNAL
        cpx #$08
        bcs B1L1D38
        lda #$20
B1L1D30 sta bfCFNAM,X
        inx
        cpx #$08
        bcc B1L1D30
B1L1D38 ldx #$08
        stx BFCFNAL
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
