* Test: Unresolved Symbol

Z        EQU Y
Y        EQU X
X        EQU 10
         XXX YYY
         blk DOS $3000
         lda <Z+10
         jmp does_not_exist
         AAA BBB
         rts
         dta b(10)
         end

