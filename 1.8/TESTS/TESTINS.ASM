* test INS
* write buffer is 255 bytes
* so for tests file must be greater
         blk dos $3000
         rts
         dta c'>begin blk'
         dta c'>begin ins'
         ins 'TESTINS.TXT'
         dta c'<end ins'
         icl 'TESTINS.ICL'
         dta c'<end blk'
         end
