* test file access

          blk dos $3000
* open for read
          jsr U_GETPAR
          lda #$04
          sta FMODE
          jsr FOPEN
          lda FHANDLE
          sta hdl_src
          jsr FILELENG
          jsr PRINTF
          dta c'File length: %e',b($9b,$00)
          dta a(FAUX1)
* open for write
          jsr U_GETPAR
          lda #$08
          sta FMODE
          jsr FOPEN
          lda FHANDLE
          sta hdl_dst

          lda <buffer
          sta FAUX1
          lda >buffer
          sta FAUX2
          lda #$00
          sta FAUX4
          lda #$01
          sta FAUX5
* copy
copy_nxt  ldx hdl_src
          stx FHANDLE
          jsr FREAD
          bpl *+7
          lda #$ff
          sta finished
          ldx hdl_dst
          stx FHANDLE
          jsr FWRITE
          lda finished
          bmi copy_end
          jmp copy_nxt
* close
copy_end  jsr FCLOSEAL
          rts

hdl_src   dta b($00)
hdl_dst   dta b($00)
finished  dta b($00)

          icl 'SDXCOMTA.ICL'
          icl 'SDXPARAM.ICL'
          icl 'SDXSTD.ICL'
          icl 'SDXFILE.ICL'
          icl 'SDXFAIL.ICL'

buffer    equ *

          end
