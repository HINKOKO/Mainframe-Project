//IMPORTP  JOB (ACCT#),'PFF',MSGCLASS=H,REGION=4M,
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,TIME=(0,35)
//****************************************************//
//* THIS JCL BUILD AND EXECUTE THE PROGRAM PART1P    *//
//*          FOR IMPORT NEW PRODUCTS IN DTABASE      *//
//*          BUILD AND EXECUTE THE PROGRAM PART2P    *//
//*          FOR IMPORT NEW ORDERS IN DATABASE       *//
//*                                                  *//
//* PLEASE BE SURE TO CHANGE YOUR SYSUID             *//
//* EXEC THIS COMMAND  ===> C APIX API[YOUR DIGIT]   *//
//*        FOR EXAMPLE ===> C APIX API10             *//
//****************************************************//
//* BUILD STEP - 'STATIC' CALL
//* LIBRARY SET GLOBAL
//PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB
//* CONSTANT SET
//         SET SYSUID=API10,
//             NOMPGM=PART1P
//* COMPDB2 PART1P
//CPPART1P EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//                 DD DSN=&SYSUID..SOURCE.COPY,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.COBOL(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//* BIND STEP PART1P
//BDPART1P EXEC  PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB    DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT   DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN    DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (PART1P)   -
       QUALIFIER (API10)   -
       ACTION    (REPLACE) -
       MEMBER    (PART1P)   -
       VALIDATE  (BIND)    -
       ISOLATION (CS)      -
       ACQUIRE   (USE)     -
       RELEASE   (COMMIT)  -
       EXPLAIN   (NO)
/*
//* RUN STEP PART1P
//RPART1P  EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB    DD DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//           DD DSN=&SYSUID..COBOL.LOAD,DISP=SHR
//CHANGEK    DD DSN=&SYSUID..AJC.CHG.KSDS,DISP=SHR
//FICNEWS    DD DSN=&SYSUID..AJC.NEWPRODS.CSV,DISP=SHR
//FICLOG     DD DSN=&SYSUID..AJC.LOGPART1.DATA,DISP=SHR
//SYSOUT     DD  SYSOUT=*,OUTLIM=4000
//SYSTSPRT   DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN    DD  *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(PART1P) PLAN (PART1P)
/*
//**************************************************
//* CONSTANT SET
//         SET SYSUID=API10,
//             NOMPGM=PART2P
//* COMPDB2 PART2P
//CPPART2P EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//                 DD DSN=&SYSUID..SOURCE.COPY,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.COBOL(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//* BIND STEP PART2P
//BDPART2P EXEC  PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB    DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT   DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN    DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (PART2P) -
       QUALIFIER (API10)   -
       ACTION    (REPLACE) -
       MEMBER    (PART2P) -
       VALIDATE  (BIND)    -
       ISOLATION (CS)      -
       ACQUIRE   (USE)     -
       RELEASE   (COMMIT)  -
       EXPLAIN   (NO)
/*
//* RUN STEP PART2P
//RPART2P  EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB    DD DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//           DD DSN=&SYSUID..COBOL.LOAD,DISP=SHR
//FVENTEU    DD DSN=&SYSUID..AJC.VENTEEU.DATA,DISP=SHR
//FVENTAS    DD DSN=&SYSUID..AJC.VENTEAS.DATA,DISP=SHR
//SYSOUT     DD  SYSOUT=*,OUTLIM=4000
//SYSTSPRT   DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN    DD  *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(PART2P) PLAN (PART2P)
/*
