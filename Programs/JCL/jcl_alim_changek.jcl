//KSCUR    JOB KSCUR,'HINKOKO',CLASS=A,MSGCLASS=A,MSGLEVEL=(1,1),
//             NOTIFY=&SYSUID
//****************************************************************
//* RAZ ON XCHANGE DATA FILE CONTAINING CONVERSION RATES
//****************************************************************
//RAZ       EXEC  PGM=IDCAMS
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *
  DELETE API2.AJC.XCHANGE.DATA
  DELETE API2.AJC.CHG.KSDS CLUSTER
/*
//**********************************************************************
//* CREATE  PDS DATASET MEMBER
//**********************************************************************
//STEP00   EXEC PGM=IEFBR14
//CREER    DD DSN=API2.AJC.XCHANGE.DATA,DISP=(NEW,CATLG,DELETE),
//          SPACE=(TRK,(1,1),RLSE),
//          DCB=(LRECL=80,BLKSIZE=400,RECFM=FB)
//SYSOUT   DD SYSOUT=*
//********************************
//* ALIM THE PDS WITH IEBGENER
//********************************
//STEP01   EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD *
EU01058
YU00138
GB01270
YE00006
IN00012
SG00756
PL00244
CH01131
RO00212
/*
//SYSUT2   DD DSN=API2.AJC.XCHANGE.DATA,DISP=SHR
//SYSIN    DD DUMMY
//********************************
//* SORT THE XCHANGE BEFORE TURNING IT INTO KSDS
//********************************
//STEP02   EXEC PGM=SORT
//SORTIN   DD DSN=API2.AJC.XCHANGE.DATA,DISP=OLD
//SORTOUT  DD DSN=API2.AJC.XCHANGE.DATA,DISP=OLD
//SYSOUT   DD SYSOUT=*
//SYSIN    DD *
  SORT FIELDS=(1,2,CH,A)
/*
//********************************
//* CREATE KSDS FOR PICK A MONEY-RATE BY INDEX
//********************************
//STEP03    EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=A
//SYSIN     DD *
       DEFINE CLUSTER (NAME(API2.AJC.CHG.KSDS)  -
                      VOLUME(APIWK2)            -
                      TRACKS(1 1)               -
                      FREESPACE(20 20)          -
                      KEYS(2 0)                 -
                      RECORDSIZE(80 80)         -
                      INDEXED)                  -
            DATA   (NAME(API2.AJC.CHG.KSDS.D))  -
            INDEX  (NAME(API2.AJC.CHG.KSDS.I))
           REPRO INDATASET(API2.AJC.XCHANGE.DATA) -
                 OUTDATASET(API2.AJC.CHG.KSDS)
/*
