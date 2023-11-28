* Part 4 Operations

* oparation name array
opCode1 dta c'CNBRSPBSPBTTCEBRTOTR'
        dta c'CCCTDSCIBLPDPAASDTBS'
        dta c'SIIABBLBBLCRJJSDL'
opCode2 dta c'LOVTEHRELVSXLOIOXRYO'
        dta c'PLPAEELNMSLEHNSTEACT'
        dta c'BNNDCPDNEDMTMSTTD'
opCode3 dta c'VPCIIPKDPSXSDRTRAAAL'
        dta c'XIYYCCCXIRAYADLXXXSY'
        dta c'CCYCCLYEQXPSPRAAA'

* machine code for operation
opCode  dta b($B8,$EA,$50,$40)
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

* index in parse vector array
prsVidx dta b($08,$08,$06,$08)
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

* mask for restricted adress mode
AMrstr  dta b($00,$00,$00,$00)
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

* array with parse vectors
prsVarr dta v(pv8AM)
        dta v(pvDTA)
        dta v(pvResM)
        dta v(pvBxx)
        dta v(pvNoPa)
        dta v(pvJSR)
        dta v(pvJMP)

B1L11AB dta b($00)

* parse look up operation
prsOprt lda BFCFNAL
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
        ldy prsVidx,X
        lda opCode,X
        sta B1L11AB
        lda prsVarr,Y
        sta B1L11EE+1
        lda prsVarr+1,Y
        sta B1L11EE+2
        lda #$01
B1L11E8 sta B1L1C45
        sta B1L1A55
B1L11EE jsr $FFFF
        clc
B1L11F2 rts

* parse no parameter
pvNoPa  lda B1L11AB
        jmp outByte

* parse branches Bxx
pvBxx   jsr B1L09B2
        bcs B1L11F2
        and #$9F
        beq B1L120A
        lda #$08
        dta b(BIT_abs)
B1L1205 lda #$07
        jmp prErrMs
B1L120A jsr pvNoPa
        lda B1L09AD
        and #$40
        bne B1L1260
        clc
        lda B1L09AE
        sbc PROGCNT
        sta B1L09AE
        lda B1L09AF
        sbc PROGCNT+1
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
B1L1260 jmp outByte

* parse JSR
pvJSR   jsr B1L09B2
        bcc B1L1269
B1L1268 rts
B1L1269 and #$1F
        beq B1L1272
B1L126D lda #$08
        jmp prErrMs
B1L1272 jsr pvNoPa
        jmp B1L081F

* parse JMP
pvJMP   jsr B1L09B2
        bcs B1L1268
        and #$1F
        beq B1L128A
        cmp #$04
        bne B1L126D
        lda #$60
        sta B1L11AB
B1L128A lda B1L11AB
        ora #$0C
        jsr outByte
        jmp B1L081F

B1L1295 dta b($10,$00,$02,$06)
        dta b($05,$20,$22,$21)
        dta b($01)
B1L129E dta b($08,$04,$14,$00)
        dta b($10,$0C,$1C,$18)
        dta b($18)

* parse all 8 address modes
pv8AM  jsr B1L09B2
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
        jsr outByte
B1L12CA cpx #$05
        bcc B1L12D1
        jmp B1L081F
B1L12D1 lda B1L09AE
        jmp outByte
B1L12D7 rts

B1L12D8 dta b($08,$10,$00,$02)
        dta b($01,$20,$22,$21)
B1L12E0 dta b($08,$00,$04,$14)
        dta b($14,$0C,$1C,$1C)
B1L12E8 dta b($20,$80,$40,$04)
        dta b($08,$10,$01,$02)
B1L12F0 dta b($00)

* parse restritced adress modes
pvResM  lda AMrstr,X
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
        jsr outByte
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

* parse DTA
pvDTA   dec B1L1C45
        jsr gettok2
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
        jsr gettok2
        bne B1L134F
B1L1392 rts

B1L1393 lda bfCLINE+1
        cmp #'('
        beq B1L139F
* ERROR: Illegal symbol
        lda #$06
        jmp prErrMs
B1L139F lda #$FF
        sta B1L09AC
        ldy #$02
B1L13A6 lda B1L09AC
        beq B1L134F
        ldx $83
        dex
        lda bfCLINE,X
        cmp #')'
        bne B1L13B9
        inc B1L09AC
        dta b(BIT_zp)
B1L13B9 inx
        txa
        jsr B1L0B29
        bcs B1L1392
        lda B1L09AD
B1L13C3 jsr $FFFF
        jsr gettok2
        beq B1L13CF
        ldy #$00
        beq B1L13A6
B1L13CF lda B1L09AC
        beq B1L1392
* ERROR: Parenthesis not balanced
        lda #$0F
        jmp prErrMs

datByte and #$3C
        bne B1L1400
        ldy #$00
B1L13DF ldx #$00
B1L13E1 lda B1L09AE,X
        jsr outByte
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
        jmp outByte

datHigh and #$1C
        bne B1L1400
        lda B1L09AF
        jmp outByte

datBy4R ldx #$03
B1L1422 lda B1L09AE,X
        jsr outByte
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
B1L1442 jsr outByte
        inx
        cpx BFCFNAL
        bcc B1L1437
        rts

        end
