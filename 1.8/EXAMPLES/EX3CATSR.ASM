* Example for FA
* to assembly:
* FA EX3CATSR.ASM EX3CATSR.COM

* call TSR Hello
* needs EX3TSR called before

HELLO   smb '@hello'

        blk sparta $3000
        jsr HELLO
        rts

        blk update adress
        blk update symbols
