a1   equ $1010
a2   equ a1+$f0
a3   equ a2+$100

     blk none $1000
     dta b($aa)

     blk padding a1 v1+1
     dta b($bb)

     blk padding a2 v2+1
     dta b($cc)

     blk padding a3 v3+1

v1   equ v2+$11
v2   equ v3+$11
v3   equ $11

     end
