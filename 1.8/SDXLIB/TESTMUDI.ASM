* Test MUL/DIV_32 SDX vs OWN

PRINTF  smb 'PRINTF'
GETS    smb 'GETS'
_MUL_32 smb 'MUL_32'
_DIV_32 smb 'DIV_32'

COMTAB     smb 'COMTAB'
CT_VAR32_1 equ $FF
CT_VAR32_2 equ $103
CT_VAR32_3 equ $107

        blk sparta $3000

start   jsr PRINTF
        dta c'Input two hex numbers a 11223344:',b($9b,$00)

        lda <input1
        ldx >input1
        ldy #$09
        jsr GETS
        bmi start
        cpy #$09
        beq *+3
        rts

        ldx #$00
        ldy #$00
next_i1 lda input1,X
        sta conva2h_inp
        inx
        lda input1,X
        sta conva2h_inp+1
        inx
        jsr conva2h
        sta op1,Y
        iny
        cpy #$04
        bne next_i1

        lda <input2
        ldx >input2
        ldy #$09
        jsr GETS
        bmi start
        cpy #$09
        beq *+3
        rts

        ldx #$00
        ldy #$00
next_i2 lda input2,X
        sta conva2h_inp
        inx
        lda input2,X
        sta conva2h_inp+1
        inx
        jsr conva2h
        sta op2,Y
        iny
        cpy #$04
        bne next_i2

        jsr PRINTF
        dta c'op1=%2x%2x%2x%2x op2=%2x%2x%2x%2x'
        dta b($9b,$00)
        dta a(op1,op1+1,op1+2,op1+3)
        dta a(op2,op2+1,op2+2,op2+3)

        jsr op2var
        jsr _MUL_32
        jsr var2mx

        jsr op2var
        jsr _DIV_32
        jsr var2dx

        jsr PRINTF
        dta c'SDX MUL=%2x%2x%2x%2x_%2x DIV=%2x%2x%2x%2x_%2x'
        dta b($9b,$00)
        dta a(mulx,mulx+1,mulx+2,mulx+3,mulx+4)
        dta a(divx,divx+1,divx+2,divx+3,divx+4)

        jsr op2var
        jsr MUL_32
        jsr var2mx

        jsr op2var
        jsr DIV_32
        jsr var2dx

        jsr PRINTF
        dta c'OWN MUL=%2x%2x%2x%2x_%2x DIV=%2x%2x%2x%2x_%2x'
        dta b($9b,$9b,$00)
        dta a(mulx,mulx+1,mulx+2,mulx+3,mulx+4)
        dta a(divx,divx+1,divx+2,divx+3,divx+4)

        jmp start

input1  dta c'         '
input2  dta c'         '

op1     dta b($00,$00,$00,$00)
op2     dta b($00,$00,$00,$00)

mulx    dta b($00,$00,$00,$00,$00)
divx    dta b($00,$00,$00,$00,$00)

op2var  ldx #$07
op2varn lda op1,X
        sta COMTAB+CT_VAR32_1,X
        dex
        bpl op2varn
        rts

var2mx  lda #$00
        rol @
        sta mulx+4
        ldx #$03
var2mxn lda COMTAB+CT_VAR32_3,X
        sta mulx,X
        dex
        bpl var2mxn
        rts

var2dx  lda #$00
        rol @
        sta divx+4
        ldx #$03
var2dxn lda COMTAB+CT_VAR32_3,X
        sta divx,X
        dex
        bpl var2dxn
        rts

********************************************
* convert atascii to hex
*   atascii conva2h_inp -> hex A
conva2h_inp dta b($00,$00)
conva2h     lda conva2h_inp
            jsr conva2h_h
            asl @
            asl @
            asl @
            asl @
            sta conva2h_o+1
            lda conva2h_inp+1
            jsr conva2h_h
conva2h_o   ora #$00
            rts

conva2h_h   sec
            sbc #'0'
            cmp #$0A
            bcc conva2h_hl
            clc
            adc #$09
conva2h_hl  and #$0F
            rts

        icl 'SDXARITH.ICL'

        blk update symbols

        end
