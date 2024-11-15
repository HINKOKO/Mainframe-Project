//JCTATE   JOB (ACCT#),'HINK',MSGCLASS=H,REGION=4M,                   
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID               
//*                                                                   
//*  ETAPE DE COMPILATION                                             
//*                                                                   
//COMPILS   EXEC IGYWCL,PARM.COBOL=(NODYNAM,ADV,OBJECT,LIB,TEST,APOST)
//COBOL.SYSIN  DD DSN=API2.SOURCE.COBOL(STPROG),DISP=SHR              
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR                           
//*            DD DSN=API2.SOURCE.COPY,DISP=SHR                       
//*                                                                   
//*  ETAPE DE LINKEDIT                                                
//*                                                                   
//LKED.SYSLMOD DD DSN=API2.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)            
//LKED.SYSIN DD *                                                     
  NAME STPROG(R)                                                      
/*                                                                    
