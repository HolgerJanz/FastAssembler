* Example for FA
* This program will call another
* program with a parameter in FLAG
* and display the state. After
* execution it returns 1. 0 if wrong
* attributes are given and error
* number if there is any other error.
* This is how the system communicates
* with COMMAND.COM as well as the ARC
* program with its subroutines (do
* DIR + h CAR :).

* Use with example CALLEE, e.g.:
* CALLER 2 CALLEE.COM

* used SDX symbols
U_GETATR smb 'U_GETATR'
U_GETNUM smb 'U_GETNUM'
U_LOAD   smb 'U_LOAD'
FLAG     smb 'FLAG'
STATUS   smb 'STATUS'
PRINTF   smb 'PRINTF'
U_SFAIL  smb 'U_SFAIL'
U_XFAIL  smb 'U_XFAIL'

* relocatable block
         blk reloc main
* get the first numeric parameters
* passed by FLAG
         jsr U_GETNUM
         bne numset
* If not given, the default is set
         lda #$00
* reseting highest bit, ensures
* triggering
numset   and #$7F
* set parameter
         sta FLAG
* get name and attributes from the
* command line
         lda #$A0
         jsr U_GETATR
         bne fileset
* if no name, program ends with
* STATUS 0
         lda #0
         jmp setstat
* otherwise, display the (FLAG)
* parameter
fileset  jsr PRINTF
         dta c'CALLER Set FLAG: $%2x'
         dta b($9b,0)
         dta v(FLAG)
* set trap for errors
         lda vtrap
         ldx vtrap+1
         jsr U_SFAIL
* U_LOAD the program and set the
* return value (because STATUS is
* reset by U_LOAD) and remove the
* trap
         jsr U_LOAD
         pha
         jsr U_XFAIL
         pla
trap     sta stat
* display of the returned parameter
         jsr PRINTF
         dta c'CALLER Received STATUS: $%2x'
         dta b($9b,0)
         dta v(stat)
* abort program with STATUS 1
         lda #$01
setstat  sta STATUS
         rts

vtrap    dta v(trap)
stat     dta b($00)

* update addresses and symbols
         blk update addresses
         blk update symbol

         end
