* print question
        jsr PRINTF
        dta c'What''s your name?'
        dta b($9B,$00)
* ask for name
        lda namev
        ldx namev+1
        ldy #nam_siz
        jsr GETS
* print Hi
        jsr PRINTF
        dta c'Hi %s !'
        dta b($9b,$00)
        dta v(name)
        rts

namev   dta v(name)
