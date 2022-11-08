* SDX: PRINTF, TOUPPER,PUTC, PUTS, GETC, GETS
* requires SDXFAIL

*****************************************************************
* PRINTF
* %% – print single %-character
* %c – print character from specified address
* %s – print string from specified address
* %p – ditto, just address of string pointer is given instead
* %[2,4,6,8]x – print value from specified address as 16-bit hex number
* %[1..8]b – print value from specified address as 8-bit dec number
* %[1..8]d – print value from specified address as 16-bit dec number
* %[1..8]e – print value from specified address as 24-bit dec number
* no supported %l – ditto, 32-bit value (as of SDX 4.40)
PRINTF      sta _prtf_reg_A
            stx _prtf_reg_X
            sty _prtf_reg_Y
* reset opt flag
            lda #$00
            sta _opt_flg
* set start address
            pla
            sta _prt_adr+1
            sta _end_adr+1
            pla
            sta _prt_adr+2
            sta _end_adr+2
* calc parameter address
_end_loop   inc _end_adr+1
            bne _end_adr
            inc _end_adr+2
_end_adr    lda $FFFF
            bne _end_loop
* set parameter address
            lda _end_adr+1
            sta _opt_adr+1
            lda _end_adr+2
            sta _opt_adr+2
* print loop
_prt_loop   inc _prt_adr+1
            bne _prt_adr
            inc _prt_adr+2
_prt_adr    lda $FFFF
            beq _prt_end
* check parameter option
            lsr _opt_flg
            bcc _prt_nopt
            jsr _chk_opt
            bcc _prt_loop
            bcs _prt_putc
_prt_nopt   cmp #'%'
            bne _prt_putc
            sec
            rol _opt_flg
            lda #$00
            sta _opt_len
            bcc _prt_loop
* print char
_prt_putc   jsr _putc
            jmp _prt_loop
* end 
_prt_end    lda _opt_adr+2
            pha
            lda _opt_adr+1
            pha
* restore register
            lda _prtf_reg_A
            ldx _prtf_reg_X
            ldy _prtf_reg_Y
            rts

_prtf_reg_A      dta b($00)
_prtf_reg_X      dta b($00)
_prtf_reg_Y      dta b($00)

* get parameter byte
_get_par    inc _opt_adr+1
            bne _opt_adr
            inc _opt_adr+2
_opt_adr    lda $FFFF
            rts

_BW_DECIN   equ $720
_BW_DECOUT  equ $713
_BW_CONVDC  equ $70A
_convdc     jmp (_BW_CONVDC)

_opt_flg    dta b($00)
_opt_len    dta b($00)
_opt_reg_X  dta b($00)
* check for parameter option
* carry 0-next 1-putc
_chk_opt    cmp #'1'
            bcc _chk_opt_st
            cmp #'9'
            bcs _chk_opt_st
            and #$0F
_chk_set_ln sta _opt_len
            sec
            rol _opt_flg
            rts
* option %*...
_chk_opt_st cmp #'*'
            bne _chk_opt_b
            jsr _get_par
            sta _chk_st_adr+1
            jsr _get_par
            sta _chk_st_adr+2
_chk_st_adr lda $FFFF
            jmp _chk_set_ln
* option %b
_chk_opt_b  cmp #'b'
            bne _chk_opt_d
            ldx #$00
            jmp _chk_optdec
* option %d
_chk_opt_d  cmp #'d'
            bne _chk_opt_e
            ldx #$01
            jmp _chk_optdec
* option %e
_chk_opt_e  cmp #'e'
            bne _chk_opt_c
            ldx #$02
_chk_optdec lda #$00
            sta _BW_DECIN
            sta _BW_DECIN+1
            sta _BW_DECIN+2
            jsr _get_par
            sta _chk_d_adr+1
            jsr _get_par
            sta _chk_d_adr+2
_chk_d_adr  lda $FFFF,X
            sta _BW_DECIN,X
            dex
            bpl _chk_d_adr
            jsr _convdc
            lda #$08
            sec
            sbc _opt_len
            sta _opt_len
            ldx #$00
_chk_d_out  lda _BW_DECOUT,X
            cmp #' '
            bne _chk_d_putc
            cpx _opt_len
            bcc _chk_d_onxt
