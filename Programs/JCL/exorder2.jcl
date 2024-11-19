//EXORDER2 JOB (ACCT#),'PFF',MSGCLASS=H,REGION=4M,
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,TIME=(0,30)
//***************************************************
//* SUPPR FICHIER FACTURES.DATA
//***************************************************
//SUPFFACT EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
   DELETE API10.AJC.FACTURES.DATA
/*
//***************************************************
//* CREER FICHIER FACTURES.DATA
//***************************************************
//CREFFACT EXEC PGM=IEFBR14
//FICHIER  DD DSN=API10.AJC.FACTURES.DATA,
//            DISP=(NEW,CATLG,CATLG),
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(LRECL=80,BLKSIZE=800,RECFM=FB)
//SYSOUT   DD SYSOUT=*
//********************************************************
//*  ETAPE D'EXECUTION DU FICHIER COBOL
//********************************************************
//EXORDER2 EXEC PGM=EDORD
//STEPLIB  DD DSN=API10.COBOL.LOAD,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//FICEXT   DD DSN=API10.AJC.EXTRACT.DATA,DISP=SHR
//FICFACT  DD DSN=API10.AJC.FACTURES.DATA,DISP=SHR
