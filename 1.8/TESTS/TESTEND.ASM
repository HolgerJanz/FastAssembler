* test statement END

         blk dos $3000
         dta b($01)
         icl 'TESTEND.ICL'
         dta b($03)
         end
         dta b($ee)
This after END and should be ignored.