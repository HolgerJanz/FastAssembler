* Test Expressions

equ11    equ 6|$ff^$00&$ff
equ12    equ equ11+2^$FF
equ13    equ [[4+5]-[256+equ12]]&$FF
equ14    equ 2*3
equ15    equ 6/2

         blk dos $3000
         rts
         lda <[equ11+3+[5-4]] 
         lda #[[4+5]-[256+21]]&$FF
         lda <equ11
         lda <equ12
         lda <equ13
         lda <equ14
         lda <equ15

equ21    equ *+$20
equ22    equ $20+!
equ23    equ !+$20
         lda equ21
         lda equ22
         lda equ23

         dta a($1000+255)
         dta a($1000*2)
         dta b(256-1)
