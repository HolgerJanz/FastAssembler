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

          ldx hdl_src
          stx FHANDLE

* copy
copy_nxt  jsr FTELL
          jsr FSEEK
          ldx hdl_src
          stx FHANDLE
          jsr FGETC
          bmi copy_end
          ldx hdl_dst
          stx FHANDLE
          pha
          jsr FTELL
          jsr FSEEK
          pla
          jsr FPUTC
          jmp copy_nxt
* close
copy_end  jsr FCLOSEAL
          rts

hdl_src   dta b($00)
hdl_dst   dta b($00)

          icl 'SDXCOMTA.ICL'
          icl 'SDXPARAM.ICL'
          icl 'SDXSTD.ICL'
          icl 'SDXFILE.ICL'
          icl 'SDXFAIL.ICL'

          end
