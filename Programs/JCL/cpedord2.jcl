//CPEDORD2 JOB (ACCT#),'PFF',MSGCLASS=H,REGION=4M,
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,COND=(4,LT)
//*
//*  ETAPE COMPILATION PROG PRINCIPAL
//*
//COMPIL   EXEC IGYWCL,PARM.COBOL=(ADV,OBJECT,LIB,TEST,APOST)
//COBOL.SYSIN  DD DSN=API10.SOURCE.COBOL(EDORD),DISP=SHR
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR
//*            DD DSN=API10.SOURCE.COPY,DISP=SHR
//*
//*  ETAPE DE LINKEDIT
//*
//LKED.SYSLMOD DD DSN=API10.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)
//LKED.SYSIN DD *
 NAME EDORD(R)
/*
