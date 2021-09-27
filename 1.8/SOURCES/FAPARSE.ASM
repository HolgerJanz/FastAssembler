* Part 3 Parse

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
        cmp #'@'
        beq B1L0A12
        cmp #'#'
        beq B1L0A0F
        cmp #'('
        bne B1L09FF
        dec B1L09AC
        bne B1L0A15
B1L09FF cmp #'<'
        beq B1L0A0A
        cmp #'>'
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
B1L0A27 cmp #','
        beq B1L0A6A
        cmp #')'
        bne B1L09D9
        stx B1L09A8
        inc B1L09AC
        lda B1L09AA
        ora #$04
        sta B1L09AA
        jsr B1L0AF7
        bcs B1L0A5F
        cmp #','
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
        cmp #'Y'
        bne B1L0A80
        jsr B1L0AF7
        bcc B1L0A65
        bcs B1L0A57
B1L0A80 cmp #'X'
        bne B1L0A65
        lda B1L09AA
        ora #$02
        sta B1L09AA
        jsr B1L0AF7
        bcs B1L0AA7
        cmp #')'
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

char_op dta c'-+/*^|&'
vec_op  dta v(op_add)
        dta v(op_add)
        dta v(op_div)
        dta v(op_mul)
        dta v(op_eor)
        dta v(op_or)
        dta v(op_and)

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
        cmp #'['
        bne B1L0B91
        dec B1L0AFE
        jmp B1L0BB5
B1L0B91 cmp #']'
        bne B1L0B9B
        inc B1L0AFE
        jmp B1L0BB5
B1L0B9B ldx B1L0AFE
        bne B1L0BB5
        ldx #$06
B1L0BA2 cmp char_op,X
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
        cmp #']'
        bne B1L0C0E
        ldy bfL1FAC,X
        lda bfL1EAC,Y
        cmp #'['
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
        lda vec_op,X
        sta B1L0C78+1
        lda vec_op+1,X
        sta B1L0C78+2
B1L0C78 jsr $FFFF
B1L0C7B dec $81
        rts

B1L0C7E jsr B1L0C85
        clc
        jmp end_op
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

* operation addition
op_add  lda B1L09AD
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
        jmp end_op

* operation exclusive or
op_eor  lda B1L09AD
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
        jmp end_op

* operation or
op_or  lda B1L09AD
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
        jmp end_op

* operation and
op_and  lda B1L09AD
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
        jmp end_op

B1L0D6E dta b($00)

* operation multiplication
op_mul  jsr B1L0D9E
        jsr MUL_32
B1L0D75 php
        ldx #$03
        ldy #$00
B1L0D79 lda COMTAB+$107,X
        sta B1L09AE,Y
        iny
        dex
        bpl B1L0D79
        plp
        bcs B1L0D91
        lda B1L0D6E
        bpl B1L0D8F
        jsr B1L0C85
B1L0D8F clc
B1L0D91 jmp end_op

* operation division
op_div  jsr B1L0D9E
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
        cmp #'"'
        bne B1L0E21
B1L0E1E jmp B1L0E7A
B1L0E21 cmp #'!'
        bne B1L0E28
        jmp B1L0EA2
B1L0E28 cmp #'$'
        bne B1L0E2F
        jmp B1L0EBA
B1L0E2F cmp #'%'
        bne B1L0E36
        jmp B1L0EF9
B1L0E36 cmp #'0'
        bcc B1L0E41
        cmp #':'
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
        jmp end_op

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
        jmp end_op
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

* end operation, carry=overflow
end_op  bcc B1L0FA6
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
