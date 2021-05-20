* Fast Assembler 1.8 PD 2021

* SpartaDos Symbols
COMTAB  smb 'COMTAB'
U_FAIL  smb 'U_FAIL'
U_SFAIL smb 'U_SFAIL'
U_XFAIL smb 'U_XFAIL'
FCLOSEA smb 'FCLOSEAL'
PRINTF  smb 'PRINTF'
FREAD   smb 'FREAD'
FOPEN   smb 'FOPEN'
FCLOSE  smb 'FCLOSE'
PUTC    smb 'PUTC'
FPUTC   smb 'FPUTC'
FTELL   smb 'FTELL'
FSEEK   smb 'FSEEK'
U_GETPA smb 'U_GETPAR'
U_SLASH smb 'U_SLASH'
DIV_32  smb 'DIV_32'
MUL_32  smb 'MUL_32'
TOUPPER smb 'TOUPPER'
STATUS  smb 'STATUS'

* System equates
MEMTOP  equ $02E5
MEMLO   equ $02E7
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

* Assembler Variables
PASSNUM equ $80

* BIT Equates
BIT_abs equ $2c
BIT_zp  equ $24

        blk reloc main
* Part 1 Main
        icl 'FAMAIN.ASM'
* Part 2 Passes
        icl 'FAPASSES.ASM'
* Part 3 Parse
        icl 'FAPARSE.ASM'
* Part 4 Operations
        icl 'FAOPS.ASM'
* Part 5 Pseudo Opcodes
        icl 'FAPSEUDO.ASM'
* Part 6 Symbols
        icl 'FASYMBOL.ASM'

        blk empty $381 main
* Data Alloc Block
bfCFNAM equ *-$0381
bfL1EAC equ *-$0281
bfL1EAD equ *-$0280
bfL1FAC equ *-$0181
bfL1FCC equ *-$0161
bfL1FEC equ *-$0141
bfL200C equ *-$0121
bfL202C equ *-$0101
bfL204C equ *-$00E1
bfL206C equ *-$00C1
bfL208C equ *-$00A1
bfL20AC equ *-$0081
bfL20CC equ *-$0061
bfL20DC equ *-$0051
bfL20EC equ *-$0041
bfL20FC equ *-$0031
bfL210C equ *-$0021
bfL2114 equ *-$0019
bfL211C equ *-$0011
bfL2124 equ *-$0009

* Update Blocks
        blk update addresses
        blk update symbols
        blk update new start '@FA'

        end
