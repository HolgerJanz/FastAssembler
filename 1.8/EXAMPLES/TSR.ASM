* Example for FA
* install TSR
* Terminate and Stay Resident
* installs new command MY_TSR

PRINTF  smb 'PRINTF'
INSTALL smb 'INSTALL'

        blk reloc main
* set INSTALL to $FF, program
* wont't be released at end
        dec INSTALL
        rts
hello   jsr PRINTF
        dta c'Hello World !'
        dta b($9b)
        dta c'I''m a TSR program.'
        dta b($9b,0)
        rts

        blk update addresses
        blk update symbols
* declare new symbol, when it starts
* with @, it's callable from command
        blk update new hello '@GREET'