_chk_d_putc jsr PUTC
_chk_d_onxt inx
            cpx #$08
            bcc _chk_d_out
            jmp _chk_x_end
* option %c
_chk_opt_c  cmp #'c'
            bne _chk_opt_s
            jsr _get_par
            sta _chk_c_adr+1
            jsr _get_par
            sta _chk_c_adr+2
_chk_c_adr  lda $FFFF
            jsr _putc
            jmp _chk_x_end
* option %s
_chk_opt_s  cmp #'s'
            bne _chk_opt_p
            jsr _get_par
            sta _chk_s_adr+1
            jsr _get_par
            sta _chk_s_adr+2
_chk_s_adr  lda $FFFF
            cmp #$9b
            beq _chk_x_end
            jsr _putc
            dec _opt_len
            beq _chk_x_end
            inc _chk_s_adr+1
            bne _chk_s_adr
            inc _chk_s_adr+2
            jmp _chk_s_adr
* option %p
_chk_opt_p  cmp #'p'
            bne _chk_opt_x
            jsr _get_par
            sta _chk_p_adr+1
            jsr _get_par
            sta _chk_p_adr+2
            ldx #$01
_chk_p_adr  lda $FFFF,X
            sta _chk_s_adr+1,X
            dex
            bpl _chk_p_adr
            jmp _chk_s_adr
* option %x
_chk_opt_x  cmp #'x'
            bne _chk_optend
            jsr _get_par
            sta _chk_x_adr+1
            jsr _get_par
            sta _chk_x_adr+2
* calc digits, only 8, 6, 4, or 2 excepted
            lda _opt_len
            bne _chk_x_len
            lda #$04
_chk_x_len  lsr @
            tax
            dex
_chk_x_loop stx _opt_reg_X
_chk_x_adr  lda $FFFF,X
            jsr _convh2a
            txa
            jsr PUTC
            tya
            jsr PUTC
            ldx _opt_reg_X
            dex
            bpl _chk_x_loop
_chk_x_end  lda #$00
            sta _opt_len
            clc
            rts
* end
_chk_optend sec
            rts

* convert hex to atascii
*   hex A -> atascii X,Y
_convh2a    pha
            lsr @
            lsr @
            lsr @
            lsr @
            sed
            clc
            adc #$90
            adc #$40
            tax
            pla
            and #$0f
            clc
            adc #$90
            adc #$40
            tay
            cld
            rts

***************************************************
* TOUPPER
TOUPPER     cmp #'a'
            bcc _toupper_e
            cmp #'z'+1
            bcs _toupper_e
            and #$DF
_toupper_e  rts

***************************************************
* PUTC put char to console
PUTC        jsr _save_reg
            jsr _putc
            jsr _rest_reg
            rts

***************************************************
* PUTS put string to console
PUTS        jsr _save_reg
            jsr _puts
            jsr _rest_reg
            rts

_putc       tay
            lda #$00
            tax
            sta $340+$08
            sta $340+$09
            lda #$0B
            sta $340+$02
            tya
            jmp _put_cio

_puts       sta $340+$04
            stx $340+$05
            tya
            sta $340+$08
            lda #$00
            tax
            sta $340+$09
            lda #$09
            sta $340+$02
_put_cio    jsr $E456
            bpl _put_cio_e
            jmp _fail
_put_cio_e  rts

***************************************************
* GETC put char to console
GETC        lda #$00
            tax
            sta $340+$08
            sta $340+$09
            lda #$07
            sta $340+$02
_getc_cio   jsr $E456
            bpl _getc_ciook
            cpy #$88
            beq _getc_cioef
            jmp _fail
_getc_cioef ldx #$FF
            rts
_getc_ciook ldx #$00
            rts

***************************************************
* GETS put string to console
GETS        sta $340+$04
            stx $340+$05
            tya
            sta $340+$08
            lda #$00
            tax
            sta $340+$09
            lda #$05
            sta $340+$02
_gets_cio   jsr $E456
            bpl _gets_ciook
            cpy #$89
            beq _gets_ciotr
            cpy #$88
            beq _gets_cioef
            jmp _fail
_gets_cioef ldy $340+$08
            lda #$FF
            rts
_gets_ciotr ldy $340+$08
            lda #$FF
            ldx $00
            rts
_gets_ciook ldy $340+$08
            lda #$00
            rts
