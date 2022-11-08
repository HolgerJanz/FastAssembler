* SDX: FHANDLE..., FOPEN, FCLOSE, FCLOSEAL, FREAD, FWRITE, FPUTC, FGETC, FTELL, FSEEK, FILELENG
* requires SDXCOMTA, SDXFAIL

FHANDLE   dta b($00)
FMODE     dta b($00)
FATR1     dta b($00)
FATR2     dta b($00)
FAUX1     dta b($00)
FAUX2     dta b($00)
FAUX3     dta b($00)
FAUX4     dta b($00)
FAUX5     dta b($00)
SYSCALL   dta b($00)

_fhandles dta b($10,$00)
          dta b($20,$00)
          dta b($30,$00)
          dta b($60,$00)
          dta b($70,$00)
          dta b($00,$00)

***************************************************
* FOPEN
FOPEN     lda _file_p+1
          bne _fop_strt
* set default drive
          lda $747+1 ; CONFNAM+1 = drive number
          sta _file_p+1
* find free IOCB
_fop_strt ldy #$00
_fop_nxt  ldx _fhandles,Y
          beq _fop_tm
          lda _fhandles+1,Y
          beq _fop_do
          iny
          iny
          jmp _fop_nxt
* too many files open
_fop_tm   lda #$A1
          jmp U_FAIL
* open
_fop_do   lda #$ff
          sta _fhandles+1,Y
          stx FHANDLE
          lda FMODE
          sta $340+$a,X
          lda FILE_P
          sta $340+4,X
          sta _fop_cd+1
          sta _fop_ca+1
          lda FILE_P+1
          sta $340+5,X
          sta _fop_cd+2
          sta _fop_ca+2
* check file name for D: or Dx:
          ldy #$01
_fop_cd   lda $FFFF,Y
          cmp #':'
          beq _fop_ok
          iny
          cpy #$03
          bne _fop_cd
* D: or Dx: missing => copy and add
          ldy #$00
_fop_ca   lda $FFFF,Y
          sta _file_pn,Y
          cmp #$9b
          beq _fop_sf
          iny
          cpy #$18
          bne _fop_ca
* set to file pointer buffer
_fop_sf   lda <_file_p
          sta $340+4,X
          lda >_file_p
          sta $340+5,X
* call CIO open
_fop_ok   lda #$03
          jmp _f_cio

***************************************************
* FCLOSE
FCLOSE    ldx #$00
* search handle
_fcls_nxt lda _fhandles,X
          beq _fcls_nf
          cmp FHANDLE
          beq _fcls_do
          inx
          inx
          jmp _fcls_nxt
* invalid IOCB number
_fcls_nf  lda #$86
          jmp U_FAIL
* close
_fcls_do  lda #$00
          sta _fhandles+1,X
          ldx FHANDLE
          lda #$0C
          sta $340+$02,X

_f_cio    sta $340+$02,X
          jsr $E456
          bpl _fcio_e
          jmp _fail
_fcio_e   rts

***************************************************
* FCLOSEAL
FCLOSEAL  ldx #$00
* search handle
_fcla_nxt lda _fhandles,X
          tay
          beq _fcla_end
          lda _fhandles+1,X
          beq _fcla_inx 
          sty FHANDLE
          txa
          pha
          jsr _fcls_do
          pla
          tax
_fcla_inx inx
          inx
          jmp _fcla_nxt
_fcla_end rts

***************************************************
* FGETC
FGETC     ldx FHANDLE
          lda #$00
          sta $340+$08,X
          sta $340+$09,X
          lda #$07
          sta $340+$02,X
          jsr $E456
          bpl _fgc_end
          cpy #$88
          beq _fgc_mend
          jmp _fail
_fgc_mend lda #$9b
          ldx #$FF
_fgc_end  rts

***************************************************
* FPUTC
FPUTC     jsr _save_reg
          ldx FHANDLE
          lda #$00
          sta $340+$08,X
          sta $340+$09,X
          lda #$0B
          sta $340+$02,X
          lda _reg_A
          jsr $E456
          bpl _fpc_end
          jmp _fail
_fpc_end  jsr _rest_reg
          rts

***************************************************
* FREAD
FREAD     jsr _f_adr_ln
          lda #$07
          sta $340+$02,X
          jsr $E456
          bpl _fr_end
          php
          cpy #$88
          beq _fr_mend
          plp
          jmp _fail
_fr_mend  ldx FHANDLE
          lda $340+$08,X
          sta FAUX4
          lda $340+$09,X
          sta FAUX5
          plp
_fr_end   rts

***************************************************
* FWRITE
FWRITE    jsr _f_adr_ln
          lda #$0B
          jmp _f_cio

_f_adr_ln ldx FHANDLE
          lda FAUX1
          sta $340+$04,X
          lda FAUX2
          sta $340+$05,X
          lda FAUX4
          sta $340+$08,X
          lda FAUX5
          sta $340+$09,X
          rts

***************************************************
* FTELL
FTELL     lda #$26
_cio_tl   ldx FHANDLE
          jsr _f_cio
          ldx FHANDLE
          lda $340+$0c,X
          sta FAUX1
          lda $340+$0d,X
          sta FAUX2
          lda $340+$0e,X
          sta FAUX3
          rts

***************************************************
* FILELENG
FILELENG  lda #$27
          jmp _cio_tl

***************************************************
* FSEEK
FSEEK     ldx FHANDLE
          lda FAUX1
          sta $340+$0c,X
          lda FAUX2
          sta $340+$0d,X
          lda FAUX3
          sta $340+$0e,X
          lda #$25
          jmp _f_cio
