//EXTCONV  JOB (ACCT#),'PFF',MSGCLASS=H,REGION=4M,                      00010000
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,COND=(4,LT)                 00010000
//*                                                                     00010000
//*  ETAPE DE COMPILATION                                               00010000
//*                                                                     00010000
//COMPCONV  EXEC IGYWCL,PARM.COBOL=(NODYNAM,ADV,OBJECT,LIB,TEST,APOST)  00010000
//COBOL.SYSIN  DD DSN=API10.SOURCE.COBTESTS(TESTCONV),DISP=SHR          00010000
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR                             00010000
//             DD DSN=API10.COB.CPY,DISP=SHR                            00010000
//*                                                                     00010000
//*  ETAPE DE LINKEDIT                                                  00010000
//*                                                                     00010000
//LKED.SYSLMOD DD DSN=API10.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)             00010000
//LKED.SYSLIB  DD DSN=API10.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)             00010000
//LKED.SYSIN   DD *                                                     00010000
 INCLUDE SYSLIB('ASSERTER')                                             00010000
 INCLUDE SYSLIB('MSGASSER')                                             00010000
 INCLUDE SYSLIB('CONVERT')                                              00010000
 NAME TESTCONV(R)                                                       00010000
/*                                                                      00010000
//EXECTEST    EXEC PGM=TESTCONV                                         00010000
//STEPLIB     DD DSN=API10.COBOL.LOAD,DISP=SHR                          00010000
//SYSPRINT    DD SYSOUT=*                                               00010000
//SYSOUT      DD SYSOUT=*                                               00010000
//CHANGEK     DD DSN=API10.AJC.CHG.KSDS,DISP=SHR                        00010000
