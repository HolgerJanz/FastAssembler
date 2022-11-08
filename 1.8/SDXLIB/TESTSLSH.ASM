* Test U_SLASH and U_GETPAR
          blk dos $3000
nxt_par   lda <options
          ldx >options
          ldy <options_e-options
          jsr U_SLASH
          sta reg_A
          jsr PRINTF
          dta c'A:%b',b($9b,$00)
          dta a(reg_A)

          ldy #$00
          ldx #$00
nxt_opt   lda options,x
          ora flags,y
          sta flags,y
          inx
          inx
          iny
          cpy <flags_e-flags
          bne nxt_opt

          jsr U_GETPAR
          beq end_para
          jsr PRINTF
          dta c'%b:%s',b($9b,$00)
          dta a(COMTAB+CT_TRAILS)
          dta a(COMTAB+CT_COMFNAM)
          jmp nxt_par

end_para  jsr PRINTF
          dta c'Options: (A:%2x),(B:%2x),(C:%2x)',b($9b,$00)
          dta a(flags)
          dta a(flags+1)
          dta a(flags+2)
          rts

reg_A     dta b($00)

options   dta b($00),c'A'
          dta b($00),c'B'
          dta b($00),c'C'
options_e equ *

flags     dta b($00,$00,$00)
flags_e   equ *

          icl 'SDXCOMTA.ICL'
          icl 'SDXPARAM.ICL'
          icl 'SDXSTD.ICL'
          icl 'SDXFAIL.ICL'
          end
