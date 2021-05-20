* Example for FA
* To assembly:
* FA EX2HELLO.ASM EX2HELLO.COM

* Hello from Atari
* SpartaDOS X executable with
* relocatable code 

* used SpartaDOS X symbols
PRINTF  smb 'printf'
GETS    smb 'gets'

* name buffer size
nam_siz equ $10

* main relocatable code block
        blk reloc main
* print question
        jsr PRINTF
        dta b($9b)
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
        dta b($9b)
        dta c'Hello %s !'
        dta b($9b,$00)
        dta v(name)
        rts
* vector is needed for get name
namev   dta v(name)

* main relocatable data block
        blk empty nam_siz main
* program counter already incremented!
name    equ *-nam_siz

* blocks for address and symbol update
        blk update adress
        blk update symbols
