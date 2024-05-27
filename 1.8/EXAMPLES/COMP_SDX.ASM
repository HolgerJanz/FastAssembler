* Example for FA and SpartaDOS X

* definition of SDX symbols used
* in the program
PUTC     smb 'PUTC'
PRINTF   smb 'PRINTF'
U_GETPAR smb 'U_GETPAR'
U_GETNUM smb 'U_GETNUM'
FOPEN    smb 'FOPEN'
FREAD    smb 'FREAD'
FCLOSEAL smb 'FCLOSEAL'
FILELENG smb 'FILELENG'
U_SFAIL  smb 'U_SFAIL'
U_FAIL   smb 'U_FAIL'
U_XFAIL  smb 'U_XFAIL'
STATUS   smb 'STATUS'
* definition of SDX register labels
FHANDLE  equ $760
FMODE    equ $778
FAUX1    equ $782
FAUX2    equ $783
FAUX4    equ $785
FAUX5    equ $786

* relocatable block
         blk reloc main
         icl 'COMPMAIN.ICL'

* allocate data area in empty block
fbuffsiz equ $100
e_start  equ *
* current file 1 or 2
fnum     equ e_start
* file handles
fileids  equ fnum+1
* size of last file read
filersiz equ fileids+2
* EOF flag for both files
fileneof equ filersiz+2
* compare bytes for diff print
f1byte   equ fileneof+1
f2byte   equ f1byte+1
* count of diff
fdif     equ f2byte+1
* max diff
fmax     equ fdif+2
* file buffer
fbuf1    equ fmax+2
fbuf2    equ fbuf1+fbuffsiz
* current index in file
compidx  equ fbuf2+fbuffsiz
ftellh2  equ compidx+1
* length of files
flength  equ ftellh2+2
e_end    equ flength+4
         blk empty e_end-e_start main

* addresses, symbols update
         blk update addresses
         blk update symbols
         blk update new comp '@MY_COMP'

         end
