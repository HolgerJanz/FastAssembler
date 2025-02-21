INISTRT lda BW_SPARTA
        cmp #'S'
        bne INIERR
        lda BW_DOS
        cmp #'B'
        bne INIERR
        lda BW_DOS+1
        cmp #'W'
        bne INIERR
        lda BW_VERS
        cmp #$14
        bcc INIERR
        lda RAMSIZ
        cmp #$80
        bcc INIERR
        rts

INIERR  lda #$0B
        sta $342
        lda <INIERRT
        sta $344
        lda >INIERRT
        sta $345
        lda <INIERRE-INIERRT
        sta $348
        ldx #$00
        stx $349
        jsr $E456
        jmp ($000A)
INIERRT dta B($9B,$FD)
        dta C'Requires at least BW-DOS 1.4 and 32k'
        dta B($9B)
INIERRE equ *
