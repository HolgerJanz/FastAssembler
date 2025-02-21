* SDX: U_GETPAR, U_GETART, U_GETNUM, U_SLASH
* requires SDXCOMTA, SDXFAIL

_par_open dta b($00)
_drv_set  dta b($00)

_crname   jsr CHKBW14
          jsr $729 ; BW_CRNAME
          php
          lda _drv_set
          bne _crname_e
* set default drive
          lda $747+1 ; CONFNAM+1 = drive number
          sta _file_p+1
          sta _drv_set
_crname_e plp
          rts

***************************************
* U_GETPAR
U_GETPAR  lda _par_open
          bne _gp_strt
          jsr _crname
          beq _getpar_e
_gp_strt  php
          ldx #$FF
_gp_nxt   inx
          lda $747,X ; BW_CONFNAM
          sta COMTAB+CT_COMFNAM,X
          cmp #$9b
          bne _gp_nxt
          stx COMTAB+CT_TRAILS
          lda #$00
          sta _par_open
          lda <COMTAB+CT_COMFNAM
          sta FILE_P
          lda >COMTAB+CT_COMFNAM+1
          sta FILE_P+1
          plp
_getpar_e rts

***************************************
* U_GETATR
U_GETATR  jmp U_GETPAR

***************************************
* U_GETNUM
U_GETNUM  lda _par_open
          bne _gn_strt
          jsr _crname
          beq _gn_e
_gn_strt  lda #$ff
          sta _par_open
* check for number
          ldy #$00
          sty _num_buf
          sty _num_buf+1
_gn_nxt   lda $747+3,Y ; BW_COMFNAM+3
          cmp #$9b
          beq _gn_en
          jsr _chknum
          bcc _gn_e
* 10 times and add new digit
          lda _num_buf
          sta _num_buf2
          lda _num_buf+1
          sta _num_buf2+1
* 2 times
          asl _num_buf
          rol _num_buf+1
          bcs _gn_e
* 8 times
          ldx #$03
_nxt_d    asl _num_buf2
          rol _num_buf2+1
          bcs _gn_e
          dex
          bne _nxt_d
* 2 + 8 times = 10 times
          clc
          lda _num_buf
          adc _num_buf2
          sta _num_buf
          lda _num_buf+1
          adc _num_buf2+1
          sta _num_buf+1
          bcs _gn_e
* add new digit
          lda $747+3,Y
          and #$0f
          clc
          adc _num_buf
          sta _num_buf
          lda _num_buf+1
          adc #$00
          sta _num_buf+1
          bcs _gn_e
          iny
          jmp _gn_nxt
* number found
_gn_en    lda #$00
          sta _par_open
          lda _num_buf
          ldx _num_buf+1
          ldy #$01
          rts
* no number or too big
_gn_e     lda #$00
          tay
          tax
          rts

_num_buf  dta b($00,$00)
_num_buf2 dta b($00,$00)

_chknum   cmp #'0'
          bcc _chknum_e
          cmp #'9'+1
          bcs _chknum_c
          sec
          rts
_chknum_c clc
_chknum_e rts

***************************************
* U_SLASH
U_SLASH   sta _us_clr_n+1
          sta _us_src_a+1
          sta _us_src_s+1
          stx _us_clr_n+2
          stx _us_src_a+2
          stx _us_src_s+2
          sty _us_clr_c+1
          sty _us_src_c+1
* clear options
          lda #$00
          sta _us_opt
          sta _us_opt_f
          tax
_us_clr_n sta $ffff,X
          inx
          inx
_us_clr_c cpx #$ff
          bne _us_clr_n
* check for parameter
          lda _par_open
          bne _us_strt
_us_nxt_o jsr _crname
          beq _us_e
          lda #$ff
          sta _par_open
_us_strt  lda $747+3 ; BW_COMFNAM+3
          cmp #'/'
          bne _us_e
          lda #$00
          sta _par_open
* search option
          ldx #$00
_us_src_o inx
          lda $747+3,X ; BW_COMFNAM+3
          cmp #$9b
          beq _us_nxt_o
          sta _us_opt
          ldy #$FF
_us_src_n iny
          iny
_us_src_c cpy #$ff
          bcs _us_fail
_us_src_a lda $ffff,Y
          cmp _us_opt 
          bne _us_src_n
          sta _us_opt_f
          dey
          lda #$FF
_us_src_s sta $ffff,Y
          jmp _us_src_o
* finished
_us_fail  lda #$9C ; Bad parameter
          jmp U_FAIL
_us_e     lda _us_opt_f
          rts

_us_opt   dta b($00)
_us_opt_f dta b($00)

