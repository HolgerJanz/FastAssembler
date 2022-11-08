* SDX: U_FAIL, U_SFAIL, U_XFAIL, STATUS

CHKBW14  lda $700
         cmp #'S'
         bne _chkbwe
         lda $703
         cmp #'B'
         bne _chkbwe
         lda $704
         cmp #'W'
         bne _chkbwe
         lda $705
         cmp #$14
         bcc _chkbwe
         rts

_txtnobw dta b($9B,$FD)
         dta c'Error: no BW-DOS 1.4'
         dta b($9B)
_chkbwe  lda <_txtnobw
         sta $340+$04
         lda >_txtnobw
         sta $340+$05
         lda #_chkbwe-_txtnobw
         sta $340+$08
         lda #$00
         tax
         sta $340+$09
         lda #$0B
         sta $340+$02
         jsr $E456
         jmp ($000A)

_fail       tya
***************************************************
* U_FAIL error handling
U_FAIL      sta STATUS
            lda _u_fail+1
            and _u_fail+2
            cmp #$FF
            beq _u_fail_end
            lda STATUS
            ldx #$01
            stx STATUS
_u_fail     jsr $FFFF
_u_fail_end lda STATUS
            bpl _u_fail_no
            jmp ($70F) ; jump to BW_FAIL
_u_fail_no  jmp $726   ; jump to BW_COMTAB

***************************************************
* U_SFAIL set error handler
U_SFAIL     sta _u_fail+1
            stx _u_fail+2
            pha
            jsr CHKBW14
            pla
            rts

***************************************************
* U_FAIL remove error handler
U_XFAIL     lda #$FF
            sta _u_fail+1
            sta _u_fail+2
            rts

***************************************************
* STATUS return status
STATUS      dta b($00)

_reg_A   dta b($00)
_reg_X   dta b($00)
_reg_Y   dta b($00)
_save_reg   sta _reg_A
            stx _reg_X
            sty _reg_Y
            rts
_rest_reg   lda _reg_A
            ldx _reg_X
            ldy _reg_Y
            rts
