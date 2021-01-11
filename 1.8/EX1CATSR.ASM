* example call TSR Hello
* needs EX1TSR called before

HELLO   smb '@hello'

        blk sparta $3000
        jsr HELLO
        rts

        blk update adress
        blk update symbols
