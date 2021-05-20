* Test labels

l1       equ l2+1
l2       equ l3+1
l3       equ $aa

l4       equ $aa
l5       equ l4+1
l6       equ l5+1

la       equ lb+1
lb       equ lc+1
lc       equ $aaaa

         blk dos $3000
         rts

         lda <l1
         lda <l2
         lda <l3
*         lda l1 error: wrong length
*         lda l2 error: wrong length
         lda l3

         lda <l4
         lda <l5
         lda <l6
         lda l4 error: wrong length
         lda l5 error: wrong length
         lda l6


         lda <la
         lda <lb
         lda <lc
         lda la
         lda lb
         lda lc

