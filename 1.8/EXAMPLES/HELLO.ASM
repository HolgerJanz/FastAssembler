* Example for FA
* Hello from Atari
* SpartaDOS X executable with
* relocatable code 

* used SpartaDOS X symbols
* see SDX programming guide
PRINTF  smb 'PRINTF'
GETS    smb 'GETS'

* name buffer size
nam_siz equ $40

* relocatable code block
        blk reloc main
* print question
        jsr PRINTF
        dta c'What''s your name?'
        dta b($9B,$00)
* get name, due to code
* relocatability you cannot use
* lda <name and ldx >name because at
* compile time we do not know where
* the program will be located!
        lda namev
        ldX namev+1
        ldy #nam_siz
        jsr GETS
* print greetings
        jsr PRINTF
        dta c'Hello %s !'
        dta b($9b,$00)
        dta v(name)
        rts
* vector is needed for get name
namev   dta v(name)

* relocatable data block
* program counter is incremented!
* by BLK EMPTY, symbols must be
* definded beforehand
name    equ *
        blk empty nam_siz main

* blocks for address and symbol update
        blk update addresses
        blk update symbols

        end
