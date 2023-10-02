 
         BLK DOS $FFF8
         RTS
 
         RTS
         INS 'TESTEMSG.ICL'

A1       DTA B(0)
         DTA L(A1,A1)
 
         ICL 'TESTEMS2.ICL'
 
*         ICL 'XXX'

         END

