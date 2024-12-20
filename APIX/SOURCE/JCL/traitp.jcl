//TRAITP   JOB (ACCT#),'PFF',CLASS=A,MSGCLASS=H,REGION=4M,
//      TIME=(0,20),NOTIFY=&SYSUID,COND=(8,LT),MSGLEVEL=(1,1)
//* DEF LIB
//PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB
//*
//         SET SYSUID=API10,
//             NOMPGM=PART3AP
//*
//* COMPDB2 PART3AP
//CPART3AP EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.COBOL(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//BIND     EXEC PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB  DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (PART3AP) -
       QUALIFIER (API10)    -
       ACTION    (REPLACE)  -
       MEMBER    (PART3AP) -
       VALIDATE  (BIND)     -
       ISOLATION (CS)       -
       ACQUIRE   (USE)      -
       RELEASE   (COMMIT)   -
       EXPLAIN   (NO)
/*
//* RUN PART3AP
//STEPRUN  EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB  DD   DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//SYSOUT   DD   SYSOUT=*,OUTLIM=1000
//SYSTSPRT DD   SYSOUT=*,OUTLIM=2500
//SYSTSIN  DD   *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(PART3AP) PLAN (PART3AP)
/*
//FICEXT   DD DSN=API10.AJC.EXTRACT.DATA,DISP=SHR
//* BUILD/COMPIL PART3BP
//CPART3BP EXEC IGYWCL,PARM.COBOL=(ADV,OBJECT,LIB,TEST,APOST)
//COBOL.SYSIN  DD DSN=API10.SOURCE.COBOL(PART3BP),DISP=SHR
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR
//*
//*  ETAPE DE LINKEDIT
//*
//LKED.SYSLMOD DD DSN=API10.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)
//LKED.SYSLIB DD DSN=API10.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)
//LKED.SYSIN DD *
 INCLUDE SYSLIB('DATEPROG')
 INCLUDE SYSLIB('STPROG')
 NAME PART3BP(R)
/*
//* EXEC PART3BP
//XPART3BP EXEC PGM=PART3BP
//STEPLIB  DD DSN=API10.COBOL.LOAD,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
00,20
/*
//FICEXT   DD DSN=API10.AJC.EXTRACT.DATA,DISP=SHR
//FICFACT  DD DSN=API10.AJC.FACTURES.DATA,DISP=SHR
//STATEK   DD DSN=API10.AJC.STATES.KSDS,DISP=SHR
//* BUILD PART4P
//*
//         SET SYSUID=API10,
//             NOMPGM=PART4P
//*
//* COMPDB2 PART4P
//CPPART4P EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.COBOL(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//BIND     EXEC PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB  DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (PART4P) -
       QUALIFIER (API10)    -
       ACTION    (REPLACE)  -
       MEMBER    (PART4P) -
       VALIDATE  (BIND)     -
       ISOLATION (CS)       -
       ACQUIRE   (USE)      -
       RELEASE   (COMMIT)   -
       EXPLAIN   (NO)
/*
//* RUN PART4P
//STEPRUN  EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB  DD   DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//SYSOUT   DD   SYSOUT=*,OUTLIM=1000
//SYSTSPRT DD   SYSOUT=*,OUTLIM=2500
//SYSTSIN  DD   *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(PART4P) PLAN (PART4P)
/*
//FXML     DD DSN=API10.AJC.XML.DATA,DISP=SHR
//* BUILD PART5P
//*
//         SET SYSUID=API10,
//             NOMPGM=PART5P
//*
//* COMPDB2 PART5P
//CPPART5P EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.COBOL(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//BIND     EXEC PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB  DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (PART5P) -
       QUALIFIER (API10)    -
       ACTION    (REPLACE)  -
       MEMBER    (PART5P) -
       VALIDATE  (BIND)     -
       ISOLATION (CS)       -
       ACQUIRE   (USE)      -
       RELEASE   (COMMIT)   -
       EXPLAIN   (NO)
/*
//* RUN PART5P
//STEPRUN  EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB  DD   DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//SYSOUT   DD   SYSOUT=*,OUTLIM=1000
//FICSTATS DD   DSN=API10.AJC.STATS.DATA,DISP=SHR
//SYSTSPRT DD   SYSOUT=*,OUTLIM=2500
//SYSTSIN  DD   *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(PART5P) PLAN (PART5P)
/*
