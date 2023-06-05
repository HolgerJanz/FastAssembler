* Example for FA BW-DOS
* Hi from Atari

nam_siz equ $40

        blk dos $3000
        jsr CHKBW14
        icl 'HI_MAIN.ICL'
* SDX lib for BW-DOS
        icl '<SDXLIB>SDXCOMTA.ICL'
        icl '<SDXLIB>SDXSTD.ICL'
        icl '<SDXLIB>SDXFAIL.ICL'

name    equ *

        end
