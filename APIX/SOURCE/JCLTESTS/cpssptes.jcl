//CPSSPTES JOB (ACCT#),'PFF',MSGCLASS=H,REGION=4M,                      00010000
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,COND=(4,LT)                 00010000
//*  BUILD MSGASSER                                                     00010000
//COMPMSG  EXEC IGYWCL,PARM.COBOL=(NODYNAM,ADV,OBJECT,LIB,TEST,APOST)   00010000
//COBOL.SYSIN   DD DSN=API10.SOURCE.COBTESTS(MSGASSER),DISP=SHR         00010000
//COBOL.SYSLIB  DD DSN=CEE.SCEESAMP,DISP=SHR                            00010000
//              DD DSN=API10.COB.CPY,DISP=SHR                           00010000
//              DD DSN=API10.SOURCE.COPY,DISP=SHR                       00010000
//*  LINKEDIT MSGASSER                                                  00010000
//LKED.SYSLMOD DD DSN=API10.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)             00010000
//LKED.SYSIN   DD *                                                     00010000
 NAME MSGASSER(R)                                                       00010000
/*                                                                      00010000
//*  BUILD ASSERTER                                                     00010000
//COMPASSR  EXEC IGYWCL,PARM.COBOL=(NODYNAM,ADV,OBJECT,LIB,TEST,APOST)  00010000
//COBOL.SYSIN  DD DSN=API10.SOURCE.COBTESTS(ASSERTER),DISP=SHR          00010000
//COBOL.SYSLIB  DD DSN=CEE.SCEESAMP,DISP=SHR                            00010000
//              DD DSN=API10.COB.CPY,DISP=SHR                           00010000
//              DD DSN=API10.SOURCE.COPY,DISP=SHR                       00010000
//*  LINKEDIT ASSERTER                                                  00010000
//LKED.SYSLMOD DD DSN=API10.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)             00010000
//LKED.SYSIN   DD *                                                     00010000
 NAME ASSERTER(R)                                                       00010000
/*                                                                      00010000
