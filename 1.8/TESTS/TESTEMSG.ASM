 
         BLK DOS $FFF8
         RTS
 
         RTS
         INS 'TESTEMSG.ICL'

A1       DTA B(0)
         DTA L(A1,A1)
 
         ICL 'TESTEMS2.ICL'


     dta b($FFF1)

     icl 'TESTEMS4.ICL'

     dta b($FFF1)

     icl 'TESTEMS5.ICL'

     dta b($FFF1)

     icl 'TESTEMS6.ICL'

     dta b($FFF1)

         END

