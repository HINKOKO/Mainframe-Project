//STATESK  JOB (AC#),'DEFKSDS',CLASS=A,MSGCLASS=H,
//           NOTIFY=&SYSUID,TIME=(,30)
//* SUPPR FICHIER STATES
//SUPPRFIC EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
   DELETE API2.AJC.STATES.DATA PURGE
/*
//COPIE    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD *
NYNEW-YORK
CACALIFORNIE
ILILLINOIS
TXTEXAS
FLFLORIDE
/*
//SYSUT2   DD DSN=API2.AJC.STATES.DATA,
//         DISP=(NEW,CATLG,DELETE),
//         DCB=(LRECL=80,RECFM=FB,BLKSIZE=800),
//         SPACE=(TRK,(1,1),RLSE)
//***********************************************
//*   TRI DU FICHIER STATES POUR PREPARER KSDS  *
//***********************************************
//TRI       EXEC PGM=SORT
//SORTIN    DD DSN=API2.AJC.STATES.DATA,DISP=OLD
//SORTOUT   DD DSN=API2.AJC.STATES.DATA,DISP=OLD
//SYSOUT    DD SYSOUT=*
//SYSIN     DD *
   SORT FIELDS=(1,2,CH,A)
/*
//CREKSDS   EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=A
//SYSIN     DD *
    DEFINE CLUSTER (NAME(API2.AJC.STATES.KSDS)  -
                      VOLUME(APIWK2)            -
                      TRACKS(1 1)               -
                      FREESPACE(20 20)          -
                      KEYS(2 0)                 -
                      RECORDSIZE(80 80)         -
                      INDEXED)                  -
            DATA   (NAME(API2.AJC.STATES.KSDS.D)) -
            INDEX  (NAME(API2.AJC.STATES.KSDS.I))
           REPRO INDATASET(API2.AJC.STATES.DATA) -
                 OUTDATASET(API2.AJC.STATES.KSDS)
/*
