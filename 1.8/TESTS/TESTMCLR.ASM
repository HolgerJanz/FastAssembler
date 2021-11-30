* CLEAR FROM MEMLO TO MEMTOP

MEMTOP equ $02E5
MEMLO  equ $02E7

            blk reloc main
start       lda MEMLO
            sta clear_loop+1
            lda MEMLO+1
            sta clear_loop+2

            ldx #$00
clear_loop  stx $ffff

            lda clear_loop+2
            cmp MEMTOP+1
            bcc clear_inc
            lda clear_loop+1
            cmp MEMTOP
            bcs clear_end

clear_inc   inc clear_loop+1
            bne clear_loop
            inc clear_loop+2
            jmp clear_loop

clear_end   rts

            blk update addresses
            blk update symbols
            blk update new start '@T_MCLR'

            end
