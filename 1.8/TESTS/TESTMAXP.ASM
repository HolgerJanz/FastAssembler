l9 equ l8+1
l8 equ l7+1
l7 equ l6+1
l6 equ l5+1
l5 equ l4+1
l4 equ l3+1
l3 equ l2+1
l2 equ l1+1
l1 equ 1

 blk dos $3000
 lda <l9
 lda <l8
 lda <l7
 lda <l6
 lda <l5
 lda <l4
 lda <l3
 lda <l2
 lda <l1 
 rts
