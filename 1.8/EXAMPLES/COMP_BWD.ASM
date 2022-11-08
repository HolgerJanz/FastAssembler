* COMP for FA and BW-DOS

* Atari DOS block
         blk dos $3000
         icl 'COMPMAIN.ICL'
* SDX lib for BW-DOS
         icl '../SDXLIB/SDXCOMTA.ICL'
         icl '../SDXLIB/SDXPARAM.ICL'
         icl '../SDXLIB/SDXSTD.ICL'
         icl '../SDXLIB/SDXFILE.ICL'
         icl '../SDXLIB/SDXFAIL.ICL'

fbuffsiz equ $100
* use data area after code
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
e_end    equ ftellh2+2

         end
