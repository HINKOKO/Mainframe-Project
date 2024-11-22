//JTCONVP JOB (ACCT#),'HINK',MSGCLASS=H,REGION=4M,                      
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,COND=(4,LT)                 
//*                                                                     
//*  ETAPE DE COMPILATION                                               
//*                                                                     
//COMPCONV  EXEC IGYWCL,PARM.COBOL=(NODYNAM,ADV,OBJECT,LIB,TEST,APOST)  
//COBOL.SYSIN  DD DSN=API2.SOURCE.COBTESTS(TESTCONV),DISP=SHR           
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR                             
//            DD DSN=API2.COB.CPY,DISP=SHR                              
//*                                                                     
//*  ETAPE DE LINKEDIT                                                  
//*                                                                     
//LKED.SYSLMOD DD DSN=API2.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)              
//LKED.SYSLIB  DD DSN=API2.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)              
//LKED.SYSIN DD *                                                       
 INCLUDE SYSLIB('ASSERTER')                                             
 INCLUDE SYSLIB('MSGASSER')                                             
 INCLUDE SYSLIB('CONVERT')                                               
 NAME TESTCONV(R)                                                       
/*                                                                      
//EXECTEST    EXEC PGM=TESTCONV                                         
//STEPLIB     DD DSN=API2.COBOL.LOAD,DISP=SHR                           
//SYSPRINT    DD SYSOUT=*                                               
//SYSOUT      DD SYSOUT=*                                               
//CHANGEK     DD DSN=API2.AJC.CHG.KSDS,DISP=SHR                         
