* example install TSR
* installs new command HELLO

PRINTF  smb 'printf'
INSTALL smb 'install'

        blk sparta $3000
        dec INSTALL
        rts

        blk reloc main
hello   jsr PRINTF
        dta b($9b)
        dta c'Hello World !'
        dta b($9b,0)
        rts

        blk update adress
        blk update symbols
        blk update new hello '@hello'
