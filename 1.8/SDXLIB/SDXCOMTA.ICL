* SDX: COMTAB

* positive offset
CT_VAR32_1 equ 0
CT_VAR32_2 equ 4
CT_VAR32_3 equ 8
CT_TRAILS  equ 12
CT_COMFNAM equ 13

COMTAB   equ *
         dta b(0,0,0,0)
         dta b(0,0,0,0)
         dta b(0,0,0,0)
         dta b(0)
         dta c'D1:',b($9b,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

FILE_P    dta a(COMTAB+CT_COMFNAM)
_file_p   dta c'D',b(0),c':'
_file_pn  dta b(0,0,0,0,0,0,0,0,0,0)
          dta b(0,0,0,0,0,0,0,0,0,0)
          dta b(0,0,0,0,$9b)

