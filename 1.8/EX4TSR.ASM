* example install TSR Hello

PRINTF  smb 'printf'
INSTALL smb 'install'

        blk sparta $3000
        dec INSTALL
        rts

        blk reloc main
hello   jsr PRINTF
        dta $9b,c'Hello World !',$9b,0
        rts

        blk update new hello '@hello'
