//CHGKSDS   JOB (AC#),'DEFKSDS',CLASS=A,MSGCLASS=H, 
//           NOTIFY=&SYSUID,TIME=(,30)
//STEP1     EXEC PGM=IDCAMS
//SYSPRINT  DD SYSOUT=A
//SYSIN     DD *
       DEFINE CLUSTER (NAME(APIX.AJC.CHG.KSDS)  -
                      VOLUME(APIWK2)            -
                      TRACKS(1 1)               -
                      FREESPACE(20 20)          -
                      KEYS(2 0)                 -
                      RECORDSIZE(80 80)         -
                      INDEXED)                  -
            DATA   (NAME(APIX.AJC.CHG.KSDS.D))  -
            INDEX  (NAME(APIX.AJC.CHG.KSDS.I))
           REPRO INDATASET(APIX.AJC.CURR1.DATA) -
                 OUTDATASET(APIX.AJC.CHG.KSDS)
/*
