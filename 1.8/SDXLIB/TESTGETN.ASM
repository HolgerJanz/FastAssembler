* test U_GETNUM

          blk dos $3000
          jsr U_GETNUM
          bne *+5
          inc z_flag1
          sta lsb
          stx msb
          jsr U_GETPAR
          bne *+5
          inc z_flag2
          jsr PRINTF
          dta c'Z:%2x %4x',b($9b)
          dta c'Z:%2x %s',b($9B,$00)
          dta a(z_flag1)
          dta a(lsb)
          dta a(z_flag2)
          dta a(COMTAB+CT_COMFNAM)
          rts

z_flag1   dta b($00)
z_flag2   dta b($00)
lsb       dta b($00)
msb       dta b($00)

          icl 'SDXCOMTA.ICL'
          icl 'SDXPARAM.ICL'
          icl 'SDXSTD.ICL'
          icl 'SDXFAIL.ICL'

          end
