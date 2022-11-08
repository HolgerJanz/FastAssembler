* SDX: MUL_32, DIV_32
* requires SDXCOMTA

* local intermediate variables
intm_1  dta b($00,$00,$00,$00)
intm_2  dta b($00,$00,$00,$00)
intm_3  dta b($00,$00,$00,$00)
carry_1 dta b($00)
carry_2 dta b($00)

********************************************
* multiplication 32bit big endian with carry
MUL_32  ldx #$07
* copy input to intermediate
mul_get lda COMTAB+CT_VAR32_1,X
        sta intm_1,X
        dex
        bpl mul_get
* clear result
        ldx #$03
        lda #$00
        sta carry_1
        sta carry_2
mul_clr sta COMTAB+CT_VAR32_3,X
        dex
        bpl mul_clr
* loop over 32bit
        ldx #$20
* shift operand 2 to right
mul_nxt lsr intm_2
        ror intm_2+1
        ror intm_2+2
        ror intm_2+3
        bcc mul_nad
* add if bit set
        lda carry_1
        ora carry_2
        sta carry_2
        clc
        ldy #$03
mul_add lda intm_1,Y
        adc COMTAB+CT_VAR32_3,Y
        sta COMTAB+CT_VAR32_3,Y
        dey
        bpl mul_add
        bcc mul_nad
        rol carry_2
* shift operand 2 to left
mul_nad asl intm_1+3
        rol intm_1+2
        rol intm_1+1
        rol intm_1
        bcc mul_ncr
        rol carry_1
* next
mul_ncr dex
        bne mul_nxt
        ror carry_2
        rts

*************************************
* divison 32bit big endian with carry
DIV_32  ldx #$03
* get var1
div_ge1 lda COMTAB+CT_VAR32_1,X
        sta intm_1,X
        dex
        bpl div_ge1
* clear result
        ldx #$03
        lda #$00
        sta carry_1
div_clr sta COMTAB+CT_VAR32_3,X
        dex
        bpl div_clr
* check division by zero
        ldx #$03
div_0   lda COMTAB+CT_VAR32_2,X
        ora carry_1
        sta carry_1
        dex
        bpl div_0
        cmp #$00
        bne div_lop
        sec
        jmp div_end
* get var2
div_lop ldx #$03
div_ge2 lda COMTAB+CT_VAR32_2,X
        sta intm_2,X
        dex
        bpl div_ge2
* check intm_2 greater intm_1
        ldx #$00
div_nxt lda intm_1,x
        cmp intm_2,x
        bcc div_ecc
        bne div_cnt
        inx
        cpx #$04
        bne div_nxt
* set intm_3 to 1
div_cnt ldx #$00
        stx intm_3
        stx intm_3+1
        stx intm_3+2
        inx
        stx intm_3+3
* shift intm_2 left
div_cn2 asl intm_2+3
        rol intm_2+2
        rol intm_2+1
        rol intm_2
        bcs  div_add
* check intm_2 still greater than intm_1
        ldx #$00
div_nx2 lda intm_1,x
        cmp intm_2,x
        bcc div_add
        inx
        cpx #$04
        bne div_nx2
* shift intm_3 left
        asl intm_3+3
        rol intm_3+2
        rol intm_3+1
        rol intm_3
        jmp div_cn2
* shift intm_2 back right once
div_add ror intm_2
        ror intm_2+1
        ror intm_2+2
        ror intm_2+3
* subtract intrm_2 from intrm_1
        sec
        ldx #$03
div_sbl lda intm_1,X
        sbc intm_2,X
        sta intm_1,X
        dex
        bpl div_sbl
* add intm_3 to result
        clc
        ldx #$03
div_adl lda intm_3,X
        adc COMTAB+CT_VAR32_3,X
        sta COMTAB+CT_VAR32_3,X
        dex
        bpl div_adl
* next
        jmp div_lop
* end div
div_ecc clc
div_end rts
