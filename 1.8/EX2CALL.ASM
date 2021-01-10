* Example program 2 for FA
* to assembly:
* FA EX2CALL.ASM EX2CALL.COM

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

* Use with example 1 EX1READ, e.g.:
* EX2CALL 2 EX1READ.COM


* list only lines with errors

         lst bad

* definition of SDX symbols.

getatr   smb 'u_getatr'
getnum   smb 'u_getnum'
load     smb 'u_load'
flag     smb 'flag'
status   smb 'status'
printf   smb 'printf'
sfail    smb 'u_sfail'
xfail    smb 'u_xfail'

* relocatable block

         blk reloc main

* get the first numeric parameters
* passed by flag

nad      jsr getnum
         bne nad_num

* If not given, the default is set

         lda #0

* reseting highest bit ensures
* triggering

nad_num  and #$7F

* set parameter

         sta flag

* get name and attributes from the
* command line

         lda #$A0    file name
         jsr getatr
         bne nad_pok

* if no name, program ends with
* status 0

         lda #0
         jmp nad_sta

* otherwise, display the (flag)
* parameter

nad_pok  jsr printf
         dta b($9b),c' Set flag: %2x',b($9b,0)
         dta v(flag)

* set trap for errors

         lda vtrap
         ldx vtrap+1
         jsr sfail

* load the program and set the
* return value (because STATUS is
* reset by U_LOAD) and remove the
* trap

         jsr load
         pha
         jsr xfail
         pla

trap     sta stat

* display of the returned parameter

         jsr printf
         dta b($9B),c' State: %2x',b($9b,0)
         dta v(stat)

* abort program with STATUS 1

         lda #1
nad_sta  sta status
         rts

vtrap    dta v(trap)
stat     dta b(0)

* address update

         blk update adress

* symbol update

         blk update symbol

* new symbol

         blk update new nad '@ex2call'

* the end
         end

