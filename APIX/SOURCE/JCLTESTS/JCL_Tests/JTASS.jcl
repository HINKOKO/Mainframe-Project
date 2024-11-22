//JTASS  JOB (ACCT#),'HINK',MSGCLASS=H,REGION=4M,                      
//    CLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID,COND=(4,LT)                
//*                                                                    
//*  ETAPE DE COMPILATION                                              
//*                                                                    
//COMPCONV  EXEC IGYWCL,PARM.COBOL=(NODYNAM,ADV,OBJECT,LIB,TEST,APOST) 
//COBOL.SYSIN  DD DSN=API2.SOURCE.COBTESTS(MSGASSER),DISP=SHR         
//*COBOL.SYSIN  DD DSN=API2.SOURCE.COBTESTS(ASSERTER),DISP=SHR         
//COBOL.SYSLIB DD DSN=CEE.SCEESAMP,DISP=SHR                            
//            DD DSN=API2.COB.CPY,DISP=SHR                             
//            DD DSN=API2.SOURCE.COPY,DISP=SHR                         
//*                                                                    
//*  ETAPE DE LINKEDIT                                                 
//*                                                                    
//LKED.SYSLMOD DD DSN=API2.COBOL.LOAD,DISP=(SHR,KEEP,KEEP)             
//* TOGGLE PROGRAM NAME BY ASSERTER/MSGASSER REGARDING WHAT U INTEND TO DO                                                       
//LKED.SYSIN DD *                                                      
 NAME MSGASSER(R)                                                      
/*                                                                     
