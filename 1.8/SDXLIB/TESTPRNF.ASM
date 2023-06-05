* PRINTF Test
            blk dos $3000

            lda <test_trap
            ldx >test_trap
            jsr U_SFAIL

            jsr PRINTF
            dta c'Test start',b($9b,$00)

            ldx #$00
next_char   lda #$1B ; ESC
            jsr PUTC
            txa
            jsr PUTC
            sta val_a
            stx val_x
            sty val_Y
            tay
            lda #$1B ; ESC
            jsr PUTC
            tya
            jsr TOUPPER
            jsr PUTC
            jsr PRINTF
            dta c' A=$%2x X=$%2x Y=$%2x',b($9b,$00)
            dta a(val_a)
            dta a(val_x)
            dta a(val_y)
            inx
            bne next_char
            lda #$9b
            jsr PUTC

            lda #$2E
            sta val_a
            ldx #$3D
            stx val_x
            ldy #$4C
            sty val_y
            jsr PRINTF
            dta c'A=$%2x X=$%2x Y=$%2x',b($9b,$00)
            dta a(val_a)
            dta a(val_x)
            dta a(val_y)

            jsr PRINTF
            dta c'one percent "%" two percent "%%"',b($9b,$00)

            jsr PRINTF
            dta c'hex $ABCD=$%x $1234=$%x hex',b($9b,$00)
            dta a(hex_val1)
            dta a(hex_val2)

            jsr PRINTF
            dta c'hex $CD=$%2x $34=$%2x hex',b($9b,$00)
            dta a(hex_val1)
            dta a(hex_val2)

            jsr PRINTF
            dta c'hex %%2x=$%2x %%4x=$%4x %%8x=$%8x',b($9b,$00)
            dta a(hex_val3)
            dta a(hex_val3)
            dta a(hex_val3)

            jsr PRINTF
            dta c'char %%c=%c %%s=%s %%p=%p',b($9b,$00)
            dta a(char_val1)
            dta a(char_val2)
            dta a(char_val3)

            jsr PRINTF
            dta c'char %%*s=%*s %%*p=%*p',b($9b,$00)
            dta a(char_len2)
            dta a(char_val2)
            dta a(char_len3)
            dta a(char_val3)

            jsr PRINTF
            dta c'dec 123=%b 42567=%d',b($9b),c'dec 16123321=%e',b($9b,$00)
            dta a(dec_val1)
            dta a(dec_val2)
            dta a(dec_val3)

            jsr PRINTF
            dta c'dec %%1e="%1e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%2e="%2e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%3e="%3e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%4e="%4e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%5e="%5e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%6e="%6e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%7e="%7e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%8e="%8e"',b($9b,$00)
            dta a(dec_val4)

            jsr PRINTF
            dta c'dec %%1e="%1e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'dec %%2e="%2e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'dec %%3e="%3e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'dec %%4e="%4e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'dec %%5e="%5e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'dec %%6e="%6e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'dec %%7e="%7e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'dec %%8e="%8e"',b($9b,$00)
            dta a(dec_val5)

            jsr PRINTF
            dta c'errors %%9x %%0x %%3q %%445680x %%44557g"',b($9b)
            dta c'errors %9x %0x %3q %445680x %44557g"',b($9b,$00)

            sta val_a
            stx val_x
            sty val_y
            jsr PRINTF
            dta c'A=$%2x X=$%2x Y=$%2x',b($9b,$00)
            dta a(val_a)
            dta a(val_x)
            dta a(val_y)

            lda <char_val2
            ldx >char_val2
            ldy #$FF
            jsr PUTS
            ldy #$03
            jsr PUTS

            jsr PRINTF
            dta c'Test end',b($9b,$00)

            jsr PRINTF
            dta c'Test GETC',b($9b,$00)

nxt_getc    jsr GETC
            bmi tst_gets
            jsr PUTC
            jmp nxt_getc

tst_gets    jsr PRINTF
            dta c'Test GETS',b($9b,$00)

nxt_gets    lda <char_val2
            ldx >char_val2
            ldy #$06
            jsr GETS
            bmi err_end
            sta reg_a
            sty reg_Y
            lda <char_val2
            ldx >char_val2
            ldy #$06
            jsr PUTS
            jsr PRINTF
            dta c'A:%b Y:%b',b($9b,$00)
            dta a(reg_a)
            dta a(reg_y)
            jmp nxt_gets
err_end     jsr PRINTF
            dta c'A:%b Y:%b',b($9b,$00)
            dta a(reg_a)
            dta a(reg_y)

            lda #242
            jsr U_FAIL

            rts

reg_a       dta b($00)
reg_y       dta b($00)

val_a       dta b($2e)
val_x       dta b($3c)
val_y       dta b($4b)

hex_val1    dta a($ABCD)
hex_val2    dta a($1234)
hex_val3    dta b($11,$22,$33,$44)

char_val1   dta c'abcdef'
char_val2   dta c'uvwxyz',b($9b)
char_len2   dta b($05)
char_val3   dta a(char_val2)
char_len3   dta b($03)

dec_val1    dta b(123)
dec_val2    dta a(42567)
dec_val3    dta e(16123321)
dec_val4    dta e(7)
dec_val5    dta e(1234)

test_trap   sta STATUS
            jsr PRINTF
            dta c'trap called',b($9b)
            dta c'STATUS %b',b($9b,$00)
            dta a(STATUS)
            rts

            icl 'SDXCOMTA.ICL'
            icl 'SDXSTD.ICL'
            icl 'SDXFAIL.ICL'

            end
