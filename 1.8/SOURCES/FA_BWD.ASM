* Fast Assembler for BW-DOS 1.8 PD 2023

* OS equates
DOSVEC  equ $0A
MEMTOP  equ $02E5
* MEMLO is redefined to point to the end
* MEMLO   equ $02E7

* Opcode Equates:
BIT_abs equ $2c
BIT_zp  equ $24

* Assembler Variables:
* $xx current pass number
PASSNUM equ $80
* $xx bfCFNAM length
BFCFNAL equ $82
* $xxxx min memory
MEMMIN  equ $86
* $xxxx max memory
MEMMAX  equ $88
* $xxx program counter
PROGCNT equ $8C
* $xxx Block program counter
BLKPCNT equ $8E
* $xxxx current line
PCURLIN equ $90
* $xxxx max used mem
MEMHIGH equ $9A
* temp1 pointer $xxxx
ZTEMP1  equ $9C
* temp2 pointer $xxxx
ZTEMP2  equ $9E
* current include line number
CURICLN equ $A0
* current icnlude index
CURICLX equ $A2

* Program
        blk dos $2800
        icl 'FAMAIN.ICL'
        icl 'FAPASSES.ICL'
        icl 'FAPARSE.ICL'
        icl 'FAOPS.ICL'
        icl 'FAPSEUDO.ICL'
        icl 'FASYMBOL.ICL'
* SDX lib for BW-DOS
        icl '<SDXLIB>SDXCOMTA.ICL'
        icl '<SDXLIB>SDXPARAM.ICL'
        icl '<SDXLIB>SDXSTD.ICL'
        icl '<SDXLIB>SDXFILE.ICL'
        icl '<SDXLIB>SDXFAIL.ICL'
        icl '<SDXLIB>SDXARITH.ICL'

* Relocatable Static Data
* read buffer size
bufReaS equ $0400
* static data (plus variable for MEMLO)
e_begin equ *+2
bfCFNAM equ e_begin
bfCLINE equ bfCFNAM+$100
bfL1FAC equ bfCLINE+$100
bfL1FCC equ bfL1FAC+$20
bfL1FEC equ bfL1FCC+$20
bfL200C equ bfL1FEC+$20
bfL202C equ bfL200C+$20
bfL204C equ bfL202C+$20
bfL206C equ bfL204C+$20
bfL208C equ bfL206C+$20
bfL20AC equ bfL208C+$20

* include stack variables
arrFHDL equ bfL20AC+$20
arrFAU1 equ arrFHDL+$10
arrFAU2 equ arrFAU1+$10
arrFAU3 equ arrFAU2+$10
arrICLL equ arrFAU3+$10
arrICLH equ arrICLL+$10
arrFILN equ arrICLH+$10
currICL equ arrFILN+$10

bfL210C equ currICL+$20
bfL2114 equ bfL210C+$08
bfL211C equ bfL2114+$08
bfL2124 equ bfL211C+$08
bufRead equ bfL2124+$08
bufWrit equ bufRead+bufReaS
bufWrtL equ bufWrit+$100
* e_end is just 1 behind that block,
* never used it in other blocks
e_end   equ bufWrtL+$01
* last used byte in empty block
e_last  equ e_end-1

* add 2 bytes for MEMLO and
* static buffer size
MEMLO   dta a(e_begin+[e_end-e_begin])

        end
