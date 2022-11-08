* Example for FA SpartaDOS X
* Hi from Atari

PRINTF  smb 'PRINTF'
GETS    smb 'GETS'

nam_siz equ $40

        blk reloc main
        icl 'HI_MAIN.ICL'

name    equ *
        blk empty nam_siz main

        blk update addresses
        blk update symbols

        end
