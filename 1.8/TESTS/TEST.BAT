; Test Suite for FA
; Use: -TEST path_to_fa>FA
; Assembles ASM files and
; compares OBJ files with COM files

ECHO Start FA test suite
FOR %FILE IN TEST*.ASM /N
 GOSUB %CHKFILE
NEXT %FILE
ECHO =====================================
ECHO Finished FA test suite
EXIT

PROC %CHKFILE
 ECHO =====================================
 ECHO Test $%FILE$.ASM
 ERASE $%FILE$.OBJ
 SETERRNO 0
 %1 $%FILE$ /B
 IF ERROR
  ECHO ERROR: Assembling $%FILE$.ASM
  EXIT
 FI
 SETERRNO 0
 COMP $%FILE$.COM $%FILE$.OBJ
 IF ERROR
  ECHO ERROR: Comparing $%FILE$.OBJ
  EXIT
 FI
RETURN

