* Test Pseudo Operations

         opt %01010101

         lst none
         lst bad
         lst all
* test list all
         lst none
         lst bad

         org $2000
         rts
         lda #'A'
         lda #"A"
         dta b($00,$00)
         dta a($aaaa,$bbbb)
         dta v($cccc,$dddd)
         dta e($eeeeee,$ffffff)
         dta f($12345678,$11223344)
         dta g($12345678,$11223344)
         dta l($abcd,$4321)
         dta h($abcd,$4321)
         dta c'! abcdefg !'
         dta d'! abcdefg !'

