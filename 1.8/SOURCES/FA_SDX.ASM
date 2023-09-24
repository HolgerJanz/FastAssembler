* Fast Assembler for SDX 1.8 PD 2023

* SDX Symbols
COMTAB   smb 'COMTAB'
U_FAIL   smb 'U_FAIL'
U_SFAIL  smb 'U_SFAIL'
U_XFAIL  smb 'U_XFAIL'
FCLOSEAL smb 'FCLOSEAL'
PRINTF   smb 'PRINTF'
FREAD    smb 'FREAD'
FOPEN    smb 'FOPEN'
FCLOSE   smb 'FCLOSE'
PUTC     smb 'PUTC'
FPUTC    smb 'FPUTC'
FWRITE   smb 'FWRITE'
FTELL    smb 'FTELL'
FSEEK    smb 'FSEEK'
U_GETPAR smb 'U_GETPAR'
U_SLASH  smb 'U_SLASH'
DIV_32   smb 'DIV_32'
MUL_32   smb 'MUL_32'
TOUPPER  smb 'TOUPPER'
STATUS   smb 'STATUS'

* OS equates
DOSVEC  equ $0A
MEMTOP  equ $02E5
MEMLO   equ $02E7
* SDX equates
* COMTAB offsets
CT_TRAILS  equ $1A
CT_COMFNAM equ $21
CT_VAR32_1 equ $FF
CT_VAR32_2 equ $103
CT_VAR32_3 equ $107

* variables
FHANDLE equ $0760
FMODE   equ $0778
FATR1   equ $0779
FATR2   equ $077A
FAUX1   equ $0782
FAUX2   equ $0783
FAUX3   equ $0784
FAUX4   equ $0785
FAUX5   equ $0786
SYSCALL equ $0787

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

* Relocatable Program
        blk reloc main
        icl 'FAMAIN.ICL'
        icl 'FAPASSES.ICL'
        icl 'FAPARSE.ICL'
        icl 'FAOPS.ICL'
        icl 'FAPSEUDO.ICL'
        icl 'FASYMBOL.ICL'

* Relocatable Static Data
* read buffer size
bufReaS equ $0400
* static data
e_begin equ *
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
arrFHDL equ bfL20AC+$20
arrFAU1 equ arrFHDL+$10
arrFAU2 equ arrFAU1+$10
arrFAU3 equ arrFAU2+$10
bfL210C equ arrFAU3+$10
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
        blk empty e_end-e_begin main

* Update Blocks
        blk update addresses
        blk update symbols
        blk update new start '@FA'

        end
