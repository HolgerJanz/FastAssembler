;Test Suite for FA SpartaDOS X
;Use: -TEST_SDX
;Requires:
;FA.COM in path,<TESTS,<EXAMPLES,<SOURCES,<SDXLIB
;Assembles ASM files,
;compares OBJ files with COM files,
;checks for expected errors

;init and show memory use
ECHO =======================================
ECHO INIT FA Test Suite
SETERRNO 0
ECHO Install @COMMAND
LOAD COMMAND.COM
ECHO Install @FA
LOAD FA.COM
ECHO Install @T_COMP
LOAD TESTCOMP.COM
ECHO Install @T_MCLR
LOAD TESTMCLR.COM
IF ERROR
 GOTO END
FI
MEM
ECHO =======================================
ECHO BEGIN FA Test Suite
ECHO ---------------------------------------
ECHO TEST: Parameter Errors
ECHO ---------------------------------------
ECHO Test no parameter
SETERRNO 0
FA
SET %ERNO=156
GOSUB %CHKERNO
ECHO Test too many parameter
SETERRNO 0
FA /LS ERRORN2 /LS ERRORN2.XXX ZZZ 
GOSUB %CHKERNO
ECHO TEST: Options
ECHO ---------------------------------------
ECHO Test list
SETERRNO 0
FA TESTSYMB.ASM /L
GOSUB %CHKERR
ECHO OK
ECHO ---------------------------------------
ECHO Test summary
SETERRNO 0
FA TESTSYMB.ASM /S
GOSUB %CHKERR
ECHO OK
ECHO ---------------------------------------
ECHO Test list and summary
FA /S TESTSYMB.ASM /L
GOSUB %CHKERR
ECHO OK
ECHO ---------------------------------------
ECHO TEST: Statements
ECHO ---------------------------------------
FOR %FILE IN TEST*.ASM /N
 GOSUB %CHKFILE
NEXT %FILE
ECHO TEST: Compile Errors
ECHO ---------------------------------------
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
ECHO TEST: Examples
ECHO ---------------------------------------
CD <EXAMPLES
FOR %FILE IN *.ASM /N
 GOSUB %CHKFILE
NEXT %FILE
ECHO ---------------------------------------
DEL *.OBJ
DEL *.SYM
CD <TESTS
ECHO TEST: SDX Lib
ECHO ---------------------------------------
CD <SDXLIB
FOR %FILE IN TEST*.ASM /N
 GOSUB %CHKFILE
NEXT %FILE
CD <TESTS
ECHO TEST: FA Compiles Itself
ECHO ---------------------------------------
CD <SOURCES
SET %FILE=FA_SDX
SET %CMPFILE=<BIN>FA
GOSUB %CHKFILE2
SET %FILE=FA_BWD
SET %CMPFILE=<DOS>FA
GOSUB %CHKFILE2
CD <TESTS
ECHO END FA Test Suite
ECHO =======================================
GOTO END

PROC %CHKFILE
SET %CMPFILE=$%FILE
GOSUB %CHKFILE2
RETURN

PROC %CHKFILE2
 ECHO Test $%FILE$.ASM
 IF EXISTS $%FILE$.OBJ
  ERASE $%FILE$.OBJ
 FI
 SETERRNO 0
 FA $%FILE$ /E
 GOSUB %CHKERR
 SETERRNO 0
 T_COMP $%CMPFILE$.COM $%FILE$.OBJ
 IF ERROR
  ECHO ERROR COMPARING: $%CMPFILE$.COM $%FILE$.OBJ
  GOTO END
 ELSE
  ECHO OK COMPARING: $%CMPFILE$.COM $%FILE$.OBJ
 FI
 IF EXISTS $%FILE$.OBJ
  ERASE $%FILE$.OBJ
 FI
 ECHO ---------------------------------------
RETURN

PROC %CHKERR
 IF ERROR
  ECHO ERROR ASSEMBLING: $%FILE$.ASM
  GOTO END
 FI
RETURN

PROC %CHKERNO
 IF NOT ERROR $%ERNO$
  ECHO ERROR EXPECTED: $%ERNO$
  GOTO END
 ELSE
  ECHO OK
 FI 
 ECHO ---------------------------------------
RETURN

:END
 LOAD
 EXIT
