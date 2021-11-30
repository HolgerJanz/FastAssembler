;Test Suite for FA
;Use: -TEST path_to_fa>FA.COM
;Assembles ASM files,
;compares OBJ files with COM files,
;checks for expected errors

;init and show memory use
ECHO =====================================
ECHO ΙΞΙΤ ΖΑ Τεστ Συιτε
SETERRNO 0
ECHO Install @COMMAND
LOAD COMMAND.COM
ECHO Install @FA
LOAD %1
ECHO Install @T_COMP
LOAD TESTCOMP.COM
ECHO Install @T_MCLR
LOAD TESTMCLR.COM
IF ERROR
 GOTO END
FI
MEM
ECHO =====================================

ECHO ΒΕΗΙΞ ΖΑ Τεστ Συιτε
ECHO =====================================

ECHO ΤεστΊ ΖΑ παςανετες εςςοςσ
ECHO Test no parameter
SETERRNO 0
FA
SET %ERNO=156
GOSUB %CHKERNO
ECHO Test too many parameter
SETERRNO 0
FA /LS ERRORN2 /LS ERRORN2.XXX ZZZ 
GOSUB %CHKERNO
ECHO =====================================

ECHO ΤΕΣΤΊ ΖΑ οπτιοξσ
ECHO Test list
SETERRNO 0
FA TESTSYMB.ASM /L
GOSUB %CHKERR
ECHO ΟΛ
ECHO Test summary
SETERRNO 0
FA TESTSYMB.ASM /S
GOSUB %CHKERR
ECHO ΟΛ
ECHO Test list and summary
FA /S TESTSYMB.ASM /L
GOSUB %CHKERR
ECHO ΟΛ
ECHO =====================================

ECHO ΤεστΊ αμμ στατενεξτσ
FOR %FILE IN TEST*.ASM /N
 GOSUB %CHKFILE
NEXT %FILE
ECHO =====================================

ECHO ΤεστΊ ασσενβμω εςςοςσ
ECHO Test undeclared label ERRORURS.ASM
SETERRNO 0
FA ERRORURS /E
SET %ERNO=224
GOSUB %CHKERNO
ECHO Test label recursion ERRORREC.ASM
SETERRNO 0
FA errorrec /E
SET %ERNO=224
GOSUB %CHKERNO
ECHO Test declared twice ERROR225.ASM
SETERRNO 0
FA error225 /E
SET %ERNO=225
GOSUB %CHKERNO
ECHO Test unexpected eol ERROR226.ASM
SETERRNO 0
FA error226 /E
SET %ERNO=226
GOSUB %CHKERNO
ECHO Test too many passes ERROR227.ASM
SETERRNO 0
FA /E error227
SET %ERNO=227
GOSUB %CHKERNO
ECHO String error ERROR229.ASM
SETERRNO 0
FA /E error229
SET %ERNO=229
GOSUB %CHKERNO
ECHO Branch too far ERROR231.ASM
SETERRNO 0
FA /E error231
SET %ERNO=231
GOSUB %CHKERNO
ECHO Improper type (2) ERRORN2.ASM
SETERRNO 0
FA ERRORN2 /E
SET %ERNO=232
GOSUB %CHKERNO
ECHO Branch too far ERROR233.ASM
SETERRNO 0
FA error233 /E
SET %ERNO=233
GOSUB %CHKERNO
ECHO Too long or invalid symbol ERROR238.ASM
SETERRNO 0
FA error238 /E
SET %ERNO=238
GOSUB %CHKERNO
ECHO =====================================

ECHO ΤεστΊ εψανπμεσ
CD <EXAMPLES
FOR %FILE IN *.ASM /N
 GOSUB %CHKFILE
NEXT %FILE
CD <TESTS
ECHO =====================================

ECHO ΤεστΊ ΖΑ γονπιμεσ ιτσεμζ
CD <SOURCES
SET %FILE=FA
GOSUB %CHKFILE
CD <TESTS
ECHO =====================================

ECHO ΕΞΔ ΖΑ Τεστ Συιτε
ECHO =====================================
GOTO END

PROC %CHKFILE
 ECHO Test $%FILE$.ASM
 IF EXISTS $%FILE$.OBJ
  ERASE $%FILE$.OBJ
 FI
 SETERRNO 0
 FA $%FILE$ /E
 GOSUB %CHKERR
 SETERRNO 0
 T_COMP $%FILE$.COM $%FILE$.OBJ
 IF ERROR
  ECHO ΕÒÒΟÒ ΓΟΝΠΑÒΙΞΗΊ $%FILE$.OBJ
  GOTO END
 ELSE
  ECHO ΟΛ
 FI
 IF EXISTS $%FILE$.OBJ
  ERASE $%FILE$.OBJ
 FI
RETURN

PROC %CHKERR
 IF ERROR
  ECHO ΕÒÒΟÒ ΑΣΣΕΝΒΜΙΞΗΊ $%FILE$.ASM
  GOTO END
 FI
RETURN

PROC %CHKERNO
 IF NOT ERROR $%ERNO$
  ECHO ΕÒÒΟÒ ΕψπεγτεδΊ $%ERNO$
  GOTO END
 ELSE
  ECHO ΟΛ
 FI 
RETURN

:END
 LOAD
 EXIT
