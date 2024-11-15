       IDENTIFICATION DIVISION.                                         
       PROGRAM-ID. STPROG.                                              
       AUTHOR.     HINKOKO.                                             
      *******************************************************          
      *   THIS PROGRAM IS INTENDED TO MAP A STATE CODE      *          
      *   TO ITS FULL TEXT REPRESENTATION                   *          
      *   RETURN THE FULL STATE NAME TO CALLER              *          
      *******************************************************          
                                                                        
       ENVIRONMENT DIVISION.                                            
       INPUT-OUTPUT SECTION.                                            
       FILE-CONTROL.                                                    
              SELECT STATEK ASSIGN TO STATEK                            
               ORGANIZATION IS INDEXED                                  
               ACCESS MODE IS RANDOM                                    
               RECORD KEY IS STATE-CODE                                 
               FILE STATUS IS FS-STATE.                                 
      ******************************************                       
       DATA DIVISION.                                                   
       FILE SECTION.                                                    
       FD STATEK.                                                       
       01 ST-STATEK.                                                    
          05 STATE-CODE    PIC X(2).                                    
          05 STATE-NAME    PIC X(30).                                   
          05 FILLER        PIC X(48).                                   
                                                                        
       WORKING-STORAGE SECTION.                                         
       77 FS-STATE         PIC 99.                                      
       77 WS-ANO           PIC 9.                                       
       77 WS-VAR           PIC 9 VALUE 0.                               
                                                                        
       LINKAGE SECTION.                                                 
       01 LK-ST-CODE       PIC X(2).                                    
       01 LK-ST-NAME       PIC X(30).                                   
                                                                        
       PROCEDURE DIVISION USING LK-ST-CODE LK-ST-NAME.                  
           DISPLAY 'RECEIVED CODE ' LK-ST-CODE                          
           OPEN INPUT STATEK                                            
           PERFORM CHECK-FILE-STATUS                                    
                    
           MOVE LK-ST-CODE TO STATE-CODE                                
           READ STATEK                                                  
           EVALUATE FS-STATE                                            
               WHEN ZERO                                                
                  MOVE STATE-NAME TO LK-ST-NAME                         
               WHEN 23                                                  
                  DISPLAY 'ETAT ' LK-ST-CODE ' INTROUVABLE.'            
               WHEN OTHER                                               
                  DISPLAY 'ERROR: FILE STATUS -> ' FS-STATE             
                  PERFORM ABEND-PROG                                    
           END-EVALUATE                                                 
                                                                        
           CLOSE STATEK                                                 
           PERFORM CHECK-FILE-STATUS                                    
           GOBACK.                                                      
                                                                        
      * PARAGRAPHS                                                      
       CHECK-FILE-STATUS.                                               
           IF FS-STATE NOT = 0 THEN                                     
              DISPLAY 'ERROR: FILE STATUS: ' FS-STATE                   
              PERFORM ABEND-PROG                                        
           END-IF.                                                      
                                                                        
       ABEND-PROG.                                                      
           COMPUTE WS-ANO = WS-ANO / WS-VAR.                            
       
