* Example for FA
* calls symbole MY_TSR Hello
* see TSR.ASM, needs TSR.COM
* called before, to define
* symbols MY_TSR

* symbol defined by TSR.COM
GREET   smb '@GREET'

        blk reloc main
        jsr GREET
        rts

* update addresses and symbols
        blk update addresses
        blk update symbols
